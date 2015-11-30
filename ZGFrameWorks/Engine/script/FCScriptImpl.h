//
//  FCScriptImpl.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "UIComponent.h"
#import "CompontentParser.h"
#import "FCScript.h"
#import "ZGContainer.h"

#define TAG  @"FCScriptImpl"

#define SETVALUE              0   // 设置控件值
#define SETTEXT               1   // 设置控件显示文本
#define SETACTION             2   // 设置控件操作
#define CHANGE_FONTSIZE       3   // 设置控件字体大小
#define CHANGE_FONTCOLOR      4   // 设置控件字体颜色
#define CHANGE_ALIGN          5   // 设置控件对齐方式
#define CHANGE_ROWS           6   // 设置控件行数
#define CHANGE_WIDTH          7   // 设置控件宽度
#define CHANGE_HEIGHT         8   // 设置控件高度
#define CHANGE_X              9   // 设置控件X
#define CHANGE_Y              10  // 设置控件Y
#define CHANGE_TYPE           11  // Input和textarea中设置控件类型
#define CHANGE_FORM           12  // 设置form排列方式
#define CHANGE_SELECTEDCOLOR  13  // 设置选中颜色
#define CHANGE_BGCOLOR        14  // 设置背景颜色
#define CHANGE_BGIMG          15  // 设置背景图片
#define CHANGE_SELECTEDBGIMG  16  // 设置选中的背景图片

#define TOP     0
#define UP      1
#define DOWN    2
#define BOTTOM  3
#define LOGOUT_YES  0
#define LOGOUT_NO   1

@interface FCScriptImpl : FCScript
{
  ZGComponent* widget;

  ZGContainer* layout;
	// 增加Context
  FSContext* context;
  // added by zhumx
  ZGComponent* focuswidget;
}

@property (nonatomic, retain) FSContext* context;

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;
- (void) setWidgetItemAttribute: (NSArray*) paramArray;
- (NSString*) getWidgetItemAttribute: (NSArray*) paramArray;
- (void) clearWidgets:(NSString*) layoutName;

@end
