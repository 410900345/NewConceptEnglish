//
//  NSNull+JSON.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/4/8.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (JSON)
- (NSUInteger)length;
- (NSInteger)integerValue;
- (float)floatValue;
- (NSString *)description;
- (NSArray *)componentsSeparatedByString:(NSString *)separator;
- (id)objectForKey:(id)key;
- (BOOL)boolValue;
- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet;
@end
