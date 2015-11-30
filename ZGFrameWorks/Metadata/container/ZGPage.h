///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   MarPage.h
/// @brief  客户端页面容器类定义文件
///
/// 该文件定义了客户页面容器类
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
#import "ZGContainer.h"

/** 客户端页面容器类
 *
 *  该类负责描述客户端展示页面容器的行为和相应事件
 */
@interface ZGPage : ZGContainer {
@private
  //顶部工具条
  NSMutableArray* headCompontents;
  //底部工具条
  NSMutableArray* bottomCompontents;
  /** 原始大小 */
  CGSize originSize;
  /** 上次调整后的大小 */
  CGSize lastSize;
  /** 头部导航栏大小 */
  CGSize headNavigatorBar;
  /** 底部导航栏大小 */
  CGSize bottomNavigatorBar;
  UIView* backView;
  BOOL isRepaint;
}

/** 调整大小
 *
 *  调整页面显示部分大小，页面容器的视图为滚动视图，此方法为调整可视部分的大小
 */
- (void) resize: (CGSize) newSize;

/** 将大小恢复至上次调整前的大小
 *
 *  将页面可视部分大小恢复上次调整前的大小
 */
- (void) restoreLastSize;

/** 将大小恢复至原始大小
 *
 *  将页面可视部分大小恢复至原始大小
 */
- (void) restoreOriginSize;

/** 增加页面导航栏
 *
 *  为页面容器增加页面导航栏。页面容器的视图会显示在上下导航栏中间部分。滚动页面
 *  容器导航栏不会随之滚动
 *  @param navigatorContainer 导航栏容器
 *  @param isAtBottom 是否为底部导航栏
 *  @return 添加是否成功
 */
- (BOOL) addNavigatorContainer: (ZGContainer*) navigatorContainer
                      atBottom: (BOOL) isAtBottom
                          size: (CGSize) drawSize;

/** 将可视范围滚动至指定位置
 *
 *  将页面视图滚动至指定位置
 *  @param rect 指定位置和大小
 *  @param animated 是否使用动画效果
 */
- (void) scrollRectToVisible: (CGRect) rect
                    animated: (BOOL) animated;

/** 获取当前可视范围
 *
 *  获取当前页面的可视范围
 */
- (CGRect) currFrame;

/** 显示键盘后触发该方法
 *
 *  显示键盘时触发该方法，用于通知页面容器键盘大小
 *  @param keyBoardSize 键盘大小
 */
- (void) showKeyBoard: (CGSize) keyBoardSize;

/** 隐藏键盘后触发该方法
 *
 *  隐藏键盘时触发该方法，用于通知页面容器键盘大小
 *  @param keyBoardSize 键盘大小
 */
- (void) hideKeyBoard: (CGSize) keyBoardSize;

+ (ZGPage*) getCurrentPage;

- (int) count;
@end