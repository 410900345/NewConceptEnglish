//
//  AppUtil.m
//  MyWord
//
//  Created by 张诚 on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppUtil.h"
#import "Reachability.h"
#import <CommonCrypto/CommonCryptor.h>
#import "ZipArchive.h"
#import "Encryption.h"
#import "DoubleBookHeader.h"

static float const kClearDayNum = 1;
static NSString *const kHomeJson = @"HomeJson";

@implementation AppUtil

#pragma mark - filePath
+(NSString*)getAppPath//得到数据库文件在App目录下的路径
{
    return [[NSBundle mainBundle]resourcePath];
}

+(NSString*)getDocPath//得到数据库文件在Doc目录下的路径
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //找出文件下所有文件目录
    NSString *docPath = ([paths count] > 0)?[paths objectAtIndex:0]:nil;
    //找到Docutement目录
    return docPath;
}

+ (NSString *)getDocTempPath
{
    return [NSString stringWithFormat:@"%@/temp",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
}

+(NSString*)getTempPath
{
    return [NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];
    //从沙箱路径中找到tmp文件夹
}

+(NSString*)getDocDownloadWordPath
{
    NSString* path = [AppUtil getDocPath];
    
    NSString* directory = [NSString stringWithFormat:@"%@/DownloadWord", path];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:directory];
    if (!find) {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directory;
}

+(NSString*)getBookPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return [docPath stringByAppendingFormat:@"/book/"];
}

+ (NSString*)getDbPath
{
    NSString* directory =  [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/NewDB"];
//    NSFileManager* fileManager = [NSFileManager defaultManager];
//    BOOL find = [fileManager fileExistsAtPath:directory];
//    if (!find) {
//        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    return directory;
}

+ (NSString*)getDbYBPath
{
    NSString* directory =  [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/YBFile"];
    return directory;
}

+ (NSString*)getDoubleBookHtmlPath
{
//    NSString* directory =  [[self getDocPath] stringByAppendingFormat:@"/%@/",kDoubleBookName];
//    return directory;
    return @"";
}

+ (NSString*)getCachesPath
{
    NSString* directory =  [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches"];
    return directory;
}

#pragma mark - Event response

+(NSString *)decodeTextWithStr:(NSString *)str
{
    NSAssert(str.length , @"Argument must be non-nil");
    if (!str.length)
    {
        return @"123";
    }
    NSString *strDec = [[self class] decryptUseDES:str key:@"noloyiyi"];
    return strDec;
    NSLog(@"%@",strDec);
}

+(NSData*) hexToBytes:(NSString *)str
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx <str.length/2.0; idx++) {
        NSRange range = NSMakeRange(idx*2, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSString *)hexStringFromData:(NSData *)data
{
    NSMutableString *str = [NSMutableString string];
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        // byte+i为指针
        [str appendString:[self stringFromByte:*(byte+i)]];
    }
    return str;
}


- (NSString *)stringFromByte:(Byte)byteVal
{
    NSMutableString *str = [NSMutableString string];
    //取高四位
    Byte byte1 = byteVal>>4;
    //取低四位
    Byte byte2 = byteVal & 0xf;
    //拼接16进制字符串
    [str appendFormat:@"%x",byte1];
    [str appendFormat:@"%x",byte2];
    return str;
}

//解密数据1
+(NSString*)decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    // 利用 GTMBase64 解碼 Base64 字串
//    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    NSData* cipherData = [[self class] hexToBytes:cipherText];
    NSString *plainText = [[self class] baseDecryptUseDES:cipherData withKey:key withDataLenth:[cipherText length]];
    return plainText;
}

+(NSString*)baseDecryptUseDES:(NSData*)cipherData withKey:(NSString *)key withDataLenth:(NSUInteger)dataLength
{
//    NSUInteger dataLength = [cipherText length];
    unsigned char buffer[dataLength];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    NSData *keydata = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          [keydata bytes],
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          dataLength,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    }
    return plainText;
}

+(NSString*)getBookPathIndex:(NSString *)bookName withResoureName:(NSString *)resoureName
{
    NSString *docPath = [self getBookPath];
    NSString *indexBook = [NSString stringWithFormat:@"%@%@/%@",docPath,bookName,resoureName];
    return indexBook;
}

+ (void)extZipResWithZipName:(NSString *)zipName withOldPath:(NSString *)oldPath withNewPath:(NSString *)newPath
{
//    NSString *bookPath = [[self class] getBookPath];
    NSString *bookPath = newPath;
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDir;
//    zipName = @"NCE1_1_24";
    NSString *downLoadFile = [oldPath stringByAppendingPathComponent:zipName];//doc
    NSString *indexBook = [NSString stringWithFormat:@"%@%@",bookPath,zipName];//doc/book/zipName
    
    if ([newPath isEqualToString:[AppUtil getDbPath]] ||
        [newPath isEqualToString:[AppUtil getDbYBPath]] ||
        [[AppUtil getDocPath] isEqualToString:newPath]||
        [[AppUtil getDoubleBookHtmlPath] isEqualToString:newPath]
        )
    {
        indexBook = newPath;//当前文件夹
    }
//    if(![fileManage fileExistsAtPath:indexBook isDirectory:&isDir])
//    {
        ZipArchive *za = [[ZipArchive alloc]init];
        NSString *zipfile = downLoadFile;
        NSLog(@"%@",zipfile);
        if([za UnzipOpenFile:zipfile])
        {
            NSLog(@"Open success!");
            if([za UnzipFileTo:indexBook overWrite:YES])
            {
                NSLog(@"UnZip book resource success!");
                BOOL remove = [fileManage removeItemAtPath:downLoadFile error:nil];
                if (remove)
                {
                     NSLog(@"delete book resource success!");
                }
            }
        }
//    }
//    else
//    {
//        NSLog(@"Book resource exited!");
//    }
}

