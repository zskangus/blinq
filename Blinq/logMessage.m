//
//  logMessage.m
//  Blinq
//
//  Created by zsk on 16/6/8.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "logMessage.h"
#import "SKConst.h"

@implementation logMessage

static NSString *_filePath;

+(void)initialize{
    
    // 获取沙盒的Documents目录
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths firstObject];
    NSLog(@"沙盒Documents目录是：%@", documentPath);
    
    //样例二：在沙盒中的相应目录下，创建一个新的文件；并在新创建的文件中，添加测试内容
    
    if (documentPath) {
        //1. 创建文件路径
        _filePath = [documentPath stringByAppendingPathComponent:@"testFile.txt"];
        
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:_filePath]) //如果不存在
    {
        //  创建testFile.txt文件，并将字符串写如文件中
        BOOL isSuccess = [@"Blinq日志\r" writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        //判定是否写入成功
        if (isSuccess) {
            NSLog(@"写入成功！");
        }
        
    }
    
}


+ (void)generateTheLogRecords:(NSString *)infoString{
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSLog(@"当前时间为:%@",dateString);
    
    NSLog(@"%@",infoString);
    
    //打开文件
    NSFileHandle  *outFile;
    NSData *buffer;
    
    outFile = [NSFileHandle fileHandleForWritingAtPath:_filePath];
    
    if(outFile == nil)
    {
        NSLog(@"Open of file for writing failed");
    }
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    
    //读取inFile并且将其内容写到outFile中
    NSString *bs = [NSString stringWithFormat:@"%@--{\r%@\r}\r\r",dateString,infoString];
    buffer = [bs dataUsingEncoding:NSUTF8StringEncoding];
    
    [outFile writeData:buffer];
    
    //关闭读写文件
    [outFile closeFile];

}

@end
