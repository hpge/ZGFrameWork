///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file CompontentParser.h
/// @brief XML解析头文件
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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIComponent.h"
#import "XMLDataParser.h"
#import "XMLNode.h"

/** CompontentParser类负责从XML中解析元数据格式
 *
 *  从xml中解析数据建立树形存储结构，
 *  根据树形结点创建对应的组件
 */ 

@interface CompontentParser : NSObject {
@public
@private
    /** 树形结构根结点 */
    XMLNode*          rootNode;
    /** 树形结构当前结点 */
    XMLNode*          currentNode;
    /** 根结点 */
    ZGContainer*    com_rootNode;
    /** 当前结点的父结点 */
    ZGComponent*    com_parentNode;
    /** 当前结点 */
    ZGComponent*    com_currentNode;
    /** 当前节点内容信息 */
    NSMutableString*  nodeContent;   
    /** 当前展示容器 */
    ZGContainer*     currShowContainer;
    /** 当前应用窗口 */
    UIWindow*         currShowWindow;     
    /** 跳过当前标签解析，用于没有找到该标签对应类 */
    BOOL              skipCurrentTag;     
}

/** 树形结构根结点 */
@property (nonatomic, retain) XMLNode*          rootNode;
/** 树形结构当前结点 */
@property (nonatomic, retain) XMLNode*          currentNode;
/** 根结点 */
@property (nonatomic, retain) ZGContainer*    com_rootNode;
/** 当前结点的父结点 */
@property (nonatomic, retain) ZGComponent*    com_parentNode;
/** 当前结点 */
@property (nonatomic, retain) ZGComponent*    com_currentNode;
/** 当前节点内容信息 */
@property (nonatomic, assign) NSMutableString*  nodeContent;
/** 当前展示容器 */
@property (nonatomic, retain) ZGContainer*     currShowContainer;
/** 当前应用窗口 */
@property (nonatomic, retain) UIWindow*         currShowWindow;

/** 初始化标签名和类名对应字典
 *
 *  根据xml中标签名称保存对应类名
 */
+ (void) load;

/** 单例模式，获取CompontentParser单例
 *
 *  @return xml单例
 */
+ (CompontentParser*) getInstance;

- (id) initWithCompontentParser: (CompontentParser*) parser;

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;

//- (void) parserDidElement: (XMLNode*) tree_rootNode;

/** 根据标签名称初始化组件对象
 *
 *  @param tagName 标签名称
 *  @return 标签名称对应的组件类实例
 */
- (ZGComponent*) newComponentByTagXml: (NSString*) tagName;

/** 进行xml数据解析，建立树形结构
 *
 *  获取数据，设置属性并解析xml
 *  @param xmlData 要解析的xml数据
 *  @return 解析后树形结构的根结点
 */
- (ZGComponent*) doXMLParser: (NSData*) xmlData;


/** 开始解析文件，遇到一个元素开始标记
 *
 *  当遇到开始标记时，进入此句
 *  @param parser 解析对象
 *  @param elementName 元素的名称，在这开始标记
 *  @param namespaceURI 如果命名空间处理是打开的，包含当前的命名空间作为一个字符串对象的URI
 *  @param qName 如果命名空间处理是打开的，包含作为一个String对象的当前的命名空间限定名称
 *  @param attributeDict 一个字典，其中包含与元素相关联的任何属性。键属性的名称和值的属性值
 */
- (void) parser:(NSXMLParser*) parser
didStartElement:(NSString*) elementName
  qualifiedName:(NSString*) qName
     attributes:(NSDictionary*) attributeDict;

/** 当遇到一个元素的结束标记时发送委托
 *
 *  当遇到结束标记时，进入此句
 *  @param parser 解析对象
 *  @param elementName 元素的名称，在其结束标记
 *  @param namespaceURI 如果命名空间处理是打开的，包含当前的命名空间作为一个字符串对象的URI
 *  @param qName 如果命名空间处理是打开的，包含作为一个String对象的当前的命名空间限定名称
 */
- (void) parser:(NSXMLParser*) parser
  didEndElement:(NSString*) elementName
    nodeContent:(NSString*) content;


/** 输出标签对应的组件信息
 *
 *  @param compontent 准备输出信息的组件对应的结点
 *  @param recursion 递归次数
 */
- (void) outPutCompontent:(ZGComponent *) compontent
                recursion:(int) recursion;

/** 输出标签信息
 *
 */
- (void) outPutCompontent;

@end

@interface SkipCompontent : ZGLayout
{
}
@end