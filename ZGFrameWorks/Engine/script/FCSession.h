//
//  FCSession.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSession : NSObject {
    NSMutableDictionary* session;
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;
/**
 * 获取FCSession实例.
 * @return FCSession FCSession实例
 */
+ (FCSession*) getInstance;

/**
 * 添加全局变量.
 * @param key key
 * @param value value
 */
- (void) setSession: (NSString*) key
                Obj: (id) obj;

/**
 * 根据Session中key获取与之对应的全局变量value.
 * @param key Session中的key
 * @return Object Session中与之对应的value
 */
- (id) getSessionByKey: (NSString*) key;

/**
 * 根据Session的key删除与之对应的全局变量.
 * @param key  session的key
 */
- (void) removeSession: (NSString*) key;

/**
 * 清除所有的Session
 */
- (void) clearSession;
    
@end
