//
//  LTHTTPSessionManager.m
//  TwMall
//
//  Created by TaiHuiTao on 16/6/15.
//  Copyright © 2016年 TaiHuiTao. All rights reserved.
//

#import "LTHTTPSessionManager.h"

//解析数据返回错误
NSString *const kParseResponseError = @"解析数据失败";
NSString *const kHttpRequestFailure = @"网络连接错误";
//返回参数key值
NSString *const kKeyResult = @"msg";
NSString *const kKeyMessage = @"msg";
NSString *const kKeyData = @"data";
NSString *const kKeyModelList = @"modellist";

@implementation LTHTTPSessionManager

- (instancetype)init{
    if (self = [super init]) {
        //将本地cookie放在网络请求header
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kcookie"]];
        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie * cookie in cookies){
            [cookieStorage setCookie: cookie];
        }
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
        self.requestSerializer.timeoutInterval = 10.0f;
    }
    return self;
}
+ (instancetype)manager{
    return [[self alloc]init];
}
- (NSURLSessionDataTask *)POSTWithParameters:(NSString *)url parameters:(id)parameters complete:(completeBlock)complete{
    // 在此 添加网络加载动画
    SVProgressShowText(@"正在加载");
    return [super POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SVProgressHiden();
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if(![responseObject[kKeyResult] isEqualToString:@"1"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
            //添加SV错误提示
//            [SVProgressHUD setMinimumDismissTimeInterval:1];
//            [SVProgressHUD showErrorWithStatus:responseObject[kKeyMessage]];
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
            SVProgressShowStuteText(kParseResponseError, NO);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
            SVProgressShowStuteText(kHttpRequestFailure, NO);
        }
    }];
}

- (NSURLSessionDataTask *)GETWithParameters:(NSString *)url parameters:(id)parameters complete:(completeBlock)complete{
    return [super GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if([responseObject[kKeyResult] isEqualToString:@"ERROR"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
        }
    }];
}


- (NSURLSessionDataTask *)PUTWithParameters:(NSString *)url parameters:(id)parameters complete:(completeBlock)complete{
    return [super PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if([responseObject[kKeyResult] isEqualToString:@"ERROR"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
        }
    }];
}


- (NSURLSessionDataTask *)DELTEWithParameters:(NSString *)url parameters:(id)parameters complete:(completeBlock)complete{
    return [super DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if([responseObject[kKeyResult] isEqualToString:@"ERROR"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
        }
    }];
}
- (NSURLSessionDataTask *)UPLOADWithParameters:(NSString *)url parameters:(id)parameters photoArray:(NSArray *)photoArray complete:(completeBlock)complete{
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在此 添加网络加载动画
    SVProgressShowText(@"正在加载...");
    return [super POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < photoArray.count; i++) {
            
            UIImage *image = photoArray[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"photo" fileName:fileName mimeType:@"image/jpeg"]; //
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SVProgressHiden();
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if(![responseObject[kKeyResult] isEqualToString:@"0000"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
            //添加SV错误提示
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:responseObject[kKeyMessage]];
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
            SVProgressShowStuteText(kParseResponseError, NO);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
            SVProgressShowStuteText(kHttpRequestFailure, NO);
        }
    }];
}
/*
- (NSURLSessionDownloadTask *)dowloadFileWithUrl:(NSString *)url complete:(completeDownloadBlock)complete{
   return [self downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
        //
        WeakSelf
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            // 下载进度
            //            weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            //            weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
        }];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //
        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [path URLByAppendingPathComponent:@"英语听力2018/QQ_V5.4.01.dmg"];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //
        NSLog(@"%@,%@",response, filePath);
        complete(response, [NSString stringWithFormat:@"%@",filePath], error);
    }];
}
//
//- (IBAction)downloadBtnClicked:(UIButton *)sender {
//
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    // 1. 创建会话管理者
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    // 2. 创建下载路径和请求对象
//    NSURL *URL = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//    // 3.创建下载任务
//    /**
//     * 第一个参数 - request：请求对象
//     * 第二个参数 - progress：下载进度block
//     *      其中： downloadProgress.completedUnitCount：已经完成的大小
//     *            downloadProgress.totalUnitCount：文件的总大小
//     * 第三个参数 - destination：自动完成文件剪切操作
//     *      其中： 返回值:该文件应该被剪切到哪里
//     *            targetPath：临时路径 tmp NSURL
//     *            response：响应头
//     * 第四个参数 - completionHandler：下载完成回调
//     *      其中： filePath：真实路径 == 第三个参数的返回值
//     *            error:错误信息
//     */
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
//
//        __weak typeof(self) weakSelf = self;
//        // 获取主线程，不然无法正确显示进度。
//        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
//        [mainQueue addOperationWithBlock:^{
//            // 下载进度
////            weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
////            weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
//        }];
//
//
//    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//
//        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [path URLByAppendingPathComponent:@"英语听力2018/QQ_V5.4.01.dmg"];
//
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//
//    // 4. 开启下载任务
//    [downloadTask resume];
//}

@end
