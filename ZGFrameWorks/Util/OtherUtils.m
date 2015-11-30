///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file TCodeScan.h
/// @brief 调用银河扫码api类库进行扫码
///
/// 调用银河扫码api类库进行扫码
///
/// @version    0.0.1
/// @date       2011.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import "OtherUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation OtherUtils

+ (CGRect) getScreenRect
{
  CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
  CGRect screenFrame = [[UIScreen mainScreen] bounds];
  CGFloat x = 0;
  CGFloat y = statusBarFrame.size.height;
  CGFloat height = screenFrame.size.height - y;
  CGFloat width = screenFrame.size.width;
  return CGRectMake(x, y, width, height);
}

+ (NSString*) stringWithSet: (NSSet*) set
{
  NSMutableString* result = [NSMutableString stringWithString: @"Set Start : "];
  for (id item in set)
  {
    [result appendFormat: @"%@,", item];
  }
  [result appendString: @" End Set"];
  return result;
}

+ (NSString*) stringWithArray: (NSArray*) array
{
  NSMutableString* result = [NSMutableString stringWithString: @"Array Start : "];
  for (id item in array)
  {
    [result appendFormat: @"%@,", item];
  }
  [result appendString: @" End Array"];
  return result;
}

+ (NSString*) stringWithDictionary: (NSDictionary*) dictionary
{
  NSMutableString* result = [NSMutableString stringWithString: @"Dictionary Start : "];
  for (id key in [dictionary keyEnumerator])
  {
    [result appendFormat: @"%@,%@;", key, [dictionary objectForKey: key]];
  }
  [result appendString: @" End Dictionary"];
  return result;
}

+ (NSData*) dataWithXMLString: (NSString*) xmlStr
{
  NSString* encodingStr = nil;
  NSRange encodingTagRange = [xmlStr rangeOfString: @"encoding=\""];
  if (encodingTagRange.location != NSNotFound)
  {
    NSRange searchRange;
    searchRange.location = encodingTagRange.location + 1;
    searchRange.length = [xmlStr length] - searchRange.location;
    NSRange encodingRange = [xmlStr rangeOfString: @"\""
                                        options: NSLiteralSearch
                                          range: searchRange];
    if (searchRange.location != NSNotFound)
    {
      encodingStr = [xmlStr substringWithRange: encodingRange];
    }
  }
  if (!encodingStr)
    encodingStr = @"UTF-8";
  return [xmlStr dataUsingEncoding: [OtherUtils getEncodingWithString: encodingStr]];
}

+ (NSStringEncoding) getEncodingWithString: (NSString*) encoding
{
  // NSURLResponse's encoding is an IANA string. Use CF utilities to convert it to a CFStringEncoding then a NSStringEncoding
  NSStringEncoding nsEncoding = NSUTF8StringEncoding; // default to UTF-8
  if (encoding) {
    CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)encoding);
    if (cfEncoding != kCFStringEncodingInvalidId) {
      nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
    }
  }
  return nsEncoding;
}

+ (int) maxInt: (int) num, ...
{
  int max = num;
  va_list args;
  int temp = NSIntegerMin;
  va_start(args, num);
  while (num)
  {
    temp = va_arg(args, int);
    max = temp > max ? temp : max;
  }
  va_end(args);
  return max;
}

+ (CGFloat) maxFloat: (CGFloat) num, ...
{
  CGFloat max = num;
  va_list args;
  CGFloat temp = NSIntegerMin;
  va_start(args, num);
  while (num)
  {
    temp = va_arg(args, double);
    max = temp > max ? temp : max;
  }
  va_end(args);
  return max;
}

+ (NSData*) md5: (NSString*) str
{  
  const char *cStr = [str UTF8String];
  unsigned char result[16];
  CC_MD5(cStr, strlen(cStr), result);
  NSData* data = [NSData dataWithBytes: result length: 16];
  return data;
}

@end