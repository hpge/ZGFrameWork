//
//  FCLineLoader.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FCLineLoader : NSObject {
    NSMutableArray *lines;//行储存器
    int curLine;//当前行
}

- (id) init;
- (void) reset;
- (void) addLine: (NSString*) s;
- (void) addLines: (NSString*) s;
- (int) getCurLine;
- (void) setCurLine: (int) n;
- (NSString*) getLine;
- (void) setCurLine: (int) n;
- (int) lineCount;
- (NSString*) getLine:(int) n;

@end
