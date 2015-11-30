//
//  CssElement.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-9.
//  Copyright 2012 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *封装CSS样式数据 
 *
 */
@interface CssElement : NSObject {
    NSString* _Name; //样式名称     
    NSMutableDictionary* _Attribute;//对应CSS元素    
}

@property (nonatomic, retain) NSString* _Name;
@property (nonatomic, retain) NSMutableDictionary* _Attribute;

- (id) initWithName: (NSString*) name;
/**
 * 获取样式名称 .
 * @return String
 */
- (NSString*) get_Name;
- (void) add_AttributeKey: (NSString*) key 
                    Value: (NSString*) value;

@end