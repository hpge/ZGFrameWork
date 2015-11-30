///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file ForwardPageAction.m
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

#import "ForwardPageAction.h"
#import "CompontentParser.h"
#import "NetWork.h"

/** 页面切换操作类
 *
 *  该action负责完成页面切换操作
 */
@implementation ForwardPageAction

@synthesize targetURL;
@synthesize targetContainer;

/** action通用初始化方法
 *
 *  根据展示组件，标签内容初始化action，该方法需要各个子类实现
 *  @param compontent Mar组件
 *  @param actionString 该组件的action属性
 *  @return 初始化后的对象
 */
- (id) initAction: (ZGComponent*) compontent
                     actionString: (NSString*) actionString
{
  [super initAction: compontent actionString:actionString];
  NSString* targetName = [compontent getAttribute: MAR_TAG_ATTR_TARGET];
  BOOL hasTargetName = (targetName != nil);
  ZGContainer* container = nil;
  while ((!container) && compontent)
  {
    compontent = compontent.parent;
    if (compontent.isFrameSet)
    {
      if (hasTargetName)
        container =
        [compontent.name isEqualToString: targetName] ? (ZGContainer*)compontent : nil;
      else {
        container = (ZGContainer*)compontent;
      }
    }
  }
  /** 从网上获取xml文件名 */
  if ([actionString hasPrefix:@"http:"] && [actionString hasSuffix:@"xml"])
  {
    ForwardPageAction* action = [[ForwardPageAction alloc] init];
    action.targetContainer = container;
    action.targetURL = actionString;
    return action;        
  }
    if ([actionString length] > 10)
  {
    actionString = [actionString substringFromIndex: 7];
    actionString = [actionString substringToIndex: [actionString length] - 4];
    ForwardPageAction* action = [[ForwardPageAction alloc] init];
    action.targetContainer = container;
    action.targetURL = actionString;
    return action;        
  }
  return nil;
}

/** action操作触发的回调函数
 *
 *  action操作触发的回调函数，该函数负责完成各个action的具体操作
 *  @param inSender 触发操作的对象
 */
- (void) executeAction: (id) inSender
{
  if (targetURL)
//  {
//    //获取xml文件
//    NSData* data;
//    if ([targetURL hasPrefix:@"http:"] && [targetURL hasSuffix:@"xml"])
//    {
//      data = [NetWork getResourceFromURL:targetURL
//                                  Header:nil
//                                    Body:nil];
//    }
//      else {
//      NSString* path = [[NSBundle mainBundle]
//                        pathForResource: targetURL ofType: @"xml"];
//      NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath: path];
//      data = [file readDataToEndOfFile]; 
//      [file closeFile];
//    }
//
//    CompontentParser* xmlParser = [CompontentParser getInstance];
//    MarContainer* switchToContainer = (MarContainer*) [xmlParser doXMLParser: data];
//    [targetContainer switchToAnother: switchToContainer];
//  }
}

@end