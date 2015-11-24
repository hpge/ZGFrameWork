//
//  ZGBaseRequest.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/24.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

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

@interface ZGBaseRequest : NSObject



@end
