//
//  YYHTTPSessionTool.m
//  AFN
//
//  Created by Loser on 8/1/19.
//  Copyright © 2019 Loser. All rights reserved.
//

#import "YYHTTPSessionTool.h"

NSString  *const YYHTTPSessionToolHTTPErrorDetailKey = @"YYHTTPSessionToolHTTPErrorDetailKey";

@interface YYHTTPSessionTool ()

@end

@implementation YYHTTPSessionTool

static YYHTTPSessionTool *HTTPTool = nil;
    
+ (instancetype)sharedHTTPSessionTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPTool = [[YYHTTPSessionTool alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return HTTPTool;
}
    
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPTool = [super allocWithZone:zone];
    });
    return HTTPTool;
}
    
- (id)copyWithZone:(NSZone *)zone{
    return HTTPTool;
}
    
    
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration{
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        // 配置网络信息
        [self configHTTPRequest];
    }
    return self;
}
    
/// HTTP配置
- (void)configHTTPRequest{
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",@"multipart/form-data",nil];
}
    
/// 开启网络状态监听
- (void)monitoringNetworkStatusChangeBlock:(void(^)(YYNetworkReachabilityStatus status))block{
    
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (block) {
            block((YYNetworkReachabilityStatus)status);
        }
    }];
    [self.reachabilityManager startMonitoring];
}
    

- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field
{
    [self.requestSerializer setValue:value forHTTPHeaderField:field];
}

    
@end
