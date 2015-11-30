//
//  CssDocument.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-9.
//  Copyright 2012 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CssElement.h"
#import "CssOperate.h"
#import "CssParse.h"

/**
 *装载CSS文档. 
 */

@interface CssDocument : NSObject {
    NSString* _Text;
    NSMutableArray* _Elements;
    CssOperate* cssOp;
}

@property (nonatomic, retain) NSString* _Text;
@property (nonatomic, retain) NSMutableArray* _Elements;
@property (nonatomic, retain) CssOperate* cssOp;

- (void) load: (NSString*) filePath;

@end
