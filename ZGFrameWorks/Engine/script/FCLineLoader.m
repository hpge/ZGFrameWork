//
//  FCLineLoader.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FCLineLoader.h"


@implementation FCLineLoader

/**
 * FCLineLoader用来加载本地FCSript的script代码
 * 加载方式是逐行加载到缓存中
 * Vector<String>存储String类型数据
 */

- (id) init {
    if (self = [super init]) {
        lines = [NSMutableArray arrayWithCapacity:20];
            curLine = 0;
    }
    return (self);
}

/**
 * 重置 FCLineLoader.
 *  
 */
- (void) reset {
    [lines removeAllObjects];
    curLine=0;
}

/**
 * 向缓存中增加数据.
 * @param s fcscript代码
 */
- (void) addLine: (NSString*) s {
    NSString* tempString = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![tempString isEqualToString: @""]) {
        [lines addObject: s];
    } else {            
        [lines addObject: @""];
    }
}

/**
 * 增加行，并去掉空行
 * 增加"\n"特殊字符处理.
 * @param s fcscript代码
 */
- (void) addLines: (NSString*) s {
    int pos;
    NSString* tempString = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    LOG(@"%@",tempString);
    if (![tempString isEqualToString: @""]){
        
        NSRange range = [s rangeOfString:@"\n"];
        pos = range.location;
        
        while (pos >= 0 && pos != NSNotFound){
            [self addLine: [s substringToIndex:pos]];
            s = [s substringFromIndex:pos+1];
            range = [s rangeOfString:@"\n"];
            pos = range.location;

        }
        tempString = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![tempString isEqualToString: @""]){
            [self addLine:s];
        }
    }
}

/**
 * 设置当前执行行.
 * @param n 前行数
 */
- (void) setCurLine: (int) n {
    if (n > [lines count]) {
        n = [lines count] - 1;
    } else if (n < 0) {
        n = 0;
    }
    
    curLine = n;
}

/**
 * 返回当前执行的是第几行.
 *@return int 当前fcscript脚本行数
 */
- (int) getCurLine {
    return curLine;
}

/**
 *返回缓冲区代码总数.
 *@return int fcscript脚本总行数
 */
- (int) lineCount {
    int a = [lines count];
    return a;
}

/**
 *返回当前行的文本.
 *@return String 当前行的fcscript脚本
 */
- (NSString*) getLine {
    NSString* str= [NSString stringWithString: [lines objectAtIndex:curLine]];
//    LOG(@"当前行的fcscript脚本=%@", str);
    return str;
}

/**
 *返回所请求的行的文本.
 *@param n 行数 
 *@return String 如果指定行存在,就返回指定行的fcscript脚本,不存在就返回""
 */

- (NSString*) getLine:(int) n {
    if(n < 0 || n >= [lines count]){
        return @"";
    }
    return [lines objectAtIndex: n];
}

//- (void) dealloc
//{
//    [super dealloc];
//    [lines release];
//}

@end
