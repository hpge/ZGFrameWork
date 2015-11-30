//
//  CssOperate.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-9.
//  Copyright 2012 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CssKeyWord.h"
#import "CssElement.h"
#import "ZGComponent.h"
#import "UIPropertiesLoader.h"
#import "FCSException.h"

/**
 * 控件Css样式操作类
 */
@interface CssOperate : NSObject {
    int tType;// 类型
    ZGComponent* fcWidget;// 修改
    BOOL is_SingleWidget;// 单独空间设置    
}

- (void) operateWidgets: (NSArray*) list;
- (void) reSet;

@end


    
    