+ (void)createCacheDir
{
//    NSString *cacheDir = [[self getTempPath]stringByAppendingPathComponent:@"cache"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if([fileManager fileExistsAtPath:cacheDir isDirectory:nil])
//    {
//        //        [fileManager removeItemAtPath:cacheDir error:nil];
//        NSArray *files = [fileManager contentsOfDirectoryAtPath:cacheDir error:nil];
//        for(NSString *file in files)
//        {
//            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",cacheDir,file] error:nil];
//        }
//    }
//    [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *cacheDir = [[self getTempPath]stringByAppendingPathComponent:@"cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cacheDir isDirectory:nil])
    {
        [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

//首页历史数据
+(void)clearCachesWithAsyHomeList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *fileName = [kMUSICMP3File stringByAppendingFormat:@"0"];//音乐列表
        NSArray *array = @[kVOAFile,kDaySentenceDetailFile,kDayInfoFile,JSONFILENAME,kHomeJsonAd,fileName];
        [self cacheCleanWithFileNamePreArray:array withTime:60*60*24*(kClearDayNum)];
    });
}
//在tmp文件夹里建立一个文件夹cache如果有就删除文件夹里所有文件
+(void)cacheCleanWithFileNamePreArray:(NSArray *)preArray withTime:(int)time
{
    NSString *cacheDir = [Common datePath];
    //永久缓存目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:cacheDir isDirectory:nil])
    {
        NSArray *files = [fileManager contentsOfDirectoryAtPath:cacheDir error:nil];
        //获得缓存文件
        for(NSString *file in files)
        {
            if (![[self class] haveFlieWithFileName:file withArray:preArray])
            {
                continue;
            }
            NSString *tempFile = [NSString stringWithFormat:@"%@/%@",cacheDir,file];
            //得到文件完整路径
            NSDictionary *attributesDict = [fileManager attributesOfItemAtPath:tempFile error:nil];
            //得到文件属性
            NSTimeInterval diff = [[attributesDict fileCreationDate]timeIntervalSinceNow];
            //[attributesDict fileCreationDate]文件创建时间
            //diff为时间差，创建时间-当前时间=timeIntervalSinceNow（是个负值）
            int cacheExpired = time;
            //20天时间
            if(abs(diff)>cacheExpired)//diff的绝对值大于20天时
            {
                [fileManager removeItemAtPath:tempFile error:nil];
                //如果大于20天，删除文件
            }
        }
    }
}

//指定文件存在不
+ (BOOL)haveFlieWithFileName:(NSString *)fileName withArray:(NSArray *)array
{
    
    for (NSString *strPre in array)
    {
        BOOL isHave = [fileName containsString: strPre];
        if (isHave)
        {
            return YES;
        }
    }
    return NO;
}
//60*60*24*(kClearDayNum)
//本地缓存
+(void)clearCachesWithAsyAllCaches
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *array = @[kVOAFileDetail,kVOAFileDetailText,KGetDayVOADetailUrl,
                               kVOAFile,kDaySentenceDetailFile,kDayInfoFile,
                               JSONFILENAME,kHomeJsonAd,kDayVOAMP3,kMUSICMP3File];
            [self cacheCleanWithFileNamePreArray:array withTime:60*60*24*(kClearDayNum)];
        });
    });
}

//删除文件夹
+ (void)deleteFilePath:(NSString *)documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        //        if ([[filename pathExtension] isEqualToString:extension]) {
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        NSLog(@"删除成功!");
        //        }
    }
}

//删除错误文件
+ (void)deleteSingleFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    if([fileManager fileExistsAtPath:filePath])
    {
        BOOL state = [fileManager removeItemAtPath:filePath error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Common MBProgressTishi:kDHUBPREGRESSTITLE forHeight:kDeviceHeight];
        });
        NSLog(@"删除成功!");
    }
    else
    {
         NSLog(@"删除文件不存在!");
    }
}

+(void)deleteBookFile
{
    NSError *error = nil;
    NSString *bookPath = [[AppUtil getDocPath] stringByAppendingPathComponent:@"book"];
    //         BOOL state = [[NSFileManager defaultManager] removeItemAtPath:bookPath error:&error];
    [[self class] deleteFilePath:bookPath];
}

+ (void)moveHomeJsonData
{
    //本地标示
    NSString * dbFile = [[Common datePath] stringByAppendingPathComponent:kHomeJson];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dbFile])
    {
        NSError *error = nil;
        NSString *dbEmpty = [[self getAppPath] stringByAppendingPathComponent:kHomeJson];
        [fileManager copyItemAtPath:dbEmpty toPath:dbFile error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:dbEmpty error:NULL];
    }
}


@end
