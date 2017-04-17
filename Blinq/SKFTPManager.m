//
//  SKFTPManager.m
//  integration
//
//  Created by zsk on 2016/12/9.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SKFTPManager.h"

@interface SKFTPManager()<NSStreamDelegate>

@property(nonatomic,strong)NSURL *serverUrl;
@property(nonatomic,copy)NSString *account;
@property(nonatomic,copy)NSString *password;


// - ftp 上传
@property (nonatomic, retain)   NSOutputStream *  outputStream;
@property (nonatomic, retain)   NSInputStream *   fileInputStream;
@property (nonatomic, readonly) uint8_t *         buffer;
@property (nonatomic, assign)   size_t            bufferOffset;
@property (nonatomic, assign)   size_t            bufferLimit;

// - ftp 下载
@property (nonatomic, retain)   NSInputStream *   inputStream;//输入流
@property (nonatomic, retain)   NSOutputStream *  fileOutputStream;//输出流

@end

@implementation SKFTPManager

- (id)initWithServerPath:(NSString *)server withName:(NSString*)userName withPass:(NSString*)passWord{
    if (self = [super init]) {
        self.serverUrl = [NSURL URLWithString:server];
        self.account = userName;
        self.password = passWord;
    }
    
    return self;
}

- (uint8_t *)buffer
{
    return self->_buffer;
}

#pragma mark 上传事件
- (void)FtpUploadFileWithPath:(NSString*)path{
    
    NSURL *url = self.serverUrl;//ftp服务器地址
    NSString *filePath = path;//图片地址
    NSString *account = self.account;//账号
    NSString *password = self.password;//密码
    
    CFWriteStreamRef ftpStream;
    
    //添加后缀（文件名称）
    url = CFBridgingRelease(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [filePath lastPathComponent], false));
    
    //读取文件，转化为输入流
    self.fileInputStream = [NSInputStream inputStreamWithFileAtPath:filePath];
    [self.fileInputStream open];
    
    //为url开启CFFTPStream输出流
    ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
    self.outputStream = (__bridge NSOutputStream *) ftpStream;
    
    //设置ftp账号密码
    [self.outputStream setProperty:account forKey:(id)kCFStreamPropertyFTPUserName];
    [self.outputStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
    
    //设置networkStream流的代理，任何关于networkStream的事件发生都会调用代理方法
    self.outputStream.delegate = self;
    
    //设置runloop
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream open];
    
    //完成释放链接
    CFRelease(ftpStream);
}

#pragma mark 下载事件
- (void)FtpDownLoadFileWithPath:(NSString*)path fileName:(NSString*)fileName storagePath:(NSString*)storagePath{
    
    CFReadStreamRef ftpStream;
    
    NSURL *url = [NSURL URLWithString:path];
    
    url = CFBridgingRelease(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [fileName lastPathComponent], false));
    
    NSLog(@"url is %@",url);
    
    // 为文件存储路径打开流，filePath为文件写入的路径,hello为图片的名字
    
    self.fileOutputStream = [NSOutputStream outputStreamToFileAtPath:storagePath append:NO];
    [self.fileOutputStream open];
    
    // 打开CFFTPStream
    ftpStream = CFReadStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
    self.inputStream = (__bridge NSInputStream *) ftpStream;
    assert(ftpStream != NULL);
    
    //设置ftp账号密码
    [self.inputStream setProperty:@"sharemoretech" forKey:(id)kCFStreamPropertyFTPUserName];
    [self.inputStream setProperty:@"s3T6m7K6" forKey:(id)kCFStreamPropertyFTPPassword];
    
    // 设置代理
    self.inputStream.delegate = self;
    
    // 启动循环
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    
    CFRelease(ftpStream);

}

#pragma mark 回调方法
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    //aStream 即为设置为代理的networkStream
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"NSStreamEventOpenCompleted");
        } break;
        case NSStreamEventHasBytesAvailable:  {// 下载
            NSInteger bytesRead;
            uint8_t buffer[32768];//缓冲区的大小 32768可以设置，uint8_t为一个字节大小的无符号int类型
            
            // 读取数据
            
            bytesRead = [self.inputStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead == -1) {
            } else if (bytesRead == 0) {
                //下载成功
                [self _stopReceiveWithStatus:nil];
            } else {
                NSInteger   bytesWritten;//实际写入数据
                NSInteger   bytesWrittenSoFar;//当前数据写入位置
                
                // 写入文件
                bytesWrittenSoFar = 0;
                do {
                    bytesWritten = [self.fileOutputStream write:&buffer[bytesWrittenSoFar] maxLength:bytesRead - bytesWrittenSoFar];
                    assert(bytesWritten != 0);
                    if (bytesWritten == -1) {
                        assert(NO);
                        break;
                    } else {
                        bytesWrittenSoFar += bytesWritten;
                    }
                } while (bytesWrittenSoFar != bytesRead);
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {// 上传
            NSLog(@"NSStreamEventHasSpaceAvailable");
            NSLog(@"bufferOffset is %zd",self.bufferOffset);
            NSLog(@"bufferLimit is %zu",self.bufferLimit);
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                bytesRead = [self.fileInputStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    //读取文件错误
                    [self _stopSendWithStatus:@"读取文件错误"];
                } else if (bytesRead == 0) {
                    //文件读取完成 上传完成
                    [self _stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            if (self.bufferOffset != self.bufferLimit) {
                //写入数据
                NSInteger bytesWritten;//bytesWritten为成功写入的数据
                bytesWritten = [self.outputStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self _stopSendWithStatus:@"网络写入错误"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self _stopSendWithStatus:@"Stream打开错误"];
            assert(NO);
        } break;
        case NSStreamEventEndEncountered: {
            // 忽略
        } break;
        default: {
            assert(NO);
        } break;
    }
}

//上传结果处理
- (void)_stopSendWithStatus:(NSString *)statusString
{
    if (self.outputStream != nil) {
        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.outputStream.delegate = nil;
        [self.outputStream close];
        self.outputStream = nil;
    }
    if (self.fileInputStream != nil) {
        [self.fileInputStream close];
        self.fileInputStream = nil;
        
        if(statusString == nil){
            statusString = @"上传成功";
        }
    }
        self.ftpResultsString(statusString);
}

//下载结果处理
#pragma mark 结果处理，关闭链接
- (void)_stopReceiveWithStatus:(NSString *)statusString
{
    if (self.inputStream != nil) {
        [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.inputStream.delegate = nil;
        [self.inputStream close];
        self.inputStream = nil;
    }
    if (self.fileOutputStream != nil) {
        [self.fileOutputStream close];
        self.fileOutputStream = nil;
    }
    if(statusString == nil){
        statusString = @"下载成功";
    }
    
    self.ftpResultsString(statusString);
}



@end
