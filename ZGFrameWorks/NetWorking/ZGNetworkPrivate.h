//
//  ZGNetworkPrivate.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/24.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGBaseRequest.h"
#import "ZGBatchRequest.h"
#import "ZGChainRequest.h"

FOUNDATION_EXPORT void ZGLog(NSString *format,...) NS_FORMAT_FUNCTION(1,2);

@interface ZGNetworkPrivate : NSObject
/**
 *  检查json合法性
 *
 *  @param json
 *  @param validatorJson
 *
 *  @return  true | false
 */
+ (BOOL)checkJson:(id)json withValidator:(id)validatorJson;

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;

+ (void)addDoNotBackupAttribute:(NSString *)path;
/**
 *  MD5 Securet
 *
 *  @param string
 *
 *  @return MD5 Encode
 */
+ (NSString *)md5StringFromString:(NSString *)string;

+ (NSString *)appVersionString;

@end

@interface ZGBaseRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;
@end

@interface ZGBatchRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end

@interface ZGChainRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end
