//
//  AudioConvertManager.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/4.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioConvertManager : NSObject

//+(NSData *)audio_PCMtoMP3WithFilePath:(NSString *)recordPath toTheFile:(NSString *)mp3FilePath;
+ (void)audio_PCMtoMP3WithPcmFile:(NSString *)pcmFile toMp3FilePath:(NSString *)mp3File;
@end
