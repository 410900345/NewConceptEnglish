//
//  SupportModel.m
//  newIdea1.0
//
//  Created by yangshuo on 15/11/14.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "SupportModel.h"

@implementation SupportModel

+(NSString *)getIndexColorWithIndex:(NSInteger)index
{
    NSArray *array = [[self class] getSupportArray];
    index = MIN(index, array.count-1);
    NSString *colorStr = array[index];
    return colorStr;
}

+(NSArray *)getSupportArray
{
    NSArray *array = @[@"FF6666", @"003EE1", @"01D882", @"977200", @"01A3E0",
                       @"BD00CC", @"F90064", @"FF7709", @"1BA602", @"016940",
                       @"FF2D2D", @"01B4F8", @"662E00", @"75002F", @"EAD200",
                       @"780082", @"D59F00", @"FF3366", @"2C007D", @"0F5A01",
                       @"015474", @"DE00F0", @"018752", @"B75200", @"750000" ];
    return array;
}

+(NSInteger )getIndexWithColorStr:(NSString *)colorStr
{
    NSInteger index = 0;
     NSArray *array = [[self class] getSupportArray];
    if ([array containsObject:colorStr])
    {
          index = [array indexOfObject:colorStr];
    }
    return index;
}


+(NSString *)getSourcePlatformFormTag:(NSInteger)index
{
    NSString *source = @"iOS";
    switch (index) {
        case 1:
            source = @"Android";
            break;
        case 2:
            source = @"iOS";
            break;
        default:
            break;
    }
    return source;
}

@end
