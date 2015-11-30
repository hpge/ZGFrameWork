//
//  ZGBaseRequest.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/24.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFDownloadRequestOperation.h"


typedef  NS_ENUM(NSInteger, ZGRequestMethod) {
    ZGRequestMethodGet =0,
    ZGRequestMethodPost,
    ZGRequestMethodHead,
    ZGRequestMethodPut,
    ZGRequestMethodDelete,
    ZGRequestMethodPatch
};

typedef NS_ENUM(NSInteger, ZGRequestSerializerType){
    ZGRequestSerializerTypeHTTP=0,
    ZGRequestSerializerTypeJSON,
};

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^AFDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);

@class ZGBaseRequest;
@protocol ZGRequestDelegate <NSObject>
@optional
- (void)requestFinished:(ZGBaseRequest *)request;
- (void)requestFailed:(ZGBaseRequest *)request;
- (void)clearRequest;

@end

@protocol ZGRequestAccessory <NSObject>

@optional

-(void)requestWillStart:(id)request;
-(void)requestwillStop:(id)request;
-(void)requestDidStop:(id)request;

@end

@interface ZGBaseRequest : NSObject
/// Tag
@property (nonatomic)NSInteger tag;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

@property (nonatomic, weak) id< ZGRequestDelegate> delegate;


@property (nonatomic, strong, readonly) NSDictionary *responseHeads;

@property (nonatomic, strong, readonly) NSString *responseString;

@property (nonatomic, strong, readonly) id responseJSONObject;

@property (nonatomic, readonly) NSInteger responseStatusCode;

@property (nonatomic, copy) void (^successCompletionBlock)(ZGBaseRequest *);

@property (nonatomic, copy)void (^failureCompletionBlock)(ZGBaseRequest *);

@property (nonatomic, strong) NSMutableArray *requestAccessories;

/// append self to request queue

- (void)start;

/// remove self from request queue

- (void)stop;

- (BOOL)isExecuting;

- (void)startWithCompletionBlockWithSuccess:(void(^)(ZGBaseRequest *request))success
                                   failure:(void(^)(ZGBaseRequest *request))failure;

- (void)setCompletionBlockWithSuccess:(void(^)(ZGBaseRequest *request))success
                              failure:(void(^)(ZGBaseRequest *request))failure;


- (void)clearCompletionBlock;

- (void)addAccessory:(id<ZGRequestAccessory>)accessory;

- (void)requestCompleteFilter;

- (void)requestFailterFilter;

- (NSString *)cdnUrl;
///请求baseurl
- (NSString *)baseUrl;
//请求的连接超时时间，默认30秒
- (NSTimeInterval)requestTimeoutInterval;

///请求参数列表
- (id)requestArgument;

///
- (id)cacheFileNameFilterForRequestArgument:(id) argument;

- (ZGRequestMethod)requestMethod;

- (ZGRequestSerializerType)requestSerializerType;


- (NSArray *)requestAuthorizationHeardFile;

/// 在HTTP报头添加的自定义参数

- (NSDictionary *)requestHeaderFieldValueDictionary;

/// 构建自定义的UrlRequest，
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType

- (NSURLRequest *)buildCustomUrlRequest;

/// 是否使用CDN的host地址
- (BOOL)useCDN;

/// 用于检查JSON是否合法的对象
- (id)jsonValidator;

/// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator;

/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock;

/// 当需要断点续传时，指定续传的地址
- (NSString *)resumableDownloadPath;

/// 当需要断点续传时，获得下载进度的回调
- (AFDownloadProgressBlock)resumableDownloadProgressBlock;


@end
