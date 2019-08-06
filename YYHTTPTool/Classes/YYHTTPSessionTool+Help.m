//
//  YYHTTPSessionTool+Help.m
//  AFN
//
//  Created by Loser on 8/2/19.
//  Copyright © 2019 Loser. All rights reserved.
//

#import "YYHTTPSessionTool+Help.h"

@implementation YYHTTPSessionTool (Help)
#pragma mark - 解析网络返回数据
- (NSDictionary *)parseHTTPResponseDataWith:(id)response{
    NSDictionary *jsonDictionary;
    if ([response isKindOfClass:NSDictionary.class]) {
        jsonDictionary = (NSDictionary *)response;
    }else if ([response isKindOfClass:NSData.class]){
        jsonDictionary = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    }
    
    return jsonDictionary;
}

- (NSError *)assemblyHTTPErrorWith:(NSError *)error responseObject:(id)response{
    NSMutableDictionary *errorUserinfoDic = error.userInfo.mutableCopy;
    [errorUserinfoDic setObject:[self parseHTTPResponseDataWith:response] forKey:YYHTTPSessionToolHTTPErrorDetailKey];
    NSError *responseError = [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:errorUserinfoDic];
    return responseError;
}
#pragma mark - 打印请求日志
- (void)HTTPRequestLog:(NSURLSessionTask *)task body:params error:(NSError *)error {
#ifdef DEBUG
    NSLog(@">>>>>>>>>>>>>>>>>>>>>👇 REQUEST FINISH 👇>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@"Request%@=======>:%@", error?@"失败":@"成功", task.currentRequest.URL.absoluteString);
    NSLog(@"requestBody======>:%@", params);
//    NSLog(@"requstHeader=====>:%@", task.currentRequest.allHTTPHeaderFields);
//    NSLog(@"response=========>:%@", task.response);
    NSLog(@"errorUserInfoDetail============>:%@", [error.userInfo valueForKey:YYHTTPSessionToolHTTPErrorDetailKey]);
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<👆 REQUEST FINISH 👆<<<<<<<<<<<<<<<<<<<<<<<<<<");
#endif
}
@end
