//
//  FCBoolean.h
//  mar_client_iphone
//
//  Created by Melvin on 11-9-6.
//  Copyright 2011 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCBoolean : NSObject {
  BOOL value;
}

@property (nonatomic, readonly) BOOL value;

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;

+ (FCBoolean*) boolWithBool: (BOOL) boolValue;

+ (FCBoolean*) YesBoolean;
+ (FCBoolean*) NoBoolean;

- (BOOL) boolValue;

@end
