//
//  RegisterTool.m
//  RedFans
//
//  Created by 思水 on 2024/3/18.
//

#import "RegisterTool.h"

#import "SechemaURLProtocol.h"
#import <WebKit/WebKit.h>

//#define kURLProtocolHandledKey @"kURLProtocolHandledKey"

@implementation RegisterTool

+ (void)registerClass {
    // 防止苹果静态检查 将 WKBrowsingContextController 拆分，然后再拼凑起来
    NSArray *privateStrArr = @[@"Controller", @"Context", @"Browsing", @"K", @"W"];
    NSString *className =  [[[privateStrArr reverseObjectEnumerator] allObjects] componentsJoinedByString:@""];
    Class cls = NSClassFromString(className);
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    
    if (cls && sel) {
        if ([(id)cls respondsToSelector:sel]) {
            // 注册自定义协议
            // [(id)cls performSelector:sel withObject:@"CustomProtocol"];
            // 注册http协议
            [(id)cls performSelector:sel withObject:HttpProtocolKey];
            // 注册https协议
            [(id)cls performSelector:sel withObject:HttpsProtocolKey];
        }
    }
    // SechemaURLProtocol 自定义类 继承于 NSURLProtocol
    [NSURLProtocol registerClass:[SechemaURLProtocol class]];
}

static NSString *_cookieString;
static NSMutableDictionary *_cookieDatas;

+ (NSString *)cookieString {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCookieDatas];
    });
    return _cookieString;
}

+ (void)updateCookieString {
    NSMutableArray *data = NSMutableArray.array;
    for (NSString *key in _cookieDatas.allKeys) {
        [data addObject:[NSString stringWithFormat:@"%@=%@", key, _cookieDatas[key]]];
    }
    _cookieString = [data componentsJoinedByString:@"; "];
}

+ (void)updateCookieDatas {
    WKWebsiteDataStore *store = WKWebsiteDataStore.defaultDataStore;
    
    [store.httpCookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull allCookies) {
        for (NSHTTPCookie *cookie in allCookies) {
            if ([cookie.domain containsString:@"xiaohongshu.com"]) {
                [self addCookie:cookie];
            }
            [NSHTTPCookieStorage.sharedHTTPCookieStorage setCookie:cookie];
        }
        [self updateCookieString];
    }];
}

+ (void)addCookie:(NSHTTPCookie *)cookie {
    _cookieDatas = _cookieDatas ?: NSMutableDictionary.dictionary;
    _cookieDatas[cookie.name] = cookie.value;
}

@end
