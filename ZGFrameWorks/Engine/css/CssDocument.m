//
//  CssDocument.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-9.
//  Copyright 2012 Mar114. All rights reserved.
//

#import "CssDocument.h"
#import "FileUtils.h"

@implementation CssDocument

@synthesize _Text;
@synthesize _Elements;
@synthesize cssOp;

/**
 * 构造方法.
 * @param context 上下文
 */
- (id) init
{
  if (self = [super init])
  {
    cssOp = [[CssOperate alloc] init];
  }
  return self;
}

- (CssOperate*) getCssOperate {
  return cssOp;
    
    }

- (NSString*) get_Text {
  return _Text;
}

/**
 * 设置Text.
 * @param text text
 */
- (void) set_Text: (NSString*) text {
  _Text = text;
}


/**
 * 获取  List<CssElement.
 * @return List<CssElement>
 */
- (NSMutableArray*) get_Elements {
  return _Elements;
}

/**
 * 设置  List<CssElement.
 * @param elements List
 */
- (void) set_Elements: (NSMutableArray*) elements {
  _Elements = elements;
}

/**
 * 添加CssElement样式.
 * @param element CssElement
 */
- (void) addCssElement: (CssElement*) element {
  [_Elements addObject:element];
}

/**
 * 返回一个CssElement样式对象.
 * @param name 样式名称
 * @return CssElement CSS样式
 */
- (CssElement*) getCssElement: (NSString*) name {
  if(nil == _Elements){
    return nil;
  }
  for (int i = 0; i < [_Elements count]; i++) {
    CssElement* element = [_Elements objectAtIndex:i];
    if ([[element get_Name] isEqualToString:name]) {
      return element;
    }
  }
  return nil;
}

/**
 * 加载CSS 样式.
 * @param filePath CSS样式路径
 */
- (void) load: (NSString*) filePath
{
  NSString* temp = [[NSString alloc] initWithData: [FileUtils loadXMLFromResource: filePath] encoding:NSUTF8StringEncoding];
  NSString* cssContent = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  [temp release];
  
  //如果Css样式文件不存在或者内容为空就不执行
  if ([@"" isEqualToString: cssContent])
  {
    return;
  }
  
  CssParse* cssParse = [[CssParse alloc] init];
  [cssParse setM_source:cssContent];
  if (_Elements == nil) {
    _Elements = [cssParse parse];
  }
  else {
    [_Elements addObjectsFromArray: [cssParse parse]];
  }
  //执行CSS
  [self run:_Elements];
}

/**
 * 执行Css样式.
 * @param list  list
 */
- (void) run: (NSArray*) list {
  @try {
    [cssOp operateWidgets:list];
  } @catch (NSException* e) {
    LOG(@"hhh%@", [e reason]);
  }
}

/**
 * 重新初始化CSS样式.
 */
- (void) reset {
  [cssOp reSet];
}

- (void) dealloc {
  [cssOp release];
  [super dealloc];
}

@end