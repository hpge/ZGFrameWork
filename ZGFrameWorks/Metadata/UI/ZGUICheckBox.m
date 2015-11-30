///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarUICheckBox.m
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

#import "ZGCheckBox.h"

/** 选择框控件
 *
 *  选择框界面控件，用于绘制选择框，并响应用户操作，同时提供选择状态查询功能
 */
@implementation ZGUICheckBox

@synthesize style;
@synthesize checkedImage;
@synthesize uncheckedImage;
@synthesize isChecked;

/** 选择框初始化方法
 *
 *  根据初始化Frame和已选择/未选择所展示的图片创建选择框显示组件
 *  @param initFrame 初始化界面大小和位置
 *  @param unchecked 未选时中的图片
 *  @param checked 已选中时的图片
 *  @return 初始化后的选择框组件
 */
- (id) initWithFrame: (CGRect) initFrame
  withUncheckedImage: (UIImage*) unchecked
    withCheckedImage: (UIImage*) checked
{
  if (self = [super initWithFrame: initFrame])
  {
    self.uncheckedImage = unchecked;
    self.checkedImage = checked;
    CGFloat width = initFrame.size.width;
    CGFloat height = initFrame.size.height;

    UIColor* color = [[UIColor alloc] initWithPatternImage: uncheckedImage];
    [self setBackgroundColor: color];

    checkedImage = checked;
    checkedImageView = [[UIImageView alloc] initWithFrame: CGRectMake((width - checkedImage.size.width) / 2 + 1,
                                                                      (height - checkedImage.size.height) / 2 + 1,
                                                                      checkedImage.size.width, checkedImage.size.height)];
    [checkedImageView setImage: checkedImage];
    [checkedImageView setBackgroundColor: [UIColor clearColor]];
  }
  [self addTarget: self action: @selector(onClick) forControlEvents: UIControlEventTouchUpInside];
  return self ;
}

/** 设置是否选中
 *
 *  设置该选择框是否被选中
 *  @param checkState 选中状态
 */
- (void) setChecked: (BOOL) checkState
{
  if (isChecked != checkState)
  {
    isChecked = checkState;

    if (isChecked)
    {
        [self addSubview: checkedImageView];
    } else {
      [checkedImageView removeFromSuperview];
    }
  }
}

/** 被选中的时候调用的方法
 *
 *  被选中时调用方法，该方法在点击控件本身时由系统调用，不提供外部调用
 */
- (void) onClick
{
  [self setChecked: !isChecked];
}

/** 析构函数
 * 
 *  析构函数
 */
//- (void) dealloc
//{
//  [checkedImage release];
//  [uncheckedImage release];
//  [checkedImageView release];
//  [super dealloc];
//}
@end