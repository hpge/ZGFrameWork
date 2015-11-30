//
//  CssOperate.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-9.
//  Copyright 2012 Mar114. All rights reserved.
//

#import "CssOperate.h"
#import "CssManager.h"
#import "ZGUIConstants.h"

@implementation CssOperate

// private Context context;

// /**
// * 构造方法.
// * @param context 上下文
// */
// public CssOperate(Context context){
// this.context=context;
// }

- (id) init {
  if (self = [super init]) {
    tType = OTHER_WORD;// 类型
    is_SingleWidget = FALSE;// 单独空间设置
  }
  return self;
}

/**
 * 单独控件设置.
 * 
 * @param widget
 *            控件
 * @param cssElement
 *            样式
 */
- (void) operateSingleWidget: (ZGComponent*) widget
                     Element: (CssElement*) cssElement {
  is_SingleWidget = TRUE;// 标示为单个控件操作
  fcWidget = widget;
  NSMutableArray* list = [NSMutableArray array];
  [list addObject:cssElement];
  @try {
    [self operateWidgets:list];
  } @catch (NSException* e) {
    LOG(@"%@", [e reason]);
    is_SingleWidget = FALSE;// 设置完成之后在还原成原始值
  }
  is_SingleWidget = FALSE;// 设置完成之后在还原成原始值
}

/**
 * 根据解析的结果做相应操作.
 * 
 * @param list
 *            CSS样式List
 * @throws Exception
 */
- (void) operateWidgets: (NSArray*) list
{
  for (int i = 0; i < [list count]; i++)
  {
    CssElement* element = [list objectAtIndex: i];
    NSString* cssType = [[list objectAtIndex:i] get_Name];
    if ([cssType hasPrefix: @"#"])// 对单个控件赋值
    {
      [[CssManager getInstance] setSpecCompontentCss: [cssType substringFromIndex: 1] withDictionary: element._Attribute];
    } else if ([@"system" isEqualToString:cssType])
    {// 系统统一设置
      [[CssManager getInstance] setSystemCssWithDictionary: element._Attribute];
    } else
    {
      [[CssManager getInstance] setCompontentCss: cssType withDictionary: element._Attribute];
    }
  }
}

/**
 * 重置样式表为初始值.
 */
- (void) reSet
{
  [[CssManager getInstance] reset];
}

@end