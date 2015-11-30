///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2015，（版权声明）
/// All rights reserved
///
/// @file   ZGUIConstants.h
/// @brief  常量定义类
///
/// 该类用于定义系统中并在各个组件处理中同时使用的常量
///
/// @version    0.0.1
/// @date       2015.11.26
/// @Created by gehaipeng on 15/11/26.
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 组件属性列表：组件宽度 */
#define MAR_TAG_ATTR_WIDTH            @"width"
/** 组件属性列表：组件高度 */
#define MAR_TAG_ATTR_HEIGHT           @"height"
/** 组件属性列表：组件名称 */
#define MAR_TAG_ATTR_NAME             @"name"
/** 组件属性列表：组件ID */
#define MAR_TAG_ATTR_ID               @"id"
/** 组件属性列表：组件类型 */
#define MAR_TAG_ATTR_TYPE             @"type"
/** 组件属性列表：组件横向偏移 */
#define MAR_TAG_ATTR_X                @"x"
/** 组件属性列表：组件纵向偏移 */
#define MAR_TAG_ATTR_Y                @"y"
/** 组件属性列表：组件横向间隔 */
#define MAR_TAG_ATTR_HMARGIN          @"hmargin"
/** 组件属性列表：组件纵向间隔 */
#define MAR_TAG_ATTR_VMARGIN          @"vmargin"
/** 组件属性列表：组件字体颜色 */
#define MAR_TAG_ATTR_FONT_COLOR       @"fontcolor"
/** 组件属性列表：组件内容颜色 */
#define MAR_TAG_ATTR_FONT_SIZE        @"size"
/** 组件属性列表：组件字体大小 */
#define MAR_TAG_ATTR_FONT_SIZE1       @"fontsize"
/** 组件属性列表：组件背景颜色 */
#define MAR_TAG_ATTR_BACK_COLOR       @"bgcolor"
/** 组件属性列表：组件背景图片 */
#define MAR_TAG_ATTR_BACK_IMAGE       @"bgimg"
/** 组件属性列表：组件被选中的图片 */
#define MAR_TAG_ATTR_SELECT_IMAGE     @"selectedImg"
/** 组件属性列表：组件背景图片宽度 */
#define MAR_TAG_ATTR_BGIMG_WIDTH      @"bgimgwidth"
/** 组件属性列表：组件背景图片高度 */
#define MAR_TAG_ATTR_BGIMG_HEIGHT     @"bgimgheight"
/** 组件属性列表：组件点击后的动作 */
#define MAR_TAG_ATTR_ACTION           @"action"
/** 组件属性列表：跳转时被刷新部分名称 */
#define MAR_TAG_ATTR_TARGET           @"target"
/** 组件属性列表：组件对齐方式 */
#define MAR_TAG_ATTR_ALIGN            @"align"
/** 组件属性列表：组件是否换行 */
#define MAR_TAG_ATTR_WRAP             @"wrap"
/** 组件属性列表：组件提示信息 */
#define MAR_TAG_ATTR_HINT             @"hint"
/** 组件属性列表：组件布局方式 */
#define MAR_TAG_ATTR_FORM             @"form"
/** 组件属性列表：背景图片对齐模式 */
#define MAR_TAG_ATTR_BGALIGN          @"bgalign"
/** 组件属性列表：背景图片绘制模式 */
#define MAR_TAG_ATTR_BGTYPE           @"bgtype"
/** 组件属性列表：是否有滚动条 */
#define MAR_TAG_ATTR_SCROLL           @"scroll"

#define MAR_TAG_ATTR_VALUE            @"value"

/** 默认属性：指定输入框是否加密的类型值 */
#define MAR_TAG_ATTR_TYPE_SECURETEXT  @"3"
/** 默认属性：space控件的默认高度 */
#define MAR_TAG_ATTR_SPACE_DEF_HEIGHT @"10"
/** 默认属性：button组件字体大小 */
#define MAR_DEFAULT_BUTTON_FONT_SIZE  15
/** 默认属性：文字类组件自动计算高度时的默认文字
 (当该类组件中没有文字时使用)
 */
#define MAR_DEFAULT_TEST_TEXT         @"text"

/** 组件属性列表：绘制时的横向偏移 */
#define MAR_COMPONTENT_DRAW_X                @"DrawX"
/** 组件属性列表：绘制时的纵向偏移 */
#define MAR_COMPONTENT_DRAW_Y                @"DrawY"
/** 组件属性列表：绘制范围 */
#define MAR_COMPONTENT_DRAW_RECT             @"DrawRect"
/** 组件属性列表：绘制范围 */
#define MAR_NAVIGATOR_DRAW_RECT              @"NavigatorRect"

/** 默认值部分 */
// 空字符串
#define NULL_STRING_VALUE @""
// 空数字
#define NULL_NUMBER_VALUE -99
// 默认日期格式
#define DEFAULT_DATE_FORMAT @"yyyy-MM-dd"
#define DEFAULT_PIC_70X70 @"pic70x70.png"
#define DEFAULT_PIC_220X190 @"pic220x190.png"
#define DEFAULT_PIC_300X190 @"pic300x190.png"

enum {
    NoDefined = 0,
    DefinedByFont,
    DefinedByImage,
    DefinedByXML,
    DefinedByConstant,
};
typedef NSUInteger SizeDefineSource;

/** 界面元素组件对齐方式
 *
 *  该结构用于表示界面元素组件对齐方式，包括水平对齐和垂直对齐两个变量
 */
struct MarUIAlignStyle
{
    /** 水平对齐 */
    NSTextAlignment hAlign;
    /** 垂直对齐 */
    UIBaselineAdjustment vAlign;
};
// 定义结构体名称
typedef struct MarUIAlignStyle MarUIAlignStyle;

/**
 * 默认宽度或者高度的来源
 */
struct MarUIDefaultSizeSource
{
    /** 宽度来源 */
    SizeDefineSource widthSource;
    /** 高度来源 */
    SizeDefineSource heightSource;
};
typedef struct MarUIDefaultSizeSource MarUIDefaultSizeSource;