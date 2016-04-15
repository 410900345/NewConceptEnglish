//
//  CommonHttpManager.h
//  newIdea1.0
//
//  Created by yangshuo on 16/2/2.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface CommonHttpManager : NSObject
+(BOOL)isWifiUse;

+(ASIFormDataRequest *)fetchAsiRequestWithObejct:(NSObject *)object;

+ (void)cancelHtttpRequestWithObejct:(NSObject *)object;

@end
