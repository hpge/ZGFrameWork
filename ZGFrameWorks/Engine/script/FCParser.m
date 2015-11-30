//
//  FCParser.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FCParser.h"
#import "FCSException.h"
#import "FCFuncEntry.h"
#import "FCBoolean.h"
#import "ZGUIConstants.h"

@implementation FCParser

@synthesize code;
@synthesize tok;
@synthesize maxLine;
@synthesize vars;
@synthesize gVars;
@synthesize host;
@synthesize funcs;
@synthesize curNode;

static NSMutableDictionary* opPrio; // 操作符管理器（并管理其优先级）



+ (void) load
{
    opPrio = [NSMutableDictionary dictionaryWithCapacity:15];
    [opPrio setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:FC_LOR]];
    [opPrio setObject:[NSNumber numberWithInt:2] forKey:[NSNumber numberWithInt:FC_LAND]];
    [opPrio setObject:[NSNumber numberWithInt:5] forKey:[NSNumber numberWithInt:FC_LEQ]];
    [opPrio setObject:[NSNumber numberWithInt:5] forKey:[NSNumber numberWithInt:FC_LNEQ]];
    [opPrio setObject:[NSNumber numberWithInt:5] forKey:[NSNumber numberWithInt:FC_LGR]];
    [opPrio setObject:[NSNumber numberWithInt:5] forKey:[NSNumber numberWithInt:FC_LGRE]];
    [opPrio setObject:[NSNumber numberWithInt:5] forKey:[NSNumber numberWithInt:FC_LLS]];
    [opPrio setObject:[NSNumber numberWithInt:5] forKey:[NSNumber numberWithInt:FC_LLSE]];
    [opPrio setObject:[NSNumber numberWithInt:10] forKey:[NSNumber numberWithInt:FC_PLUS]];
    [opPrio setObject:[NSNumber numberWithInt:10] forKey:[NSNumber numberWithInt:FC_MINUS]];
    [opPrio setObject:[NSNumber numberWithInt:20] forKey:[NSNumber numberWithInt:FC_MULT]];
    [opPrio setObject:[NSNumber numberWithInt:20] forKey:[NSNumber numberWithInt:FC_DIV]];
    [opPrio setObject:[NSNumber numberWithInt:20] forKey:[NSNumber numberWithInt:FC_MOD]];
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
//+ (void) staticFree
//{
//	[opPrio release];
//}

/**
 * FCParser 是FCSript的script代码解析器 其中包含了各种逻辑运算,算术运算,变量定义,函数定义等
 */

/**
 * 构造方法.
 *
 * @param h
 *            fcscript
 */
- (id) initWithFCScript: (FCScript*) h
{
    // 实例化变量管理器，解析script时会把定义的变量一个一个加入到该函数管理器中
    vars = [NSMutableDictionary dictionaryWithCapacity: 1];
    gVars = nil;// 全局变量
    // 解析script时会把定义的函数一个一个加入到该函数管理器中
    funcs = [NSMutableDictionary dictionaryWithCapacity: 1];
    host = h;// script主函数
    return self;
}

- (id) initWithFCScript: (FCScript*) h
             dictionary: (NSMutableDictionary*) l
             dictionary: (NSMutableDictionary*) g
             dictionary: (NSMutableDictionary*) f {
    self.vars = l;
    self.gVars = g;
    self.funcs = f;
    self.host = h;
    return self;
}

/**
 * 主解析方法,该方法定义了各种关键字 和 相应的解析执行方法
 *
 * 从第几行解析到第几行，实现局部解析
 *
 * 解析入口
 *
 * @param from
 *            起始位置
 * @param to
 *            结束位置
 * @return retVal 如果脚本中有return,则返回其相应结果
 * @throws FCSException
 * @throws Exception
 */
- (id) parsefrom:(int) from
              to:(int) to {// throws FCSException
    
    if ([code lineCount] <= from)
        return nil;
    
    maxLine = to;// 设置最大行数
    [code setCurLine: from];// 设置当前行
    // 实例化文字管理器
    tok = [[FCKeyword alloc] initWithString: [code getLine]];
    [self checkLine:[code getLine]];// 核对该行是否为注释
    // 得到下一个token
    [self getNextToken];
    
    while (tok.ttype != FC_EOF) {// 直到解析完 FC_EOF
        @try {
            [self parseStmt];// 按状态进行解析
        }
        @catch (ExitException* e) {
            [e raise];
        }
        @catch (RetException* e) {
            return retVal;
        }
        [self getNextToken];// 得到下一个token
    }
    return retVal;
}

/**
 * 只解析FCScript中定义的Function,即预编译Function
 *
 * @param from
 *            起始位置
 * @param to
 *            结束位置
 * @throws FCSException
 * @throws Exception
 */
- (void) parseDefFuncfrom:(int) from
                       to:(int) to {//throws FCSException
    
    if ([code lineCount] <= from)
        return;
    
    maxLine = to;// 设置最大行数
    [code setCurLine:from];// 设置当前行
    tok = [[FCKeyword alloc] initWithString: [code getLine]];
    [self checkLine:[code getLine]];// 核对该行是否为注释
    // 得到下一个token
    [self getNextToken];
    while (tok.ttype != FC_EOF) {// 直到解析完
        @try {
            switch (tok.ttype) {
                case FC_DEFFUNC: {// 得到关键字
                    [self parseFunctionDef];
                    break;
                }
                default: {
                    [self getNextToken];
                }
            }
        }
        @catch (ExitException* e) {
            [e raise];
        }
        @catch (RetException* e) {
            //      return retVal;
        }
    }
}

/**
 * 重置变量
 */
- (void) reset {
    if (vars != nil) {
        [vars removeAllObjects];
    }
    if (gVars != nil) {
        [gVars removeAllObjects];
    }
}

- (void) parseForStmt  {//throws FCSException, RetException
    switch (tok.ttype) {
        case FC_DEFINT: {
            [self parseForDefWord];
            break;
        }
        case FC_WORD: {
            [self parseAssign];
            break;
        }
    }
}

- (void) parseForDefWord {//throws FCSException, RetException
    int type = 0;
    NSString* name;
    
    // 取出数据类型赋给type
    if (tok.ttype == FC_DEFINT) {// int
        type = FC_DEFINT;
    } else {
        [self parseError:@"Expected 'int'"];
    }
    
    do {
        [self getNextToken];// 获取下一个token
        if (tok.ttype != FC_ARRAY
            && tok.ttype != FC_WORD) {// 数据类型关键字后只能跟 变量名或"["
            // 而他们俩的type为TT_ARRAY或TT_WORD
            [self parseError:@"Expected variable name identifier,"];
        }
        
        // 取出变量名
        name = tok.value;
        if (tok.ttype == FC_ARRAY)
        {// 如果后跟的是数组标识
            while (tok.ttype != FC_INTEGER
                   && tok.ttype != FC_WORD
                   && tok.ttype != FC_ENDARRAY) {
                [self getNextToken];// 取出数组个数值
            }
            
            int arraySize = 0;
            if (tok.ttype == FC_INTEGER) {// 如果是int直接取出size
                // 赋值给数组变量
                arraySize = [tok.value intValue];
                [self getNextToken];// ‘]’
            } else if (tok.ttype == FC_WORD) {// 如果是word,则为变量
                id obj = [self getVar: tok.value];
                arraySize = [obj intValue];
                [self getNextToken];// ‘]’
            }
            if (type == FC_DEFSTRING || type == FC_DEFINT || type == FC_DEFBOOLEAN
                || type == FC_DEFDOUBLE || type == FC_DEFOBJECT)
            {
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:arraySize];
                [self addVar:name value: array];
            }
        } else {// 普通变量赋值
            switch (type) {
                case FC_DEFINT: {// integer测试
                    [self addVar: name value: [NSNumber numberWithInt: 0]];
                    break;
                }
                case FC_DEFSTRING: {// string测试
                    [self addVar: name value: NULL_STRING_VALUE];
                    break;
                }
                case FC_DEFBOOLEAN: {// Boolean测试
                    [self addVar: name value: [NSNumber numberWithBool: NO]];
                    break;
                }
                case FC_DEFDOUBLE: {// Double测试
                    [self addVar: name value: [NSNumber numberWithDouble: 0]];
                    break;
                }
                case FC_DEFOBJECT: {// Object测试
                    [self addVar: name value: [[NSObject alloc] init]];
                    break;
                }
            }
        }
        [self getNextToken];
        if (tok.ttype == FC_EQ) {// 例如 int a=1 这种赋值
            [self getNextToken];
            [self addVar: name value: [self parseExpr]];
        } else if (tok.ttype != ',') {// 定义多个变量
            [self parseError:@"Expected ','"];
        }
    } while (tok.ttype != ',');// 直到该行结束
}

