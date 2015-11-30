//
//  FCTreeNode.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 判断表达式.
 */
#define E_OP 0
/**
 * 赋值表达式.
 */
#define E_VAL 1


@interface FCTreeNode : NSObject {
    /**
     * FCETreeNode是解析时使用的哈夫曼树.
     * 
     */
    
    /**
     * 节点类型 1.判断操作符(OP) 2.赋值操作符.
     */
    int type;
    
    /**
     * 值 1.操作符的值(如> < = ) 2.变量的值.
     */
    id value;
    
    /**
     * 左节点 存操作符左边数据
     */
    FCTreeNode *left;
    
    /**
     * 右节点 存操作符右边数据.
     */
    FCTreeNode *right;
    
    /**
     * 父亲节点（存操作符）.
     */
    FCTreeNode *parent;
    
}

@property int type;
@property (nonatomic, retain) id value;
@property (nonatomic, retain) FCTreeNode *left;
@property (nonatomic, retain) FCTreeNode *right;
@property (nonatomic, retain) FCTreeNode *parent;

@end
