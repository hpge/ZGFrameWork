///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarImageLink.m
/// @brief 图片链接文件
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
#import "ForwardPageAction.h"

@implementation ZGImageLink

/** 图片链接按钮 */
@synthesize uiImageLink;

/** 组件内容初始化方法
 *
 *  XML解析器在读取标签内容后调用，用于初始化标签内容属性
 *  @param tagContent 标签内容
 */
- (void) specInit
{
  [super specInit];
  /** 如果没有背景图案或者背景颜色则默认为圆角按钮 */
  if (backGroundImage)
  {
    isRoundedRect = FALSE;
  } else {
    isRoundedRect = TRUE;
  }
  /** 添加跳转连接 */
  FSActionInterface* action = [UIPropertiesLoader newAction: self];
  if (action)
  {
    [actionList addObject: action];
  }
}

/** 析构函数
 *  析构函数
 */
//- (void) dealloc
//{
//  [uiImageLink release];
//  [super dealloc];
//}

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
  CGSize drawSize = [super calculateFitableSize: xmlDefineSize
                                     remainSize: remainSize
                                 maxSeeableSize: maxSeeableSize
                                percentBaseSize: percentBaseSize
                                    inContainer: container];
  if (!uiImageLink)
  {
    if (isRoundedRect)
    {
      self.uiImageLink = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    } else {
      self.uiImageLink = [UIButton buttonWithType: UIButtonTypeCustom];
    }
  }
  
  /** 背景图片设置 */
  if (backGroundImage) {
    [uiImageLink setBackgroundImage: backGroundImage forState: UIControlStateNormal];
    [uiImageLink setBackgroundImage: backGroundImage forState: UIControlStateHighlighted];
  }
  if ([actionList count] > 0)
  {
    [uiImageLink addTarget: [actionList objectAtIndex: 0]
                    action: @selector(executeAction:)
          forControlEvents: UIControlEventTouchDown];
  }
  drawSize = [UIPropertiesLoader getCompSize: remainSize
                                  xmlDefSize: drawSize
                                   bgimgSize: CGSizeMake(bgWidth, bgHeight)
                                       image: backGroundImage
                                        font: nil
                                     content: nil
                                  compontent: self
                           sizeDefinedSource: defaultSizeSource];
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
  drawRect = [super drawCompontentOnContainer: container OnView: nil WithRect: drawRect];
  uiImageLink.frame = drawRect;
  if (!isAddedToParent)
  {
    isAddedToParent = YES;
    [view addSubview: uiImageLink]; /** 添加按钮到视图中 */
  }
  return drawRect;
}

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
  
  uiImageLink.frame = [UIPropertiesLoader getNewRect: uiImageLink.frame
                                          compontent: self
                                       attributeName: attributeName
                                      attributeValue: value];
  if ([attributeName isEqualToString:MAR_TAG_ATTR_BACK_IMAGE]) {
    self.backGroundImage = [UIPropertiesLoader initImageWithString: value
                                                          defImage: backGroundImage
                                                          callback: @selector(backgroundFinishLoaded:)
                                                        compontent: self];
    if (backGroundImage)
    {
      [uiImageLink setBackgroundImage: backGroundImage forState: UIControlStateNormal];
      [uiImageLink setBackgroundImage: backGroundImage forState: UIControlStateHighlighted];
    } else {
//      uiImageLink = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    }
  }
  else if ([attributeName isEqualToString:MAR_TAG_ATTR_ACTION]) {
    /** 添加跳转连接 */
    FSActionInterface* action = [UIPropertiesLoader newAction: self];
    if (action)
    {
      [actionList addObject: action];
      [uiImageLink addTarget: action
                      action: @selector(executeAction:)
            forControlEvents: UIControlEventTouchDown];
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
    [uiImageLink setBackgroundImage: backGroundImage forState: UIControlStateNormal];
    [uiImageLink setBackgroundImage: backGroundImage forState: UIControlStateHighlighted];
  }
}

@end