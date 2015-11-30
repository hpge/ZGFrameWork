///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2015，版权声明）
/// All rights reserved
///
/// @file   UIPropertiesLoader.h
/// @brief  界面展示组件参数初始化工具类定义
///
/// 该文件用于定义界面展示组件参数初始化工具类
///
/// @version    0.0.1
/// @date       2015.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import "UIPropertiesLoader.h"
#import "ForwardPageAction.h"
#import "AsyncImageLoader.h"
#import "NetWork.h"
#import "FileUtils.h"

/** 界面展示组件参数初始化工具类
 *
 *  界面展示组件参数初始化工具类，负责提供各个页面展示组件参数的初始化方法
 */
@implementation UIPropertiesLoader

// 颜色名称和颜色值的对应关系字典
static NSDictionary const *COLOR_MAP;

// 静态代码初始化颜色名称和颜色值的对应关系
+ (void) load
{
  COLOR_MAP = [NSDictionary dictionaryWithObjectsAndKeys:
               [UIColor blackColor],      @"black",
               [UIColor darkGrayColor],   @"darkGray",
               [UIColor lightGrayColor],  @"lightGray",
               [UIColor whiteColor],      @"white",
               [UIColor grayColor],       @"gray",
               [UIColor redColor],        @"red",
               [UIColor greenColor],      @"green",
               [UIColor blueColor],       @"blue",
               [UIColor cyanColor],       @"cyan",
               [UIColor yellowColor],     @"yellow",
               [UIColor magentaColor],    @"magenta",
               [UIColor orangeColor],     @"orange",
               [UIColor purpleColor],     @"purple",
               [UIColor brownColor],      @"brown",
               [UIColor clearColor],      @"clear",
               nil];  //初始化颜色名称和颜色对象的字典
  [COLOR_MAP retain];
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree
{
	[COLOR_MAP release];
}

/** 颜色初始化方法
 *
 *  根据传入的颜色字符串初始化对应的颜色
 *  @param colorStr 传入的颜色字符串，传入的颜色字符串支持3种格式：1.颜色名称
 *          颜色的英文名称。2.#+RGB十六进制值 3.RGB十六进制值
 *  @return 返回对应的UIColor实例
 */
+ (UIColor*) initColorWithString: (NSString*) colorStr
                    isBackground: (BOOL) isBackground
{
  if (!colorStr ||
      [[colorStr stringByTrimmingCharactersInSet:
        [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
  {
    return nil;
  }
  
  unsigned int c;
  id tempColor = [COLOR_MAP objectForKey: colorStr];
  if (tempColor)
    return tempColor;
  if ([colorStr characterAtIndex: 0] == '#')
  {
    [[NSScanner scannerWithString:
      [colorStr substringFromIndex: 1]] scanHexInt: &c];
  } else {
    [[NSScanner scannerWithString: colorStr] scanHexInt: &c];
  }
  if (isBackground && c == 0xffffff)
    return [UIColor clearColor];
  return [UIColor colorWithRed: ((c & 0xff0000) >> 16)/255.0 
                         green: ((c & 0xff00) >> 8)/255.0 
                          blue: (c & 0xff)/255.0
                         alpha: 1.0];
}

/** 图片初始化方法
 *
 *  根据传入的图片路径初始化对应的图片对象
 *  @param imageURL 传入的图片路径
 *  @return 返回对应的图片实例
 */
+ (UIImage*) initImageWithString: (NSString*) imageURL
                        defImage: (UIImage*) defImage
                        callback: (SEL) callback
                      compontent: (id) compontent
{
  if (imageURL) {
    if ([imageURL hasPrefix:@"http:"])
    {
      return [AsyncImageLoader loadImageFromStringURL: imageURL
                                         defaultImage: defImage
                                             callback: callback
                                           compontent: compontent];
    } else {
      return [UIImage imageNamed: imageURL];
    }
  }
  return nil;
}

/** 图片初始化方法
 *
 *  根据传入的图片路径初始化对应的图片对象
 *  @param imageURL 传入的图片路径
 *  @return 返回对应的图片实例
 */
+ (UIImage*) initImageWithString: (NSString*) imageURL
                        callback: (SEL) callback
                      compontent: (id) compontent
{
  return [UIPropertiesLoader initImageWithString: imageURL
                                        defImage: [UIImage imageNamed: DEFAULT_PIC_70X70]
                                        callback: callback
                                      compontent: compontent];
}

/** 初始化对齐方式
 *
 *  根据对齐方式值初始化对齐方式
 *  @param align 对齐方式值
 *  @return 返回对齐方式结构体
 */
+ (MarUIAlignStyle) getTextAlignment: (NSString*) align
                textAlign: (MarUIAlignStyle) alignStyle
{
  if (align)
  {
    int iAlign = [align intValue];
    switch (iAlign / 3) {
      case 2:
        alignStyle.vAlign = UIBaselineAdjustmentNone;
        break;
      case 1:
        alignStyle.vAlign = UIBaselineAdjustmentAlignCenters;
        break;
      default:
        alignStyle.vAlign = UIBaselineAdjustmentAlignBaselines;
        break;
    }
    switch (iAlign % 3) {
      case 2:
        alignStyle.hAlign = UITextAlignmentRight;
        break;
      case 1:
        alignStyle.hAlign = UITextAlignmentCenter;
        break;
      default:
        alignStyle.hAlign = UITextAlignmentLeft;
        break;
    }
  }
  return alignStyle;
}

/** 获取垂直方向的对齐方式
 *
 *  根据对齐方式字符串初始化垂直方向上的对齐方式
 *  @param align 对齐方式值
 *  @return 垂直方向上的对齐方式0为向上对齐，1为居中对齐，2为向下对齐
 */
+ (unsigned int) getBaselineAlignment: (NSString*) align
{
  return [align intValue] / 3;
}

/** 根据容器布局允许宽高，xml定义宽高，背景图片宽高，字体，文字内容等生成组件宽高
 *  @param availableSize 容器布局允许宽高
 *  @param xmlDefineSize XML中定义的宽高
 *  @param bgimgSize XML中定义的背景图片宽高
 *  @param backgroundImage 背景图片
 *  @param font 字体
 *  @param content 文字内容
 *  @param compontent 该组件
 *  @param definedSource 宽高定义来源
 */
+ (CGSize) getCompSize: (CGSize) availableSize
            xmlDefSize: (CGSize) xmlDefineSize
             bgimgSize: (CGSize) bgimgSize
                 image: (UIImage*) backgroudImage
                  font: (UIFont*) font
               content: (NSString*) content
            compontent: (MarCompontent*) compontent
     sizeDefinedSource: (MarUIDefaultSizeSource) definedSource
{
  CGSize size = xmlDefineSize;
  CGSize fontDefinedSize;
  CGSize imageDefinedSize;
  fontDefinedSize.width = NULL_NUMBER_VALUE;
  fontDefinedSize.height = NULL_NUMBER_VALUE;
  imageDefinedSize.width = NULL_NUMBER_VALUE;
  imageDefinedSize.height = NULL_NUMBER_VALUE;

  LOG(@"换行文本 : %@", content);
  if (content)
  {
    if ([content isEqualToString: @""])
    {
      content = @"1";
    }
  }
  /** 设置文本换行 */
  UILineBreakMode mode = UILineBreakModeCharacterWrap;
  NSString* temp = [compontent getAttribute: MAR_TAG_ATTR_WRAP];
  if (temp && ([temp isEqualToString: @"no"] || [temp isEqualToString: @"NO"]))
  {
    mode = UILineBreakModeTailTruncation;
  }

  if (size.width == NULL_NUMBER_VALUE)
  {
    if (bgimgSize.width != NULL_NUMBER_VALUE)
    {
      size.width = bgimgSize.width;
      definedSource.widthSource = DefinedByXML;
    } else {
      //对于容器来说，如果没有指定长度，则默认为剩余全部长度
      if ([compontent isContainer])
      {
        size.width = availableSize.width;
        definedSource.widthSource = NoDefined;
      } else {
        //对于组件来说，如果没有指定长度，则计算字体或者背景图片宽度
        if (content)
        {
          if (mode == UILineBreakModeCharacterWrap)
          {
            fontDefinedSize = [content sizeWithFont: font constrainedToSize: CGSizeMake(availableSize.width, MAXFLOAT) lineBreakMode: mode];
            LOG(@"计算换行后 文本显示的范围 : %.2f %.2f", fontDefinedSize.width, fontDefinedSize.height);
          } else {
            fontDefinedSize = [content sizeWithFont: font];
          }
        }
        if (backgroudImage)
        {
          imageDefinedSize = backgroudImage.size;
        }
        if (imageDefinedSize.width > 0 || fontDefinedSize.width > 0)
        {
          if (imageDefinedSize.width > fontDefinedSize.width)
          {
            size.width = imageDefinedSize.width;
            definedSource.widthSource = DefinedByImage;
          } else {
            size.width = fontDefinedSize.width;
            definedSource.widthSource = DefinedByFont;
          }
        } else {
          size.width = availableSize.width;
          definedSource.widthSource = NoDefined;
        }
      }
    }
  }
  if (xmlDefineSize.height == NULL_NUMBER_VALUE)
  {
    if (bgimgSize.height != NULL_NUMBER_VALUE)
    {
      size.height = bgimgSize.height;
      definedSource.heightSource = DefinedByXML;
    } else {
      if (content)
      {
        if (mode == UILineBreakModeCharacterWrap)
        {
          fontDefinedSize = [content sizeWithFont: font constrainedToSize: CGSizeMake(size.width, MAXFLOAT) lineBreakMode: mode];
          LOG(@"计算换行后 文本显示的范围 : %.2f %.2f", fontDefinedSize.width, fontDefinedSize.height);
        } else {
          fontDefinedSize = [content sizeWithFont: font];
        }
      }
      if (backgroudImage)
      {
        imageDefinedSize = backgroudImage.size;
      }
      if (imageDefinedSize.height > 0 || fontDefinedSize.height > 0)
      {
        if (imageDefinedSize.height > fontDefinedSize.height)
        {
          size.height = imageDefinedSize.height;
          definedSource.widthSource = DefinedByImage;
        } else {
          size.height = fontDefinedSize.height;
          definedSource.heightSource = DefinedByFont;
        }
      } else {
        size.height = availableSize.height;
        definedSource.heightSource = NoDefined;
      }
    }
  }
  return size;
}

/** 初始化操作处理器
 *
 *  根据组件参数列表中action属性的内容，初始化操作处理器
 *  @param compontent 组件
 *  @return 该组件中action属性对应的操作处理器
 *  @attention 目前仅支持"page://"开头的跳转操作
 */
+ (FSActionInterface*) newAction: (MarCompontent*) compontent
{
  if (compontent)
  {
    NSString* actionString = [compontent getAttribute: MAR_TAG_ATTR_ACTION];
    if (actionString)
    {
      FSActionInterface* action = [FSActionInterface newAction: compontent
                                                  actionString: actionString];
      return action;
    }
  }
  return nil;
}

/** 构造CGSize
 *
 *  根据传入的宽高构造CGSize
 *  @param width 宽度
 *  @param height 高度
 *  @return 构造好的CGSize
 */
+ (CGSize) getSizeWithWidth: (NSString*) width
                     height: (NSString*) height
{
  CGFloat fWidth = NULL_NUMBER_VALUE;
  CGFloat fHeight = NULL_NUMBER_VALUE;
  if (width)
    fWidth = [width floatValue];
  if (height)
    fHeight = [height floatValue];
  return CGSizeMake(fWidth, fHeight);
}

+ (CGRect) getNewRect: (const CGRect) orgRect
           compontent: (MarCompontent*) compontent
        attributeName: (NSString*) name
       attributeValue: (NSString*) value
{
  CGRect newRect = CGRectMake(orgRect.origin.x, orgRect.origin.y, orgRect.size.width, orgRect.size.height);
  if ([name isEqualToString:MAR_TAG_ATTR_X])
  {
    newRect.origin.x = [value floatValue];
    compontent.compX = newRect.origin.x;
  }
  else if ([name isEqualToString:MAR_TAG_ATTR_Y]) {
    newRect.origin.y = [value floatValue];
    compontent.compY = newRect.origin.y;
  }
  else if ([name isEqualToString:MAR_TAG_ATTR_WIDTH]) {
    newRect.size.width = [value floatValue];
    compontent.compWidth = newRect.size.width;
  }
  else if ([name isEqualToString:MAR_TAG_ATTR_HEIGHT]) {
    newRect.size.height = [value floatValue];
    compontent.compHeight = newRect.size.height;
  }
  return newRect;
}

/** 获取换行方式 */
+ (UILineBreakMode) getLineBreakMode: (MarCompontent*) compontent
{
  /** 设置文本换行 */
  NSString* temp = [compontent.propertiesMap objectForKey: MAR_TAG_ATTR_WRAP];
  if (temp && ([temp isEqualToString: @"no"] || [temp isEqualToString: @"NO"]))
  {
    return UILineBreakModeTailTruncation;
  } else {
    return UILineBreakModeCharacterWrap;
  }
}

@end