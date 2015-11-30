///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 201，（版权声明）
/// All rights reserved
///
/// @file ForwardPageAction.h
/// @brief 页面切换操作
///
/// 该action负责完成页面切换操作
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
@class FSActionInterface;

/** 页面切换操作类
 *
 *  该action负责完成页面切换操作
 */
@interface ForwardPageAction : FSActionInterface
{
@private
  /* 欲切换的容器对象 */
  ZGContainer* targetContainer;
  /* 目的容器的访问路径 */
  NSString* targetURL;
}

@property (retain, nonatomic) NSString* targetURL;
@property (assign, nonatomic) ZGContainer* targetContainer;

@end