/**
 * 按状态进行解析。在调该执行，先通过[self getNextToken];获得token也就是状态关键字
 *
 * @throws FCSException
 * @throws RetException
 * @throws Exception
 */
- (void) parseStmt {//throws FCSException, RetException
    
    switch (tok.ttype) {
            
        case FC_FOR:
        case FC_EFOR: // 增加For循环
            
        case FC_IF:
        case FC_EIF:
        case FC_WHILE:
        case FC_EWHILE:
        case FC_DEFINT:
        case FC_DEFSTRING:
        case FC_DEFBOOLEAN:
        case FC_DEFDOUBLE:
        case FC_DEFOBJECT:// Object
        case FC_DEFFUNC:
        case FC_EXIT:
        case FC_EDEFFUNC:
        case FC_RETURN: {// 得到关键字
            [self parseKeyWord];
            break;
        }
        case FC_FUNC: {// 解析方法
            [self parseFunc];
            break;
        }
        case FC_ARRAY: {
            [self parseArrayAssign];
            break;
        }
        case FC_WORD: {
            [self parseAssign];
            break;
        }
        case FC_EOL: {
            //      [self getNextToken];    //[tok nextToken];
            break;
        }
        case FC_EOF: {
            // all done
            break;
        }
        default: {
            [self parseError: @"Expected identifier"];
        }
    }
}

/**
 * 解析FUNC
 *
 * @throws FCSException
 * @throws RetException
 * @throws Exception
 */
- (void) parseFunc {//throws FCSException, RetException
    NSString* name = tok.value;
    // '('
    [self getNextToken];
    [self parseCallFunc: name];
    //  [self getNextToken];
}

/**
 * 解析array
 *
 * @throws FCSException
 * @throws RetException
 * @throws Exception
 */
- (void) parseArrayAssign {//throws FCSException, RetException
    NSString* name = tok.value;
    id index;
    id val;
    
    [self getNextToken]; // '['
    [self getNextToken];
    index = [self parseExpr];
    [self getNextToken]; // ']'
    
    if (tok.ttype != FC_EQ) {
        [self parseError: @"Expected '='"];
    } else {
        [self getNextToken];
        val = [self parseExpr];
        @try {
            [self setArrayItemByName:name andIndex: index value: val];
        }
        @catch (NSException* e) {
            [self parseError: [e reason]];
        }
    }
}

/**
 * 解析关键字,定义常量类型
 *
 * @throws FCSException
 * @throws RetException
 * @throws Exception
 */
- (void) parseKeyWord
{//throws FCSException, RetException
    switch (tok.ttype) {
        case FC_DEFINT:// 我们自定义的int类型
        case FC_DEFSTRING:// 我们自定义的string类型
        case FC_DEFBOOLEAN:// 我们自定义的boolean类型
        case FC_DEFDOUBLE: // 我们自定义的double类型
        case FC_DEFOBJECT:// 我们自定义的object类型
        {// 解析我们定义的数据类型的变量
            [self parseVarDef];
            break;
        }
            
        case FC_FOR: {// 解析for循环
            [self parseFor];
            break;
        }
            
        case FC_IF: {// 解析IF
            [self parseIf];
            break;
        }
        case FC_WHILE: {// 解析WHILE
            [self parseWhile];
            break;
        }
        case FC_RETURN: {// 解析RETURN
            [self parseReturn];
            break;
        }
        case FC_DEFFUNC: {// 解析定义的函数
            // parseFunctionDefNext();
            [self parseFunctionDef];
            break;
        }
        case FC_EXIT: {// 解析退出
            [self parseExit];
        }
        default: {
            [self parseError:@"Not a keyword" ];
        }
    }
}

/**
 * 执行return
 */
- (void) parseReturn { //throws FCSException, RetException
    [self getNextToken];
    retVal = [self parseExpr];
    [[[RetException alloc] initWithReason: @"return"] raise];
}

/**
 * 执行exit
 */
- (void) parseExit {//throws FCSException, RetException
    [self getNextToken];
    retVal = [self parseExpr];
    [[[ExitException alloc] initWithReason: @"exit key"] raise];
}

/**
 * 解析赋值
 *
 * @throws FCSException
 * @throws Exception
 */
- (void) parseAssign {//throws FCSException
    NSString* name = [NSString stringWithString: tok.value];
    id val;
    
    [self getNextToken];
    //     LOG(@"tok.ttype=%d",tok.ttype);
    if (tok.ttype != FC_EQ) {
        [self parseError:@"Expected '='"];
    } else {
        [self getNextToken];// 读等号后面的值
        val = [self parseExpr];
        if ([self hasVar: name]) {
            [self setVarWithName:name value:val];
        } else {
            @try {
                [host setVarString:name Object:nil Object:val];
            }
            @catch (NSException * e) {
                LOG(@"%@", [e reason]);
                [self parseError: [e reason]];
            }
        }
    }
}

/**
 * 系统自定义调用function
 *
 * @return val fucntion的返回值
 */
- (id) callFunction: (NSString*) name
              Array: (NSMutableArray*) _params {//throws FCSException
    FCFuncEntry* fDef;
    int n;
    int oldLine;
    id val;
    val = nil;
    
    fDef = [funcs objectForKey: name];
    if (fDef) {
        LOG(@"MMFS Invoke script function: %@", name);
        if ([fDef.paramNames count] != [_params count])
        {
            [self parseError: [NSString stringWithFormat:
                               @"Expected %lu parameters, Found %lu", (unsigned long)[fDef.paramNames count], (unsigned long)[_params count]]];
        }
        
        FCParser* p = nil;
        NSMutableDictionary* locals = [NSMutableDictionary dictionaryWithCapacity: 1];
        
        /**
         * func里定义的方法变量
         */
        for (n = 0; n < [fDef.paramNames count]; n++) {
            //locals.put(fDef.paramNames.elementAt(n), params.elementAt(n));
            [locals setObject:[_params objectAtIndex:n] forKey:[fDef.paramNames objectAtIndex:n]];
        }
        
        if (gVars == nil) {
            p = [[FCParser alloc] initWithFCScript:host dictionary:locals dictionary:vars dictionary:funcs];
            
        } else {
            p = [[FCParser alloc] initWithFCScript:host dictionary:locals dictionary:gVars dictionary:funcs];
        }
        oldLine = [code getCurLine];
        [p setCode: code];
        val = [p parsefrom: fDef.startLine + 1 to: fDef.endLine - 1];
        [code setCurLine: oldLine];
    } else {
        val = [host callFunctionString:name Array:_params];
    }
    return val;
}

