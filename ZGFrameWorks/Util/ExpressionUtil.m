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

#import "ExpressionUtil.h"

@implementation ExpressionUtil

static NSCharacterSet const *PERCENT_SIGN;
static NSCharacterSet *ALGEBRAIC_OPERATOR;

/** 静态初始化方法
 *
 *  初始化表达式符号，百分号符号
 */
+ (void) initialize
{
  PERCENT_SIGN = [NSCharacterSet characterSetWithCharactersInString: @"%"];
  ALGEBRAIC_OPERATOR = [NSCharacterSet characterSetWithCharactersInString: @"+-*/()"];
  [PERCENT_SIGN retain];
  [ALGEBRAIC_OPERATOR retain];
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
//+ (void) staticFree
//{
//	[PERCENT_SIGN release];
//    [ALGEBRAIC_OPERATOR release];
//}

/** 计算百分比表达式
 *
 *  计算百分比表达式，该表示为数学表达式，其中百分比数据格式为XX%，基数为parentValue参数
 *  @param expressionStr 数学表达式，其中含有形如XX%的表达式，
 *  @param parentValue 百分比值的基数
 *  return 运算后的数值，返回NSNumber*类型
 */
+ (NSNumber*) calculatePercentExp: (NSString*) expressionStr
                      numberValue: (NSNumber*) parentValue
{
  int currentIndex = -1;
  NSUInteger expressionLength = [expressionStr length];
  NSArray* numbersExp = [expressionStr componentsSeparatedByCharactersInSet: ALGEBRAIC_OPERATOR];
  int resultNumber = 0;
  unichar operator = '+';
  int tempValue = 0;
  for (NSString* numberExp in numbersExp)
  {
    if (![numberExp isEqualToString: @""])
    {
      tempValue = [[ExpressionUtil calculatePercentValue: [numberExp stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                             numberValue: parentValue] intValue];
      switch (operator) {
        case '+':
          resultNumber += tempValue;
          break;
        case '-':
          resultNumber -= tempValue;
          break;
        case '*':
          resultNumber *= tempValue;
          break;
        case '/':
          resultNumber /= tempValue;
          break;
        default:
          break;
      }
      currentIndex += [numberExp length];
      if (currentIndex < expressionLength - 1)
      {
        currentIndex++;
        operator = [expressionStr characterAtIndex: currentIndex];
      }
    } else {
      currentIndex++;
      unichar opTemp = [expressionStr characterAtIndex: currentIndex];
      if (opTemp != '(')
      {
        operator = opTemp;
      }
    }
    
  }
  return [NSNumber numberWithInt: resultNumber];
}

/** 计算百分比表达式
 *
 *  计算百分比表达式，该表示为数学表达式，其中百分比数据格式为XX%，基数为parentValue参数
 *  @param percentValue 数学表达式，其中含有形如XX%的表达式，
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回NSNumber*类型
 */
+ (NSNumber*) calculatePercentValue: (NSString*) percentValue
                        numberValue: (NSNumber*) parentValue
{
  NSUInteger strLength = [percentValue length];
  if ([PERCENT_SIGN characterIsMember: [percentValue characterAtIndex: strLength - 1]])
  {
    float percentage = [[percentValue substringToIndex: strLength - 1] floatValue];
    return [NSNumber numberWithInt: [parentValue intValue] * percentage / 100];
  } else {
    return [NSNumber numberWithInt: [percentValue intValue]];
  }
}

/** 计算百分比表达式
 *
 *  计算百分比表达式，该表示为数学表达式，其中百分比数据格式为XX%，基数为parentValue参数
 *  @param expressionStr 数学表达式，其中含有形如XX%的表达式，
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回int
 */
+ (int) calculatePercentExp: (NSString*) expressionStr
                   intValue: (int) parentValue
{
  return [[ExpressionUtil calculatePercentExp: expressionStr
                                  numberValue: [NSNumber numberWithInt: parentValue]] intValue];
}

/** 计算百分比
 *
 *  该方法用于百分比计算表达式，用于计算一个数的百分比值
 *  @param percentValue 以百分号结束的百分数
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回int
 */
+ (int) calculatePercentValue: (NSString*) percentValue
                     intValue: (int) parentValue
{
  return [[ExpressionUtil calculatePercentValue: percentValue
                                    numberValue: [NSNumber numberWithInt: parentValue]] intValue];
}

/** 计算百分比表达式
 *
 *  计算百分比表达式，该表示为数学表达式，其中百分比数据格式为XX%，基数为parentValue参数
 *  @param expressionStr 数学表达式，其中含有形如XX%的表达式，
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回float类型
 */
+ (float) calculatePercentExp: (NSString*) expressionStr
                   floatValue: (float) parentValue
{  
  return [[ExpressionUtil calculatePercentExp: expressionStr
                                  numberValue: [NSNumber numberWithFloat: parentValue]] floatValue];
}

/** 计算百分比
 *
 *  该方法用于百分比计算表达式，用于计算一个数的百分比值
 *  @param percentValue 以百分号结束的百分数
 *  @param parentValue 百分比值的基数
 *  @return 运算后的数值，返回float类型
 */
+ (float) calculatePercentValue: (NSString*) percentValue
                     floatValue: (float) parentValue
{
  return [[ExpressionUtil calculatePercentValue: percentValue
                                    numberValue: [NSNumber numberWithInt: parentValue]] floatValue];
}

@end
