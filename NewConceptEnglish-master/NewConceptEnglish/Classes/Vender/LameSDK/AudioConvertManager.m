//
//  AudioConvertManager.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/4.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "AudioConvertManager.h"
//#import "amrFileCodec.h"
#import <lame/lame.h>
#import "TTSConfig.h"

@implementation AudioConvertManager
//+(NSData *)audio_PCMtoMP3WithFilePath:(NSString *)recordPath toTheFile:(NSString *)mp3FilePath
//{
//    NSData* data = EncodeWAVEToAMR([NSData dataWithContentsOfFile:recordPath], 1, 16);
////    [[NSFileManager defaultManager] removeItemAtPath:recordPath error:nil];
////    NSString *rootFilePath = [Common getAudioPath];
////    NSString *amrFilePath = [rootFilePath stringByAppendingFormat:@"/%@", mp3FilePath];
//    [data writeToFile:mp3FilePath atomically:YES];
//    return data;
//}

+ (void)audio_PCMtoMP3WithPcmFile:(NSString *)pcmFile toMp3FilePath:(NSString *)mp3File
{    
    NSString *cafFilePath = pcmFile;
    NSString *mp3FilePath = mp3File;
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000.0);
        lame_set_num_channels(lame, 1); // 单声道
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
 
    }
}

@end
