//
//  CssManager.h
//  mar_client_iphone
//
//  Created by Melvin1 on 12-3-30.
//  Copyright (c) 2012年 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CssManager : NSObject
{
@private
  //系统css
  NSMutableDictionary* systemCss;
  //各个组件的css
  NSMutableDictionary* compontentCss;
  //单个组件的css
  NSMutableDictionary* specCompontentCss;
}

+ (CssManager*) getInstance;
+ (void) staticFree;

/**
 * 设置系统css，向systemCss设置属性
 */
- (void) setSystemCss: (NSString*) name value: (NSString*) value;

- (void) setSystemCssWithDictionary: (NSDictionary*) dict;

/**
 * 获取系统css，返回systemCss
 */
- (NSDictionary*) getSystemCss;

/**
 * 向组件css字典里面设置css样式属性
 */
- (void) setCompontentCss: (NSString*) compontentName
                  cssName: (NSString*) cssName
                    value: (NSString*) value;

/**
 * 向组件css字典里面设置css样式属性
 */
- (void) setCompontentCss: (NSString*) compontentName
           withDictionary: (NSDictionary*) dict;

- (void) setSpecCompontentCss: (NSString*) compontentCombineId
               withDictionary: (NSDictionary*) dict;

/**
 * 向组件css字典里面设置css样式属性
 * @param compontentName 属性标签名
 * @param combinedID 页面ID+'.'+标签ID
 * @return
 */
- (NSDictionary*) getCompontentCss: (NSString*) compontentName
                        combinedID: (NSString*) compontentCombineId;

- (void) reset;

@end