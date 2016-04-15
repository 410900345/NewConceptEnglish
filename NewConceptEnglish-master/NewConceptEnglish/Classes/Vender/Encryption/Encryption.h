//
//  Encryption.h
//  DownloadFile
//
//  Created by  on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSObject (Encryption)

-(NSString *)SXencryptUseDES:(NSString *)clearText key:(NSString *)key;
-(NSString*)SXdecryptUseDES:(NSString*)cipherText key:(NSString*)key;

@end
