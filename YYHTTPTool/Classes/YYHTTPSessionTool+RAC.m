//
//  YYHTTPSessionTool+RAC.m
//  AFN
//
//  Created by Loser on 8/1/19.
//  Copyright © 2019 Loser. All rights reserved.
//

#import "YYHTTPSessionTool+RAC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YYHTTPSessionTool+Help.h"

@implementation YYHTTPSessionTool (RAC)
    
#pragma mark ================================= 网络请求方式
- (RACSignal *)RAC_GET:(NSString *)path parameters:(NSDictionary *)params{
    return [self RAC_RequestWith:path parameters:params method:@"GET"];
}
- (RACSignal *)RAC_POST:(NSString *)path parameters:(NSDictionary *)params{
    return [self RAC_RequestWith:path parameters:params method:@"POST"];
}
- (RACSignal *)RAC_PUT:(NSString *)path parameters:(NSDictionary *)params{
    return [self RAC_RequestWith:path parameters:params method:@"PUT"];
}
- (RACSignal *)RAC_PATCH:(NSString *)path parameters:(NSDictionary *)params{
    return [self RAC_RequestWith:path parameters:params method:@"PATCH"];
}

- (RACSignal *)RAC_RequestWith:(NSString *)path parameters:(NSDictionary *)params method:(NSString *)method
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *requestError;
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:path parameters:params error:&requestError];
        if (requestError) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:requestError];
            });
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        __block NSURLSessionDataTask *task = nil;
       task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
           if (error) {
               NSError *responseError = [self assemblyHTTPErrorWith:error responseObject:responseObject];
               [self HTTPRequestLog:task body:params error:responseError];
               [subscriber sendError:responseError];
           }else {
               [subscriber sendNext:[self parseHTTPResponseDataWith:responseObject]];
               [subscriber sendCompleted];
           }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
    
#pragma mark ================================= 上传资源请求方式
- (RACSignal *)RAC_PUTUploadRequestWith:(NSString *)path parameters:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block{
    
    return [self RAC_UploadRequestWith:path parameters:params constructingBodyWithBlock:block method:@"PUT"];
}
- (RACSignal *)RAC_POSTUploadRequestWith:(NSString *)path parameters:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block{
    
    return [self RAC_UploadRequestWith:path parameters:params constructingBodyWithBlock:block method:@"POST"];
}

- (RACSignal *)RAC_UploadRequestWith:(NSString *)path parameters:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block method:(NSString *)method
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *requestError;
        NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:method URLString:path parameters:params constructingBodyWithBlock:block error:&requestError];
        
        if (requestError) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:requestError];
            });
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        __block NSURLSessionDataTask *task = nil;
        task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSError *responseError = [self assemblyHTTPErrorWith:error responseObject:responseObject];
                [self HTTPRequestLog:task body:params error:responseError];
                [subscriber sendError:responseError];
            }else {
                [subscriber sendNext:[self parseHTTPResponseDataWith:responseObject]];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
    
@end
