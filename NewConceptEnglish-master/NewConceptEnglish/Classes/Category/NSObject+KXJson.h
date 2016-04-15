//
//  NSObject+KXJson.h
//  TextIpa
//
//  Created by jiuhao-yangshuo on 15/9/14.
//  Copyright (c) 2015年 jiuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KXJsonString)

//解析
-(NSString *)KXjSONString;

@end

@interface NSString (KXJsonObject)

//转为字典
-(id)KXjSONValueObject;



@end
