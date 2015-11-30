///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   MarPage.m
/// @brief  客户端页面容器类实现文件
///
/// 该文件实现了客户页面容器类
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
#import "OtherUtils.h"
#import "ZGFCScript.h"
#import "CompontentParser.h"


@implementation ZGPage

#pragma mark -
#pragma mark properites

#pragma mark -
#pragma mark init & dealloc method

static ZGPage* currentPage;

- (void) loadView
{
  UIView* tempView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0, 0.0, 0.0, 0.0)];
  self.view = tempView;
  backView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
}

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
  [super loadFromXMLTag: tagName attributes: attributeDict parentContainer: container];
  bottomCompontents = [[NSMutableArray alloc] initWithCapacity: 3];
  headCompontents = [[NSMutableArray alloc] initWithCapacity: 3];
  isRepaint = NO;
  if (!self->fscript)
    [self getFscript];
  self->isFrameSet = TRUE;
   return self;
}

/** 组件内容初始化方法
 *
 *  XML解析器在读取标签内容后调用，用于初始化标签内容属性
 *  @param tagContent 标签内容
 */
- (void) specInit
{
 
  [super specInit];
  originSize = CGSizeMake(-1, -1);
  lastSize = CGSizeMake(-1, -1);
  CGRect screenRect = [OtherUtils getScreenRect];
  bottomNavigatorBar = CGSizeMake(screenRect.size.width, 0);
  headNavigatorBar = CGSizeMake(screenRect.size.width, 0);
  if (!backGroundColor)
  {
    for (ZGComponent* backcolorCompontent in self->childCompontents)
    {
      if (![backcolorCompontent isKindOfClass: [ZGFCScript class]]
          && ![backcolorCompontent isKindOfClass: [ZGToolBar class]]
          && ![backcolorCompontent isKindOfClass: [ZGMenu class]])
      {
        self.backGroundColor = [UIPropertiesLoader initColorWithString: [backcolorCompontent getAttribute: MAR_TAG_ATTR_BACK_COLOR]
                                                          isBackground: YES];
        break;
      }
    }
  }
}

/** 析构函数
 *
 *  析构函数，负责释放页面容器类内部属性
 */
//- (void) dealloc
//{
//  [backView release];
//  [headCompontents release];
//  [bottomCompontents release];
//  [super dealloc];
//}

#pragma mark -
#pragma mark draw rect & draw method

/** 初步计算组件的大小和各个元素绘制范围的方法
 *
 *  由布局管理器调用，传入当前绘制的点，以及计算百分比表达式的高度以及宽度
 *  各个组件负责计算自己宽度和高度，同时计算最合适的绘制范围，并返回给布局
 *  管理器，方法中orgPoint和maxSize均不可修改。
 *  @param orgPoint 绘制原点
 *  @param defaultSize 容器计算的目前默认宽度和高度
 *  @param maxSize 用于计算百分比的宽度和高度
 *  @return 最合适的绘制范围，其中point表示左右和上下的偏移量
 */
- (CGSize) calculateFitableSize: (const CGSize) xmlDefineSize
                     remainSize: (const CGSize) remainSize
                 maxSeeableSize: (const CGSize) maxSeeableSize
                percentBaseSize: (const CGSize) percentBaseSize
                    inContainer: (ZGContainer*) container
{
  CGRect seeableRect = [OtherUtils getScreenRect];
  if (container == nil)
  {
    [CompontentParser getInstance].currShowContainer = self;
  }

  for (ZGComponent* headCompontent in headCompontents)
  {
    CGSize compDrawSize = [headCompontent getFitableSize: seeableRect.size
                                          maxSeeableSize: CGSizeMake(seeableRect.size.width, seeableRect.size.height - headNavigatorBar.height)
                                         percentBaseSize: percentBaseSize
                                              inContainer: self];
    CGRect compRect = CGRectMake(0, headNavigatorBar.height, compDrawSize.width, compDrawSize.height);
    headNavigatorBar.height += compDrawSize.height;
    NSValue* value = [NSValue valueWithCGRect: compRect];
    [headCompontent setAttributeByName: MAR_COMPONTENT_DRAW_RECT attributeVale: value];
  }

  for (ZGComponent* bottomCompontent in bottomCompontents)
  {
    CGSize compDrawSize = [bottomCompontent getFitableSize: seeableRect.size
                                          maxSeeableSize: CGSizeMake(seeableRect.size.width, seeableRect.size.height - headNavigatorBar.height - bottomNavigatorBar.height)
                                         percentBaseSize: percentBaseSize
                                             inContainer: self];
    bottomNavigatorBar.height += compDrawSize.height;
    CGRect compRect = CGRectMake(0, seeableRect.size.height - bottomNavigatorBar.height, compDrawSize.width, compDrawSize.height);
    NSValue* value = [NSValue valueWithCGRect: compRect];
    [bottomCompontent setAttributeByName: MAR_COMPONTENT_DRAW_RECT attributeVale: value];
  }
  
  if (!layoutManager)
  {
    layoutManager = [ZGLayoutManager alloc];
  }
  CGSize drawSize = CGSizeMake(seeableRect.size.width, seeableRect.size.height - headNavigatorBar.height - bottomNavigatorBar.height);
  layoutManager = [layoutManager initWithContainer: self
                                       definedSize: drawSize
                                        remainSize: drawSize
                                    maxSeeableSize: drawSize
                                   percentBaseSize: percentBaseSize
                                   parentContainer: container];
  
  for (ZGComponent* childCompontent in childCompontents)
  {
    if (![childCompontent isKindOfClass: [ZGToolBar class]]
        && ![childCompontent isKindOfClass: [ZGMenu class]])
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
  }
  drawSize = layoutManager.totalShowRect;
  [self.view setBackgroundColor: backGroundColor];
  return drawSize;
}

