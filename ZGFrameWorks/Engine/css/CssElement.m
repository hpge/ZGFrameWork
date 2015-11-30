//
//  CssElement.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-9.
//  Copyright 2012 Mar114. All rights reserved.
//

#import "CssElement.h"

@implementation CssElement

@synthesize _Name;
@synthesize _Attribute;

/**
 * 构造方法.
 * @param name 样式名称
 */
- (id) initWithName: (NSString*) name {
    if (self = [super init])
    {
        _Name = name;
        _Attribute = [[NSMutableDictionary alloc] init];
    }
    return self;
}


/**
 * 获取样式名称 .
 * @return String
 */
- (NSString*) get_Name {
    return _Name;
}

/**
 * 设置样式名称.
 * @param name 样式名称
 */
- (void) set_Name: (NSString*) name {
    _Name = name;
}

/**
 * 获取样式属性.
 * @return Map<String,String> 
 */
- (NSMutableDictionary*) get_Attribute {
    return _Attribute;
}

/**
 * 设置样式属性.
 * @param attribute 对应CSS元素
 */
- (void) set_Attribute: (NSMutableDictionary*) attribute {
    [_Attribute setValuesForKeysWithDictionary:attribute];
}

/**
 * 向CSS样式表中添加对应的元素
 * @param key 名称
 * @param value 值
 */
- (void) add_AttributeKey: (NSString*) key 
                    Value: (NSString*) value {
    [_Attribute setObject:value forKey:key];
}

//- (void) dealloc {
//    [_Attribute release];
//    [super dealloc];
//}

@end
