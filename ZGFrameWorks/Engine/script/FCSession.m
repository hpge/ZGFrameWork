//
//  FCSession.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FCSession.h"

@implementation FCSession

static FCSession* fcSession;

+ (void) load
{
  fcSession = [[FCSession alloc] init];
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
//+ (void) staticFree
//{
//	[fcSession release];
//}

/*
 * 全局变量
 *使用单例模式，整个应用中只存在一个实例对象
 */
- (id) init {
  if (self = [super init]) {
    session = [NSMutableDictionary dictionaryWithCapacity:10] ;
  }
  return (self);
}

/**
 * 获取FCSession实例.
 * @return FCSession FCSession实例
 */
+ (FCSession*) getInstance
{
  return fcSession;
}

/**
 * 根据Session中key获取与之对应的全局变量value.
 * @param key Session中的key
 * @return Object Session中与之对应的value
 */
- (id) getSessionByKey: (NSString*) key {
  id obj = [session objectForKey:key];
  return obj;
}

/**
 * 添加全局变量.
 * @param key key
 * @param value value
 */
- (void) setSession: (NSString*) key
                Obj: (id) obj {
  [session setObject:obj forKey:key];
}


/**
 * 根据Session的key删除与之对应的全局变量.
 * @param key  session的key
 */
- (void) removeSession: (NSString*) key {
  [session removeObjectForKey:key];
}

/**
 * 清除所有的Session
 */
- (void) clearSession {
  [session removeAllObjects];
}


@end