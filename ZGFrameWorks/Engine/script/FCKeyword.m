//
//  FCKeyword.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FCKeyword.h"
#import "FCBoolean.h"
#import "FCSException.h"

@implementation FCKeyword

@synthesize ttype;
@synthesize value;
@synthesize line;

#ifndef MAX_BUFFER_SIZE
#define MAX_BUFFER_SIZE 10240
#endif

// FCSript函数的方法定义只能以字母开始
static NSCharacterSet* ALLOW_WORD_START;
//FCSript函数的变量定义只能以允许其中包含字母,数字,'.','_'
static NSCharacterSet* ALLOW_WORD;
//对数字类型Integer 或者 Double
static NSCharacterSet* ALLOW_NUMBER;
//cBuf，临时变量。作用为解析变量名或值时，一个字符一个字符地加到cBuf，组成需要的字符串
static unichar* cBuf;

+ (void) load
{
  cBuf = (unichar*) malloc(sizeof(unichar) * MAX_BUFFER_SIZE);
  memset(cBuf, 0, sizeof(unichar) * MAX_BUFFER_SIZE);
  // FCSript函数的方法定义只能以字母开始
  ALLOW_WORD_START = [NSCharacterSet characterSetWithCharactersInString:
                      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
  //FCSript函数的变量定义只能以允许其中包含字母,数字,'.','_'
  ALLOW_WORD = [NSCharacterSet characterSetWithCharactersInString:
                @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890._" ];
  //对数字类型Integer 或者 Double
  ALLOW_NUMBER = [NSCharacterSet characterSetWithCharactersInString: @"1234567890."] ;
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
//+ (void) staticFree
//{
//	[ALLOW_WORD_START release];
//    [ALLOW_WORD release];
//	[ALLOW_NUMBER release];
//  free(cBuf);
//}

- (id) init
{
  if (self = [super init]) 
  {
    line = nil;
    line_length = 0;
    pos = 0;
    c = 0;
    return self;
  }
  return nil;
}

- (id) initWithString: (NSString*) firstLine {
  self = [self init];
  [self setString: firstLine];
  return self;
}

/**
 * 设置要解析的当前行
 * @param str
 */
- (void) setString: (NSString*) str 
{  
  self.line = str;
  line_length = [line length];
  pos = 0;
  c = 0;
}

/**
 * 获取下一个字符
 * @return
 */
- (int) getChar
{
  if (pos < line_length)
  {
    unichar character = [line characterAtIndex: pos];
    pos++;
    return character;
  } else {
    return EOL;
  }
}

- (int) peekChar: (int) offset
{
  int n = pos + offset - 1;
  if (n >= line_length)
  {
    return EOL;
  } else {
    return [line characterAtIndex: n];
  }
}

/**
 * 获取下一个token
 * 注：token，英文本义：标识。
 * 在本程序中意义如下
 * 1.关键字
 * 2.变量名
 * 3.变量值
 * 
 * 两种情况
 * 1.then特殊处理（参考pushBack方法） 2.普通处理（去读下一个标识）
 * @return int token的类型
 * @throws FCSException
 */
- (int) nextToken
{
  if (!pBack) {
    return [self nextT];
  } else {
    pBack = FALSE;
    return ttype;
  }
}
/**
 * 如果遇到then，执行完then的方法体后。
 * 由于if...endif...语句读到EOL（行结束符）是继续往下执行，而then是结束该语句的意思。
 * 所以此处用于特殊处理then，让其在then方法体内循环执行，知道读到EOL，结束then语句.
 * 
 */
- (void) pushBack {
  pBack = TRUE;
}

/**
 * 获取下一个字符
 * @return int 字符的int值
 * @throws FCSException
 */
- (int) nextT {
  int cPos = 0;
  if (c == 0)
    c = [self getChar];
//    LOG(@"c=%c",c);
  value = nil;
  while (c == ' ' || c == '\t' || c == '\n' || c == '\r')
    c = [self getChar];
//    LOG(@"c=%c",c);
  if (c == EOL) 
  {//读的值为EOL（-1）也即读不到字符了，通知FCKeyWord结束
    ttype = FC_EOL;
  }
  else if (c == '#')
  {//读的值为#表示该行该字符（#）之后值都为注释。读到结尾，通知FCKeyWord结束
    while (c != EOL)
      c = [self getChar];
//      LOG(@"c=%d",c);
    [self nextT];
    [self nextT];
  }
  else if (c == '"' || c == '\'')
  {
    char startChar = c;
    //读的值为 " 表示正在读一个string类型的字符串。把转义的进行处理
    c = [self getChar];
//      LOG(@"c=%c",c);
    while ((c != EOL) && (c != startChar)) {
      if (c == '\\') {
        switch ([self peekChar:1]) {
          case 'n': {
            cBuf[cPos++] = '\n';
            [self getChar];
            break;
          }
          case 't': {
            cBuf[cPos++] = '\t';
            [self getChar];
            break;
          }
          case 'r': {
            cBuf[cPos++] = '\r';
            [self getChar];
            break;
          }
          case '\"': {
            cBuf[cPos++] = '"';
            [self getChar];
            break;
          }
          case '\\': {
            cBuf[cPos++] = '\\';
            [self getChar];
            break;
          }
          case '\'': {
            cBuf[cPos++] = '"';
            [self getChar];
            break;
          }
        }
      } else {
        cBuf[cPos++] = (unichar) c;
      }
      c = [self getChar];
//        LOG(@"c=%c",c);
    }
    value = [NSMutableString stringWithCharacters: cBuf length: cPos];
    c = [self getChar];
//      LOG(@"c=%c",c);
    ttype = FC_STRING;
  }
  // Words
  else if ([ALLOW_WORD_START characterIsMember: c])
  {
    while ([ALLOW_WORD characterIsMember: c])
    {
      cBuf[cPos++] = (char) c;
      c = [self getChar];
//        LOG(@"c=%c",c);
      [ALLOW_WORD characterIsMember: c];
    }
    value = [NSMutableString stringWithCharacters: cBuf length: cPos];
    if ([value isEqualToString:@"if"]) {   //(value.equals("if"))
      ttype = FC_IF;
    } else if ([value isEqualToString:@"then"]) {
      ttype = FC_THEN;
    } else if ([value isEqualToString:@"endif"]) {
      ttype = FC_EIF;
    } else if ([value isEqualToString:@"else"]) {
      ttype = FC_ELSE;
    } else if ([value isEqualToString:@"elseif"]) {
      ttype = FC_ELSIF;
    } else if ([value isEqualToString:@"while"]) {
      ttype = FC_WHILE;
    } else if ([value isEqualToString:@"endwhile"]) {
      ttype = FC_EWHILE;
    } else if ([value isEqualToString:@"func"]) {
      ttype = FC_DEFFUNC;
    } else if ([value isEqualToString:@"endfunc"]) {
      ttype = FC_EDEFFUNC;
    } else if ([value isEqualToString:@"return"]) {
      ttype = FC_RETURN;
    } else if ([value isEqualToString:@"exit"]) {
      ttype = FC_EXIT;
    } else if ([value isEqualToString:@"int"]) {
      ttype = FC_DEFINT;
    } else if ([value isEqualToString:@"string"]) {
      ttype = FC_DEFSTRING;
    } else if ([value isEqualToString:@"boolean"]) {// 增加Boolean类型
      ttype = FC_DEFBOOLEAN;
    } else if ([value isEqualToString:@"true"]) {// 对Boolean类型赋值
      ttype = FC_BOOLEAN;
      value = [FCBoolean boolWithBool: YES];
    } else if ([value isEqualToString:@"false"]) {// 对Boolean类型赋值
      ttype = FC_BOOLEAN;
      value = [FCBoolean boolWithBool: NO];
    } else if([value isEqualToString:@"for"]) {//增加FOR循环
      ttype = FC_FOR;
    } else if([value isEqualToString:@"endfor"]) {
      ttype = FC_EFOR;
    } else if ([value isEqualToString:@"double"]) {// 增加Double类型
      ttype = FC_DEFDOUBLE;
    } else if([value isEqualToString:@"object"]) {
      ttype=FC_DEFOBJECT;
    } else if (c == '(') {
      ttype = FC_FUNC;
    } else if (c == '[') {
      ttype = FC_ARRAY;
    } else if([value isEqualToString:@"success"]){//Dialog
      ttype = FC_STRING;
      value = DIDLOG_SUCCESS;
    } else if([value isEqualToString:@"failed"]){
      ttype = FC_STRING;
      value = DIDLOG_FAILED;
    } else if([value isEqualToString:@"warning"]){
      ttype = FC_STRING;
      value = DIDLOG_WARNING;
    } else if([value isEqualToString:@"error"]){
      ttype = FC_STRING;
      value = DIDLOG_ERROR;
    } else if([value isEqualToString:@"doubt"]){
      ttype = FC_STRING;
      value = DIDLOG_DOUBT;
    } else if([value isEqualToString:@"prompt"]){
      ttype = FC_STRING;
      value = DIDLOG_PROMPT;
    } else {
      ttype = FC_WORD;
    }
  }
  //数字类型处理
  else if([ALLOW_NUMBER characterIsMember: c])
  {
    BOOL hasDot = NO;
    while ([ALLOW_NUMBER characterIsMember: c])
    {
      if (!hasDot)
        hasDot = c == '.';
      cBuf[cPos++] = (char) c;
      c = [self getChar];
//        LOG(@"c=%c",c);
    }
    NSMutableString* str = [NSMutableString stringWithCharacters: cBuf length: cPos];

    if(hasDot) {//如果字符中间包含'.'就按照是double类型处理
      ttype = FC_DOUBLE;
      value = [NSNumber numberWithDouble: [str doubleValue]];
    } else {
      ttype = FC_INTEGER;//如果不包含就按照int类型处理
      value = [NSNumber numberWithDouble: [str intValue]];
    }
    
  }

  else if(c==';'){
    [[[FCSException alloc] initWithReason: @"the operators ';' is illegal !"] raise];
  }
  else {
    if (c == '+') {
      ttype = FC_PLUS;
    } else if (c == '-') {
      if ( [self peekChar:1] == '-') {
        [[[FCSException alloc] initWithReason: @"the operators '--' is illegal !"] raise];
      } else {
        ttype = FC_MINUS;
      }
    } else if (c == '*') {
      ttype = FC_MULT;
    } else if (c == '/') {
      ttype = FC_DIV;
    } else if (c == '%') {
      ttype = FC_MOD;
    } else if (c == '>') {
      if ([self peekChar:1] == '=') {
        [self getChar];
        ttype = FC_LGRE;
      } else {
        ttype = FC_LGR;
      }
    } else if (c == '<') {
      if ([self peekChar:1] == '=') {
        [self getChar];
        ttype = FC_LLSE;
      } else {
        ttype = FC_LLS;
      }
    } else if (c == '=') {
      if ([self peekChar:1] == '=') {
        [self getChar];
        ttype = FC_LEQ;
      } else {
        ttype = FC_EQ;
      }
    } else if (c == '!') {
      if ([self peekChar:1] == '=') {
        [self getChar];
        ttype = FC_LNEQ;
      } else {
        ttype = FC_NOT;
      }
    } else if ((c == '|') && ([self peekChar:1] == '|')) {// ||
      [self getChar];
      ttype = FC_LOR;
    } else if ((c == '&') && ([self peekChar:1] == '&')) {// &&
      [self getChar];
      ttype = FC_LAND;
    }
    else if (c == ']') {
      ttype = FC_ENDARRAY;
    } 
    
    else {
      ttype = c;
    }
    c = [self getChar];
//      LOG(@"c=%c",c);
  }
  
  return ttype;
}

- (void)dealloc {
  if (cBuf) {
    free(cBuf);
    cBuf = NULL;
  }
}

@end
