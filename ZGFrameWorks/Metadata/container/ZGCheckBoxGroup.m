//
//  MarCheckBoxGroup.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZGCheckBoxGroup.h"
#import "ZGUIConstants.h"
#import "ZGLayoutManager.h"
#import "ExpressionUtil.h"

@implementation ZGCheckBoxGroup

#pragma mark -
#pragma mark properites

@synthesize checkBoxArray;

#pragma mark -
#pragma mark init & dealloc method

/** 组件加载方法
 *
 *  XML解析器在解析XML文档时，遇到标签开始时调用该方法将标签名称，标签参数列表
 *  和父组件传递给组件类，并根据设置相关内容。
 *  @param tagName 标签名称
 *  @param attributeDict 标签属性字典
 *  @param parentContainer 父组件
 *  @return 初始化后的组件对象
 *  @attention 该方法不应被覆盖，如果需要实现标签的初始化方法，应覆盖specInit方法
 */
- (ZGComponent*) loadFromXMLTag: (NSString*) tagName
                       attributes: (NSDictionary*) attributeDict
                  parentContainer: (ZGContainer*) parentContainer
{
  [super loadFromXMLTag: tagName
             attributes: attributeDict
        parentContainer: parentContainer];
  checkBoxArray = [[NSMutableArray alloc] init];
  return self;
}

/** 析构函数
 *  析构函数
 */
//- (void) dealloc
//{
//  [checkBoxArray release];
//  [super dealloc];
//}

#pragma mark -
#pragma mark draw rect & draw method

/** 初步计算组件的大小和各个元素绘制范围的方法
 *
 *  由布局管理器调用，传入当前绘制的点，以及计算百分比表达式的高度以及宽度
 *  各个组件负责计算自己宽度和高度，同时计算最合适的绘制范围，并返回给布局
 *  管理器，方法中orgPoint和maxSize均不可修改。
 *  @param orgPoint 绘制原点
 *  @param defaultSize 容器计算的目前默认宽度和高度
 *  @param maxSize 用于计算百分比的宽度和高度
 *  @return 最合适的绘制范围，其中point表示左右和上下的偏移量
 */
- (CGSize) calculateFitableSize: (const CGSize) xmlDefineSize
                     remainSize: (const CGSize) remainSize
                 maxSeeableSize: (const CGSize) maxSeeableSize
                percentBaseSize: (const CGSize) percentBaseSize
                    inContainer: (ZGContainer*) container
{
  NSString* temp = [propertiesMap objectForKey: MAR_TAG_ATTR_X];
  if (temp)
    compX = [ExpressionUtil calculatePercentExp: temp intValue: percentBaseSize.width];
  
  temp = [propertiesMap objectForKey: MAR_TAG_ATTR_Y];
  if (temp)
    compY = [ExpressionUtil calculatePercentExp: temp intValue: percentBaseSize.height];
  
  temp = [propertiesMap objectForKey: MAR_TAG_ATTR_WIDTH];
  if (temp)
  {
    compWidth = [ExpressionUtil calculatePercentExp: temp intValue: percentBaseSize.width];
    defaultSizeSource.widthSource = DefinedByXML;
  }
  
  temp = [propertiesMap objectForKey: MAR_TAG_ATTR_HEIGHT];
  if (temp)
  {
    compHeight = [ExpressionUtil calculatePercentExp: temp intValue: percentBaseSize.height];
    defaultSizeSource.heightSource = DefinedByXML;
  }
  
  temp = [propertiesMap objectForKey: MAR_TAG_ATTR_BGIMG_WIDTH];
  if (temp)
    bgWidth = [ExpressionUtil calculatePercentExp: temp intValue: percentBaseSize.width];
  
  temp = [propertiesMap objectForKey: MAR_TAG_ATTR_BGIMG_HEIGHT];
  if (temp)
    bgHeight = [ExpressionUtil calculatePercentExp: temp intValue: percentBaseSize.height];

  if (!layoutManager)
  {
    layoutManager = [ZGLayoutManager alloc];
  }
  
  layoutManager = [layoutManager initWithContainer: self
                                       definedSize: xmlDefineSize
                                        remainSize: remainSize
                                    maxSeeableSize: maxSeeableSize
                                   percentBaseSize: percentBaseSize
                                   parentContainer: container];

  for (ZGCheckBox* checkbox in checkBoxArray)
  {
    CGSize nextAvailableSize = [layoutManager nextAvailableSize];
    CGSize remainSeeableSize = [layoutManager remainSeeableSize];
    CGSize compDrawSize = [checkbox getFitableSize: nextAvailableSize
                                           maxSeeableSize: remainSeeableSize
                                          percentBaseSize: percentBaseSize
                                              inContainer: self];
    CGRect compRect = [layoutManager finetuningDrawRect: compDrawSize];
    [checkbox drawCompontentOnContainer: self OnView: self.view WithRect: compRect];
    [self afterPainCompontent: checkbox WithRect: compRect];
  }
  return layoutManager.totalShowRect;
}