/** 根据传入的绘制范围绘制组件
 *
 *  由布局管理器调用，传入父容器，绘制视图，以及根据getBestFitRect方法
 *  计算并重新调整的绘制范围，在View中绘制组件，该方法由各个子类实现。
 *  @param container 父容器
 *  @param view 绘制视图
 *  @param drawRect 绘制范围
 */
- (CGRect) drawCompontentOnContainer: (ZGContainer*) container
                              OnView: (UIView*) view
                            WithRect: (CGRect) drawRect
{
  CGRect seeableRect = [OtherUtils getScreenRect];
  backView.frame = seeableRect;
  CGSize seeableSize = seeableRect.size;
  seeableSize.height -= headNavigatorBar.height + bottomNavigatorBar.height;
  if (seeableSize.height > drawRect.size.height)
  {
    drawRect.size.height = seeableSize.height;
  }
  if ([self.view isKindOfClass: [UIScrollView class]])
  {
    [(UIScrollView*)self.view setContentSize: drawRect.size];
  }
  if (!isAddedToParent)
  {
    if (currentPage) {
    }
    currentPage = self;
//  drawRect = [super drawCompontentOnContainer: container OnView: backView WithRect: CGRectMake(0, headNavigatorBar.height, seeableSize.width, seeableSize.height)];
    drawRect = CGRectMake(0, headNavigatorBar.height, seeableSize.width, seeableSize.height);
    drawRect.size.width -= compX;
    drawRect.size.height -= compY;
    drawRect.origin.x += compX;
    drawRect.origin.y += compY;
    self.compWidth = drawRect.size.width;
    self.compHeight = drawRect.size.height;
    if (view)
    {
      self.parentContainerView = view;
      isAddedToParent = YES;
      [backView addSubview: self.view];
    }
    for (ZGComponent* childCompontent in childCompontents)
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
    self.view.frame = drawRect;
    [view addSubview: backView];
  } else {
    UIView* temp = self.parentContainerView;
    drawRect = [super drawCompontentOnContainer: container OnView: backView WithRect: CGRectMake(0, headNavigatorBar.height, seeableSize.width, seeableSize.height)];
    self.parentContainerView = temp;
  }
  FCScript* script = nil;
  script = self.fscript;
  if (!script)
  {
    script = rootNode.fscript;
  }
  if (script && !isRepaint)
  {
    [script runCode];
    if ([script definedFunction: @"init"])
    {
      [script callFunctionString: @"init" Array: nil];
    }
  }
  return drawRect;
}

/** 切换显示容器
 *
 *  将该容器从父视图中移除，并将指定容器放入父视图
 *  @param container 指定显示的新容器
 *  @return 切换是否成功
 */
- (BOOL) switchToAnother: (ZGContainer*) container
{
  [backView removeFromSuperview];
  BOOL result = [super switchToAnother: container];
  return result;
}

#pragma mark -
#pragma mark navigator view method

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
                          size: (CGSize) drawSize
{
  BOOL result = FALSE;
  if (navigatorContainer)
  {
    id temp = [navigatorContainer getAttribute: MAR_COMPONTENT_DRAW_RECT];
    if (temp && [temp isKindOfClass: [NSValue class]])
    {
      NSValue* value = (NSValue*) temp;
      CGRect compRect = [value CGRectValue];
      navigatorContainer.view.frame = compRect;
      [backView addSubview: navigatorContainer.view];
      result = TRUE;
    }
  }
  return result;
}

