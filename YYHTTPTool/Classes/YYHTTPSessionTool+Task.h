//
//  YYHTTPSessionTool+Task.h
//  AFN
//
//  Created by Loser on 8/1/19.
//  Copyright © 2019 Loser. All rights reserved.
//

#import "YYHTTPSessionTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYHTTPSessionTool (Task)

/**
 block 网络请求

 @param path 发起网络请求地址
 @param params 网络请求的参数
 @param success 网络请求成功回调
 @param failure 网络请求失败回调
 @param method 网络请求方式(GET,POST,PUT,PATCH)
 */
- (void)HTTPRequestWith:(NSString *)path
             parameters:(NSDictionary *)params
                success:(void (^)(NSDictionary *response))success
                failure:(void(^)(NSDictionary *errorResponse,NSError *error))failure
                 method:(NSString *)method;



/**
 POST方式上传资源

 @param path 发起网络请求地址
 @param params 网路请求参数
 @param block 一个接受参数并将数据附加到HTTP body上的block回调
 @param success 网络请求成功回调
 @param failure 网络请求失败回调
 */
- (void)POSTUploadWith:(NSString *)path
            parameters:(NSDictionary *)params
            constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(NSDictionary *response))success
            failure:(void(^)(NSDictionary *errorResponse,NSError *error))failure;
/**
 PUT方式上传资源
 
 @param path 发起网络请求地址
 @param params 网路请求参数
 @param block 一个接受参数并将数据附加到HTTP body上的block回调
 @param success 网络请求成功回调
 @param failure 网络请求失败回调
 */
- (void)PUTUploadWith:(NSString *)path
           parameters:(NSDictionary *)params
           constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
           success:(void (^)(NSDictionary *response))success
           failure:(void(^)(NSDictionary *errorResponse,NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
