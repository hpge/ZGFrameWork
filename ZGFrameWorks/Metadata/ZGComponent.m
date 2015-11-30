//
//  ZGComponent.m
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/26.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import "ZGComponent.h"
#import "ExpressionUtil.h"
#import "UIPropertiesLoader.h"
@interface ZGComponent ()

@end

@implementation ZGComponent


#pragma mark -
#pragma mark properties

/** XML标签内容 */
@synthesize content;
/** 标签ID */
@synthesize ID;
/** 标签名称 */
@synthesize name;
/** 父标签 */
@synthesize parent;
/** 根标签 */
@synthesize rootNode;
/** 属性表 */
@synthesize propertiesMap;
/** 是否能够成为局部刷新的对象 */
@synthesize isFrameSet;
/** 目前绘制范围 */
@synthesize drawFrame;
/** 是否为水平布局 */
@synthesize isHorizontal;
/** 组件宽度 */
@synthesize compWidth;
/** 组件高度 */
@synthesize compHeight;
/** 组件横向偏移 */
@synthesize compX;
/** 组件纵向偏移 */
@synthesize compY;
/** 背景图片 */
@synthesize backGroundImage;
/** 背景颜色 */
@synthesize backGroundColor;
/** 组件宽度 */
@synthesize bgWidth;
/** 组件高度 */
@synthesize bgHeight;
/** XML标签名称 */
@synthesize XMLNodeName;
/** 文字对齐方式 */
@synthesize alignStyle;
@synthesize fontSize;

#pragma mark -
#pragma mark init & dealloc methods

/**
 * 初始化参数
 */
- (id) init
{
    if (self = [super init])
    {
        //初始化相关参数
        content = nil;
        ID = nil;
        name = nil;
        parent = nil;
        rootNode = nil;
        isFrameSet = NO;
        isHorizontal = YES;
        actionList = [[NSMutableArray alloc] initWithCapacity: 3];;
        defaultSizeSource.widthSource = NoDefined;
        defaultSizeSource.heightSource = NoDefined;
        propertiesMap = [[NSMutableDictionary alloc] initWithCapacity: 3];
        compWidth = NULL_NUMBER_VALUE;
        compHeight = NULL_NUMBER_VALUE;
        compX = 0;
        compY = 0;
        bgWidth = NULL_NUMBER_VALUE;
        bgHeight = NULL_NUMBER_VALUE;
        backGroundImage = nil;
        backGroundColor = nil;
        alignStyle.vAlign = UIBaselineAdjustmentNone;
        alignStyle.hAlign = NSTextAlignmentLeft;
        fontSize = 0;
    }
    return self;
}

/** 析构函数
 *
 *  析构函数，释放组件内部属性
 */
- (void) dealloc
{
    
}

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
- (ZGContainer*) loadFromXMLTag: (NSString*) tagName
                       attributes: (NSDictionary*) attributeDict
                  parentContainer: (ZGContainer*) parentContainer
{
    // 为不变参数赋值，此类参数在计算组件过程中不发生变化
    self.parent = parentContainer;
    self.rootNode = (parentContainer == nil) ? nil : parentContainer.rootNode;
    // 初始化组件ID
    NSString* temp = [attributeDict objectForKey: MAR_TAG_ATTR_ID];
    if (temp)
    {
        self.ID = temp;
    } else {
//        self.ID = [NSString stringWithFormat: @"%@%@", tagName, [TimeUtil stringWithDateFormat: @"HH:mm:sss"]];
    }
    
    // 为name赋值
    temp = [attributeDict objectForKey: MAR_TAG_ATTR_NAME];
    if (temp) {
        self.name = temp;
    } else {
        self.name = ID;
    }
    
    NSString* combinedID = [NSString stringWithFormat: @"%@.%@", self.rootNode.ID, ID];
//    NSDictionary* dict = [[CssManager getInstance] getCompontentCss: tagName combinedID: combinedID];
    if (dict && [dict count])
    {
        [propertiesMap addEntriesFromDictionary: dict];
    }
    // 保存初始化的参数列表，该参数列表可以在后面修改，并在repaint方法中生效，所以参数列表不在specInit方法中重置
    [propertiesMap addEntriesFromDictionary: attributeDict];
    isAddedToParent = NO;
    return self;
}

