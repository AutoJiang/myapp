//
//  aboutUsViewController.h
//  题海秘籍
//
//  Created by jiang aoteng on 16/3/7.
//  Copyright © 2015年 Auto. All rights reserved.
//

#import "ATFileDownloader.h"
#import "MBProgressHUD+NJ.h"

@interface ATFileDownloader() <NSURLConnectionDataDelegate>
/**
 * 连接对象
 */
@property (nonatomic, strong) NSURLConnection *conn;

/**
 *  写数据的文件句柄
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;
/**
 *  当前已下载数据的长度
 */
@property (nonatomic, assign) long long currentLength;
/**
 *  完整文件的总长度
 */
@property (nonatomic, assign) long long totalLength;
@end

@implementation ATFileDownloader

/**
 * 开始(恢复)下载
 */
- (void)start
{
    NSURL *url = [NSURL URLWithString:self.url];
    // 默认就是GET请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求头信息
    NSString *value = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
    [request setValue:value forHTTPHeaderField:@"Range"];
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
    _downloading = YES;
}

/**
 * 暂停下载
 */
- (void)pause
{
    [self.conn cancel];
    self.conn = nil;
    
    _downloading = NO;
}

#pragma mark - NSURLConnectionDataDelegate 代理方法
/**
 *  1. 当接受到服务器的响应(连通了服务器)就会调用
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *dict = httpResponse.allHeaderFields;
//    NSLog(@"%@",httpResponse.allHeaderFields);
    NSString *webTimeString = [dict objectForKey:@"Last-Modified"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEE, dd MMM yyyy hh:mm:ss ZZZ"];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    NSDate *webTime =[formatter dateFromString:webTimeString];
//    NSDate *lastTime = [NSDate dateWithTimeInterval];
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //Get documents directory
//    NSString *directoryPaths = [NSSearchPathForDirectoriesInDomains
//    (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path = [directoryPaths stringByAppendingString:@"tiku.db"];
    
    if ([fileManager fileExistsAtPath:self.destPath]== YES) {
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:self.destPath error:nil];
        NSDate *localTime = [fileAttributes objectForKey:NSFileModificationDate];
        if ([localTime compare:webTime] == NSOrderedDescending||[localTime compare:webTime] == NSOrderedSame) {
            [self pause];
            return;
        }
    }
#warning 一定要判断
    if (self.totalLength) return;
    
    // 1.创建一个空的文件到沙盒中
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 刚创建完毕的大小是0字节
    [mgr createFileAtPath:self.destPath contents:nil attributes:nil];
    
    // 2.创建写数据的文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:self.destPath];
    
    // 3.获得完整文件的长度
    self.totalLength = response.expectedContentLength;
}

/**
 *  2. 当接受到服务器的数据就会调用(可能会被调用多次, 每次调用只会传递部分数据)
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 累加长度
    self.currentLength += data.length;
    
    // 显示进度
    double progress = (double)self.currentLength / self.totalLength;
    if (self.progressHandler) { // 传递进度值给block
        self.progressHandler(progress);
    }
    
    // 移动到文件的尾部
    [self.writeHandle seekToEndOfFile];
    // 从当前移动的位置(文件尾部)开始写入数据
    [self.writeHandle writeData:data];
}

/**
 *  3. 当服务器的数据接受完毕后就会调用
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 清空属性值
    self.currentLength = 0;
    self.totalLength = 0;
    
    if (self.currentLength == self.totalLength) {
        // 关闭连接(不再输入数据到文件中)
        [self.writeHandle closeFile];
        self.writeHandle = nil;
    }
    
    if (self.completionHandler) {
        self.completionHandler();
    }
    [MBProgressHUD showSuccess:@"已更新至最新题库！"];
}

/**
 *  请求错误(失败)的时候调用(请求超时\断网\没有网, 一般指客户端错误)
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.failureHandler) {
        self.failureHandler(error);
    }
}

@end
