//
//  DecodingManager.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/28.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecodingManager : NSObject

+ (NSString*)SXdecryptionWithStr:(NSString*)str;
+ (NSString *)SXEncryptionWithStr:(NSString *)str;
@end
