///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarFrame.m
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

@implementation ZGFrame

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
  isFrameSet = TRUE;
  return self;
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
}    

@end