/** 标签属性初始化方法
 *
 *  在XML解析器完成loadFromXMLTag和setContent方法后，进行初始化的方法
 *  @attention 该方法被用于实现各个子类的初始化工作
 */
- (void) specInit
{
    [actionList removeAllObjects];
    alignStyle = [UIPropertiesLoader getTextAlignment: [propertiesMap objectForKey: MAR_TAG_ATTR_ALIGN]
                                            textAlign: alignStyle];
    NSString* temp = [propertiesMap objectForKey: MAR_TAG_ATTR_FONT_SIZE];
    if (!temp)
    {
        temp = [propertiesMap objectForKey: MAR_TAG_ATTR_FONT_SIZE1];
        if (temp)
            [propertiesMap setObject: temp
                              forKey: MAR_TAG_ATTR_FONT_SIZE];
    }
    /** 字体设置大小 */
    fontSize = [[propertiesMap objectForKey: MAR_TAG_ATTR_FONT_SIZE] intValue];
    if (fontSize == 0)
    {
        fontSize = MAR_DEFAULT_BUTTON_FONT_SIZE;
    }
    temp = [propertiesMap objectForKey: MAR_TAG_ATTR_FORM];
    if (temp)
    {
        self.isHorizontal = ![temp isEqualToString: @"ver"];
    }
    temp = [propertiesMap objectForKey: MAR_TAG_ATTR_BACK_IMAGE];
    if (temp)
    {
        self.backGroundImage = [UIPropertiesLoader initImageWithString: temp
                                                              callback: @selector(backgroundFinishLoaded:)
                                                            compontent: self];
    }
    temp = [propertiesMap objectForKey: MAR_TAG_ATTR_BACK_COLOR];
    if (temp)
    {
        self.backGroundColor = [UIPropertiesLoader initColorWithString: temp
                                                          isBackground: YES];
    }
}

#pragma mark -
#pragma mark get & set attribute methods

/** 获取属性
 *
 *  根据属性名称获取属性列表中的属性
 *  @param attributeName 标签名称
 *  @return 返回标签属性字符串
 */
- (NSString*) getAttribute:(NSString*) attributeName
{
    return [self.propertiesMap objectForKey:attributeName];
}

/** 获取属性值数组
 *
 *  获取全部属性值
 *  @return 获取属性值数组
 */
- (NSArray*) getAttribute
{
    return [self.propertiesMap allValues];
}

/** 设置属性值
 *
 *  根据属性名设置相应属性的值
 *  @param attributeName 欲设置属性值的属性名称
 *  @param value 属性值
 */
- (void) setAttributeByName: (NSString*) attributeName
              attributeVale: (id) value
{
    if (value != nil && attributeName != nil)
    {
        if ([attributeName isEqualToString: MAR_TAG_ATTR_VALUE])
        {
            [self setWidgetValue: value];
        } else {
            [propertiesMap setObject: value forKey: attributeName];
        }
    }
}

/** 更改组件的属性信息
 *
 *  该方法将控件值增加在属性值列表中，子类需要实现各自的方法将控件属性的变化反应至展示控件中
 *  @param attributeName 属性名称
 *  @param value 属性值
 */
- (void) setWidgetAttributeName: (NSString*) attributeName
                  AttributeVale: (NSString*) value
{
    [self setAttributeByName: attributeName
               attributeVale: value];
}

/** 增加属性值
 *
 *  设置传入的属性值列表
 *  @param dict 属性值列表
 */
- (void) addAttributeWithDictionary: (NSDictionary*) dict
{
    [propertiesMap addEntriesFromDictionary: dict];
}

/** 获取组件信息
 *
 *  该方法将获取控件值并将其返回，如果为输入框则返回输入值，单选框返回选择的值，radio button返回
 *  是否选中，单选框组返回选中列表，用逗号分隔
 */
- (NSString*) getWidgetValue
{
    return nil;
}

