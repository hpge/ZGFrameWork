///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file OtherUtils.h
/// @brief 其它工具类
///
/// 其它工具类
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
/** 其它工具类
 */
@interface OtherUtils : NSObject {

}

+ (CGRect) getScreenRect;

+ (NSString*) stringWithSet: (NSSet*) set;
+ (NSString*) stringWithArray: (NSArray*) array;
+ (NSString*) stringWithDictionary: (NSDictionary*) dictionary;

+ (NSData*) dataWithXMLString: (NSString*) xmlStr;
+ (NSStringEncoding) getEncodingWithString: (NSString*) encoding;

+ (int) maxInt: (int) args, ...;
+ (CGFloat) maxFloat: (CGFloat) args, ...;
+ (NSData*) md5: (NSString*) str;

@end
