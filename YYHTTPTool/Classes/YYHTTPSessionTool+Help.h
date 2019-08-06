//
//  YYHTTPSessionTool+Help.h
//  AFN
//
//  Created by Loser on 8/2/19.
//  Copyright © 2019 Loser. All rights reserved.
//

#import "YYHTTPSessionTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYHTTPSessionTool (Help)

/**
 解析网络返回数据

 @param response 网络返回数据
 @return jsonDic
 */
- (NSDictionary *)parseHTTPResponseDataWith:(id)response;


/**
 把网络请求错误数据添加到error中

 @param error Http error
 @param response Http 返回数据
 @return error
 */
- (NSError *)assemblyHTTPErrorWith:(NSError *)error responseObject:(id)response;
/**
 网络请求数据错误打印

 @param task 网络请求任务
 @param error 网络请求错误
 */
- (void)HTTPRequestLog:(NSURLSessionTask *)task body:params error:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
