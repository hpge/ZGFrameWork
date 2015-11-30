///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarSelect.m
/// @brief
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

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]


#import "UIComponent.h"

@implementation ZGSelect

#pragma mark -
#pragma mark properites

@synthesize comboBoxDatasource = _comboBoxDatasource;
@synthesize _currView;

#pragma mark -
#pragma mark init & dealloc method

/** 组件内容初始化方法
 *
 *  XML解析器在读取标签内容后调用，用于初始化标签内容属性
 *  @param tagContent 标签内容
 */
- (void) specInit
{
  [super specInit];
}

/** 析构函数
 *  析构函数
 */
//- (void)dealloc {
//  _comboBoxTableView.delegate = nil;
//  _comboBoxTableView.dataSource	= nil;
//  
//  [_comboBoxDatasource release];
//  _comboBoxDatasource = nil;
//  
//  [super dealloc];
//}
//
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
  CGSize drawSize = [super calculateFitableSize: xmlDefineSize
                                     remainSize: remainSize
                                 maxSeeableSize: maxSeeableSize
                                percentBaseSize: percentBaseSize
                                    inContainer: container];
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
  drawRect = [super drawCompontentOnContainer: container OnView: view WithRect: drawRect];
  
  if (!isAddedToParent)
  {
    isAddedToParent = YES;
    _comboBoxDatasource = [[NSArray alloc] initWithObjects:@"one", @"two", @"three", @"four", @"five", @"six", @"seven", @"eight", nil];
    _currView = view;
    
    //    CGFloat x = [[propertiesMap objectForKey: MAR_COMPONTENT_DRAW_X] floatValue];
    //    CGFloat y = [[propertiesMap objectForKey: MAR_COMPONTENT_DRAW_Y] floatValue];
    //    CGFloat width = [[propertiesMap objectForKey: MAR_TAG_ATTR_WIDTH] floatValue];
    //    CGFloat height = [[propertiesMap objectForKey: MAR_TAG_ATTR_HEIGHT] floatValue];
    
    //添加标签
    _selectContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 35)];
    _selectContentLabel.font = [UIFont systemFontOfSize:21.0f];
    _selectContentLabel.backgroundColor = [UIColor orangeColor];
    
    [view addSubview:_selectContentLabel];
    
    //添加按钮
    _pulldownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pulldownButton setFrame:CGRectMake(150, 50, 25, 35)];
    [_pulldownButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_ico_d" ofType:@"png"]]
                               forState:UIControlStateNormal];
    [_pulldownButton setBackgroundColor:[UIColor orangeColor]];
    [_pulldownButton addTarget:self action:@selector(pulldownButtonWasClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    [_currView addSubview:_pulldownButton];
    
    _hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_hiddenButton setFrame:CGRectMake(50, 50, 110, 35)];
    _hiddenButton.backgroundColor = [UIColor clearColor];
    [_hiddenButton addTarget:self action:@selector(pulldownButtonWasClicked:)
            forControlEvents:UIControlEventTouchUpInside];
    [_currView addSubview:_hiddenButton];
    
    _comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 85, 125, 188)];
    _comboBoxTableView.dataSource = self;
    _comboBoxTableView.delegate = self;
    _comboBoxTableView.backgroundColor = [UIColor yellowColor];
    _comboBoxTableView.separatorColor = [UIColor blackColor];
    _comboBoxTableView.hidden = YES;
    [_currView addSubview:_comboBoxTableView];
  }
  return drawRect;
}

- (void)initVariables {
  _showComboBox = NO;
}

- (void)setContent:(NSString *) contentValue {
  _selectContentLabel.text = contentValue;
}

- (void)show {
  _comboBoxTableView.hidden = NO;
  _showComboBox = YES;
  [_currView setNeedsDisplay];
}

- (void)hidden {
  _comboBoxTableView.hidden = YES;
  _showComboBox = NO;
  [_currView setNeedsDisplay];
}

#pragma mark -
#pragma mark custom event methods

- (void)pulldownButtonWasClicked:(id)sender {
  if (_showComboBox == YES) {
    [self hidden];
  }else {
    [self show];
  }
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_comboBoxDatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"ListCellIdentifier";
  UITableViewCell *cell = [_comboBoxTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  cell.textLabel.text = (NSString *)[_comboBoxDatasource objectAtIndex:indexPath.row];
  cell.textLabel.font = [UIFont systemFontOfSize:21.0f];
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 35.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self hidden];
  _selectContentLabel.text = (NSString *)[_comboBoxDatasource objectAtIndex:indexPath.row];
}

- (void)drawListFrameWithFrame:(CGRect)frame withContext:(CGContextRef)context {
  CGContextSetLineWidth(context, 1.0f);
  CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
  if (_showComboBox == YES) {
    CGContextAddRect(context, CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height));
    
  }else {
    CGContextAddRect(context, CGRectMake(0.0f, 0.0f, frame.size.width, 25.0f));
  }
  CGContextDrawPath(context, kCGPathStroke);	
  CGContextMoveToPoint(context, 0.0f, 25.0f);
  CGContextAddLineToPoint(context, frame.size.width, 25.0f);
  CGContextMoveToPoint(context, frame.size.width - 25, 0);
  CGContextAddLineToPoint(context, frame.size.width - 25, 25.0f);
  
  CGContextStrokePath(context);
}


#pragma mark -
#pragma mark drawRect methods

- (void)drawRect:(CGRect)rect {
  //	[self drawListFrameWithFrame:self.frame withContext:UIGraphicsGetCurrentContext()];
}

@end