- (BOOL) definedFunction: (NSString*) name
{
    return [funcs objectForKey: name] != nil;
}

/**
 * 解析调用的function
 *
 * @param name
 * @return Object
 * @throws FCSException
 * @throws Exception
 */
- (id) parseCallFunc: (NSString*) name //throws FCSException
{
    // add by 田广文 用于修正调用函数前后丢失表达式结点的问题 begin
    FCTreeNode* tempNode = self.curNode;
    // add by 田广文 用于修正调用函数前后丢失表达式结点的问题 end
    
    NSMutableArray* _params = [NSMutableArray arrayWithCapacity: 4];
    int lastTokenType = 0;
    BOOL isContinue = YES;
    do {
        lastTokenType = (tok == nil ? 0 : tok.ttype);
        [self getNextToken];
        if (tok.ttype == ',')
        {
            //      lastTokenType = tok.ttype;
            [self getNextToken];
        }
        else if (tok.ttype == ')')
        {
            isContinue = NO;
            if (lastTokenType == ',')
            {
                [_params addObject: NULL_STRING_VALUE];
            }
        }
        if (isContinue) {
            id obj = [self parseExpr];
            if (obj)
                [_params addObject: obj];
            else
                [_params addObject: NULL_STRING_VALUE];
        }
    } while (tok.ttype == ',' && isContinue);
    
    // add by 田广文 用于修正调用函数前后丢失表达式结点的问题 begin
    self.curNode = tempNode;
    // add by 田广文 用于修正调用函数前后丢失表达式结点的问题 end
    
    return [self callFunction:name Array:_params];
}

/**
 * function定义解析 解析定义在script中的函数
 * 执行时，先从我们定义中的函数中找。如果找到则执行；否则，从内置中的函数找（即FCScriptImpl中的callFunction方法中）。
 *
 * @throws FCSException
 */
- (void) parseFunctionDef {//throws FCSException
    
    FCFuncEntry* fDef = [[FCFuncEntry alloc] init];
    id val;
    NSString* name = nil;
    NSString* fName = nil;
    
    
    fDef.startLine = [code getCurLine];
    
    [self getNextToken];
    
    if (tok.ttype != FC_FUNC) {
        [self parseError:@"Expected function start identifier"];
    }
    fName = [NSString stringWithString: tok.value];
    [self getNextToken];
    
    if (tok.ttype != '(') {
        [self parseError:@"Expected ("];
    }
    
    [self getNextToken];
    // 在( *** )中定义类型
    while (tok.ttype != ')') {
        if (tok.ttype != FC_DEFINT
            && tok.ttype != FC_DEFSTRING
            && tok.ttype != FC_DEFDOUBLE
            && tok.ttype != FC_DEFBOOLEAN
            && tok.ttype != FC_DEFOBJECT) {
            [self parseError:@"Expected type name"];
        }
        
        val = nil;
        
        if (tok.ttype == FC_DEFINT) {
            val = [NSNumber numberWithInt: 0];
        } else if (tok.ttype == FC_DEFSTRING) {
            val =  NULL_STRING_VALUE;
        } else if (tok.ttype == FC_DEFBOOLEAN) {
            val = [NSNumber numberWithBool: NO];
        } else if (tok.ttype == FC_DEFOBJECT) {// object
            val = [[NSObject alloc]init];
        } else if (tok.ttype == FC_DEFDOUBLE) {// object
            val = [NSNumber numberWithDouble: 0];
        }
        
        [self getNextToken];
        
        if (tok.ttype != FC_WORD) {
            [self parseError:@"Expected function parameter name identifier"];
        }
        
        name = [NSString stringWithString: tok.value];
        
        [fDef.paramNames addObject: name];
        
        [fDef.params setObject: val forKey: name];
        
        [self getNextToken];
        if (tok.ttype == ',')
        {
            [self getNextToken];
        }
    }
    
    // 如果到了最后一行还没有endfunc,就抛出一个异常
    while ((tok.ttype != FC_EDEFFUNC) && (tok.ttype != FC_EOF)) {
        [self getNextToken];
        if (tok.ttype == FC_DEFFUNC || tok.ttype == FC_EOF)
            [self parseError:@"Nested functions are illegal"];
    }
    
    fDef.endLine = [code getCurLine];
    
    [self getNextToken];
    
    //    LOG(@"fDef.startLine:%d", fDef.startLine);
    //    LOG(@"fDef.endLine:%d", fDef.endLine);
    //    int a = [fDef.paramNames count];
    //    LOG(@"paramNames count:%d",a);
    //    if ([fDef.paramNames count]>0)
    //        LOG(@"fDef.paramNames[0]:%@", [fDef.paramNames objectAtIndex:0]);
    //    LOG(@"fName = %@",fName);
    //    LOG(@"tok.value = %@", tok.value);
    //    LOG(@"name = %@",name);
    //    LOG(@"fDef.params:%@", [fDef.params objectForKey:name]);
    //    LOG(@"HHHHHHHHHHHHHHHHHHH");
    
    //    a = [funcs count];
    //    LOG(@"a = %d", a);
    [funcs setObject:fDef forKey:fName];
}

/**
 * 变量赋值
 *
 * @throws
 */
- (id) evaluate {//throws FCSException
    id val = nil;
    switch (tok.ttype)
    {// 先把比较的变量进行赋值
        case FC_INTEGER: {
            val = [NSNumber numberWithInt:[tok.value intValue]];
            break;
        }
        case FC_DOUBLE: {
            val = [NSNumber numberWithDouble:[tok.value doubleValue]];
            break;
        }
        case FC_BOOLEAN: {// Boolean测试
            val = [FCBoolean boolWithBool: [tok.value boolValue]];
            break;
        }
        case FC_OBJECT: {
            val = tok.value;
            break;
        }
        case FC_FUNC: {
            NSString* name = tok.value;
            [self getNextToken];
            val = [self parseCallFunc:name];
            break;
        }
        case FC_ARRAY: {
            NSString* name = tok.value;
            [self getNextToken]; // '['
            [self getNextToken];
            // add by 田广文 用于修正调用函数前后丢失表达式结点的问题 begin
            FCTreeNode* tempNode = self.curNode;
            // add by 田广文 用于修正调用函数前后丢失表达式结点的问题 end
            id index = [self parseExpr];
            // add by 田广文 用于修正调用函数前后丢失表达式结点的问题 begin
            self.curNode = tempNode;
            // add by 田广文 用于修正调用函数前后丢失表达式结点的问题 end
            @try {
                val = [self getArrayItemByName:name andIndex:index];
            }
            @catch (NSException* e) {
                LOG(@"%@", [e reason]);
                [self parseError: [e reason]];
            }
            break;
        }
        case FC_WORD: {
            if ([self hasVar: tok.value])
            {
                val = [self getVar: tok.value];
            } else {
                LOG(@"%@", tok.value);
                @try {
                    val = [host getVarString: tok.value Object: nil];
                }
                @catch (NSException * e) {
                    LOG(@"%@", [e reason]);
                    [self parseError: [e reason]];
                }
            }
            break;
        }
        case FC_STRING:
        {
            val =  tok.value;
            break;
        }
    }
    return val;
}

