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

//#import "UICompontent.h"
#import "FSActionInterface.h"

/** 界面展示组件参数初始化工具类
 *
 *  界面展示组件参数初始化工具类，负责提供各个页面展示组件参数的初始化方法
 */
@interface UIPropertiesLoader : NSObject {
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;

/** 颜色初始化方法
 *
 *  根据传入的颜色字符串初始化对应的颜色
 *  @param colorStr 传入的颜色字符串，传入的颜色字符串支持3种格式：1.颜色名称
 *          颜色的英文名称。2.#+RGB十六进制值 3.RGB十六进制值
 *  @return 返回对应的UIColor实例
 */
+ (UIColor*) initColorWithString: (NSString*) colorStr
                    isBackground: (BOOL) isBackground;

/** 图片初始化方法
 *
 *  根据传入的图片路径初始化对应的图片对象
 *  @param imageURL 传入的图片路径
 *  @return 返回对应的图片实例
 */
+ (UIImage*) initImageWithString: (NSString*) imageURL
                        callback: (SEL) callback
                      compontent: (id) compontent;

/** 图片初始化方法
 *
 *  根据传入的图片路径初始化对应的图片对象
 *  @param imageURL 传入的图片路径
 *  @return 返回对应的图片实例
 */
+ (UIImage*) initImageWithString: (NSString*) imageURL
                        defImage: (UIImage*) defImage
                        callback: (SEL) callback
                      compontent: (id) compontent;

/** 初始化对齐方式
 *
 *  根据对齐方式值初始化对齐方式
 *  @param align 对齐方式值
 *  @return 返回对齐方式结构体
 */
+ (MarUIAlignStyle) getTextAlignment: (NSString*) align
                textAlign: (MarUIAlignStyle) alignStyle;

/** 获取垂直方向的对齐方式
 *
 *  根据对齐方式字符串初始化垂直方向上的对齐方式
 *  @param align 对齐方式值
 *  @return 垂直方向上的对齐方式0为向上对齐，1为居中对齐，2为向下对齐
 */
+ (unsigned int) getBaselineAlignment: (NSString*) align;

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
            compontent: (ZGComponent*) compontent
     sizeDefinedSource: (MarUIDefaultSizeSource) definedSource;

/** 初始化操作处理器
 *
 *  根据组件参数列表中action属性的内容，初始化操作处理器
 *  @param compontent 组件
 *  @return 该组件中action属性对应的操作处理器
 */
+ (FSActionInterface*) newAction: (ZGComponent*) compontent;

/** 构造CGSize
 *
 *  根据传入的宽高构造CGSize
 *  @param width 宽度
 *  @param height 高度
 *  @return 构造好的CGSize
 */
+ (CGSize) getSizeWithWidth: (NSString*) width
                     height: (NSString*) height;

+ (CGRect) getNewRect: (const CGRect) orgRect
           compontent: (ZGComponent*) compontent
        attributeName: (NSString*) name
       attributeValue: (NSString*) value;

/** 获取换行方式 */
+ (UILineBreakMode) getLineBreakMode: (ZGComponent*) compontent;

@end