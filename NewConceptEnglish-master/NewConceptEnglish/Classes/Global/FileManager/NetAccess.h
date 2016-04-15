//
//  NetAccess.h
//  BreakPointsDownload
//
//  Created by Visitor on 3/13/13.
//  Copyright (c) 2013 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"



@protocol NetAccessDelegate <NSObject>

@optional
- (void)requestFailed;
- (void)downLoadFinishWithFilePath:(NSString *)filePath withFileName:(NSString *)fileName;
- (void)analysisFinishWithData:(NSArray *)dataArray;
@end

@interface NetAccess : NSObject<ASIHTTPRequestDelegate>
//{
//    id<NetAccessDelegate> _delegate;
//}
@property(nonatomic,assign)id<NetAccessDelegate> delegate;
@property(nonatomic ,copy) NSString *m_fileSavedocPath;

//+ (NetAccess *)sharedNetAccess;

- (void)downLoadUrl:(NSString *)urlStr andProgressView:(UIProgressView *)pv withBookName:(NSString *)bookName;

- (void)setUpNilDelegate;

- (void)suspendDownLoad;
//解析数据
- (void)importTextLineWithFilePath:(NSString *)filePath withFileName:(NSString *)fileName withDelegate:(id)delegate;
@end
