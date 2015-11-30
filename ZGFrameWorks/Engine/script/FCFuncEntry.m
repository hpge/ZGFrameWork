//
//  FCFuncEntry.m
//  mar_client_iphone
//
//  Created by Melvin on 11-9-6.
//  Copyright 2011 Mar114. All rights reserved.
//

#import "FCFuncEntry.h"
#import "OtherUtils.h"

@implementation FCFuncEntry

@synthesize startLine;
@synthesize endLine;
@synthesize paramNames;
@synthesize params;

- (id) init
{
  if (self = [super init])
  {
    startLine = 0;
    endLine = 0;
    paramNames = [[NSMutableArray alloc] initWithCapacity: 4];
    params = [[NSMutableDictionary alloc] init];
    return self;
  }
  return nil;
}

- (NSString*) toString
{
  NSMutableString* result = [NSMutableString stringWithString: @"FCFuncEntry:"];
  [result appendFormat: @"startLine : %d\r\n", startLine];
  [result appendFormat: @"endLine : %d\r\n", endLine];
  [result appendFormat: @"paramNames : %@\r\n", [OtherUtils stringWithArray: paramNames]];
  [result appendFormat: @"params : %@\r\n", [OtherUtils stringWithDictionary: params]];
  return result;
}
@end
