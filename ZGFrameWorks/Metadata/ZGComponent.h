//
//  ZGComponent.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/26.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//
#import "ZGUIConstants.h"
@class ZGContainer;
@interface ZGComponent : UIViewController
{
    /** XML标签内容 */
    NSString* content;
    /** 标签ID */
    NSString* ID;
    /** 标签名称 */
    NSString* name;
    /** XML中定义的标签名称 */
    NSString* XMLNodeName;
    /** 父标签 */
    ZGContainer* parent;
    /** 根标签 */
    ZGContainer* rootNode;
//    /** 属性表 */
    NSMutableDictionary* propertiesMap;
    /** 是否能够成为局部刷新的对象 */
    BOOL isFrameSet;
    /** 是否为水平布局 */
    BOOL isHorizontal;
    /** 绑定的操作处理器列表 */
    NSMutableArray* actionList;
    /** 目前绘制范围 */
    CGRect drawFrame;
    /** 组件宽度 */
    CGFloat compWidth;
    /** 组件高度 */
    CGFloat compHeight;
    /** 组件横向偏移 */
    CGFloat compX;
    /** 组件纵向偏移 */
    CGFloat compY;
    /** 组件宽度 */
    CGFloat bgWidth;
    /** 组件高度 */
    CGFloat bgHeight;
    // 文字对齐方式
    MarUIAlignStyle alignStyle;
    /** 默认值来源 */
    MarUIDefaultSizeSource defaultSizeSource;
    /** 背景图片 */
    UIImage* backGroundImage;
    /** 背景颜色 */
    UIColor* backGroundColor;
    /** 是否已经添加到容器 */
    BOOL isAddedToParent;
    /** 按钮上的字体大小 */
    int fontSize;
}

#pragma mark -
#pragma mark properties

/** XML标签内容 */
@property (strong, nonatomic) NSString* content;
/** 标签ID */
@property (strong, nonatomic) NSString* ID;
/** 标签名称 */
@property (strong, nonatomic) NSString* name;
/** XML中标签名称 */
@property (strong, nonatomic) NSString* XMLNodeName;
/** 父标签 */
@property (assign, nonatomic) ZGContainer* parent;
/** 根标签 */
@property (assign, nonatomic) ZGContainer* rootNode;
/** 属性表 */
@property (nonatomic, readonly) NSMutableDictionary* propertiesMap;
/** 是否能够成为局部刷新的对象 */
@property (assign, nonatomic, readonly, getter=isFrameSet) BOOL isFrameSet;
/** 是否为水平布局 */
@property (assign, nonatomic, getter=isHorizontal) BOOL isHorizontal;
/** 目前绘制范围 */
@property (assign, readonly, nonatomic) CGRect drawFrame;
/** 组件宽度 */
@property (nonatomic) CGFloat compWidth;
/** 组件高度 */
@property (nonatomic) CGFloat compHeight;
/** 组件横向偏移 */
@property (nonatomic) CGFloat compX;
/** 组件纵向偏移 */
@property (nonatomic) CGFloat compY;
/** 组件宽度 */
@property (nonatomic) CGFloat bgWidth;
/** 组件高度 */
@property (nonatomic) CGFloat bgHeight;
/** 背景图片 */
@property (retain, nonatomic) UIImage* backGroundImage;
/** 背景颜色 */
@property (retain, nonatomic) UIColor* backGroundColor;
// 文字对齐方式
@property (nonatomic) MarUIAlignStyle alignStyle;
// 文字对齐方式
@property (nonatomic) int fontSize;
#pragma mark -
#pragma mark init & dealloc methods

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
                  parentContainer: (ZGContainer*) parentContainer;

/** 标签属性初始化方法
 *
 *  在XML解析器完成loadFromXMLTag和setContent方法后，进行初始化的方法
 *  @attention 该方法被用于实现各个子类的初始化工作
 */
- (void) specInit;

#pragma mark -
#pragma mark get & set attribute methods

/** 获取属性
 *
 *  根据属性名称获取属性列表中的属性
 *  @param attributeName 标签名称
 *  @return 返回标签属性字符串
 */
