//
//  FCSException.m
//  mar_client_iphone
//
//  Created by Melvin on 11-9-6.
//  Copyright 2011 Mar114. All rights reserved.
//

#import "FCSException.h"


@implementation FCSException

- (id) initWithReason: (NSString*) aReason
             userInfo: (NSDictionary*) aUserInfo
{
  return [super initWithName: @"FCSException" reason: aReason userInfo: aUserInfo];
}

- (id) initWithReason: (NSString*) aReason
{
  return [self initWithReason: aReason userInfo: nil];
}

@end

@implementation RetException
@end

@implementation ExitException
@end