/**
 * 负数赋值
 * @return
 */
- (id) negate_evaluate: (id) val
{
    if ([val isKindOfClass: [NSNumber class]])
    {
        return [NSNumber numberWithDouble: 0 - [val doubleValue]];
    } else {
        [self parseError: @"Type mistmatch for unary -"];
    }
    return nil;
}

// 解析表达式
// Expression parser
- (id) parseExpr {
    self.curNode = nil;
    BOOL end = NO;
    id val;
    BOOL negate = NO; // flag for unary minus
    BOOL not = NO;// flag for unary not.
    BOOL prevOp = YES;// flag - YES if previous value was an operator
    
    while (!end)
    {
        switch (tok.ttype)
        {
                // 得到values
            case FC_INTEGER:// int
            case FC_DOUBLE:// double
            case FC_STRING:// string
            case FC_BOOLEAN:// Boolean测试
            case FC_OBJECT:// Object
            case FC_WORD:
            case FC_FUNC:
            case FC_ARRAY:
            {
                if (!prevOp)
                {
                    [self parseError:@"Expected Operator"];
                } else {
                    val = nil;
                    FCTreeNode* node = [[FCTreeNode alloc] init];
                    node.type = E_VAL;
                    val = [self evaluate];// 变量赋值，以备后面进行比较
                    // 逻辑非
                    // unary not
                    if (not)
                    {
                        if ([val isKindOfClass: [FCBoolean class]]
                            || [val isKindOfClass: [NSNumber class]]
                            || [val isKindOfClass: [NSString class]])
                        {
                            val = [FCBoolean boolWithBool: ![val boolValue]];
                        } else {
                            [self parseError:@"Type mismatch for !"];
                        }
                        not = NO;
                    }
                    
                    // 相减
                    // unary minus
                    if (negate) {
                        val = [self negate_evaluate: val];
                        negate = NO;
                    }
                    
                    node.value = val;// 赋给比较的树节点
                    
                    if (curNode != nil) {
                        if (curNode.left == nil)
                        {
                            curNode.left = node;
                            node.parent = curNode;
                            self.curNode = node;
                        }
                        else if (curNode.right == nil)
                        {
                            curNode.right = node;
                            node.parent = curNode;
                            self.curNode = node;
                        }
                    } else {
                        self.curNode = node;
                    }
                    prevOp = NO;// 变量变量之间必须有操作符，如果没有报错
                }
                break;
            }
                /*
                 * 逻辑 operators
                 */
            case FC_LEQ:
            case FC_LNEQ:
            case FC_MULT:
            case FC_DIV:
            case FC_MOD:
            case FC_PLUS:
            case FC_MINUS:
            case FC_LGR:
            case FC_LGRE:
            case FC_LLSE:
            case FC_LLS:
            case FC_NOT:
            case FC_LAND: // &&
            case FC_LOR: {
                if (prevOp) {
                    if (tok.ttype == FC_MINUS)
                    {
                        negate = YES;
                    }
                    else if (tok.ttype == FC_NOT)
                    {
                        not = YES;
                    }
                    else
                    {
                        [self parseError:@"Expected expression"];
                    }
                } else {
                    FCTreeNode* node = [[FCTreeNode alloc] init];
                    node.type = E_OP;// 操作符类型为等式操作符类型为等式
                    node.value = [NSNumber numberWithInt: tok.ttype];
                    if (curNode.parent != nil) {
                        ///////////////异常点
                        int curPrio = [self getPrio: tok.ttype];// 获取当前节点的优先级
                        int parPrio = [self getPrio: [curNode.parent.value intValue]];// 获取父亲节点的优先级
                        
                        if (curPrio <= parPrio) {
                            /*******
                             * 1+3>2
                             *
                             *    >
                             *   / \
                             *  +   2
                             * / \
                             *1   3
                             *
                             */
                            node.parent = curNode.parent.parent;
                            node.left = curNode.parent;
                            if (curNode.parent.parent != nil) {
                                curNode.parent.parent.right = node;
                            }
                            
                            curNode.parent.parent = node;
                            self.curNode = node;
                        } else {
                            /******
                             * 4>1+2
                             *
                             *     >
                             *    / \
                             *   4   +
                             *      / \
                             *     1   2
                             *
                             */
                            curNode.parent.right = node;
                            node.left = curNode;
                            node.parent = curNode.parent;
                            curNode.parent = node;
                            self.curNode = node;
                        }
                    } else {
                        node.left = curNode;
                        curNode.parent = node;
                        self.curNode = node;
                    }
                    prevOp = YES;
                }
                break;
            }
            case '(': {
                [self getNextToken];
                val = [self parseExpr];// 先括号，再操作符
                
                FCTreeNode* node = [[FCTreeNode alloc] init];
                node.value = val;
                node.type = E_VAL;
                
                if (curNode != nil)
                {
                    if (curNode.left == nil)
                    {
                        curNode.left = node;
                        node.parent = curNode;
                        self.curNode = node;
                    } else if (curNode.right == nil)
                    {
                        curNode.right = node;
                        node.parent = curNode;
                        self.curNode = node;
                    }
                } else {
                    self.curNode = node;
                }
                prevOp = NO;
                break;
            }
            default: {
                end = YES;
            }
        }
        if (!end)
        {
            [tok nextToken];
        }
    }
    
    if (curNode == nil)
        [self parseError:@"Missing Expression"];
    
    while (curNode.parent != nil)
    {
        curNode = curNode.parent;
    }
    id obj = [self evalETree: curNode];
    return obj;
}

/**
 * 获取操作符优先级
 *
 * @param op
 * @return int 操作符的优先级
 */
- (int) getPrio: (int) op
{
    NSString* str = [opPrio objectForKey: [NSNumber numberWithInt: op]];
    //    LOG(@"%@",str);
    //    int a = [str intValue];
    return [str intValue];
}

/**
 * 各种逻辑判断和运算, 表达式树解析
 **/
- (id) evalETree: (FCTreeNode*) node
{
    id lVal, rVal;
    
    if (node.type == E_VAL) //如果是等式，直接返回
    {
        return node.value;
    }
    
    lVal = [self evalETree:node.left];
    rVal = [self evalETree:node.right];
    switch ([node.value intValue]) {
            // call the various eval functions
        case FC_PLUS: {// 相加+
            return [self evalPlusObject:lVal Object: rVal];
        }
        case FC_MINUS: {// 相减-
            return [self evalMinusObject:lVal Object:rVal];
        }
        case FC_MULT: {// 相乘*
            return [self evalMultObject:lVal Object:rVal];
        }
        case FC_DIV: {// 相除/
            return [self evalDivObject:lVal Object:rVal];
        }
        case FC_LEQ: {// 相等==
            return [self evalEqObject:lVal Object:rVal];
        }
        case FC_LNEQ: {// 不相等!=
            return [self evalNEqObject:lVal Object:rVal];
        }
        case FC_LLS: {// >
            return [self evalLsObject:lVal Object:rVal];
        }
        case FC_LLSE: {// >=
            return [self evalLseObject:lVal Object:rVal];
        }
        case FC_LGR: {// >
            return [self evalGrObject:lVal Object:rVal];
        }
        case FC_LGRE: {// >=
            return [self evalGreObject:lVal Object:rVal];
        }
        case FC_MOD: {// 取模 %
            return [self evalModObject:lVal Object:rVal];
        }
        case FC_LAND: {// &&
            return [self evalAndObject:lVal Object:rVal];
        }
        case FC_LOR: {// ||
            return [self evalOrObject:lVal Object:rVal];
        }
    }
    
    return nil;
}

