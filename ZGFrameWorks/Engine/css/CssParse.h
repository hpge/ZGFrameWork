//
//  CssParse.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-9.
//  Copyright 2012 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CssElement.h"

/**
 * CSS解析器
 */
@interface CssParse : NSObject {
    NSString* m_source;
    int m_idx;
    unichar c;    
}

@property (nonatomic, retain) NSString* m_source;

- (BOOL) eof;
- (unichar) getCurrentChar;
- (unichar) getCurrentChar: (int) peek;
- (NSMutableArray*) parse;

@end
