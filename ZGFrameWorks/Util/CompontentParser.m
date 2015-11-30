///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file CompontentParser.m
/// @brief XML解析文件
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

#import "CompontentParser.h"
#import "FileUtils.h"

@implementation CompontentParser

/** 标签名称和组件类对应字典 */
static NSDictionary* COMPONTENT_CLASS_MAP;  
static CompontentParser* instance;

/** 树形结构根结点 */
@synthesize rootNode;
/** 树形结构当前结点 */
@synthesize currentNode;
/** 根结点 */
@synthesize com_rootNode;
/** 当前结点的父结点 */
@synthesize com_parentNode;
/** 当前结点 */
@synthesize com_currentNode;
/** 当前节点内容信息 */
@synthesize nodeContent;
/** 当前展示容器 */
@synthesize currShowContainer;
/** 当前应用窗口 */
@synthesize currShowWindow;

/** 初始化标签名和类名对应字典
 *
 *  根据xml中标签名称保存对应类名
 */
+ (void) load
{
  instance = nil;
  COMPONTENT_CLASS_MAP = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"MarFCScript", @"fcscript",
                          @"MarButton", @"button",
                          @"MarImage", @"image",
                          @"MarLink", @"link",
                          @"MarOptions",@"option",
                          @"MarOptions",@"combobox",
                          @"MarSelect", @"select",
                          @"MarTextField", @"input",
                          @"MarFrame", @"frame",
                          @"MarInclude", @"include",
                          @"MarLayout", @"layout",
                          @"MarPage", @"page",
                          @"MarLabel", @"text",
                          @"MarSpace", @"space",
                          @"MarImageLink", @"imagelink",
                          @"MarToolBar", @"toolbar",
                          @"MarPhoneText", @"phonetext",
                          @"MarTitle", @"title",
                          @"MarTextArea", @"textarea",
                          @"MarUserCalendar", @"usercalendar",
                          @"MarMenu", @"bottom",
                          @"MarCheckBox", @"checkboxitem",
                          @"MarMenu", @"menu",
                          @"MarCheckBoxGroup", @"checkboxgroup",
                          nil];  //初始化标签名和类名对应字典
  [COMPONTENT_CLASS_MAP retain];
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree
{
	[COMPONTENT_CLASS_MAP release];
    [instance release];
}

/** 单例模式，获取CompontentParser单例
 *
 *  @return xml单例
 */
+ (CompontentParser*) getInstance
{
  if (!instance) {
    instance = [[CompontentParser alloc] init];
  }
  return instance;
}

- (id) initWithCompontentParser: (CompontentParser*) parser
{
  if (self = [self init])
  {
    if (parser)
    {
      self.rootNode = parser.rootNode;
      self.currentNode = parser.currentNode;
      self.com_rootNode = parser.com_rootNode;
      self.com_parentNode = parser.com_parentNode;
      self.com_currentNode = parser.com_currentNode;
      self.nodeContent = parser.nodeContent;
      self.currShowContainer = parser.currShowContainer;
      self.currShowWindow = parser.currShowWindow;
      skipCurrentTag = parser->skipCurrentTag;
    }
    return self;
  }
  return nil;
}

/** 进行xml数据解析，用于内部调用
 *
 *  对外开放的解析方法中，负责初始化跟结点等中间数据，该方法中不初始化这些中间数据，用于实现include
 *  标签的递归加载
 *  @param xmlData 要解析的xml数据
 */
- (void) startParseXML: (XMLNode*) node
{
   [self parser:nil
didStartElement:node.name
  qualifiedName:nil
     attributes:node.attributeMap];
  
  for (XMLNode* childnode in node.childNodes) {
    [self startParseXML: childnode];
    //        [self parser:nil
    //       didEndElement:childnode.name
    //         nodeContent:childnode.content];
  }
  [self parser:nil
 didEndElement:node.name
   nodeContent:node.content];
}

/** 根据标签名称初始化组件对象
 *
 *  @param tagName 标签名称
 *  @return 标签名称对应的组件类实例
 */
- (ZGComponent*) newComponentByTagXml: (NSString*) tagName
{
  NSString* className = [COMPONTENT_CLASS_MAP objectForKey: [tagName lowercaseString]];
  Class compontentClass = [[NSBundle mainBundle] classNamed: className];
  id myInstance = [[compontentClass alloc] init];
  if ([myInstance isKindOfClass: [ZGComponent class]])
  {
    if ([myInstance isKindOfClass: [ZGPage class]])
    {
      LOG(@"%@", ((ZGPage*)myInstance).name);
    }
    return (ZGComponent*) myInstance;
  } else {
    return nil;
  }
}

/** 进行xml数据解析，建立树形结构
 *
 *  获取数据，设置属性并解析xml
 *  @param xmlData 要解析的xml数据
 *  @return 解析后树形结构的根结点
 */
- (ZGComponent*) doXMLParser: (NSData*) xmlData
{
  self.com_rootNode = nil;
  self.com_currentNode = nil;
  self.nodeContent = nil;
  XMLDataParser* parser = [[XMLDataParser alloc] init];
  self.rootNode = [parser doXMLParser: xmlData];
  [parser outPutNode];
  [self startParseXML: rootNode];
  [parser release];
  return com_rootNode;
}

