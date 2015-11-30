//
//  CssManager.m
//  mar_client_iphone
//
//  Created by Melvin1 on 12-3-30.
//  Copyright (c) 2012年 Mar114. All rights reserved.
//

#import "CssManager.h"

@implementation CssManager

static CssManager* instance;

#pragma mark -
#pragma mark init & dealloc

+ (void) load
{
  instance = [[CssManager alloc] init];
}

//+ (void) staticFree
//{
//  [instance release];
//  instance = nil;
//}

+ (CssManager*) getInstance
{
  return instance;
}

- (id) init
{
  if (self = [super init])
  {
    systemCss = [[NSMutableDictionary alloc] initWithCapacity: 3];
    compontentCss = [[NSMutableDictionary alloc] initWithCapacity: 3];
    specCompontentCss = [[NSMutableDictionary alloc] initWithCapacity: 3];
  }
  return self;
}

//- (void) dealloc
//{
//  [systemCss release];
//  [compontentCss release];
//  [specCompontentCss release];
//  [super dealloc];
//}

#pragma mark -
#pragma mark get or set css

/**
 * 设置系统css，向systemCss设置属性
 */
- (void) setSystemCss: (NSString*) name value: (NSString*) value
{
  [systemCss setValue:value forKey:name];
}

- (void) setSystemCssWithDictionary: (NSDictionary*) dict
{
  [systemCss addEntriesFromDictionary: dict];
}

/**
 * 获取系统css，返回systemCss
 */
- (NSDictionary*) getSystemCss
{
  return systemCss;
}

//
/**
 * 向组件css字典里面设置css样式属性
 */
- (void) setCompontentCss: (NSString*) compontentName
                  cssName: (NSString*) cssName
                    value: (NSString*) value
{
  NSMutableDictionary *dict = [compontentCss objectForKey: compontentName];
  if (!dict)
  {
    dict = [[NSMutableDictionary alloc] init];
    [compontentCss setObject: dict forKey: compontentName];
  }
  [dict setObject: value forKey: cssName];
}

/**
 * 向组件css字典里面设置css样式属性
 */
- (void) setCompontentCss: (NSString*) compontentName
           withDictionary: (NSDictionary*) dict
{
  NSMutableDictionary *compDict = [compontentCss objectForKey: compontentName];
  if (!dict)
  {
    compDict = [[NSMutableDictionary alloc] init];
    [compontentCss setObject: compDict forKey: compontentName];
  }
  [compDict addEntriesFromDictionary: dict];
}

- (void) setSpecCompontentCss: (NSString*) compontentCombineId
               withDictionary: (NSDictionary*) dict
{
  NSMutableDictionary *specDict = [specCompontentCss objectForKey: compontentCombineId];
  if (!specDict)
  {
    specDict = [[NSMutableDictionary alloc] init];
    [specCompontentCss setObject: specDict forKey: compontentCombineId];
  }
  [specDict addEntriesFromDictionary: dict];
}

/**
 * 向组件css字典里面设置css样式属性
 */
- (NSDictionary*) getCompontentCss: (NSString*) compontentName
                        combinedID: (NSString*) compontentCombineId
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: systemCss];
  NSMutableDictionary* compontentDict = [compontentCss objectForKey: compontentName];
  if (compontentDict)
  {
    [dict addEntriesFromDictionary: compontentDict];
  }
  NSMutableDictionary* specDict = [specCompontentCss objectForKey: compontentCombineId];
  if (specDict)
  {
    [dict addEntriesFromDictionary: specDict];
  }
  return dict;
}

- (void) reset
{
  [systemCss removeAllObjects];
  [compontentCss removeAllObjects];
  [specCompontentCss removeAllObjects];
}

@end