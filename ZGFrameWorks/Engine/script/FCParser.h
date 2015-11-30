//
//  FCParser.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCLineLoader.h"
#import "FCKeyword.h"
#import "FCTreeNode.h"
#import "FCScript.h"

@class FCScript;


@interface FCParser : NSObject {

    FCLineLoader* code; // 行载入器
    FCKeyword* tok; // 文字管理器
    
    int maxLine;// 最大行数
    
    NSMutableDictionary* vars; // 局部变量管理容器
    NSMutableDictionary* gVars; // 全局变量管理容器

    FCScript* host; // script解析的主函数（在这里就是FCScriptImpl）
    NSMutableDictionary* funcs; // 函数管理器
    id retVal; // 暂未使用
    NSMutableArray* error;
  FCTreeNode* curNode;
  
}

@property (nonatomic, retain) FCLineLoader* code;
@property (nonatomic, retain) FCKeyword* tok;
@property (nonatomic) int maxLine;
@property (nonatomic, retain) FCTreeNode* curNode;
@property (nonatomic, retain) NSMutableDictionary* vars;
@property (nonatomic, retain) NSMutableDictionary* gVars;
@property (nonatomic, retain) FCScript* host;
@property (nonatomic, retain) NSMutableDictionary* funcs;

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;
- (void) parseFor;
- (id) parseExpr;
- (void) parseError:(NSString*) s;
- (void) getNextToken;
- (void) addVar: (NSString*) name value: (id) value;
- (id) getVar:(NSString*) name;
- (void) resetTokens;
- (void) parseForDefWord;
- (id)initWithFCScript: (FCScript*) h;
- (void) setCode:(FCLineLoader*) _in;
- (void) reset;
- (void) parseDefFuncfrom:(int) from
                       to:(int) to;
- (id) parsefrom:(int) from
              to: (int) to;
- (void) exit:(id) o;
- (NSMutableArray*) getError;
- (id) getArrayItemByName: (NSString*) name andIndex: (id) index;
- (void) setVarWithName: (NSString*) name value: (id) val;
- (id) callFunction: (NSString*) name
              Array: (NSMutableArray*) params;
- (void) checkLine:(NSString*) line;
- (void) parseStmt;
- (void) parseKeyWord;
- (void) parseAssign;
- (BOOL) hasVar:(NSString*) name;
- (id) evalAndObject: (id) lVal Object: (id) rVal;
- (id) evalOrObject:  (id) lVal Object: (id) rVal;
- (id) evalDivObject: (id) lVal Object: (id) rVal;
- (id) evalEqObject:  (id) lVal Object: (id) rVal;
- (id) evalLsObject:  (id) lVal Object: (id) rVal;
- (id) evalLseObject: (id) lVal Object: (id) rVal;
- (id) evalGrObject:  (id) lVal Object: (id) rVal;
- (id) evalGreObject: (id) lVal Object: (id) rVal;
- (id) evalNEqObject: (id) lVal Object: (id) rVal;
- (id) evalModObject: (id) lVal Object: (id) rVal;
- (id) evalPlusObject:(id) lVal Object: (id) rVal;
- (id) evalMinusObject: (id) lVal Object: (id) rVal;
- (id) evalMultObject: (id) lVal Object: (id) rVal;
- (id) evalETree: (FCTreeNode*) node;
- (int) getPrio:(int) op;
- (void) parseFunctionDef;
- (void) parseFunc;
- (id) parseCallFunc: (NSString*) name;
- (void) setArrayItemByName: (NSString*) name
                   andIndex: (id) index 
                      value: (id) val;
- (void) parseArrayAssign;
- (void) parseVarDef;
- (void) parseIf;
- (void) parseWhile;
- (int) parseExprValue;
- (void) printETree:(FCTreeNode*) node;
- (void) parseReturn;
- (void) parseExit;
- (BOOL) definedFunction: (NSString*) name;

@end