//
//  FCBoolean.m
//  mar_client_iphone
//
//  Created by Melvin on 11-9-6.
//  Copyright 2011 Mar114. All rights reserved.
//

#import "FCBoolean.h"


@implementation FCBoolean

@synthesize value;

static FCBoolean* YesValue;
static FCBoolean* NoValue;

+ (void) load
{
  YesValue = [[FCBoolean alloc] init];
  YesValue->value = YES;
  NoValue = [[FCBoolean alloc] init];
  NoValue->value = NO;
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
//+ (void) staticFree
//{
//	[YesValue release];
//    [ NoValue release];
//}

+ (FCBoolean*) boolWithBool: (BOOL) boolValue
{
  if (boolValue)
    return YesValue;
  return NoValue;
}

+ (FCBoolean*) YesBoolean
{
  return YesValue;
}

+ (FCBoolean*) NoBoolean
{
  return NoValue;
}

- (BOOL) boolValue
{
  return value;
}

@end
