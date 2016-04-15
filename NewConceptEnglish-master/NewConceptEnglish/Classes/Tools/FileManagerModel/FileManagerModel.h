//
//  FileManagerModel.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/9/28.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ItemBookNum) {
    ItemBookNumOne,
    ItemBookNumTwo,
    ItemBookNumThree,
    ItemBookNumFour
};

static NSString *const kBookTxt = @"kBookTxt";
static NSString *const kBookIndexTxt = @"kBookIndexTxt";//kBookIndex = "1-2";
static NSString *const kBookIndexDocTxt = @"kBookIndexDocTxt";//kBookIndexDocTxt = 1;

static NSString *const kTxtTime = @"kTxtTime";//时间格式
static NSString *const kTxtTimeNum = @"kTxtTimeNum";//具体时间
static NSString *const kTxtDetail = @"kTxtDetail";
static NSString *const kTxtChinese = @"kTxtChinese";
static NSString *const kTxtChangeColor = @"kTxtChangeColor";

static NSString *const kTxtCellHight = @"kTxtCellHight";

@interface FileManagerModel : NSObject

@property (nonatomic, strong) UISlider *durationSlider;

@property (nonatomic, copy) NSString *readWord;//不一定用的上
@property (nonatomic,strong) UIView *showView;//显示的view
@property (nonatomic,assign) float skipSecond;//跳过100毫秒
@property (nonatomic,strong) NSMutableDictionary *cellInfoDict;//跳过100毫秒

+ (instancetype)sharedFileManagerModel;

//得到数组索引
+ (NSArray *)getBookIndexWithBookItem:(ItemBookNum)bookNum;

//数字
+ (NSString *)getBookNumStrIndexWithBookItem:(ItemBookNum)bookNum;


- (void)readWordSystem:(NSString *)wordStr withMale:(BOOL)isMale;

- (void)readWordFromResoure:(NSString *)wordStr withIsUk:(BOOL)isUK withUrl:(NSString *)url;

//[00:00.74]From VOA Learning English, this is the Health & Lifestyle report.
+(NSArray *)handleDataWithDetailText:(NSArray *)resutArray;
//[00:00.74
+ (NSString *)getTempTimeWitTime:(NSString *)timeStrNew;

-(void)setUpNilDelegate;

-(void)stopPlayMusic;

-(void)playMusic:(NSString *)file;

-(void)setUpCallBackBlock:(SXBasicBlock)block;

+(NSString *)getExtensionWithFileName:(NSString *)fileName withIsUk:(BOOL)isUK;

+(BOOL)fileDBExistsAtWithName:(NSString *)name;

@end
