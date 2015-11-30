///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   MarUITextField.m
/// @brief  用户输入框组件实现文件
///
/// 用户输入框组件实现文件，该文件负责实现用户输入框展示组件，并实现客户端自定义的相关功能。
///
/// @version    0.0.1
/// @date       2011.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import "ZGUITextField.h"

/** 用户输入框组件类
 *
 *  该类为用户输入框组件类，负责绘制用户输入框，并提供相关事件触发和访问机制
 */
@implementation ZGUITextField

/** 静态变量，用于判断键盘是否显示
 *
 *  静态变量，用于判断键盘是否显示
 */
static BOOL keyboardShown;

/** 静态变量，用于记录激活的输入框
 *
 *  静态变量，用于记录激活的输入框
 */
static UITextField* activeField;

/** 静态变量，保存所有的MarUITextField实例
 *
 *  静态变量，保存所有的MarUITextField实例
 */
static NSMutableArray* allTextField;

+ (void) load
{
  allTextField = [[NSMutableArray alloc] initWithCapacity: 10];
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
//+ (void) staticFree
//{
//	[activeField release];
//	[allTextField release];
//}

/** 设置当前编辑的用户输入框
 *
 *  设置当前正在编辑的用户输入框，该方法为静态方法，在静态变量中保存目前正在编辑的
 *  用户输入框
 *  @param textField 正在使用的用户输入框
 */
+ (void) setActiveField: (UITextField*) textField
{
  if (activeField)
//    [activeField release];
     activeField = textField;
//    [activeField retain];
}

/** 初始化方法
 *
 *  初始化方法，设置uiTextField的事件代理为本身
 *  @attention 如果再次设置本类的delegate方法会导致行为异常，该问题还没有解决
 */
- (id) init
{
  if (self = [super init])
  {
    [allTextField addObject: self];
    isRegister = FALSE;
    return self;
  }
  return nil;
}

/** 返回用户输入时的文字绘制范围
 *
 *  该方法传入用户输入时的文字绘制范围，并根据字体大小将其居中后返回
 *  @param bounds 文字绘制范围
 *  @return 居中后文字绘制范围
 *  @attention 该方法在UITextField需要时调用，不应用于外部调用
 */
- (CGRect) editingRectForBounds: (CGRect) bounds
{
  CGRect drawRect = [super editingRectForBounds: bounds];
  LOG(@"into editingRectForBounds");
  return [self getCenterRectForBounds: drawRect];
}

/** 返回用户输后的文字绘制范围
 *
 *  该方法传入用户输入后文字绘制范围，并根据字体大小将其居中后返回
 *  @param bounds 文字绘制范围
 *  @return 居中后文字绘制范围
 *  @attention 该方法在UITextField需要时调用，不应用于外部调用
 */
- (CGRect) textRectForBounds: (CGRect) bounds
{
  CGRect drawRect = [super textRectForBounds: bounds];
  LOG(@"into textRectForBounds");
  return [self getCenterRectForBounds: drawRect];
}

/** 返回默认文字的绘制范围
 *
 *  该方法传入默认文字绘制范围，并根据字体大小将其居中后返回
 *  @param bounds 文字绘制范围
 *  @return 默认文字绘制范围
 *  @attention 该方法在UITextField需要时调用，不应用于外部调用
 */
- (CGRect) placeholderRectForBounds: (CGRect) bounds
{
  CGRect drawRect = [super placeholderRectForBounds: bounds];
  LOG(@"into placeholderRectForBounds");
  return [self getCenterRectForBounds: drawRect];
}

/** 获取组件绘制范围的中间部分
 *
 *  通过传入的组件绘制范围，使用当前字体计算字体所占范围，而后返回字体居中显示的位置，
 *  主要调整基线的高度
 *  @param bounds 组件的绘制范围
 *  @return 根据字体高度计算出来居中显示的绘制范围
 */
- (CGRect) getCenterRectForBounds: (CGRect) bounds
{
  if ([self isEditing])
  {
    int size = [allTextField count];
    for (int i = size; i > 0; i--)
    {
      ZGUITextField* item = [allTextField objectAtIndex: i - 1];
      if (item != self)
      {
        [item didLostFocus];
      }
    }
  }
  CGSize size = [@"test" sizeWithFont: self.font
                    constrainedToSize: bounds.size
                        lineBreakMode: UILineBreakModeClip];
  bounds.size.height = size.height;
  bounds.origin.y = bounds.origin.y + (bounds.size.height - size.height) / 2;
  bounds.origin.x += 3;
  LOG(@"边界原点:(%.1f, %.1f) 宽:%.1f 高:%.1f\n",
      bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
  LOG(@"字体原点:(%.1f, %.1f) 宽:%.1f 高:%.1f\n",
      bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
  return bounds;
}


/** 注册响应KeyboardNotifications事件的MarPage容器
 *
 *  注册响应KeyboardNotifications事件的MarPage容器，并在该输入框显示或者
 *  隐藏键盘时发送KeyboardNotifications事件
 *  @param uiMarPage MarPage控件，该控件用于响应KeyboardNotifications消息
 */
- (void) registerForKeyboardNotifications: (ZGPage*) uiMarPage
{
  if (!isRegister)
  {
    marPage = uiMarPage;
    isRegister = TRUE;
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWasShown:)
                                                 name: UIKeyboardDidShowNotification
                                               object: nil];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWasHidden:)
                                                 name: UIKeyboardDidHideNotification
                                               object: nil];
  }
}

/** 移除已经注册的键盘显示消息
 *
 *  移除响应KeyboardNotifications事件的MarPage容器
 */
- (void) removeRegisterForKeyboardNotifications
{
  if (isRegister)
  {
    isRegister = FALSE;
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: UIKeyboardDidShowNotification
                                                  object: nil];

    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: UIKeyboardDidHideNotification
                                                  object: nil];
  }
}

/** 当键盘显示时的响应函数
 *
 *  当键盘显示时的响应函数，该函数内部调用以注册的MarPage的showKeyBoard函数
 *  @param aNotification 键盘显示消息
 *  @attention 该函数在没有注册MarPage时，或者键盘已经显示时直接返回
 */
- (void) keyboardWasShown: (NSNotification*) aNotification
{
  if (!keyboardShown && marPage)
  {
    NSDictionary* info = [aNotification userInfo];
    
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey: UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Resize the scroll view (which is the root view of the window)
    [marPage showKeyBoard: keyboardSize];
    keyboardShown = YES;
  }
  // Scroll the active text field into view.
  if ([self isEditing])
  {
    CGRect textFieldRect = [activeField frame];
    [marPage scrollRectToVisible: textFieldRect
                        animated: YES];
  }
  return;
}

/** 当键盘隐藏时的响应函数
 *
 *  当键盘隐藏时的响应函数，该函数内部调用以注册的MarPage的hideKeyBoard函数
 *  @param aNotification 键盘显示消息
 *  @attention 该函数在没有注册MarPage时，或者键盘已经隐藏时直接返回
 */
- (void)keyboardWasHidden: (NSNotification*) aNotification
{
  if (marPage && keyboardShown)
  {
    NSDictionary* info = [aNotification userInfo];
    
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey: UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Reset the height of the scroll view to its original value
    [marPage hideKeyBoard: keyboardSize];
    keyboardShown = NO;
  }
}

/** 组件失去焦点的行为
 *
 *  当组件没有处于焦点时调用，调用代码处于getCenterRectForBounds方法中
 */
- (void) didLostFocus
{
}

/** 析构方法
 *
 */
//- (void) dealloc
//{
//  [allTextField removeObject: self];
//  [super dealloc];
//}

@end