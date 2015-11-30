//
//  FCTreeNode.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FCTreeNode.h"


@implementation FCTreeNode

@synthesize type;
@synthesize value;
@synthesize left;
@synthesize right;
@synthesize parent;

- (id) init {
    if (self = [super init]) {

    }
    return (self);
}


- (NSString*) toString {
    NSMutableString* string = [NSMutableString stringWithString:@"Type="];
    [string appendFormat:@"%d", type];
    [string appendString:@" Value="];
    [string appendFormat:@"%d",value];
    return string;
}


@end
