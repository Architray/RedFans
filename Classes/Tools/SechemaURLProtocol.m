//
//  SechemaURLProtocol.m
//  WKWebViewHookRequest
//
//  Created by 梁宪松 on 2017/11/27.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "SechemaURLProtocol.h"

#import "App-Swift.h"
#import "RegisterTool.h"

static const NSString *kURLProtocolHandledKey = @"URLProtocolHandledKey";
NSString *const HttpProtocolKey = @"http";
NSString *const HttpsProtocolKey = @"https";

@interface SechemaURLProtocol()<NSURLSessionDelegate>

@property (atomic,strong,readwrite) NSURLSessionDataTask *task;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSError *error;

@end

@implementation SechemaURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *scheme = [[request URL] scheme];
    // 判断是否需要进入自定义加载器
    if ([scheme caseInsensitiveCompare:HttpProtocolKey] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:HttpsProtocolKey] == NSOrderedSame) {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:kURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    // 执行自定义操作，例如添加统一的请求头等
//    [mutableReqeust addValue:@"xsecappid=xhs-pc-web; webBuild=4.6.0; unread={%22ub%22:%2265ede8cc0000000012030702%22%2C%22ue%22:%2265f09fc1000000001203ca25%22%2C%22uc%22:10}; sec_poison_id=81e7911f-fcdb-4888-9bb2-6f975d6b57d4; websectiga=cf46039d1971c7b9a650d87269f31ac8fe3bf71d61ebf9d9a0a87efb414b816c; gid=yYd28qf20Ji0yYd28qf2J2KlDJjqAlT49M1SW7TV6ufi6hq8F3f4KD888jj4KWW8WfDyj82D; web_session=030037a2c48ab8391d7d80988f224a574c9050; acw_tc=472b3e56080d60991e2f2496735480ba25efca66d26d4a6da9fadcf43ea77a52; a1=18e503d52b293qok4tslcjmzdfmrid46f57vb6ouk30000994677; abRequestId=f36d25ca-9896-58d8-941d-77f8099c4f55; webId=0e3a120e3e1d576a3a53f4cf696cc7cc; xhsSEM=b230609b-14b9-4a8e-98b8-9cd2e293cc6d; xhsTrackerId=fd533c7e-6bd6-4683-c616-2582366b581b" forHTTPHeaderField:@"Cookie"];
//    [mutableReqeust addValue:[RegisterTool cookieString] forHTTPHeaderField:@"Cookie"];
    return mutableReqeust;
}

// 判重
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    // 标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:kURLProtocolHandledKey inRequest:mutableReqeust];
    
    self.data = [NSMutableData data];
    self.startTime = [[NSDate date] timeIntervalSince1970];
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session  = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:self.queue];
    self.task = [self.session dataTaskWithRequest:mutableReqeust];
    [self.task resume];
}

- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;

    [NetworkDatas networkData:self.request response:self.response data:self.data error:self.error startTime:self.startTime];
}

#pragma mark - Getter
- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}
@end

@implementation SechemaURLProtocol(NSURLSessionDelegate)

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    }else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.response = response;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler {
    completionHandler(proposedResponse);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler {
    NSMutableURLRequest*    redirectRequest;
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:kURLProtocolHandledKey inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

@end

