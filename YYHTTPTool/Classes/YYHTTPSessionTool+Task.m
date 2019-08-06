//
//  YYHTTPSessionTool+Task.m
//  AFN
//
//  Created by Loser on 8/1/19.
//  Copyright © 2019 Loser. All rights reserved.
//

#import "YYHTTPSessionTool+Task.h"
#import "YYHTTPSessionTool+Help.h"

@implementation YYHTTPSessionTool (Task)
    
#pragma mark ================================= 数据请求
- (void)HTTPRequestWith:(NSString *)path
             parameters:(NSDictionary *)params
                success:(void (^)(NSDictionary *response))success
                failure:(void(^)(NSDictionary *errorResponse,NSError *error))failure
                 method:(NSString *)method{
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithHTTPMethod:method URLString:path parameters:params success:^(id responseObject) {
        [self requestSuccessWith:responseObject successBlock:success];
    } failure:^(id responseObject, NSError *error) {
        NSError *responseError = [self assemblyHTTPErrorWith:error responseObject:responseObject];
        [self HTTPRequestLog:dataTask body:params error:responseError];
        [self requestFailureWith:responseError errorResponse:responseObject failureBlock:failure];
    }];
}

/// 网络请求
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(id responseObject, NSError *))failure{
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(responseObject,error);
                               }
                           } else {
                               if (success) {
                                   success(responseObject);
                               }
                           }
                       }];
    [dataTask resume];
    
    return dataTask;
}
    
- (void)requestSuccessWith:(id)response successBlock:(void (^)(NSDictionary *response))block{
    NSDictionary *jsonDictionary = [self parseHTTPResponseDataWith:response];
    if (block) {
        block(jsonDictionary);
    }
}
    
- (void)requestFailureWith:(NSError *)error errorResponse:(id)errorRes failureBlock:(void (^)(NSDictionary *errorResponse,NSError *error))block{
    NSDictionary *jsonDictionary = [self parseHTTPResponseDataWith:errorRes];
    if (block) {
        block(jsonDictionary,error);
    }
}




#pragma mark ================================= 上传资源文件请求
- (void)POSTUploadWith:(NSString *)path
            parameters:(NSDictionary *)params
            constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(NSDictionary *response))success
            failure:(void(^)(NSDictionary *errorResponse,NSError *error))failure{
    [self uploadRequestWith:path parameters:params constructingBodyWithBlock:block success:success failure:failure method:@"POST"];
}
    
- (void)PUTUploadWith:(NSString *)path
            parameters:(NSDictionary *)params
            constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(NSDictionary *response))success
            failure:(void(^)(NSDictionary *errorResponse,NSError *error))failure{
    [self uploadRequestWith:path parameters:params constructingBodyWithBlock:block success:success failure:failure method:@"PUT"];
}
    
- (void)uploadRequestWith:(NSString *)path
            parameters:(NSDictionary *)params
            constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(NSDictionary *response))success
            failure:(void(^)(NSDictionary *errorResponse,NSError *error))failure
            method:(NSString *)method{
   
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:params constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [self requestFailureWith:serializationError errorResponse:nil failureBlock:failure];
            });
#pragma clang diagnostic pop
        }
        
    }
    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            NSError *responseError = [self assemblyHTTPErrorWith:error responseObject:responseObject];
            [self HTTPRequestLog:task body:params error:responseError];
            [self requestFailureWith:responseError errorResponse:responseObject failureBlock:failure];
        } else {
            [self requestSuccessWith:responseObject successBlock:success];
        }
    }];
    
    [task resume];
    
}

@end