/** 获取组件信息
 *
 *  该方法将获取控件值并将其返回，如果为输入框则返回输入值，单选框返回选择的值，radio button返回
 *  是否选中，单选框组返回选中列表，用逗号分隔
 */
- (void) setWidgetValue: (NSString*) value
{
}

/** 异步方法返回修改background
 */
- (void) backgroundFinishLoaded: (UIImage*) image
{
    self.backGroundImage = image;
}

#pragma mark -
#pragma mark compontent's manage methods

/** 判断是否在指定类的容器中
 *
 *  递归判断是否在指定的容器类中
 *  @param containerClass 容器类
 *  @return 该组件是否在该类容器中
 */
- (BOOL) isInContainerClass: (Class) containerClass
{
    ZGComponent* checkContainer = self.parent;
    while (checkContainer)
    {
        if ([checkContainer isKindOfClass: containerClass])
        {
            break;
        } else {
            checkContainer = checkContainer.parent;
        }
    }
    return checkContainer != nil;
}

/** 该组件从容器中移除后处理方法
 *
 *  该组件从父容器中移除后的处理方法
 */
- (void) removedFromContainer
{
    [self.view removeFromSuperview];
}

/** 组件重置方法
 *
 *  组件重置方法用于容器部分重绘，在容器重绘之前，重置组件相关参数，并由容器重新
 *  按照组件当前属性进行绘制。如果子类有部分没有在specInit中实现初始化的参数，
 *  应重写该方法，并在该方法中实现参数的初始化
 */
- (void) reset
{
    [self specInit];
}

/** 返回该组件是否为容器
 */
- (BOOL) isContainer
{
    return NO;
}

#pragma mark -
#pragma mark get draw rect & draw methods

/** 初步计算组件的大小和各个元素绘制范围的方法
 *
 *  由布局管理器调用，传入默认绘制大小，以及计算百分比表达式的高度以及宽度
 *  各个组件负责计算自己宽度和高度，同时计算最合适的绘制范围，并返回给布局
 *  管理器，方法中availableSize和maxSize均不可修改。
 *  此方法不应被手动调用，该方法会在组件计算大小过程中自动调用
 *  @param availableSize 容器计算的目前默认宽度和高度
 *  @param maxSize 用于计算百分比的宽度和高度
 *  @return 最合适的绘制大小，其中需要包括组件宽高和相应的偏移量
 */
- (CGSize) calculateFitableSize: (const CGSize) xmlDefineSize
                     remainSize: (const CGSize) remainSize
                 maxSeeableSize: (const CGSize) maxSeeableSize
                percentBaseSize: (const CGSize) percentBaseSize
                    inContainer: (ZGContainer*) container
{
    return xmlDefineSize;
}

/** 初步计算组件的大小和各个元素绘制范围的方法(外部调用部分)
 *
 *  所有的子组件应复写calculateFitableSize:maxSize:inContainer:
 *  而非本方法，本方法会在布局解析的过程中调用上述方法，获取子类自定义的绘
 *  制范围计算部分
 *  @param availableSize 容器计算的目前默认宽度和高度
 *  @param maxSize 用于计算百分比的宽度和高度
 *  @return 最合适的绘制大小，其中需要包括组件宽高和相应的偏移量
 */
- (CGSize) getFitableSize: (const CGSize) remainSize
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
    
    CGSize drawSize = [self calculateFitableSize: CGSizeMake(compWidth, compHeight)
                                      remainSize: remainSize
                                  maxSeeableSize: maxSeeableSize
                                 percentBaseSize: percentBaseSize
                                     inContainer: container];
    
    return CGSizeMake(compX + drawSize.width, compY + drawSize.height);
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
    drawRect.size.width -= compX;
    drawRect.size.height -= compY;
    drawRect.origin.x += compX;
    drawRect.origin.y += compY;
    self.compWidth = drawRect.size.width;
    self.compHeight = drawRect.size.height;
    LOG(@"%@ frame : %.2f, %.2f, %.2f, %.2f", name, drawRect.origin.x,
        drawRect.origin.y, drawRect.size.width, drawRect.size.height);
    
    return drawRect;
}

@end
