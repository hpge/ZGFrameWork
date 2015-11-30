//
//  ZGContainer.m
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/26.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import "ZGContainer.h"


@interface ZGContainer ()

@end

@implementation ZGContainer

#pragma mark -
#pragma mark properites

/** 子组件容器管理 */
@synthesize layoutManager;
@synthesize fscript;
@synthesize childIndexDict;
@synthesize childCompontents;
@synthesize parentContainerView;

#pragma mark -
#pragma mark init & dealloc method

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
    isFrameSet = FALSE;
    if (!rootNode) rootNode = self;
    if (container && container->fscript)
        self->fscript = container->fscript;
    self.childCompontents = [NSMutableArray arrayWithCapacity: 3];
    self.childIndexDict = [NSMutableDictionary dictionaryWithCapacity: 3];
    return self;
}

/** 标签属性初始化方法
 *
 *  在XML解析器完成loadFromXMLTag和setContent方法后，进行初始化的方法
 *  @attention 该方法被用于实现各个子类的初始化工作
 */
- (void) specInit
{
    [super specInit];
    NSString* temp = nil;
    if (![propertiesMap objectForKey: MAR_TAG_ATTR_BACK_COLOR])
    {
        temp = [parent getAttribute: MAR_TAG_ATTR_BACK_COLOR];
        if (temp)
        {
            [propertiesMap setObject: temp forKey: MAR_TAG_ATTR_BACK_COLOR];
        }
    }
}

/** 标签属性初始化方法
 *
 *  在XML解析器完成loadFromXMLTag和setContent方法后，进行初始化的方法
 *  @attention 该方法被用于实现各个子类的初始化工作
 */
- (void) specInitInRepaint
{
    [self specInit];
    for (ZGComponent* childCompontent in childCompontents)
    {
        if ([childCompontent isKindOfClass: [ZGContainer class]])
        {
            [(ZGContainer*) childCompontent specInitInRepaint];
        } else {
            [childCompontent specInit];
        }
    }
}

/** 析构函数
 */
//- (void) dealloc
//{
//    [parentContainerView release];
//    [childCompontents release];
//    [childIndexDict release];
//    if (layoutManager)
//        [layoutManager release];
//    [super dealloc];
//}

#pragma mark -
#pragma mark manage child compontent

/** 增加子组件
 *
 *  将子组件添加至此容器
 *  @param compontent 欲增加的子组件
 *  @return 是否添加成功
 */
- (BOOL) addChildComontent: (ZGComponent*) compontent
{
    /*
     if ([compontent isKindOfClass:[MarToolBar class]] || [compontent isKindOfClass:[MarMenu class]])
     {
     [childToolbarIndexDict setObject: [NSNumber numberWithInteger: [childToolbarCompontents count]]
     forKey: compontent.name];
     [childToolbarCompontents addObject: compontent];
     compontent.rootNode = self.rootNode;
     return YES;
     }
     */
    [childIndexDict setObject: [NSNumber numberWithInteger: [childCompontents count]]
                       forKey: compontent.name];
    [childCompontents addObject: compontent];
    compontent.rootNode = self.rootNode;
    return YES;
}

/** 移除指定ID的组件
 *
 *  根据ID移除该容器的子组件
 *  @param compontentID 移除组件的ID
 *  @return 是否移除成功，如果不存在则返回FALSE
 */
- (BOOL) removeChildCompontent: (NSString*) compontentID
{
    NSNumber* index = [childIndexDict objectForKey: compontentID];
    ZGComponent* compontent = [childCompontents objectAtIndex: [index intValue]];
    [compontent removedFromContainer];
    [childCompontents removeObjectAtIndex: [index intValue]];
    [childIndexDict removeObjectForKey: compontentID];
    return YES;
}

/** 移除容器中全部的子组件
 *
 *  移除容器中全部子组件
 *  @return 返回移除是否成功
 */
- (BOOL) removeAllChildCompontent
{
    for (ZGComponent* compontent in childCompontents)
    {
        [compontent removedFromContainer];
    }
    [childIndexDict removeAllObjects];
    [childCompontents removeAllObjects];
    return NO;
}

/** 获取全部组件的列表
 *
 *  返回该容器全部组件数组
 *  @return 该容器全部子组件的数组，如果没有子组件则返回空数组
 */
- (NSArray*) getAllChildCompontent
{
    return childCompontents;
}

/** 判断是否有子组件
 *
 *  判断该容器是否存在子组件
 *  如果子组件列表为空，则返回TRUE，否则为FALSE
 */
