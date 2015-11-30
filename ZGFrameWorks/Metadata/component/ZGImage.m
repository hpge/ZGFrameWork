///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarImage.m
/// @brief 图片视图文件
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

@implementation ZGImage

#pragma mark -
#pragma mark properites

/** 图片视图控件 */
@synthesize uiImageView;

#pragma mark -
#pragma mark init & dealloc method

/** 组件加载方法
 *
 *  XML解析器在解析XML文档时，遇到标签开始时调用该方法将标签名称，标签参数列表
 *  和父组件传递给组件类，并根据相关内容完成初始化工作。子类不应重写该方法，子类
 *  自定义初始化部分，应重写specInit方法。
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
  [super loadFromXMLTag: tagName attributes: attributeDict parentContainer: parentContainer];
  backView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
  uiImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
  return self;
}

/** 组件内容初始化方法
 *
 *  XML解析器在读取标签内容后调用，用于初始化标签内容属性
 *  @param tagContent 标签内容
 */
- (void) specInit
{
  [super specInit];
}

/** 析构函数
 *  析构函数
 */
//- (void) dealloc
//{
//  [uiImageView release];
//  [backView release];
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
  CGSize drawSize = [super calculateFitableSize: xmlDefineSize
                                     remainSize: remainSize
                                 maxSeeableSize: maxSeeableSize
                                percentBaseSize: percentBaseSize
                                    inContainer: container];
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

  backView.frame = drawRect;
  CGRect imageRect = drawRect;
  if ([propertiesMap objectForKey:MAR_TAG_ATTR_BACK_IMAGE]) { //图片居中
    CGFloat imagewidth = backGroundImage.size.width;
    CGFloat imageheight = backGroundImage.size.height;
    imageRect = CGRectMake((drawRect.size.width - imagewidth)/2, (drawRect.size.height - imageheight)/2, imagewidth, imageheight);
  }
  uiImageView.frame = imageRect;
  if (self.backGroundColor)
    [backView setBackgroundColor: backGroundColor];
  if (self.backGroundImage)
    [uiImageView setImage: backGroundImage];
  
  if (!isAddedToParent)
  {
    isAddedToParent = YES;
    [backView addSubview: uiImageView];
    [view addSubview: backView]; /** 添加按钮到视图中 */
  }
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
  uiImageView.frame = [UIPropertiesLoader getNewRect: uiImageView.frame
                                          compontent: self
                                       attributeName: attributeName
                                      attributeValue: value];
  if ([attributeName isEqualToString: MAR_TAG_ATTR_BACK_IMAGE])
  {
    [UIPropertiesLoader initImageWithString: value
                                   defImage: backGroundImage
                                   callback: @selector(backgroundFinishLoaded:)
                                 compontent: self];
  }
}

/** 异步方法返回修改背景图片
 */
- (void) backgroundFinishLoaded: (UIImage*) image
{
  if (image)
  {
    self.backGroundImage = image;
    [uiImageView setImage: image];
  }
}

@end