//
//  YYHTTPSessionTool+RAC.h
//  AFN
//
//  Created by Loser on 8/1/19.
//  Copyright © 2019 Loser. All rights reserved.
//
@class RACSignal;
#import "YYHTTPSessionTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYHTTPSessionTool (RAC)

/**
 GET网络请求

 @param path 网络请求地址
 @param params 网络请求参数
 @return 响应信号
 */
- (RACSignal *)RAC_GET:(NSString *)path parameters:(NSDictionary *)params;
/**
 POST网络请求
 
 @param path 网络请求地址
 @param params 网络请求参数
 @return 响应信号
 */
- (RACSignal *)RAC_POST:(NSString *)path parameters:(NSDictionary *)params;
/**
 PUT网络请求
 
 @param path 网络请求地址
 @param params 网络请求参数
 @return 响应信号
 */
- (RACSignal *)RAC_PUT:(NSString *)path parameters:(NSDictionary *)params;

/**
 PATCH网络请求
 
 @param path 网络请求地址
 @param params 网络请求参数
 @return 响应信号
 */
- (RACSignal *)RAC_PATCH:(NSString *)path parameters:(NSDictionary *)params;

/**
 以PUT请求方式上传资源

 @param path 网络请求地址
 @param params 网络请求参数
 @param block 一个接受参数并将数据附加到HTTP body上的block回调
 @return 响应信号源
 */
- (RACSignal *)RAC_PUTUploadRequestWith:(NSString *)path parameters:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

/**
 以POST请求方式上传资源
 
 @param path 网络请求地址
 @param params 网络请求参数
 @param block 一个接受参数并将数据附加到HTTP body上的block回调
 @return 响应信号源
 */
- (RACSignal *)RAC_POSTUploadRequestWith:(NSString *)path parameters:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;
@end

NS_ASSUME_NONNULL_END
