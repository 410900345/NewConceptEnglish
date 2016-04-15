//
//  DecodingManager.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/28.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "DecodingManager.h"
//#import "Encryption.h"

static NSString *const kMUSICMP3KEY  = @"s-h&eng@";//mp3key
@implementation DecodingManager
//
//+(NSString *)SXdecryptionWithStr:(NSString *)str
//{
////    NSLog(@"encrypt = %@", str);
//    NSString *returnStr = @"";
//    if (IsStrEmpty(str))
//    {
//        return returnStr;
//    }
//    NSString *encrypt = [self SXdecryptUseDES:str key:kMUSICMP3KEY];
////    NSLog(@"encrypt = %@", str);
//    if (!IsStrEmpty(encrypt))
//    {
//        returnStr = encrypt;
//    }
//    return encrypt;
//}
//
//+(NSString *)SXEncryptionWithStr:(NSString *)str
//{
//    //    NSLog(@"encrypt = %@", str);
//    NSString *returnStr = @"";
//    if (IsStrEmpty(str))
//    {
//        return returnStr;
//    }
//    NSString *encrypt = [self SXencryptUseDES:str key:kMUSICMP3KEY];
//    //    NSLog(@"encrypt = %@", str);
//    if (!IsStrEmpty(encrypt))
//    {
//        returnStr = encrypt;
//    }
//    return encrypt;
//}

//-(NSString *)getDecodeStr:(NSString *)str
//{
//     NSString * mystring = @"";
//    if (IsStrEmpty(str))
//    {
//        return mystring;
//    }
//    char mychar[str.length];
//    strcpy(mychar,(char *)[str UTF8String]);
//
//    for (int i = 0; i <str.length; i++)
//    {
//        mychar[i] = (char) (mychar[i] ^ (str.length));
//    }
//    mystring=[NSString stringWithFormat:@"%s",mychar];
//    NSLog(@"------%@",mystring);
//    return mystring;
//}

//+(NSString *)getDecodeStrTrue:(NSString *)str
//{
//    NSString *returnStr = @"";
//    if (IsStrEmpty(str))
//    {
//        return returnStr;
//    }
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (int i = 0;i < str.length; i++)
//    {
//        NSString *str1 = [str substringWithRange:NSMakeRange(i, 1)];
//        NSString *decodStr = [[self class] getDecodeStr:str1 withIndexNum:str.length];
//        [array addObject:decodStr];
//    }
//    returnStr = [array componentsJoinedByString:@""];
//    return returnStr;
//}

//+(NSString *)getDecodeStr:(NSString *)str withIndexNum:(NSInteger)num
//{
//    NSStringEncoding encoding = NSUTF8StringEncoding;
//    NSString * mystring = @"";
//    char mychar[1000];
//    const char *c = [str cStringUsingEncoding:encoding];
//    strcpy(mychar,c);
//    int length = strlen(c);
//    for (int i = length-1; i >= 0; i--)
//    {
//        if (i == length-1)
//        {
//            mychar[i] =  mychar[i]^num;
//        }
//    }
//    mystring=[NSString stringWithCString:mychar encoding:encoding];
//    NSLog(@"------%@",mystring);
//    return mystring;
//}
@end
