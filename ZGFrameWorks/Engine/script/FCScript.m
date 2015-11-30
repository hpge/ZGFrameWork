//
//  FCScript.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FCScript.h"
#import "FCParser.h"
#import "FCSException.h"
#import "FileUtils.h"
#import "ClientConstants.h"
#import "XMLDataParser.h"
#import "XMLNode.h"

@implementation FCScript

/**
 * FCScript主函数 执行解析的script代码
 */

- (id)init {
  if (self = [super init]) {        
    parser = [[FCParser alloc] initWithFCScript:self];
    code = [[FCLineLoader alloc] init];
    [parser setCode:code];
    NSData* data = [FileUtils loadXMLFromResource: COMMON_FS_FILE];
    XMLDataParser* dataparser = [[XMLDataParser alloc] init];
    XMLNode* node = [dataparser doXMLParser: data];
    if (node.content)
      [self addLines: node.content];
//    [self runCode];
  }
  return (self);
}


/**
 * 添加FCscript代码.
 * @param s FCScript代码
 */
- (void) addLines: (NSString*) s {
  [code addLines: s];
}

/**
 * 获取该fcscript代码行数
 * @return int 代码行数
 */
- (int) getCodeLings {
  return [code lineCount];
}

/**
 * 加载当前代码并运行.
 *@return 返回FCScript支持的 int,boolean,string和其数组 类型)
 */
- (id) runCode
{
  //() throws  FCSException,Exception
  id obj = nil;
  LOG(@"into run code");
  @try {
    [parser reset];//重置解析类
    //      int a = [code lineCount];
    [parser parseDefFuncfrom: 0 to: [code lineCount] - 1];//首先解析定义的function 
    obj = [parser parsefrom: 0 to: [code lineCount] - 1];//解析从第一行到最后一行
  }
  @catch (NSException* theException)
  {
    LOG(@"exception !!! description : %@", [theException reason]);
  }
  @finally
  {
    return obj;
  }
}

/**
 * 重置缓存代码.
 */
- (void) reset {
  [code reset];
  [parser reset];
}

/**
 * 在script代码中 中包含 'exit'关键字就跳出.
 * @param o fcscript代码对象
 **/
- (void) exit: (id) o {   //throws FCSException
  [parser exit: o];
}

/**
 * 按照指定起始行数解析FCscript脚本.
 * @param from 代码解析起始位置
 * @return Object
 * @throws FCSException
 * @throws Exception
 */
- (id) cont:(int) from { //throws FCSException,Exception 
  @try {
    if(from == 0){
      return [self runCode];
    }
    else {
      [parser parseDefFuncfrom:from to: [code lineCount] - 1];
      return [parser parsefrom:from to: [code lineCount] - 1];
    }
  }
  @catch (NSException *exception)
  {
    LOG(@"exception : %@", [exception reason]);
    return nil;
  }
}

/**
 * 返回详细的error信息.
 * FCSExceptions.
 * s[0]=错误信息 
 * s[1]=行数 
 * s[2]=该行的文字
 * s[3]=当前执行位置
 * s[4]=局部变量的存储 
 * s[5]=全局变量存储
 */
- (NSMutableArray*) getError {
  return [parser getError];
}

/**
 * 获取某变量的值.
 * @param name 参数名
 * @return Object 参数值
 * @throws FCSException
 */
- (id) getVar: (NSString*) name {
  return [parser getVar:name];
}

/**
 * 从数组中获取某索引下的值.
 * @param name 变量名
 * @param index 索引
 * @return Object 数组中对应索引值
 * @throws FCSException
 */
- (id) getVarString:(NSString*) name Object: (id) index {
  return [parser getArrayItemByName: name andIndex:index];
}

/**
 * 给变量赋值.
 * @param name 变量名
 * @param value	变量值
 * @throws FCSException
 */
- (void) setVar: (NSString*) name
         Object: (id) value {
  FCSException* e = [[FCSException alloc] initWithReason:
                     [NSString stringWithFormat: @"Unrecognized External: %@", name]];
  [e raise];
}

/**
 * 给数组赋值.
 * @param name 数组名
 * @param index	数组索引
 * @param value	数组值
 * @throws FCSException
 */
- (void) setVarString:(NSString*) name 
               Object: (id) index 
               Object: (id) value {
  FCSException* e = [[FCSException alloc] initWithReason:
                     [NSString stringWithFormat: @"Unrecognized External: %@", name]];
  [e raise];
}

/**
 * 调用函数 
 * 引擎中调用，外部不可调用.
 * @param name 方法名
 * @param params 参数
 * @return Object function对应的值
 * @throws FCSException
 */
- (id) callFunctionString:(NSString*) name 
                    Array: (NSArray*) params {
  FCSException* e = [[FCSException alloc] initWithReason:
                     [NSString stringWithFormat: @"Unrecognized External: %@", name]];
  [e raise];
  return nil;
}

/**
 * 定义变量.
 * @param name	变量名
 * @param value	变量值
 * @throws FCSException
 */
- (void) setScript: (NSString*) name 
               Var: (id) value {    // throws FCSException
  [parser setVarWithName: name value: value];
}

/**
 * 调用函数.
 * @param name	方法名
 * @param params 参数
 * @return Object function对应的值
 * @throws FCSException
 */
- (id) callScript: (NSString*) name 
         Function: (NSMutableArray*) params {    //throws  FCSException
  return [parser callFunction:name Array:params];
}

- (BOOL) definedFunction: (NSString*) name
{
  return [parser definedFunction: name];
}

//- (void) dealloc {
//  [parser release];
//  [code release];
//  [super dealloc];
//}

@end

@implementation FSContext

@synthesize currentPage;
@synthesize currentFocus;
@synthesize contextParams;

- (id) initWithContextParameters: (NSDictionary*) dict
{
  if (self = [super init])
  {
    self.currentPage = nil;
    self.currentFocus = nil;
    self.contextParams = [NSMutableDictionary dictionaryWithDictionary: dict];
  }
  return self;
}

//- (void) dealloc
//{
//  [contextParams release];
//  [super dealloc];
//}

@end