///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarButton.m
/// @brief 按钮控件文件
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

#import "ExpressionUtil.h"
#import "ForwardPageAction.h"
#import "FSActionInterface.h"

@implementation ZGButton

#pragma mark -
#pragma mark properites

/** 按钮控件 */
@synthesize uiButton;
@synthesize selectedImage;
@synthesize fontColor;

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
  self.uiButton = [UIButton buttonWithType: UIButtonTypeCustom];
  if ([self isInContainerClass: [ZGMenu class]])
  {
    style = MENU_BUTTON;
  } else {
    style = NORMAL_BUTTON;
  }
  return self;
}

/** 初始化组件方法
 *
 *  XML解析器在读取标签内容后调用，用于初始化标签内容属性
 *  @param tagContent 标签内容
 */
- (void) specInit
{
  [super specInit];
  /** 字体颜色设置 */
  self.fontColor = [UIPropertiesLoader initColorWithString:
                    [propertiesMap objectForKey: MAR_TAG_ATTR_FONT_COLOR]
                                              isBackground: NO];
  /** 选中图片设置 */
  self.selectedImage = [UIPropertiesLoader initImageWithString:
                        [propertiesMap objectForKey: MAR_TAG_ATTR_SELECT_IMAGE]
                                                      callback: @selector(selectedFinishLoaded:)
                                                    compontent: self];
  /** 获取事件 */
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
//  [fontColor release];
//  [selectedImage release];
//  [uiButton release];
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
  /** 标题文字 */
  [uiButton setTitle: self.content forState: UIControlStateNormal];
  [uiButton.titleLabel setBackgroundColor: [UIColor clearColor]];
  /** 背景颜色设置 */
  if (self.backGroundColor) {
    [uiButton setBackgroundColor: backGroundColor];
  }
  UIFont* font = [UIFont boldSystemFontOfSize: fontSize];
  [uiButton.titleLabel setFont: font];
  
  /** 设置文本换行 */  
  NSString* align = [propertiesMap objectForKey:MAR_TAG_ATTR_ALIGN];
  if ([align isEqualToString:@"11"])
    
  {
    uiButton.titleLabel.textAlignment = UITextAlignmentRight;
  }
  
  NSString* breakMode = [propertiesMap objectForKey: MAR_TAG_ATTR_WRAP];
  if (breakMode && ([breakMode isEqualToString: @"no"]
                    || [breakMode isEqualToString: @"NO"]))
  {
    uiButton.titleLabel.numberOfLines = 1;
    uiButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
   
  } else
  {
    uiButton.titleLabel.numberOfLines = 0;
    uiButton.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
  }
  
    
  
  if ([actionList count] > 0)
    [uiButton addTarget: [actionList objectAtIndex: 0]
                 action: @selector(executeAction:)
       forControlEvents: UIControlEventTouchUpInside];
  if (fontColor)
  {
    [uiButton setTitleColor: fontColor
                   forState: UIControlStateNormal];
  } else {
    [uiButton setTitleColor: [UIColor whiteColor]
                   forState: UIControlStateNormal];
  }
    [uiButton setTitleColor:[UIColor redColor]
                 forState:UIControlStateHighlighted];

  /** 背景图片设置 */
  if (backGroundImage) {
    [uiButton setBackgroundImage: backGroundImage forState: UIControlStateNormal];
  }
  if (selectedImage)
  {
    [uiButton setBackgroundImage: selectedImage forState: UIControlStateHighlighted];
  }
  drawSize = [UIPropertiesLoader getCompSize: remainSize
                                  xmlDefSize: drawSize
                                   bgimgSize: CGSizeMake(bgWidth, bgHeight)
                                       image: backGroundImage
                                        font: font
                                     content: content
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
  drawRect = [super drawCompontentOnContainer: container OnView: view WithRect: drawRect];
  if (style == MENU_BUTTON)
  {
      
    CGSize drawSize = backGroundImage.size;
    int x = (drawRect.size.width - drawSize.width) / 2;
    uiButton.frame = CGRectMake(drawRect.origin.x + x, drawRect.origin.y, drawSize.width, drawSize.height);
    drawSize = [self.content sizeWithFont: self.uiButton.titleLabel.font];
    x = (drawRect.size.width - drawSize.width) / 2;
    int y = drawRect.size.height - drawSize.height - 2;
    uiButton.titleLabel.frame = CGRectMake(x, y, drawSize.width, drawSize.height);
  } else {
    /** 显示区域 */
    uiButton.frame = drawRect;
  }
  LOG("add button %@ to container", name);
  if (!isAddedToParent)
  {
    LOG("button %@ not in container", name);
    isAddedToParent = YES;
    [view addSubview: uiButton]; /** 添加按钮到视图中 */
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
  uiButton.frame = [UIPropertiesLoader getNewRect: uiButton.frame
                                       compontent: self
                                    attributeName: attributeName
                                   attributeValue: value];
  if ([attributeName isEqualToString:MAR_TAG_ATTR_BACK_IMAGE]) {
    UIImage* backImage = [UIPropertiesLoader initImageWithString: value
                                                        defImage: backGroundImage
                                                        callback: @selector(backgroundFinishLoaded:)
                                                      compontent: self];
    if (backImage)
    {
      self.backGroundImage = backImage;
      [uiButton setBackgroundImage: backImage forState: UIControlStateNormal];
    }
  } else if ([attributeName isEqualToString:MAR_TAG_ATTR_SELECT_IMAGE]) {
    UIImage* checkedImage = [UIPropertiesLoader initImageWithString: value
                                                           defImage: selectedImage
                                                           callback: @selector(selectedFinishLoaded:)
                                                         compontent: self];
    if (checkedImage)
    {
      self.selectedImage = checkedImage;
      [uiButton setBackgroundImage: checkedImage forState: UIControlStateHighlighted];
    }
  } else if ([attributeName isEqualToString:MAR_TAG_ATTR_BACK_COLOR]) {
    UIColor* backColor = [UIPropertiesLoader initColorWithString: value
                                                    isBackground: YES];
    if (backColor) {
      self.backGroundColor = backColor;
    }
  } else if ([attributeName isEqualToString:MAR_TAG_ATTR_FONT_COLOR]) {
    /** 字体颜色设置 */
    UIColor* color = [UIPropertiesLoader initColorWithString: value
                                                isBackground: NO];
    if (color)
    {
      self.fontColor = color;
      [uiButton setTitleColor: fontColor forState: UIControlStateNormal];
    }
  } else if ([attributeName isEqualToString:MAR_TAG_ATTR_FONT_SIZE] ||
           [attributeName isEqualToString:MAR_TAG_ATTR_FONT_SIZE1]) {
    /** 字体设置大小 */
    int fSize = [value intValue];
    if (fSize <= 0)
    {
      fSize = MAR_DEFAULT_BUTTON_FONT_SIZE;
    }
    UIFont* font = [UIFont boldSystemFontOfSize: fSize];
    [uiButton.titleLabel setFont: font];
  } else if ([attributeName isEqualToString:MAR_TAG_ATTR_ACTION]) {
    /** 添加跳转连接 */
    FSActionInterface* action = [UIPropertiesLoader newAction: self];
    if (action)
    {
      if ([actionList count] > 0)
      {
        FSActionInterface* temp = [actionList objectAtIndex: 0];
        [uiButton removeTarget: temp
                        action: @selector(executeAction:)
              forControlEvents: UIControlEventTouchUpInside];
        [actionList removeObject: temp];
      }
      [actionList addObject: action];
      [uiButton addTarget: action
                   action: @selector(executeAction:)
         forControlEvents: UIControlEventTouchUpInside];
    }
  }
  CGRect drawRect = self.uiButton.frame;
  CGSize drawSize = backGroundImage.size;
  int x = (drawRect.size.width - drawSize.width) / 2;
  uiButton.frame = CGRectMake(drawRect.origin.x + x, drawRect.origin.y, drawSize.width, drawSize.height);
  drawSize = [self.content sizeWithFont: self.uiButton.titleLabel.font];
  x = (drawRect.size.width - drawSize.width) / 2;
  int y = drawRect.size.height - drawSize.height - 2;
  uiButton.titleLabel.frame = CGRectMake(x, y, drawSize.width, drawSize.height);
}

/** 异步方法返回修改背景图片
 */
- (void) backgroundFinishLoaded: (UIImage*) image
{
  if (image)
  {
    self.backGroundImage = image;
    [uiButton setBackgroundImage: image forState: UIControlStateNormal];
    
  }
}

/** 异步方法返回修改被选中图片
 */
- (void) selectedFinishLoaded: (UIImage*) image
{
  if (image)
  {
    self.selectedImage = image;
    [uiButton setBackgroundImage: image forState: UIControlStateHighlighted];
  }
}

/** 该组件从容器中移除后处理方法
 *
 *  该组件从父容器中移除后的处理方法
 */
- (void) removedFromContainer
{
  [uiButton removeFromSuperview];
  [super removedFromContainer];
}

#pragma mark -
#pragma mark get & set WidgetValue method

- (NSString*) getWidgetValue
{
  return self.uiButton.titleLabel.text;
}

@end