//
//  YYHTTPSessionTool.h
//  AFN
//
//  Created by Loser on 8/1/19.
//  Copyright © 2019 Loser. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString  *const YYHTTPSessionToolHTTPErrorDetailKey;

typedef NS_ENUM(NSInteger,YYNetworkReachabilityStatus){
    YYNetworkReachabilityStatusUnknow           = -1, // 位置网络
    YYNetworkReachabilityStatusNotReachable     = 0,  // 没有网络
    YYNetworkReachabilityStatusReachableViaWWAN = 1,  // 手机网络
    YYNetworkReachabilityStatusReachableViaWiFi = 2,  // wifi
};

@interface YYHTTPSessionTool : AFHTTPSessionManager
  
/**
 实例化对象

 @return 实例化对象
 */
+ (instancetype)sharedHTTPSessionTool;

/**
 设置请求头

 @param value value
 @param field field
 */
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field;


/**
开启网络监听

 @param block 网络状态回调
 */
- (void)monitoringNetworkStatusChangeBlock:(void(^)(YYNetworkReachabilityStatus status))block;

@end

NS_ASSUME_NONNULL_END