///** 当开始解析文件时发送委托
// *
// *  @param parser 解析对象
// */
//- (void)parserDidStartDocument:(NSXMLParser *)parser 
//{
//}

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
     attributes:(NSDictionary*) attributeDict
{
  //  LOG(@"compontent start : %@", elementName);
  BOOL needIncluded = [elementName isEqualToString: @"include"];
  if (needIncluded)
  {
    NSString* url = [attributeDict objectForKey: @"src"];
    NSData* data = [FileUtils loadXMLFromResource: url];
    
    if (data)
    {
      XMLDataParser* dataparser = [[XMLDataParser alloc] init];
      XMLNode* node = [dataparser doXMLParser: data];
      [self startParseXML: node];
      [dataparser release];
    }
  } else {
    ZGComponent* currentTemp = nil;
    if (self.com_currentNode)
    {
      ZGComponent* pNode = self.com_currentNode;
      while ([pNode isKindOfClass: [SkipCompontent class]])
      {
        pNode = pNode.parent;
      }
      if ([pNode isKindOfClass: [ZGContainer class]])
      {
        ZGContainer* container = (ZGContainer*) self.com_currentNode;
        currentTemp = [self newComponentByTagXml: elementName];
        if (currentTemp)
        {
          if ([currentTemp isKindOfClass: [ZGToolBar class]]
              || [currentTemp isKindOfClass: [ZGMenu class]])
          {
            [currentTemp loadFromXMLTag: elementName
                             attributes: attributeDict
                        parentContainer: (ZGContainer*) self.com_currentNode];
            [com_rootNode addChildComontent: [container specInitCompontent: currentTemp]];
          } else {
            [currentTemp loadFromXMLTag: elementName
                             attributes: attributeDict
                        parentContainer: (ZGContainer*) self.com_currentNode];
            [container addChildComontent: [container specInitCompontent: currentTemp]];
          }
        }
      }
    } else {
      currentTemp = [self newComponentByTagXml: elementName];
      if (currentTemp)
      {
        [currentTemp loadFromXMLTag: elementName
                         attributes: attributeDict
                    parentContainer: (ZGContainer*) self.com_currentNode];
      }
    }
    if (!currentTemp)
    {
      currentTemp = [[SkipCompontent alloc] init];
      currentTemp.parent = (ZGContainer*) com_currentNode;
    }
    self.com_currentNode = currentTemp;
    if (!com_rootNode)
      self.com_rootNode = (ZGContainer*) currentTemp;
//    if (currentTemp)
//      [currentTemp release];
  }
}

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
    nodeContent:(NSString*) content
{
  //  LOG(@"compontent end : %@", elementName);
  Boolean needIncluded = [elementName isEqualToString: @"include"];
  if (!needIncluded)
  {
    if (content && ![content isEqualToString: @""])
    {
      self.com_currentNode.content = [NSString stringWithString: content];
    } else {
      self.com_currentNode.content = nil;
    }
    if (self.com_currentNode)
    {
      //      self.com_currentNode.content = contentTemp;
      [self.com_currentNode specInit];
      self.com_currentNode = self.com_currentNode.parent;
    }
  }
}

///** 当xml节点有值时，则进入此句
// *  代表全部或部分当前元素的字符串
// *  
// *  @param parser 解析对象
// *  @param string 当前元素的文本内容的全部或部分
// */
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
//{
//  NSString* tempString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//  if (!self.nodeContent)
//  {
//    self.nodeContent = [NSMutableString stringWithString: tempString];
//  }
//  else {
//    [self.nodeContent appendString: tempString];
//  }
//}


/** 输出标签对应的组件信息
 *
 *  @param compontent 准备输出信息的组件对应的结点
 *  @param recursion 递归次数
 */
- (void) outPutCompontent:(ZGComponent *) compontent
                recursion:(int) recursion
{
  NSMutableString* prefix = [[NSMutableString alloc] initWithCapacity: recursion];
  for (int i = recursion; i > 0; i--)
  {
    [prefix appendString:@"\t"];
  }
  LOG(@"%@标签名称:%@", prefix, compontent.name);
  LOG(@"%@标签内容:%@", prefix, compontent.content);
  LOG(@"%@标签属性列表:", prefix);
  for (NSString* attributeName in compontent.propertiesMap) //输出属性列表
  {
    LOG(@"%@\t%@:%@", prefix, attributeName,
        [compontent.propertiesMap objectForKey:attributeName]);
  }
  
  if ([compontent isKindOfClass: [ZGContainer class]])
  {
    ZGContainer* container = (ZGContainer*) compontent;
    if ([container hasChildCompontent])
    {
      LOG(@"%@子标签列表:", prefix);
      for (ZGComponent* childCompontent in [container getAllChildCompontent])
      {
        [self outPutCompontent: childCompontent
                     recursion: recursion + 1];
      }
    }
  }
  LOG(@"%@标签结束", prefix);
  [prefix release];
  LOG(@"\n");
}

/** 输出标签信息
 *
 */
- (void) outPutCompontent
{
  LOG(@"\n");
  LOG(@"\n");
  LOG(@"\n");
  LOG(@"\n");
  LOG(@"\n");
  LOG(@">>>>>>输出标签>>>>>>");
  [self outPutCompontent: self.com_rootNode
               recursion: 0];
}


/** 析构函数
 *  析构函数
 */
//- (void) dealloc
//{
//  [rootNode release];
//  [currentNode release];
//  [com_rootNode release];
//  [com_parentNode release];
//  [com_currentNode release];
//  [nodeContent release];
//  [currShowWindow release];
//  [currShowContainer release];
//  [super dealloc];
//}

- (ZGContainer*) currShowContainer
{
  if (currShowContainer)
    return currShowContainer;
  else if ([com_rootNode isKindOfClass: [ZGContainer class]])
    return (ZGContainer*) com_rootNode;
  return nil;
}

@end

@implementation SkipCompontent
@end