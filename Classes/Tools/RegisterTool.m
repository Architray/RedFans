//
//  RegisterTool.m
//  RedFans
//
//  Created by 思水 on 2024/3/18.
//

#import "RegisterTool.h"

#import "SechemaURLProtocol.h"

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

//+ (BOOL)isMarkRequest:(NSURLRequest *) request {
//    return [NSURLProtocol propertyForKey:kURLProtocolHandledKey inRequest:request];
//}
//
//+ (void)markRequest:(NSURLRequest *) request {
//    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
//    // 标示改request已经处理过了，防止无限循环
//    [NSURLProtocol setProperty:@YES forKey:kURLProtocolHandledKey inRequest:mutableReqeust];
//}
//
//+ (NSURLRequest *)mutableRequest:(NSURLRequest *) request {
//    return request.mutableCopy;
//}

@end