- (BOOL) hasChildCompontent
{
    return [childCompontents count] > 0;
}

/** 初始化子组件后调用方法
 *
 *  在XML解析器遍历该容器子组件列表时，初始化子组件后调用
 *  @param newCompontent 遍历后初始化的子组件
 *  @return 容器处理后的子组件
 */
- (ZGComponent*) specInitCompontent: (ZGComponent*) newCompontent
{
    return newCompontent;
}

/** 绘制子组件后执行方法
 *
 *  在绘制子组件后执行的方法
 *  @param compontent 刚刚绘制的子组件
 *  @return 是否继续绘制后续的子组件
 */
- (BOOL) afterPainCompontent: (ZGComponent*) compontent
{
    return TRUE;
}

/** 该组件从容器中移除后处理方法
 *
 *  该组件从父容器中移除后的处理方法
 */
- (void) removedFromContainer
{
    for (ZGComponent* compontent in childCompontents)
    {
        [compontent removedFromContainer];
    }
    [super removedFromContainer];
}

/** 根据组件ID获取子组件
 *
 *  根据组件ID获取子组件
 *  @param compontentID 子组件的ID
 *  @return 指定ID的子组件
 */
- (ZGComponent*) getChildCompontentByID: (NSString*) compontentID
{
    NSNumber* indexNumber = [childIndexDict objectForKey: compontentID];
    if (indexNumber)
    {
        return [childCompontents objectAtIndex: [indexNumber intValue]];
    } else {
        ZGComponent* temp = nil;
        for (ZGComponent* childCompontent in childCompontents)
        {
            if ([childCompontent isKindOfClass: [ZGContainer class]])
            {
                temp = [(ZGContainer*) childCompontent getChildCompontentByID: compontentID];
                if (temp)
                    return temp;
            }
        }
        return nil;
    }
}

/** 获取组件信息
 *
 *  该方法将获取控件值并将其返回，如果为输入框则返回输入值，单选框返回选择的值，radio button返回
 *  是否选中，单选框组返回选中列表，用逗号分隔
 */
- (NSString*) getWidgetValue
{
    NSString* temp = nil;
    for (ZGComponent* childCompontent in childCompontents)
    {
        temp = [childCompontent getWidgetValue];
        if (temp)
            return temp;
    }
    return nil;
}

#pragma mark -
#pragma mark draw rect & draw method

/** 初步计算组件的大小和各个元素绘制范围的方法
 *
 *  由布局管理器调用，传入默认绘制大小，以及计算百分比表达式的高度以及宽度
 *  各个组件负责计算自己宽度和高度，同时计算最合适的绘制范围，并返回给布局
 *  管理器，方法中defaultSize和maxSize均不可修改。
 *  @param defaultSize 容器计算的目前默认宽度和高度
 *  @param maxSize 用于计算百分比的宽度和高度
 *  @return 最合适的绘制大小，其中需要包括组件宽高和相应的偏移量
 */
- (CGSize) calculateFitableSize: (const CGSize) xmlDefineSize
                     remainSize: (const CGSize) remainSize
                 maxSeeableSize: (const CGSize) maxSeeableSize
                percentBaseSize: (const CGSize) percentBaseSize
                    inContainer: (ZGContainer*) container
{
    CGSize drawSize = [super calculateFitableSize: xmlDefineSize
                                       remainSize: remainSize
                                   maxSeeableSize: maxSeeableSize
                                  percentBaseSize: percentBaseSize
                                      inContainer: container];
    if (container == nil)
    {
        [CompontentParser getInstance].currShowContainer = self;
    }
    if (!layoutManager)
    {
        layoutManager = [MarLayoutManager alloc];
    }
    
    layoutManager = [layoutManager initWithContainer: self
                                         definedSize: xmlDefineSize
                                          remainSize: remainSize
                                      maxSeeableSize: maxSeeableSize
                                     percentBaseSize: percentBaseSize
                                     parentContainer: container];
    
    for (ZGComponent* childCompontent in childCompontents)
    {
        CGSize nextAvailableSize = [layoutManager nextAvailableSize];
        CGSize remainSeeableSize = [layoutManager remainSeeableSize];
        CGSize compDrawSize = [childCompontent getFitableSize: nextAvailableSize
                                               maxSeeableSize: remainSeeableSize
                                              percentBaseSize: percentBaseSize
                                                  inContainer: self];
        CGRect compRect = [layoutManager finetuningDrawRect: compDrawSize];
        NSValue* value = [NSValue valueWithCGRect: compRect];
        [childCompontent setAttributeByName: MAR_COMPONTENT_DRAW_RECT attributeVale: value];
    }
    drawSize = layoutManager.totalShowRect;
    LOG(@"%.0f,%.0f", drawSize.width, drawSize.height);
    if (drawSize.height == 0 && drawSize.width > 0)
    {
        drawSize.height = remainSize.height;
    }
    return drawSize;
}