/**
 * 加法运算
 *
 * @param lVal
 * @param rVal
 * @return Object
 * @throws FCSException
 */
- (id) evalPlusObject: (id) lVal Object: (id) rVal
{
    if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [NSNumber numberWithDouble:[lVal doubleValue] + [rVal doubleValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] || [rVal isKindOfClass: [NSString class]])
    { //String相加
        return [NSString stringWithFormat: @"%@%@", lVal, rVal];
    }
    else {
        [self parseError:@"Type Mismatch for operator +"];
    }
    return nil;
}

/**
 * 减法运算
 *
 * @param lVal
 * @param rVal
 * @return Object
 * @throws FCSException
 */
- (id) evalMinusObject: (id) lVal Object: (id) rVal
{
    if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [NSNumber numberWithDouble: [lVal doubleValue] - [rVal doubleValue]];
    } else {
        [self parseError:@"Type Mismatch for operator -"];
    }
    return nil;
}

// multiplication
- (id) evalMultObject: (id) lVal Object: (id) rVal
{
    if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [NSNumber numberWithDouble: [lVal doubleValue] * [rVal doubleValue]];
    } else {
        [self parseError:@"Type Mismatch for operator *"];
    }
    return nil;
}

// modulus
- (id) evalModObject: (id) lVal Object: (id) rVal
{
    if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [NSNumber numberWithDouble: [lVal intValue] % [rVal intValue]];
    } else {
        [self parseError:@"Type Mismatch for operator %"];
    }
    return nil;
}

// division
- (id) evalDivObject: (id) lVal Object: (id) rVal
{
    if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [NSNumber numberWithDouble: [lVal doubleValue] / [rVal doubleValue]];
    } else {
        [self parseError:@"Type Mismatch for operator /"];
    }
    return nil;
}

// Logical AND
- (id) evalAndObject: (id) lVal Object: (id) rVal
{
    if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [FCBoolean boolWithBool: [lVal boolValue] && [rVal boolValue]];
    }
    else if ([lVal isKindOfClass: [FCBoolean class]] && [rVal isKindOfClass: [FCBoolean class]])
    {
        return [FCBoolean boolWithBool: [lVal boolValue] && [rVal boolValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [lVal boolValue] && [rVal boolValue]];
    }
    else
    {
        [self parseError: @"Type Mismatch for operator &&"];
    }
    return nil;
}

// Logical Or
- (id) evalOrObject: (id) lVal Object: (id) rVal
{
    if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [FCBoolean boolWithBool: [lVal boolValue] || [rVal boolValue]];
    }
    else if ([lVal isKindOfClass: [FCBoolean class]] && [rVal isKindOfClass: [FCBoolean class]])
    {
        return [FCBoolean boolWithBool: [lVal boolValue] || [rVal boolValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [lVal boolValue] || [rVal boolValue]];
    }
    else
    {
        [self parseError: @"Type Mismatch for operator ||"];
    }
    return nil;
}


// logical equal
- (id) evalEqObject: (id) lVal Object: (id) rVal
{
    if (lVal == rVal)
    {
        return [FCBoolean boolWithBool: YES];
    }
    else if (lVal == nil)
    {
        return [FCBoolean boolWithBool: NO];
    }
    else if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [FCBoolean boolWithBool: [lVal isEqualToNumber: (NSNumber*) rVal]];
    }
    else if ([lVal isKindOfClass: [FCBoolean class]] && [rVal isKindOfClass: [FCBoolean class]])
    {
        return [FCBoolean boolWithBool: [lVal boolValue] == [rVal boolValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [lVal isEqualToString: (NSString*) rVal]];
    }
    else if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [((NSNumber*)lVal) doubleValue] == [((NSString*)rVal) doubleValue]];
    }
    else {
        [self parseError: @"Type Mismatch for operator =="];
    }
    return nil;
}

// <
- (id) evalLsObject: (id) lVal Object: (id) rVal
{
    if (lVal == rVal)
    {
        return [FCBoolean boolWithBool: NO];
    }
    else if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [FCBoolean boolWithBool: [lVal doubleValue] < [rVal doubleValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [(NSString*) lVal compare: (NSString*) rVal] < 0];
    }
    else
    {
        [self parseError: @"Type Mismatch for operator <"];
    }
    return nil;
}

// <=
- (id) evalLseObject: (id) lVal Object: (id) rVal
{
    if (lVal == rVal)
    {
        return [FCBoolean boolWithBool: YES];
    }
    else if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [FCBoolean boolWithBool: [lVal doubleValue] <= [rVal doubleValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [(NSString*) lVal compare: (NSString*) rVal] <= 0];
    }
    else
    {
        [self parseError: @"Type Mismatch for operator <"];
    }
    return nil;
}

// >
- (id) evalGrObject: (id) lVal Object: (id) rVal
{
    if (lVal == rVal)
    {
        return [FCBoolean boolWithBool: NO];
    }
    else if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [FCBoolean boolWithBool: [lVal doubleValue] > [rVal doubleValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [(NSString*) lVal compare: (NSString*) rVal] > 0];
    }
    else
    {
        [self parseError: @"Type Mismatch for operator >"];
    }
    return nil;
}

// >=
- (id) evalGreObject: (id) lVal Object: (id) rVal
{
    if (lVal == rVal)
    {
        return [FCBoolean boolWithBool: YES];
    }
    else if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [FCBoolean boolWithBool: [lVal doubleValue] >= [rVal doubleValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [(NSString*) lVal compare: (NSString*) rVal] >= 0];
    }
    else
    {
        [self parseError: @"Type Mismatch for operator >="];
    }
    return nil;
}

// 不等于
- (id) evalNEqObject: (id) lVal Object: (id) rVal
{
    if ((lVal == nil) && ([rVal isKindOfClass: [NSString class]]))
    {
        return [FCBoolean boolWithBool: ![lVal isEqualToString: (NSString*) rVal]];
    }
    
    if (lVal == rVal)
    {
        return [FCBoolean boolWithBool: NO];
    }
    else if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSNumber class]])
    {
        return [FCBoolean boolWithBool: ![lVal isEqualToNumber: (NSNumber*) rVal]];
    }
    else if ([lVal isKindOfClass: [FCBoolean class]] && [rVal isKindOfClass: [FCBoolean class]])
    {
        return [FCBoolean boolWithBool: ![lVal boolValue] == [rVal boolValue]];
    }
    else if ([lVal isKindOfClass: [NSString class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: ![lVal isEqualToString: (NSString*) rVal]];
    }
    else if ([lVal isKindOfClass: [NSNumber class]] && [rVal isKindOfClass: [NSString class]])
    {
        return [FCBoolean boolWithBool: [((NSNumber*)lVal) doubleValue] != [((NSString*)rVal) doubleValue]];
    }
    else
    {
        [self parseError: @"Type Mismatch for operator !="];
    }
    return nil;
}

