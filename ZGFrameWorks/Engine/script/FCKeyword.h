//
//  FCKeyword.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// general 
#define FC_WORD  9000 //文字
#define FC_INTEGER  9100 //int
#define FC_DOUBLE  9150 //double
#define FC_BOOLEAN  9151 // boolean测试
#define FC_OBJECT  91512 //object
#define FC_EOF   9200  // 整个script的结束符
#define FC_EOL   9300 //该行结束符
#define FC_STRING   9500 //string
#define FC_FUNC   9600 //函数开始关键字
#define FC_ARRAY   9650 //数组
#define FC_ENDARRAY   9651 //数组

// keywords关键字
#define FC_IF   9700 //if
#define FC_EIF   9800 //endif
#define FC_ELSE   9850 //else
#define FC_ELSIF   9855 //elseif
#define FC_THEN   9875 //then

#define FC_DEFFUNC   9900 //自定义的函数
#define FC_EDEFFUNC   10000 //自定义的函数结束
#define FC_WHILE   10100 
#define FC_EWHILE   10200 
#define FC_DEFINT   10300 //自定义的int
#define FC_DEFSTRING   10400 //自定义的string
#define FC_DEFDOUBLE   10425 //double测试
#define FC_DEFBOOLEAN   10426 // boolean测试
#define FC_DEFOBJECT 10427 //object
#define FC_RETURN   10450 
#define FC_EXIT   10455 

#define FC_FOR 10456 //定义for循环
#define FC_EFOR 10457 

// math opts  数学运算符
#define FC_PLUS   10500 
#define FC_MINUS   10600 
#define FC_MULT   10700 
#define FC_DIV   10800 
#define FC_MOD   10850 

// logic 逻辑运算符
#define FC_LAND   10900 // ||
#define FC_LOR   11000 //&&
#define FC_LEQ   11100 //==
#define FC_LNEQ   11200 //!=
#define FC_LGR   11300 //>
#define FC_LLS   11500 //<
#define FC_LGRE   11600 //>=
#define FC_LLSE   11700 //<=
#define FC_NOT   11800 //!

//null
#define FC_NULL 118001 

//Dialog常量
#define DIDLOG_SUCCESS @"1" //success
#define DIDLOG_FAILED @"2" //failed
#define DIDLOG_WARNING @"3" //warning
#define DIDLOG_ERROR @"4" //error
#define DIDLOG_DOUBT @"5" //doubt
#define DIDLOG_PROMPT @"6" //	提示

// equal
#define FC_EQ   11900 

//行结束标识
#define EOL   -1 

/**
 * FCLexAnn ,sript代码中各种关键字的定义
 *  1.管理关键字(包括结束符，if，then，endif，else，while，endwhile，func，endfunc，return，exit，int，string，[，]，（，），字符串。。。。)
 *	2．存储值（变量名，变量值）
 *
 */
@interface FCKeyword : NSObject
{
  int ttype;//变量类型
  id value;//变量值

  bool pBack;//then特殊处理

  //line,该行script的字符转成的char数组。
  NSString* line;
  NSUInteger line_length;

  int pos;//该行的char数组索引
  int c;//临时变量，当前读到的char值
}

@property int ttype;
@property (nonatomic, retain) id value;
@property (nonatomic, retain) NSString* line;

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;

- (id) initWithString: (NSString*) firstLine;
- (void) setString: (NSString*) str;
- (int) getChar;
- (int) peekChar: (int) offset;
- (int) nextT;
- (int) nextToken;
- (void) pushBack;

@end