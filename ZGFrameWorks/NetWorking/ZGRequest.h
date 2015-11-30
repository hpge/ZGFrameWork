//
//  ZGRequest.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/24.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGBaseRequest.h"
@interface ZGRequest : ZGBaseRequest
@property (nonatomic) BOOL ignoreCache;

// 返回当前缓存的对象
- (id) cacheJson;

// 是否当前的数据从缓存获得
- (BOOL)isDataFromCache;

//返回当前缓存是否需要更新
- (BOOL)isCacheVersionExpired;

//强制更新缓存
- (void)startWithoutCache;

//手动将其他请求的respone 写入该请求
-(void)saveJsonResponeToCacheFile:(id)json;


// for subclass to overwrite
- (NSInteger)cacheTimeInSeconds;

- (long long)cacheVersion;

- (id)cacheSensitiveData;
@end
