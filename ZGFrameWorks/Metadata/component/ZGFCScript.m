//
//  MarFCScript.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZGFCScript.h"
#import "FCScriptImpl.h"
#import "FileUtils.h"

@implementation ZGFCScript

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
  isRunned = NO;
  return [super loadFromXMLTag: tagName attributes: attributeDict parentContainer: parentContainer];
}

- (void) specInit
{
  [super specInit];
  if (!isRunned)
  {
    isRunned = YES;
    FCScript* fcScript = rootNode.fscript;
    int currentBackup = 0;
    currentBackup = [fcScript getCodeLings];
    if (!content || [content isEqualToString: @""])
    {
      NSString* srcPath = [self getAttribute: @"src"];
      NSData* data = [FileUtils loadXMLFromResource: srcPath];
      XMLDataParser* dataparser = [[XMLDataParser alloc] init];
      XMLNode* node = [dataparser doXMLParser: data];
      content = node.content;
    }
    if (content)
    {
      [fcScript addLines: content];
      [fcScript cont: currentBackup];
    }
  }
}
- (void) PainOnContainer: (ZGContainer*) container
              parentView: (UIView*) parentView
{
}

@end