- (void) printWTree: (FCTreeNode*) node
{
    while (node.parent != nil)
    {
        node = node.parent;
    }
    [self printETree:node];
}

/**
 * 打印树节点
 *
 * @param node
 */
- (void) printETree: (FCTreeNode*) node
{
    if (node.left != nil)
    {
        [self printETree:node.left];
    }
    if (node.right != nil)
    {
        [self printETree:node.right];
    }
}

/**
 * 解析IF
 *
 * 注：token，英文本义标识。 在本程序中意义如下 1.关键字 2.变量名 3.变量值
 *
 * @throws FCSException
 * @throws RetException
 * @throws Exception
 */

- (void) parseIf {//throws FCSException, RetException
    int val = 0;
    int depth;
    BOOL then = NO;
    
    /******************* 解析if条件语句 ********************/
    [self getNextToken];
    val = [self parseExprValue];
    /**
     * if... then ...语句 不需要endif结束。以EOL（该行读不到字符）结束
     *
     */
    if (tok.ttype == FC_THEN)
    {
        [self getNextToken];
        if (tok.ttype != FC_EOL)
        {
            if (val != 0)
            {
                [self parseStmt];
            } else {
                while (tok.ttype != FC_EOL)
                {
                    [self getNextToken];
                }
            }
            then = YES;
        }
    }
    
    /**
     * if... [elseif] ...else...endif语句 不需要endif结束。以EOL（该行读不到字符）结束
     *
     */
    if (!then) {
        if (val != 0) {// 条件成立（YES）
            [self getNextToken];// 获取下一个token(标识)
            while ((tok.ttype != FC_EIF)
                   && (tok.ttype != FC_ELSE)
                   && (tok.ttype != FC_EOF)
                   && (tok.ttype != FC_ELSIF)) {// 执行if方法体，直到1.读到endif；2.读到else
                // 3.读到script结束符
                // 4.读到elseif
                [self parseStmt];// 执行if方法体
                [self getNextToken];// 获取该行的结束token
            }
            if (tok.ttype == FC_ELSE
                || tok.ttype == FC_ELSIF) {// 如果读到的是else
                // 或elseif执行。可能嵌套
                depth = 1;
                do {// 嵌套了if
                    [self getNextToken];// 获取下一个token，或获取该行的结束token
                    if (tok.ttype == FC_IF)
                        depth++;// 多层嵌套，做个深度记录（层的纪录）。深度增1
                    if (tok.ttype == FC_EOF)
                        [self parseError:@"can't find endif"];
                    if (tok.ttype == FC_EIF)
                        depth--;
                    if (tok.ttype == FC_THEN)
                    {
                        [self getNextToken];
                        if (tok.ttype != FC_EOL)
                        {
                            depth--;
                        }
                        [tok pushBack];
                    }
                } while (depth > 0);
                [self getNextToken];// 获取该行的结束token
            } else {// 读到的是endif或script结束符
                [self getNextToken];// 获取该行的结束token
            }
        } else {// 条件不成立（NO），执行elseif 或else语句
            depth = 1;
            do {// 嵌套了if
                [self getNextToken];
                if (tok.ttype == FC_IF)
                    depth++;// 多层嵌套，做个深度记录（层的纪录）。深度增1
                if (tok.ttype == FC_EOF)
                    [self parseError:@"can't find endif"];
                if (tok.ttype == FC_EIF)
                    depth--;// 多层嵌套，做个深度记录（层的纪录）。深度减1
                if ((tok.ttype == FC_ELSE || tok.ttype == FC_ELSIF) && depth == 1)
                    depth--;// 当前深度为1时，结束该循环
                if (tok.ttype == FC_THEN)
                {
                    [self getNextToken];// 获取下一个token
                    if (tok.ttype != FC_EOL) {
                        depth--;// 如果是then 读到TT_EOL（-1）时，深度减1
                    }
                    [tok pushBack];// 执行完then方法体后，必须读到EOL才结束，否则还进入该方法体（设置tok.ttype不变）
                }
            } while (depth > 0);// 嵌套方法体执行完
            
            if (tok.ttype == FC_ELSE)
            {// 执行else
                [self getNextToken];// 获取该行的结束token 注：空行是不会加入到执行代码中的
                [self getNextToken];// 获取下一行第一个的token（获取）
                // run else clause
                while (tok.ttype != FC_EIF)
                {
                    [self parseStmt];// 执行else方法体
                    [self getNextToken];// 获取该行的结束token
                }
                [self getNextToken];// 获取下一行第一个的token
            } else if (tok.ttype == FC_ELSIF)
            {
                [self parseIf];// 执行elseif方法体
            } else {
                [self getNextToken];
            }
        }
    }
}

// **************************************FOR循环语句***********************************
// ******************** for(int a=0,a<6,a=a+1)
// ********************************
// 解析for 循环语句
- (void) parseFor {//throws FCSException, RetException
    BOOL val = NO;
    int _startLine;
    int depth;
    
    _startLine = [code getCurLine];// 循环体开始
    
    int i = 0;
    [self getNextToken];// '('
    [self getNextToken];// 'i'
    
    if (tok.ttype == FC_DEFINT)
    {// 'int'
        [self parseForStmt];// 'int i=0'
    } else {
        [self parseStmt];// i=0
    }
    
    int times = 0;
    while (YES) {
        //for方法参数开始
        i = 0;
        do {
            if (tok.ttype == ',')
            {
                [self getNextToken];
            }
            else if (tok.ttype == ')')
            {
                break;
            }
            if (i == 1)
            {
                val = [[self parseExpr] boolValue];// i<size
                [self getNextToken];// ')'
            }
            else if (i == 0)
            {
                if (times > 0)
                {
                    [self parseStmt];// i=i+1
                } else {
                    do {
                        [self getNextToken];
                    } while (tok.ttype != ',' && tok.ttype != FC_EOF);
                }
            }
            i = i + 1;
        } while (tok.ttype == ',');
        //for方法参数结束
        
        if (val)
        {// 符合for条件 表达式成立
            while ((tok.ttype != FC_EFOR) && (tok.ttype != FC_EOF))
            {// 解析for方法体
                [self parseStmt];
                [self getNextToken];
            }
            [code setCurLine:_startLine];
            [self resetTokens];
        } else {// 不符合for条件
            break;
        }
        do {
            [self getNextToken];
        } while (tok.ttype != ',' && tok.ttype != FC_EOF);
        times++;
    }
    depth = 1;
    do {
        [self getNextToken];
        if (tok.ttype == FC_FOR)
            depth++;
        if (tok.ttype == FC_EFOR)
            depth--;
        if (tok.ttype == FC_EOF)
            [self parseError:@"can't find endfor"];
    } while (depth > 0);
    [self getNextToken];
}

// *****************************************************************************

/**
 * 获取读取表达式的值，使用在if while中
 *
 * @return int
 * @throws FCSException
 */
- (int) parseExprValue {
    int val = 0;// 表达式结果 0,1 0为NO 1为YES
    // if a 之类的单个函数 或者while语句中使用
    @try {
        id obj;
        obj = [self parseExpr];
        if ([obj isKindOfClass: [NSNumber class]])
        {
            val = [obj intValue];
        }
        else if ([obj isKindOfClass: [FCBoolean class]])
        {
            val = [obj boolValue] ? 1 : 0;
        }
    }
    @catch (FCSException* e) {
        LOG(@"parseExprValue: %@", [e reason]);
        [self parseError: [e reason]];
    }
    return val;
}

