///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// All rights reserved
///
/// @file MarLayout.h
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

#import <Foundation/Foundation.h>

#import "ZGContainer.h"

@interface ZGLayout : ZGContainer {
@private
  // 是否有滚动条
  BOOL scrollable;
}
@property (assign, nonatomic) BOOL scrollable;
@end
