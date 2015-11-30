//
//  FCScript.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIComponent.h"
#import "FCLineLoader.h"
#import "FCParser.h"

@class FCParser;

@interface FCScript : NSObject
{
  FCParser* parser;//解析引擎
  FCLineLoader* code;//行载入器。把script按行存入该类中
}

- (id) callFunctionString:(NSString*) name Array: (NSArray*) params;
- (void) setVarString:(NSString*) name Object: (id) index Object: (id) value;
- (BOOL) definedFunction: (NSString*) name;

/**
 * 添加FCscript代码.
 * @param s FCScript代码
 */
- (void) addLines: (NSString*) s;

/**
 * 获取该fcscript代码行数
 * @return int 代码行数
 */
- (int) getCodeLings;

/**
 * 加载当前代码并运行.
 *@return 返回FCScript支持的 int,boolean,string和其数组 类型)
 */
- (id) runCode;  //() throws  FCSException,Exception

/**
 * 重置缓存代码.
 */
- (void) reset;

/**
 * 在script代码中 中包含 'exit'关键字就跳出.
 * @param o fcscript代码对象
 **/
- (void) exit: (id) o;   //throws FCSException

/**
 * 按照指定起始行数解析FCscript脚本.
 * @param from 代码解析起始位置
 * @return Object
 * @throws FCSException
 * @throws Exception
 */
- (id) cont:(int) from; //throws FCSException,Exception 

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
- (NSMutableArray*) getError;

/**
 * 获取某变量的值.
 * @param name 参数名
 * @return Object 参数值
 * @throws FCSException
 */
- (id) getVar: (NSString*) name;
    
/**
 * 从数组中获取某索引下的值.
 * @param name 变量名
 * @param index 索引
 * @return Object 数组中对应索引值
 * @throws FCSException
 */
- (id) getVarString:(NSString*) name Object: (id) index;

/**
 * 定义变量.
 * @param name	变量名
 * @param value	变量值
 * @throws FCSException
 */
- (void) setScript: (NSString*) name 
               Var: (id) value;    // throws FCSException

/**
 * 调用函数.
 * @param name	方法名
 * @param params 参数
 * @return Object function对应的值
 * @throws FCSException
 */
- (id) callScript: (NSString*) name 
         Function: (NSMutableArray*) params;    //throws  FCSException
    
@end

@interface FSContext : NSObject
{
@protected
  ZGPage* currentPage;
  ZGComponent* currentFocus;
  NSMutableDictionary* contextParams;
}

- (id) initWithContextParameters: (NSDictionary*) dict;

@property (nonatomic, assign) ZGPage* currentPage;
@property (nonatomic, assign) ZGComponent* currentFocus;
@property (nonatomic, assign) NSMutableDictionary* contextParams;

@end