// 解析while 循环语句
- (void) parseWhile {
    int val = 0;
    int _startLine;
    int depth;
    
    _startLine = [code getCurLine];
    [self getNextToken];
    
    val = [self parseExprValue];
    [self getNextToken];
    
    while (val != 0)
    {
        while ((tok.ttype != FC_EWHILE) && (tok.ttype != FC_EOF))
        {
            [self parseStmt];
            [self getNextToken];
        }
        
        // while循环的起始位置
        [code setCurLine:_startLine];
        [self resetTokens];
        [self getNextToken];
        val = [self parseExprValue];
        [self getNextToken];
    }
    // while循的结束位置
    depth = 1;
    do {
        [self getNextToken];
        if (tok.ttype == FC_WHILE)
            depth++;
        if (tok.ttype == FC_EWHILE)
            depth--;
        if (tok.ttype == FC_EOF)
            [self parseError:@"can't find endwhile"];
    } while (depth > 0);
    
    [self getNextToken];
}

/**
 * 解析定义的数据类型
 *
 * @throws FCSException
 * @throws Exception
 */

- (void) parseVarDef
{
    int type = 0;
    NSString* name;
    
    // 取出数据类型赋给type
    if (tok.ttype == FC_DEFINT) {// int
        type = FC_DEFINT;
    } else if (tok.ttype == FC_DEFSTRING) {// string
        type = FC_DEFSTRING;
    } else if (tok.ttype == FC_DEFBOOLEAN) {// boolean
        type = FC_DEFBOOLEAN;
    } else if (tok.ttype == FC_DEFDOUBLE) {// double
        type = FC_DEFDOUBLE;
    } else if (tok.ttype == FC_DEFOBJECT) {// object
        type = FC_DEFOBJECT;
    } else {
        [self parseError:@"Expected 'int','string','double' ,'boolean' or 'object'"];
    }
    
    do {
        [self getNextToken];// 获取下一个token
        if (tok.ttype != FC_ARRAY
            && tok.ttype != FC_WORD) {// 数据类型关键字后只能跟 变量名或"["
            // 而他们俩的type为TT_ARRAY或TT_WORD
            [self parseError:@"Expected variable name identifier"];
        }
        
        name = tok.value;// 取出变量名
        if (tok.ttype == FC_ARRAY) {// 如果后跟的是数组标识
            while (tok.ttype != FC_INTEGER
                   && tok.ttype != FC_WORD
                   && tok.ttype != FC_ENDARRAY) {
                [self getNextToken];// 取出数组个数值
            }
            int arraySize = 0;
            if (tok.ttype == FC_INTEGER) {// 如果是int直接取出size
                // 赋值给数组变量
                arraySize = [tok.value intValue];
                [self getNextToken];// ‘]’
            } else if (tok.ttype == FC_WORD) {// 如果是word,则为变量
                id obj = [self getVar: tok.value];
                arraySize = [obj intValue];
                [self getNextToken];// ‘]’
            }
            
            // else 读到的为 ']'
            if (type == FC_DEFSTRING || type == FC_DEFINT || type == FC_DEFBOOLEAN
                || type == FC_DEFDOUBLE || type == FC_DEFOBJECT)// string数组
            {
                [self addVar:name value: [NSMutableArray arrayWithCapacity: arraySize]];
            }
        } else {// 普通变量赋值
            switch (type)
            {
                case FC_DEFINT: {// integer测试
                    [self addVar:name value: [NSNumber numberWithInt: 0]];
                    break;
                }
                case FC_DEFSTRING: {// string测试
                    [self addVar:name value:  NULL_STRING_VALUE];
                    break;
                }
                case FC_DEFBOOLEAN: {// Boolean测试
                    [self addVar:name value: [FCBoolean boolWithBool: NO]];
                    break;
                }
                case FC_DEFDOUBLE: {// Double测试
                    [self addVar:name value: [NSNumber numberWithInt: 0]];
                    break;
                }
                case FC_DEFOBJECT: {// Object测试
                    [self addVar: name value: [[NSObject alloc] init]];
                    break;
                }
            }
        }
        [self getNextToken];
        if (tok.ttype == FC_EQ)
        {// 例如 int a=1 这种赋值
            [self getNextToken];
            id obj = [self parseExpr];
            [self setVarWithName:name value: obj];
        }
        else if (tok.ttype != ',' && tok.ttype != FC_EOL)
        {// 定义多个变量
            [self parseError:@"Expected ','"];
        }
    } while (tok.ttype != FC_EOL);// 直到该行结束
}

// FSException异常的信息格式
- (void) parseError: (NSString*) s
{
    //        NSString* t;
    //        error = new String[6];
    //
    //        t = tok.toString();
    //
    //        // set up our error block
    //
    //        error[0] = s;
    //        error[1] = (new Integer(code.getCurLine())).toString();
    //        error[2] = code.getLine();
    //        error[3] = t;
    //        error[4] = vars.toString();
    //        if (gVars != null)
    //            error[5] = gVars.toString();
    //
    //        // then build the display string
    //        s = "\n\t" + s;
    //        int l = code.getCurLine();
    //        s = s + "\n\t\t at line:" + l + " ";
    //        s += "\n\t\t\t  " + code.getLine(l - 2);
    //        s += "\n\t\t\t  " + code.getLine(l - 1);
    //        s += "\n\t\t\t> " + code.getLine(l) + " <";
    //        s += "\n\t\t\t  " + code.getLine(l + 1);
    //        s += "\n\t\t\t  " + code.getLine(l + 2);
    //        s = s + "\n\t\t current token:" + t;
    //        s = s + "\n\t\t Variable dump:" + vars;
    //        if (gVars != null) {
    //            s = s + "\n\t\t Globals:" + gVars;
    //        }
    FCSException* exception = [[FCSException alloc] initWithReason: s userInfo: nil];
    [exception raise];
}

- (NSMutableArray*) getError {
    return error;
}

- (BOOL) pComp: (NSString*) s {
    // a compare for (String)tok.value strings - that avoids the null
    // problem
    if (tok.value != nil)
    {
        return ([tok.value isEqualToString:s]);
    } else {
        return NO;
    }
}

/**
 * 取得下一个字符
 *
 * @throws FCSException
 */
- (void) getNextToken
{
    if ((tok.ttype == FC_EOL) && ([code getCurLine] < maxLine))
    {
        [code setCurLine: [code getCurLine] + 1];
        [tok setString: [code getLine]];
        // 得到下一个字符串
        [tok nextToken];
    }
    else if ((tok.ttype == FC_EOL) && ([code getCurLine] >= maxLine))
    {
        tok.ttype = FC_EOF;
    } else {
        [tok nextToken];
    }
}

- (void) resetTokens
{
    [tok setString: [code getLine]];
    [tok nextToken];
}

/**
 * 增加变量
 *
 * @param name
 * @param value
 * @throws FCSException
 */
- (void) addVar: (NSString*) name value: (id) value
{//throws FCSException
    id obj = [vars objectForKey: name];
    if (obj)
    {
        [self parseError: [NSString stringWithFormat: @"Already defined in this scope: %@", name]];
    }
    [vars setObject: value forKey: name];
}

- (id) getVar: (NSString*) name
{
    id obj = [vars objectForKey: name];
    if (!obj && gVars != nil)
    {
        obj = [gVars objectForKey: name];
    }
    return obj;
}

