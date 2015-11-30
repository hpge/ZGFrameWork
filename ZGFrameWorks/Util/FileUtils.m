///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   FileUtils.m
/// @brief  实现文件工具类
///
/// 该文件实现了文件工具类
///
/// @version    0.0.1
/// @date       2011.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import "FileUtils.h"
//#import "NetWork.h"

/** 文件工具类
 *
 *  该类用于实现文件的读取，写入，查找等相关操作
 */
@implementation FileUtils

/** 从程序包中读取文件
 *
 *  该方法从ipa包中读取文件，并转换为NSData数据
 *  @param fileName 文件名称
 *  @return 该文件中的数据，如果文件没有找到则返回nil
 */
+ (NSData*) loadXMLFromResource: (NSString*) fileName
{
  if (fileName)
  {
    //获取xml文件
    NSData* data;
    if ([fileName hasPrefix:@"http:"])
    {
        //FIXME::
//      data = [NetWork getResourceFromURL: fileName
//                                  Header: nil
//                                    Body: nil];
    } else {
      NSString* path = [FileUtils getResourceFilePath: fileName];
      NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath: path];
      data = [file readDataToEndOfFile];
      [file closeFile];
    }
    if (data)
      return data;
    LOG(@"装载文件失败,文件名称:%@", fileName);
  }
  return nil;
}

/** 从网络上读取文件
 *
 *  该方法从网络上读取xml文件，并转换为NSData数据
 *  @param urlStr 文件名称
 *  @return 该文件中的数据，如果文件没有找到则返回nil
 */
+ (NSData*) loadXMLFromURL: (NSString*) urlStr
{
  if (urlStr)
  {
//    NSData* data = [NetWork getResourceFromURL:urlStr
//                                        Header:nil
//                                          Body:nil];
    NSData *data;
    return data;
  }
  LOG(@"装载文件失败,文件名称:%@", urlStr);
  return nil;
}

/** 把字典写入文件中
 *
 *  @param dict 字典内容
 *  @param path 文件路径
 */
+ (void) writeDictionaryToFile: (NSDictionary *)dict 
                          Path: (NSString *) fileName
{
  NSString* path = [FileUtils getTempFilePath: fileName];
  [dict writeToFile: path atomically: YES];
} 

/** 从文件中读取字典信息
 *
 *  @param path 文件路径
 *  @return 字典信息
 */
+ (NSDictionary*) readDictionaryFromFile: (NSString*) fileName
{
  NSString* path = [FileUtils getTempFilePath: fileName];
  NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile: path];
  return dict;
}

/** 把字符串信息写入文件
 *
 *  @param inputString 字符串内容
 *  @param path 文件路径
 */
+ (void) writeStringToFile: (NSString *) inputString 
                      Path: (NSString*) fileName
{
  NSString* path = [FileUtils getTempFilePath: fileName];
  //创建数据缓冲 
  NSMutableData *writer = [[NSMutableData alloc] init]; 
  //将字符串添加到缓冲中 
  [writer appendData: [inputString dataUsingEncoding: NSUTF8StringEncoding]]; 
  //将其他数据添加到缓冲中 
  //将缓冲的数据写入到文件中 
  [writer writeToFile: path atomically: YES]; 
}

/** 从文件中读取字符串内容
 *
 *  @param path 文件路径
 *  @return 字符串内容
 */
+ (NSString*) readStringFromFile: (NSString*) fileName
{
  NSString* path = [FileUtils getTempFilePath: fileName];
  NSString* str = [NSString stringWithContentsOfFile: path
                                            encoding: NSUTF8StringEncoding
                                               error: nil];
  return str;
} 

+ (void) writeObjectToFile: (id)object Path:(NSString*) fileName
{
  NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject: object];
  NSString* path = [FileUtils getTempFilePath: fileName];
  [udObject writeToFile:path atomically:YES];
}

+ (id) readObjectFromFile: (NSString*) fileName
{
  NSString* path = [FileUtils getTempFilePath: fileName];
  NSData *reader = [NSData dataWithContentsOfFile: path];//读取文件
  id object = [NSKeyedUnarchiver unarchiveObjectWithData:reader];//反序列化
  LOG(@"%@",object);
  return object;
}

/** 将数据存储在app的document目录下
 *
 * @param fileContent NSData*的文件内容
 * @param fileName 文件名称
 * @return 保存是否成功
 */
+ (BOOL) saveDataToFile: (NSData*) fileContent
               fileName: (NSString*) fileName
{
  NSString* filePath = [FileUtils getTempFilePath: fileName deleteExistsFile: YES];
  if (fileContent)
    return [fileContent writeToFile: filePath atomically: YES];
  return NO;
}

+ (NSData*) getDataFromFile: (NSString*) fileName
{
  NSString* filePath = [FileUtils getTempFilePath: fileName];
  NSData* reader = [NSData dataWithContentsOfFile: filePath];
  return reader;
}

+ (NSString*) getResourceFilePath: (NSString*) fileName
{
  NSString* path = nil;
  if (fileName)
  {
    NSRange dotIndex = [fileName rangeOfString: @"." options: NSBackwardsSearch];
    if (dotIndex.location != NSNotFound)
    {
      path = [[NSBundle mainBundle] pathForResource: [fileName substringToIndex: dotIndex.location]
                                             ofType: [fileName substringFromIndex: dotIndex.location + 1]];
    } else {
      path = [[NSBundle mainBundle] pathForResource: fileName ofType: nil];
    }
  }
  return path;
}

+ (NSString*) getTempFilePath: (NSString*) fileName
             deleteExistsFile: (BOOL) isDeleteExistsFile
{
  NSFileManager* fileManager = [NSFileManager defaultManager];
  NSError* error;
  
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex: 0];
  
  NSString* filePath = [documentsDirectory stringByAppendingPathComponent: fileName];
  LOG(@"%@", filePath);
  
  if(isDeleteExistsFile && [fileManager fileExistsAtPath: filePath])
  {
    [fileManager removeItemAtPath: filePath error: &error];
  }
  
  return filePath;
}

+ (NSString*) getTempFilePath: (NSString*) fileName
{  
  return [FileUtils getTempFilePath: fileName
                   deleteExistsFile: NO];
}

@end
