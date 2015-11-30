//
//  FCFuncEntry.h
//  mar_client_iphone
//
//  Created by Melvin on 11-9-6.
//  Copyright 2011 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCFuncEntry : NSObject {
  int startLine;  // function起始位置
  int endLine;    // function结束位置
  NSMutableArray*       paramNames;
  NSMutableDictionary*  params;
}

- (id) init;
- (NSString*) toString;

@property (nonatomic) int startLine;
@property (nonatomic) int endLine;
@property (nonatomic, readonly) NSMutableArray* paramNames;
@property (nonatomic, readonly) NSMutableDictionary*  params;

@end
