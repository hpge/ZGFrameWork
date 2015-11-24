//
//  ZGChainRequestAgent.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/24.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGChainRequest.h"
@interface ZGChainRequestAgent : NSObject

+(ZGChainRequestAgent *)sharedInstance;

-(void)addChainRequest:(ZGChainRequest *)request;

-(void)removeChainRequest:(ZGChainRequest *)request;
@end