/** 根据传入的绘制范围绘制组件
 *
 *  由布局管理器调用，传入父容器，绘制视图，以及根据calculateFitableSize方法
 *  计算并重新调整的绘制范围，在View中绘制组件，该方法由各个子类实现。
 *  @param container 父容器
 *  @param view 绘制视图
 *  @param drawRect 绘制范围
 */
- (CGRect) drawCompontentOnContainer: (ZGContainer*) container
                              OnView: (UIView*) view
                            WithRect: (CGRect) drawRect
{
    drawRect = [super drawCompontentOnContainer: container OnView: view WithRect: drawRect];
    self.view.frame = drawRect;
    if (view)
    {
        self.parentContainerView = view;
        if (!isAddedToParent)
        {
            isAddedToParent = YES;
            [view addSubview: self.view];
        }
    }
    for (MarCompontent* childCompontent in childCompontents)
    {
        id temp = [childCompontent getAttribute: MAR_COMPONTENT_DRAW_RECT];
        if (temp && [temp isKindOfClass: [NSValue class]])
        {
            NSValue* value = (NSValue*) temp;
            CGRect compRect = [value CGRectValue];
            [childCompontent drawCompontentOnContainer: self OnView: self.view WithRect: compRect];
            [self afterPainCompontent: childCompontent WithRect: compRect];
        }
    }
    return drawRect;
}

/** 绘制子组件后执行方法
 *
 *  在绘制子组件后执行的方法
 *  @param compontent 刚刚绘制的子组件
 *  @return 是否继续绘制后续的子组件
 */
- (BOOL) afterPainCompontent: (ZGComponent*) compontent
                    WithRect: (CGRect) rect
{
    return YES;
}

/** 组件重绘方法 */
- (void) rePaint: (ZGContainer*) container
{
    if (!container)
        container = parent;
    //  [self.view removeFromSuperview];
    //  [self removedFromContainer];
    [self specInit];
    CGRect drawRect = self.view.frame;
    CGSize maxSeeableSize = parent == nil ? self.view.frame.size : parent.layoutManager.totalShowRect;
    drawRect.size = [self calculateFitableSize: CGSizeMake(compWidth, compHeight)
                                    remainSize: maxSeeableSize
                                maxSeeableSize: maxSeeableSize
                               percentBaseSize: layoutManager.percentBaseSize
                                   inContainer: container.parent];
    [self drawCompontentOnContainer: parent OnView: container.view WithRect: drawRect];
}

#pragma mark -
#pragma mark other container method

/** 切换显示容器
 *
 *  将该容器从父视图中移除，并将指定容器放入父视图
 *  @param container 指定显示的新容器
 *  @return 切换是否成功
 */
- (BOOL) switchToAnother: (ZGContainer*) container
{
    [CompontentParser getInstance].currShowContainer = container;
    container.parent = self.parent;
    CGRect drawRect = self.view.frame;
    [self.view removeFromSuperview];
    [self removedFromContainer];
    CGSize maxSeeableSize = parent == nil ? self.view.frame.size : parent.layoutManager.totalShowRect;
    drawRect.size = [container calculateFitableSize: self.view.frame.size
                                         remainSize: maxSeeableSize
                                     maxSeeableSize: maxSeeableSize
                                    percentBaseSize: layoutManager.percentBaseSize
                                        inContainer: container.parent];
    [container drawCompontentOnContainer: container.parent OnView: parentContainerView WithRect: drawRect];
    [container.parent afterPainCompontent: container WithRect: drawRect];
    return TRUE;
}

- (void) setRootNode: (ZGContainer*) rootnode
{
    self->rootNode = rootnode;
    for (MarCompontent* childCompontent in childCompontents)
    {
        childCompontent.rootNode = rootnode;
    }
    return;
}

- (FCScript*) getFscript
{
    if (!self->fscript)
        self->fscript = [[FCScriptImpl alloc] init];
    return self->fscript;
}

/** 返回该组件是否为容器
 */
- (BOOL) isContainer
{
    return YES;
}

@end