/** 根据传入的绘制范围绘制组件
 *
 *  由布局管理器调用，传入父容器，绘制视图，以及根据getBestFitRect方法
 *  计算并重新调整的绘制范围，在View中绘制组件，该方法由各个子类实现。
 *  @param container 父容器
 *  @param view 绘制视图
 *  @param drawRect 绘制范围
 */
- (CGRect) drawCompontentOnContainer: (ZGContainer*) container
                              OnView: (UIView*) view
                            WithRect: (CGRect) drawRect
{
  return [super drawCompontentOnContainer: container OnView: view WithRect: drawRect];
}

#pragma mark -
#pragma mark manage checkbox methods

- (void) addCheckBoxToGroup: (ZGCheckBox*) checkBox
{
    [checkBoxArray addObject:checkBox];
}

/** 判断是否全选
 *
 *  @return 全选返回真
 */
- (BOOL) isAllSelect
{
    for (ZGCheckBox* checkbox in checkBoxArray) {
        if (![checkbox checkBoxIsCheck])
        {
            return NO;
        }
    }
    return YES;
}

/** 判断是否全不选
 *
 *  @return 全不选返回真
 */
- (BOOL) isAllNoSelect
{
    for (ZGCheckBox* checkbox in checkBoxArray) {
        if ([checkbox checkBoxIsCheck])
        {
            return NO;
        }
    }
    return YES;
}

/** 设置全选
 *
 */
- (void) setAllSelect
{
    for (ZGCheckBox* checkbox in checkBoxArray) {
        [checkbox setCheckBoxCheck:YES];
    }
}

/** 设置全不选
 *
 */
- (void) setAllNoSelect
{
    for (ZGCheckBox* checkbox in checkBoxArray) {
        [checkbox setCheckBoxCheck:NO];
    }
}

/** 设置单选框
 *
 *  @param selectCheckBox 选择框组件
 *  @param isRadio 是否是单选框
 */
- (void) isRadioSelect: (ZGCheckBox*) selectCheckBox
                    Tag: (BOOL) isRadio
{
    if (isRadio) {
        if ([selectCheckBox checkBoxIsCheck]) {
            for (ZGCheckBox* checkbox in checkBoxArray) {
                [checkbox setCheckBoxCheck:NO];
            }
            [selectCheckBox setCheckBoxCheck:YES];
        }
    }
}

/** 返回选中复选框中value的属性值数组
 *
 *  @return value属性数组
 *
 */
- (NSMutableArray*) checkBoxValue
{
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:1];
    for (ZGCheckBox* checkbox in checkBoxArray) {
        if ([checkbox checkBoxIsCheck]) {
            NSString* str = [checkbox getAttribute:MAR_TAG_ATTR_VALUE];
            [valueArray addObject: str];
        }
    }
    return valueArray;
}

@end