#pragma mark -
#pragma mark manage scroll view method

/** 调整大小
 *
 *  调整页面显示部分大小，页面容器的视图为滚动视图，此方法为调整可视部分的大小
 */
- (void) resize: (CGSize) newSize
{
  if (newSize.width > 0 && newSize.height > 0)
  {
    CGRect viewFrame = [self.view frame];
    if (originSize.width < 0)
    {
      originSize = viewFrame.size;
    }
    lastSize = viewFrame.size;
    viewFrame.size = newSize;
    self.view.frame = viewFrame;
  }
}

/** 将大小恢复至上次调整前的大小
 *
 *  将页面可视部分大小恢复上次调整前的大小
 */
- (void) restoreLastSize
{
  if (lastSize.width > 0)
  {
    CGRect viewFrame = [self.view frame];
    viewFrame.size = lastSize;
    self.view.frame = viewFrame;
  }
}

/** 将大小恢复至原始大小
 *
 *  将页面可视部分大小恢复至原始大小
 */
- (void) restoreOriginSize
{
  if (originSize.width > 0)
  {
    CGRect viewFrame = [self.view frame];
    viewFrame.size = originSize;
    self.view.frame = viewFrame;
    lastSize = originSize;
  }
}

/** 将可视范围滚动至指定位置
 *
 *  将页面视图滚动至指定位置
 *  @param rect 指定位置和大小
 *  @param animated 是否使用动画效果
 */
- (void) scrollRectToVisible: (CGRect) rect
                    animated: (BOOL) animated
{
  if ([self.view isKindOfClass: [UIScrollView class]])
  {
    [(UIScrollView*) self.view scrollRectToVisible: rect
                                          animated: animated];
  }
}

#pragma mark -
#pragma mark keyboard method

/** 显示键盘后触发该方法
 *
 *  显示键盘时触发该方法，用于通知页面容器键盘大小
 *  @param keyBoardSize 键盘大小
 */
- (void) showKeyBoard: (CGSize) keyBoardSize
{
  CGFloat newHight = self.view.frame.size.height + bottomNavigatorBar.height - keyBoardSize.height;
  CGRect viewFrame = [self.view frame];
  lastSize = viewFrame.size;
  viewFrame.size.height = newHight;
  self.view.frame = viewFrame;
  //  temp = [(UIScrollView*) contentView frame].size;
  //  LOG(@"窗口后大小%f,%f", viewFrame.size.width, viewFrame.size.height);
  //  temp = [(UIScrollView*) contentView contentSize];
  //  LOG(@"内容后大小%f,%f", temp.width, temp.height);
}

/** 隐藏键盘后触发该方法
 *
 *  隐藏键盘时触发该方法，用于通知页面容器键盘大小
 *  @param keyBoardSize 键盘大小
 */
- (void) hideKeyBoard: (CGSize) keyBoardSize
{
  LOG(@"into hideKeyBoard");
  CGFloat newHight = self.view.frame.size.height + keyBoardSize.height - bottomNavigatorBar.height;
  CGRect viewFrame = [self.view frame];
  viewFrame.size.height = newHight;
  self.view.frame = viewFrame;
}

#pragma mark -
#pragma mark other method

/** 获取当前可视范围
 *
 *  获取当前页面的可视范围
 */
- (CGRect) currFrame
{
 return self.view.frame;
}

- (void) viewDidAppear: (BOOL)animated
{
  [super viewDidAppear: animated];
  //  super.view.frame = [OtherUtils getScreenRect];
}

/** 组件重绘方法 */
- (void) rePaint: (ZGContainer*) container
{
  isRepaint = YES;
  [super rePaint: container];
}

+ (ZGPage*) getCurrentPage
{
  return currentPage;
}

/** 增加子组件
 *
 *  将子组件添加至此容器
 *  @param compontent 欲增加的子组件
 *  @return 是否添加成功
 */
- (BOOL) addChildComontent: (ZGComponent*) compontent
{
  [super addChildComontent: compontent];
  if ([compontent isKindOfClass: [ZGToolBar class]])
  {
    [headCompontents addObject: compontent];
  } else if ([compontent isKindOfClass: [ZGMenu class]])
  {
    [bottomCompontents addObject: compontent];
  }
  return YES;
}

- (int) count
{
  return 2;
}
@end