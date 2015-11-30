///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarLayout.m
/// @brief
///
/// descirption
///
/// @version    0.0.1
/// @date       2011.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import "UIComponent.h"

@implementation ZGLayout

@synthesize scrollable;

#pragma mark -
#pragma mark init & dealloc method

/** 容器加载方法
 *
 *  XML解析器在解析XML文档时，遇到标签开始时调用该方法将标签名称，标签参数列表
 *  和父组件传递给组件类，并根据相关内容完成初始化工作。
 *  @param tagName 标签名称
 *  @param attributeDict 标签属性字典
 *  @param parentContainer 父组件
 *  @return 初始化后的容器对象
 */
- (ZGComponent*) loadFromXMLTag: (NSString*) tagName
                       attributes: (NSDictionary*) attributeDict
                  parentContainer: (ZGContainer*) container
{
  [super loadFromXMLTag: tagName
             attributes: attributeDict
        parentContainer: container];
  return self;
}

/** 组件内容初始化方法
 *
 *  XML解析器在读取标签内容后调用，用于初始化标签内容属性
 *  @param tagContent 标签内容
 */
- (void) specInit
{
  self.scrollable = [[propertiesMap objectForKey: MAR_TAG_ATTR_SCROLL] boolValue];
  if (scrollable)
  {
    self.view = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
  }
  [super specInit];
}

#pragma mark -
#pragma mark draw rect & draw method


/** 初步计算组件的大小和各个元素绘制范围的方法
 *
 *  由布局管理器调用，传入默认绘制大小，以及计算百分比表达式的高度以及宽度
 *  各个组件负责计算自己宽度和高度，同时计算最合适的绘制范围，并返回给布局
 *  管理器，方法中defaultSize和maxSize均不可修改。
 *  @param defaultSize 容器计算的目前默认宽度和高度
 *  @param maxSize 用于计算百分比的宽度和高度
 *  @return 最合适的绘制大小，其中需要包括组件宽高和相应的偏移量
 */
- (CGSize) calculateFitableSize: (const CGSize) xmlDefineSize
                     remainSize: (const CGSize) remainSize
                 maxSeeableSize: (const CGSize) maxSeeableSize
                percentBaseSize: (const CGSize) percentBaseSize
                    inContainer: (ZGContainer*) container
{
  CGSize drawSize = [super calculateFitableSize: xmlDefineSize
                                     remainSize: remainSize
                                 maxSeeableSize: maxSeeableSize
                                percentBaseSize: percentBaseSize
                                    inContainer: container];
  if (scrollable)
  {
    if (drawSize.height > remainSize.height)
    {
      [(UIScrollView*)self.view setContentSize: drawSize];
      return remainSize;
    } else {
      return drawSize;
    }
  }
  return drawSize;
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
  if (self.backGroundImage)
  {
    UIColor* color = [[UIColor alloc] initWithPatternImage: backGroundImage];
    [self.view setBackgroundColor: color];
  } else if (self.backGroundColor) {
    [self.view setBackgroundColor: backGroundColor];
  }
  drawRect = [super drawCompontentOnContainer: container OnView: view WithRect: drawRect];
  return drawRect;
}

#pragma mark -
#pragma mark get & set WidgetValue method

/** 更改组件的属性信息
 *
 *  @param attributeName 属性名称
 *  @param value 属性值
 */
- (void) setWidgetAttributeName: (NSString*) attributeName
                  AttributeVale: (NSString*) value
{
  [super setWidgetAttributeName: attributeName 
                  AttributeVale: value];
  if ([attributeName isEqualToString: MAR_TAG_ATTR_BACK_IMAGE]) {
    UIImage* backImage = [UIPropertiesLoader initImageWithString: [propertiesMap objectForKey: MAR_TAG_ATTR_BACK_IMAGE]
                                                        defImage: backGroundImage
                                                        callback: @selector(backgroundFinishLoaded:)
                                                      compontent: self];
    if (backImage)
    {
      self.backGroundImage = backImage;
      UIColor* color = [[UIColor alloc] initWithPatternImage: backGroundImage];
      [self.view setBackgroundColor: color];
    }
  }
  else if ([attributeName isEqualToString: MAR_TAG_ATTR_BACK_COLOR]) {
    UIColor* backColor = [UIPropertiesLoader initColorWithString: value
                                                    isBackground: YES];
    if (backColor) {
      self.backGroundColor = backColor;
      [self.view setBackgroundColor: backColor];
    } 
  }
}

/** 异步方法返回修改背景图片
 */
- (void) backgroundFinishLoaded: (UIImage*) image
{
  if (image)
  {
    self.backGroundImage = image;
    UIColor* color = [[UIColor alloc] initWithPatternImage: backGroundImage];
    [self.view setBackgroundColor: color];
  }
}

@end