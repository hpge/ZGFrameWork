///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，（版权声明）
/// All rights reserved
///
/// @file MarLabel.m
/// @brief 标签文件
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

@implementation ZGLabel
/** 标签控件 */
@synthesize uiLabel;
/** 字体颜色 */
@synthesize fontColor;

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
  UILabel* temp = [[UILabel alloc] init];
  self.uiLabel = temp;
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
  /** 字体颜色设置 */
  self.fontColor = [UIPropertiesLoader initColorWithString:
                    [propertiesMap objectForKey: MAR_TAG_ATTR_FONT_COLOR]
                                              isBackground: NO];
}

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
  UIFont *font;
  bool isInToolBar = [self isInContainerClass: [ZGToolBar class]];
  if (fontColor)
  {
    [uiLabel setTextColor: fontColor];
    font = [UIFont systemFontOfSize: fontSize];
  }
  else if (isInToolBar)
  {
    [uiLabel setTextColor: [UIColor whiteColor]];
    font = [UIFont boldSystemFontOfSize: fontSize];
  } else {
    [uiLabel setTextColor: [UIColor blackColor]];
    font = [UIFont systemFontOfSize: fontSize];
  }
  [uiLabel setFont: font];
  /** 背景颜色设置 */
  if (self.backGroundImage)
  {
    UIColor* color = [[UIColor alloc] initWithPatternImage: backGroundImage];
    [uiLabel setBackgroundColor: color];
  } else if (self.backGroundColor && !isInToolBar) {
    [uiLabel setBackgroundColor: backGroundColor];
  } else {
    [uiLabel setBackgroundColor: [UIColor clearColor]];
  }
  uiLabel.textAlignment = alignStyle.hAlign;
  uiLabel.baselineAdjustment = alignStyle.vAlign;
  if (self.content == nil)
  {
    self.content = @"";
  }
  /** 标题文字 */
  [uiLabel setText: self.content];
  if ([[propertiesMap objectForKey: MAR_TAG_ATTR_FORM] isEqualToString: @"ver"])
  {
    uiLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    uiLabel.numberOfLines = 0;
    drawSize = [content sizeWithFont: font constrainedToSize: CGSizeMake(compWidth, 460) lineBreakMode: UILineBreakModeCharacterWrap];
  } else {
    /** 设置文本换行 */
    UILineBreakMode mode = UILineBreakModeWordWrap;
    NSString* temp = [self getAttribute: MAR_TAG_ATTR_WRAP];
    if (temp && ([temp isEqualToString: @"no"] || [temp isEqualToString: @"NO"]))
    {
      mode = UILineBreakModeTailTruncation;
    }  
    uiLabel.lineBreakMode = mode;
    drawSize = [UIPropertiesLoader getCompSize: remainSize
                                    xmlDefSize: drawSize
                                     bgimgSize: CGSizeMake(bgWidth, bgHeight)
                                         image: backGroundImage
                                          font: font
                                       content: self.content
                                    compontent: self
                             sizeDefinedSource: defaultSizeSource];
    uiLabel.numberOfLines = 0;
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
  drawRect = [super drawCompontentOnContainer: container OnView: view WithRect: drawRect];
  uiLabel.frame = drawRect;
  
  if (!isAddedToParent)
  {
    isAddedToParent = YES;
    
    [view addSubview: uiLabel]; /** 添加按钮到视图中 */
    
    
  }
  LOG(@"label frame : %.2f, %.2f, %.2f, %.2f",  drawRect.origin.x,
      drawRect.origin.y, drawRect.size.width, drawRect.size.height);
  return drawRect;
}

/** 析构函数
 *  析构函数
 */
//- (void) dealloc
//{
//  [uiLabel release];
//  [super dealloc];
//}

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
  
  uiLabel.frame = [UIPropertiesLoader getNewRect: uiLabel.frame
                                      compontent: self
                                   attributeName: attributeName
                                  attributeValue: value];
  if ([attributeName isEqualToString:MAR_TAG_ATTR_FONT_COLOR]) {
    /** 字体颜色设置 */
    UIColor* color = [UIPropertiesLoader initColorWithString: value
                                                isBackground: NO];
    if (color)
    {
      self.fontColor = color;
      [uiLabel setTextColor: fontColor];
    }
  }
  else if ([attributeName isEqualToString:MAR_TAG_ATTR_FONT_SIZE] ||
           [attributeName isEqualToString:MAR_TAG_ATTR_FONT_SIZE1]) {
    /** 字体设置大小 */
    int fSize = [value intValue];
    if (fSize <= 0)
    {
      fSize = MAR_DEFAULT_BUTTON_FONT_SIZE;
    }
    if (fontSize != fSize)
    {
      fontSize = fSize;
      UIFont* font;
      if (fontColor)
      {
        font = [UIFont systemFontOfSize: fontSize];
      }
      else if ([self isInContainerClass: [ZGToolBar class]])
      {
        font = [UIFont boldSystemFontOfSize: fontSize];
      } else {
        font = [UIFont systemFontOfSize: fontSize];
      }
      [uiLabel setFont: font];
    }
  }
  else if ([attributeName isEqualToString:MAR_TAG_ATTR_BACK_IMAGE]) {
    UIImage* backImage = [UIPropertiesLoader initImageWithString: value
                                                        defImage: backGroundImage
                                                        callback: @selector(backgroundFinishLoaded:)
                                                      compontent: self];
    if (backImage)
    {
      self.backGroundImage = backImage;
      UIColor* color = [[UIColor alloc] initWithPatternImage: backGroundImage];
      [uiLabel setBackgroundColor: color];
    }
  }
  else if ([attributeName isEqualToString:MAR_TAG_ATTR_BACK_COLOR]) {
    UIColor* backColor = [UIPropertiesLoader initColorWithString: value
                                                    isBackground: NO];
    if (backColor) {
      self.backGroundColor = backColor;
      [uiLabel setBackgroundColor: backColor];
    } 
  }
}

- (NSString*) getWidgetValue
{
  return uiLabel.text;
}

/** 获取组件信息
 *
 *  该方法将获取控件值并将其返回，如果为输入框则返回输入值，单选框返回选择的值，radio button返回
 *  是否选中，单选框组返回选中列表，用逗号分隔
 */
- (void) setWidgetValue: (NSString*) value
{
  if (value)
  {
    uiLabel.text = value;
    self.content = value;
    CGRect drawRect = uiLabel.frame;
    CGSize drawSize;
    if ([[propertiesMap objectForKey: MAR_TAG_ATTR_FORM] isEqualToString: @"ver"])
    {
      uiLabel.lineBreakMode = UILineBreakModeCharacterWrap;
      uiLabel.numberOfLines = 0;
      drawSize = [content sizeWithFont: uiLabel.font constrainedToSize: CGSizeMake(compWidth, 460) lineBreakMode: UILineBreakModeCharacterWrap];
    } else {
      drawSize = [content sizeWithFont: uiLabel.font constrainedToSize: CGSizeMake(320, drawRect.size.height)];
    }
    if (drawSize.width > drawRect.size.width || drawSize.height > drawRect.size.height)
      uiLabel.frame = CGRectMake(drawRect.origin.x, drawRect.origin.y, drawSize.width, drawSize.height);
    [propertiesMap setObject: value forKey: MAR_TAG_ATTR_VALUE];
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
    [uiLabel setBackgroundColor: color];
  }
}

/** 该组件从容器中移除后处理方法
 *
 *  该组件从父容器中移除后的处理方法
 */
- (void) removedFromContainer
{
  [uiLabel removeFromSuperview];
  [super removedFromContainer];
}
@end