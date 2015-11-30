//
//  OtherScriptImpl.h
//  mar_client_iphone
//
//  Created by Melvin on 12-2-28.
//  Copyright (c) 2012年 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCBoolean.h"
#import <MessageUI/MessageUI.h>

#define SMS       1
#define MAIL      2

@interface OtherScriptImpl : NSObject

- (NSString*) getCurrentTime: (NSArray*) params;
- (NSString*) generateTransSeq: (NSArray*) params;
- (FCBoolean*) isnull: (NSArray*) params;
- (void) clearfocus: (NSArray*) params;
- (NSArray*) queryfieldarray: (NSArray*) params;

@end