/**
 * 根据数组名称和数组按索引取值
 * 
 * @param name
 *            数组名
 * @param index
 *            数组索引
 * @return obj 数组指定索引的值
 * @throws FCSException
 */
- (id) getArrayItemByName: (NSString*) name andIndex: (id) index
{// throws FCSException
    if (index == nil)
    {
        id obj = [vars objectForKey: name];
        if (obj)
            return obj;
        else {
            return [gVars objectForKey: name];
        }
    } else if ([index respondsToSelector: @selector(intValue)])
    {
        int i = [index intValue];
        id obj = [vars objectForKey: name];
        if (obj && [obj isKindOfClass: [NSArray class]])
        {
            return [(NSArray*)obj objectAtIndex: i];
        } else {
            obj = [gVars objectForKey: name];
            if (obj && [obj isKindOfClass: [NSArray class]])
            {
                return [(NSArray*)obj objectAtIndex: i];
            }
        }
    }
    else 
    {
        [self parseError: @"the type of index is error"];
    }
    return nil;
}

/**
 * 根据数组名称和数组按索引设置相应的值
 * 
 * @param name
 *            数组名
 * @param index
 *            数组索引
 * @param val
 *            数组要存放的值
 * @throws FCSException
 */
- (void) setArrayItemByName: (NSString*) name
                   andIndex: (id) index 
                      value: (id) val
{//throws FCSException
    if (val == nil)
    {
        [self parseError: [NSString stringWithFormat: @"set variable %@ with null value", name]];
    } else {
        if (index == nil) {
            id obj = [vars objectForKey: name];
            if (obj)
            {
                [vars setObject: val forKey: name];
            } else {
                [gVars setObject: val forKey: name];
            }
        }
        else if ([index respondsToSelector: @selector(intValue)])
        {
            int i = [index intValue];
            id obj = [vars objectForKey: name];
            if (obj && [obj isKindOfClass: [NSMutableArray class]])
            {
                LOG(@"%lu", (unsigned long)[(NSMutableArray*)obj count]);
                if (i < [(NSMutableArray*)obj count]) {
                    [(NSMutableArray*)obj replaceObjectAtIndex:i withObject: val];
                }
                else {
                    [(NSMutableArray*)obj addObject:val];
                }
            } else {
                obj = [gVars objectForKey: name];
                if (obj && [obj isKindOfClass: [NSMutableArray class]])
                {
                    LOG(@"%lu", (unsigned long)[(NSMutableArray*)obj count]);
                    if (i < [(NSMutableArray*)obj count]) {
                        [(NSMutableArray*)obj replaceObjectAtIndex:i withObject: val];
                    }
                    else {
                        [(NSMutableArray*)obj addObject:val];
                    }
                }
            }
        }
        else 
        {
            [self parseError: @"the type of index is error"];
        }
    }
}

/**
 * 核对变量是参数数据类型，并对不同数据类型进行转换
 * 
 * @param var
 * @param param
 * @return
 * @throws FCSException
 */
- (id) checkVarAndParamObject: (id) var 
                       Object: (id) param
{//throws FCSException 
    if (var == nil)
        var = [[NSObject alloc] init];
    if (param == nil)
        return nil;
    
    // 如果不是同一类型,需进行转换
    if (![param isKindOfClass: [var class]])
    {
        if ([param isKindOfClass: [NSString class]] && [var isKindOfClass: [NSString class]])
        {
            return param;
        }
        // 左右数据类型不一直的情况只有2种
        // 1、一种是Object类型的,右边是其他类型的数据可以把其他类型数据赋值给左边Object
        // 如果左边是Object类型数据，右边都可以给object赋值
        //
        // 2、integer和double 2中类型的数据。(iphone中double和int均使用NSNumber可以互换)
        // 当左边数据类型为Double类型时才能把 右边integer类型的值赋值给左边。
        // 反之则不成立,目前来说该fcscript还不支持类型强制转换
        return var;// 变量更新
    } else {// 如果同一类型,直接返回参数值
        return param;
    }
}

/**
 * 设置变量的值
 * 
 * @param name
 *            变量名称
 * @param val
 *            值
 * @throws FCSException
 */
- (void) setVarWithName: (NSString*) name value: (id) val vars: (NSMutableDictionary*) v
{
    id obj = [v objectForKey:name];
    if (val)
    {
        // 判断变更的值类型是否一致
        obj = [self checkVarAndParamObject: obj Object: val];
        [v setObject: obj forKey: name];
    } else {
        if ([obj isKindOfClass: [NSString class]])
        {
            [v setObject: NULL_STRING_VALUE forKey: name];
        } else if ([obj isKindOfClass: [FCBoolean class]])
        {
            [v setObject: [FCBoolean boolWithBool: NO] forKey: name];
        } else if ([obj isKindOfClass: [NSNumber class]])
        {
            [v setObject: [NSNumber numberWithInt: NULL_NUMBER_VALUE] forKey: name];
        } else {
            [self parseError: @"can't set null to not default type"];
        }
    }
}

/**
 * 设置变量的值
 * 
 * @param name
 *            变量名称
 * @param val
 *            值
 * @throws FCSException
 */
- (void) setVarWithName: (NSString*) name value: (id) val
{
    id obj = [vars objectForKey:name];
    if (obj)
    {
        [self setVarWithName:name value: val vars: vars];
    } else {
        obj = [gVars objectForKey:name];
        if (obj)
            [self setVarWithName:name value: val vars: gVars];
        else
            [self parseError: [NSString stringWithFormat: @"no params with name : %@", name]];
    }
}

/**
 * 判断变量是否存在
 * 
 * @param name
 *            变量名称
 * @return boolean 变量存在返回YES,不存在返回NO
 */
- (BOOL) hasVar: (NSString*) name {
    if (gVars == nil) {
        return [vars objectForKey:name] != nil;
    } else {
        return ([gVars objectForKey:name] != nil) || ([vars objectForKey:name] != nil);
    }
}

- (id) getReturnValue {
    return retVal;
}

- (void) exit: (id) o {//throws FCSException
    retVal = o;
}

// 检测代码行正确格式()和"
- (void) checkLine:(NSString*) line {//throws FCSException
    BOOL inQuotes = NO;
    int brCount = 0;
    line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int n;
    
    if (line != nil) {
        NSUInteger length = [line length];
        if (![line hasPrefix: @"#"]) {//line.trim().startsWith("#")
            for (n = 0; n < length; n++) {
                if (inQuotes) {
                    if ([line characterAtIndex: n] == '"') {
                        if (n >= 1) {
                            if ([line characterAtIndex: n - 1] != '\\') {
                                inQuotes = NO;
                            }
                        }
                    }
                } else {
                    if ([line characterAtIndex: n] == '(') {
                        brCount++;
                    } else if ([line characterAtIndex: n] == ')') {
                        brCount--;
                    } else if ([line characterAtIndex: n] == '"') {
                        if (n >= 1) {
                            if ([line characterAtIndex: n - 1] != '\\') {
                                inQuotes = YES;
                            }
                        }
                    }
                }
            }
            
            if (inQuotes) {
                [self parseError:@"Mismatched quotes"];
            }
            
            if (brCount != 0) {
                [self parseError:@"Mismatched brackets"];
            }
        }
    }
}

/** 析构函数
 *  析构函数
 */
//- (void) dealloc
//{
//    [funcs release];
//    [vars release];
////  [opPrio release];
//  [super dealloc];
//}

@end