- (NSString*) getAttribute:(NSString*) attributeName;

/** 获取属性值数组
 *
 *  获取全部属性值
 *  @return 获取属性值数组
 */
- (NSArray*) getAttribute;

/** 设置属性值
 *
 *  根据属性名设置相应属性的值
 *  @param attributeName 欲设置属性值的属性名称
 *  @param value 属性值
 */
- (void) setAttributeByName: (NSString*) attributeName
              attributeVale: (id) value;

/** 更改组件的属性信息
 *
 *  该方法将控件值增加在属性值列表中，子类需要实现各自的方法将控件属性的变化反应至展示控件中
 *  @param attributeName 属性名称
 *  @param value 属性值
 */
- (void) setWidgetAttributeName: (NSString*) attributeName
                  AttributeVale: (NSString*) value;

/** 增加属性值
 *
 *  设置传入的属性值列表
 *  @param dict 属性值列表
 */
- (void) addAttributeWithDictionary: (NSDictionary*) dict;

/** 获取组件信息
 *
 *  该方法将获取控件值并将其返回，如果为输入框则返回输入值，单选框返回选择的值，radio button返回
 *  是否选中，单选框组返回选中列表，用逗号分隔
 */
- (NSString*) getWidgetValue;


/** 设置组件信息
 *
 */
- (void) setWidgetValue: (NSString*) value;

/** 异步方法返回修改background
 */
- (void) backgroundFinishLoaded: (UIImage*) image;

#pragma mark -
#pragma mark compontent's manage methods

/** 判断是否在指定类的容器中
 *
 *  递归判断是否在指定的容器类中
 *  @param containerClass 容器类
 *  @return 该组件是否在该类容器中
 */
- (BOOL) isInContainerClass: (Class) containerClass;

/** 该组件从容器中移除后处理方法
 *
 *  该组件从父容器中移除后的处理方法
 */
- (void) removedFromContainer;

/** 组件重置方法
 *
 *  组件重置方法用于容器部分重绘，在容器重绘之前，重置组件相关参数，并由容器重新
 *  按照组件当前属性进行绘制。如果子类有部分没有在specInit中实现初始化的参数，
 *  应重写该方法，并在该方法中实现参数的初始化
 */
- (void) reset;

/** 返回该组件是否为容器
 */
- (BOOL) isContainer;

#pragma mark -
#pragma mark get draw rect & draw methods

/** 初步计算组件的大小和各个元素绘制范围的方法
 *
 *  由布局管理器调用，传入默认绘制大小，以及计算百分比表达式的高度以及宽度
 *  各个组件负责计算自己宽度和高度，同时计算最合适的绘制范围，并返回给布局
 *  管理器，方法中availableSize和maxSize均不可修改。
 *  @param availableSize 容器计算的目前默认宽度和高度
 *  @param maxSize 用于计算百分比的宽度和高度
 *  @return 最合适的绘制大小，其中需要包括组件宽高和相应的偏移量
 */
- (CGSize) calculateFitableSize: (const CGSize) xmlDefineSize
                     remainSize: (const CGSize) remainSize
                 maxSeeableSize: (const CGSize) maxSeeableSize
                percentBaseSize: (const CGSize) percentBaseSize
                    inContainer: (ZGContainer*) container;

/** 初步计算组件的大小和各个元素绘制范围的方法(外部调用部分)
 *
 *  所有的子组件应复写calculateFitableSize:maxSize:inContainer:
 *  而非本方法，本方法会在布局解析的过程中调用上述方法，获取子类自定义的绘
 *  制范围计算部分
 *  @param
 *  @param maxSeeableSize 当前容器剩余可视大小
 *  @param percentBaseSize 用于计算百分比的宽度和高度基数
 *  @return 最合适的绘制大小，其中需要包括组件宽高和相应的偏移量
 */
- (CGSize) getFitableSize: (const CGSize) remainSize
           maxSeeableSize: (const CGSize) maxSeeableSize
          percentBaseSize: (const CGSize) percentBaseSize
              inContainer: (ZGContainer*) container;

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
                            WithRect: (CGRect) drawRect;


@end
