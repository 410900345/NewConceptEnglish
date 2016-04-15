//
//  WordModel.m
//  newIdea1.0
//
//  Created by yangshuo on 16/3/22.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel

+(instancetype)fillWordModelWithTitle:(NSString *)title andContent:(NSString *)content
{
    WordModel *wordModel = [[WordModel alloc] init];
    wordModel.title = title;
    wordModel.content = content;
    return wordModel;
}

+(NSString *)fetchWordImageUrlWithWord:(NSString *)word
{
    if (!word.length)
    {
        return @"";
    }
    return [NSString stringWithFormat:@"http://www.youdict.com/images/words/%@1.jpg",word];
}
@end
