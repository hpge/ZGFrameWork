//
//  ZGContainer.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/26.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import "ZGComponent.h"

@class ZGLayoutManager;
@class FCScript;

/** 客户端界面展示容器基类
 *
 *  客户端界面展示容器基类，继承组件基类，主要用于定义page，layout等元素，负责在其内部装载和
 *  展示客户端界面展示组件，该基类提供一些通用的自组件管理方法，遍历子组件进行排版等通用行为的
 *  定义
 */

@interface ZGContainer : ZGComponent
{
    /** 子组件ID和序号对应的字典，用于快速查找子组件 */
    NSMutableDictionary* childIndexDict;
    /** 子组件数组 */
    NSMutableArray* childCompontents;
    /** 子组件容器管理 */
    ZGLayoutManager* layoutManager;
    FCScript* fscript;
    /** 父容器视图或者应用窗体视图 */
    UIView* parentContainerView;
@public
}


/** 增加子组件
 *
 *  将子组件添加至此容器
 *  @param compontent 欲增加的子组件
 *  @return 是否添加成功
 */
- (BOOL) addChildComontent: (ZGComponent*) compontent;

/** 移除指定ID的组件
 *
 *  根据ID移除该容器的子组件
 *  @param compontentID 移除组件的ID
 *  @return 是否移除成功，如果不存在则返回FALSE
 */
- (BOOL) removeChildCompontent: (NSString*) compontentID;

/** 移除容器中全部的子组件
 *
 *  移除容器中全部子组件
 *  @return 返回移除是否成功
 */
- (BOOL) removeAllChildCompontent;

/** 判断是否有子组件
 *
 *  判断该容器是否存在子组件
 *  如果子组件列表为空，则返回TRUE，否则为FALSE
 */
- (BOOL) hasChildCompontent;

/** 根据组件ID获取子组件
 *
 *  根据组件ID获取子组件
 *  @param compontentID 子组件的ID
 *  @return 指定ID的子组件
 */
- (ZGComponent*) getChildCompontentByID: (NSString*) compontentID;

/** 获取全部组件的列表
 *
 *  返回该容器全部组件数组
 *  @return 该容器全部子组件的数组，如果没有子组件则返回空数组
 */
- (NSArray*) getAllChildCompontent;

/** 切换显示容器
 *
 *  将该容器从父视图中移除，并将指定容器放入父视图
 *  @param container 指定显示的新容器
 *  @return 切换是否成功
 */
- (BOOL) switchToAnother: (ZGComponent*) container;

/** 初始化子组件后调用方法
 *
 *  在XML解析器遍历该容器子组件列表时，初始化子组件后调用
 *  @param newCompontent 遍历后初始化的子组件
 *  @return 容器处理后的子组件
 */
- (ZGComponent*) specInitCompontent: (ZGComponent*) newCompontent;

/*
 以下方法用于MarContainer类内部调用，提供绘图方面的个性化设置
 */
/** 绘制子组件后执行方法
 *
 *  在绘制子组件后执行的方法
 *  @param compontent 刚刚绘制的子组件
 *  @return 是否继续绘制后续的子组件
 */
- (BOOL) afterPainCompontent: (ZGComponent*) compontent
                    WithRect: (CGRect) rect;

/** 组件重绘方法 */
- (void) rePaint: (ZGComponent*) container;

@property (nonatomic, retain, readonly, getter=getFscript) FCScript* fscript;
@property (nonatomic, retain) NSMutableArray* childCompontents;
@property (nonatomic, retain) NSMutableDictionary* childIndexDict;
@property (nonatomic, retain) UIView* parentContainerView;
/** 子组件容器管理 */
@property (assign, readonly) ZGLayoutManager* layoutManager;

@end
