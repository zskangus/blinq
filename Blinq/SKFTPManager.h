//
//  SKFTPManager.h
//  integration
//
//  Created by zsk on 2016/12/9.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    kSendBufferSize = 32768
};

//定位成功回调
typedef void(^ReturnFTPEvents)(NSString *resultsString);


@interface SKFTPManager : NSObject{
    uint8_t _buffer[kSendBufferSize];
}

@property(nonatomic,strong)ReturnFTPEvents ftpResultsString;

- (id)initWithServerPath:(NSString *)server withName:(NSString*)userName withPass:(NSString*)passWord;

- (void)FtpUploadFileWithPath:(NSString*)path;

- (void)FtpDownLoadFileWithPath:(NSString*)path fileName:(NSString*)fileName storagePath:(NSString*)storagePath;

@end
