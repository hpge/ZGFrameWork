//
//  ZGChainRequestAgent.m
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/24.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import "ZGChainRequestAgent.h"


@interface ZGChainRequestAgent()

@property (strong, nonatomic) NSMutableArray *requestArray;

@end

@implementation ZGChainRequestAgent

+ (ZGChainRequestAgent *)sharedInstance{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance =[[self alloc]init];
    });
    return shareInstance;
}


- (id)init {
    self=[super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequest:(ZGChainRequest *)request{
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeChainRequest:(ZGChainRequest *)request{
    @synchronized(self) {
        [_requestArray removeObject:request];
    }

}
@end
