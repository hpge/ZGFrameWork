///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   FileUtils.h
/// @brief  定义文件工具类
///
/// 该文件定义了文件工具类
///
/// @version    0.0.1
/// @date       2011.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

/** 文件工具类
 *
 *  该类用于实现文件的读取，写入，查找等相关操作
 */
@interface FileUtils : NSObject
{
}

/** 从程序包中读取文件
 *
 *  该方法从ipa包中读取文件，并转换为NSData数据
 *  @param fileName 文件名称
 *  @return 该文件中的数据，如果文件没有找到则返回nil
 */
+ (NSData*) loadXMLFromResource: (NSString*) fileName;

/** 从网络上读取文件
 *
 *  该方法从网络上读取xml文件，并转换为NSData数据
 *  @param urlStr 文件名称
 *  @return 该文件中的数据，如果文件没有找到则返回nil
 */
+ (NSData*) loadXMLFromURL: (NSString*) urlStr;

/** 把字典写入文件中
 *
 *  @param dict 字典内容
 *  @param path 文件路径
 */
+ (void) writeDictionaryToFile: (NSDictionary *)dict 
                          Path: (NSString *)path;

/** 从文件中读取字典信息
 *
 *  @param path 文件路径
 *  @return 字典信息
 */
+ (NSDictionary*) readDictionaryFromFile: (NSString*)path;

/** 将数据存储在app的document目录下
 *
 * @param fileContent NSData*的文件内容
 * @param fileName 文件名称
 * @return 保存是否成功
 */
+ (BOOL) saveDataToFile: (NSData*) fileContent
               fileName: (NSString*) fileName;

+ (NSData*) getDataFromFile: (NSString*) fileName;

+ (NSString*) getResourceFilePath: (NSString*) fileName;

+ (NSString*) getTempFilePath: (NSString*) fileName;

+ (NSString*) getTempFilePath: (NSString*) fileName
             deleteExistsFile: (BOOL) isDeleteExistsFile;
@end