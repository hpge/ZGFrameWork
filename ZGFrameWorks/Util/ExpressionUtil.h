///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2015，（版权声明）
/// All rights reserved
///
/// @file   ExpressionUtil.h
/// @brief  表达式解析工具类定义文件
///
/// 该类定义了表达式解析工具类
///
/// @version    0.0.1
/// @date       2015.11.25
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

#ifndef MAX
#define MAX(x,y) (x) > (y) ? (x) : (y);
#endif
#ifndef MIN
#define MIN(x,y) (x) < (y) ? (x) : (y);
#endif

/** 表达式解析工具类
 *
 *  该类用于表达式解析
 */
@interface ExpressionUtil : NSObject {
}
/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;
/** 计算百分比表达式
 *
 *  计算百分比表达式，该表示为数学表达式，其中百分比数据格式为XX%，基数为parentValue参数
 *  @param expressionStr 数学表达式，其中含有形如XX%的表达式，
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回NSNumber*类型
 */
+ (NSNumber*) calculatePercentExp: (NSString*) expressionStr
                      numberValue: (NSNumber*) parentValue;

/** 计算百分比
 *
 *  该方法用于百分比计算表达式，用于计算一个数的百分比值
 *  @param percentValue 以百分号结束的百分数
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回NSNumber*
 */
+ (NSNumber*) calculatePercentValue: (NSString*) percentValue
                        numberValue: (NSNumber*) parentValue;

/** 计算百分比表达式
 *
 *  计算百分比表达式，该表示为数学表达式，其中百分比数据格式为XX%，基数为parentValue参数
 *  @param expressionStr 数学表达式，其中含有形如XX%的表达式，
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回int
 */
+ (int) calculatePercentExp: (NSString*) expressionStr
                   intValue: (int) parentValue;

/** 计算百分比
 *
 *  该方法用于百分比计算表达式，用于计算一个数的百分比值
 *  @param percentValue 以百分号结束的百分数
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回NSNumber*
 */
+ (int) calculatePercentValue: (NSString*) percentValue
                     intValue: (int) parentValue;

/** 计算百分比表达式
 *
 *  计算百分比表达式，该表示为数学表达式，其中百分比数据格式为XX%，基数为parentValue参数
 *  @param expressionStr 数学表达式，其中含有形如XX%的表达式，
 *  @param parentValue 百分比值的基数
 *  @param 运算后的数值，返回float
 */
+ (float) calculatePercentExp: (NSString*) expressionStr
                   floatValue: (float) parentValue;

/** 计算百分比
 *
 *  该方法用于百分比计算表达式，用于计算一个数的百分比值
 *  @param percentValue 以百分号结束的百分数
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回NSNumber*
 */
+ (float) calculatePercentValue: (NSString*) percentValue
                     floatValue: (float) parentValue;
@end
