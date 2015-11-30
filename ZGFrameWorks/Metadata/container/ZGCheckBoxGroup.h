//
//  MarCheckBoxGroup.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGContainer.h"
#import "ZGCheckBox.h"


@interface ZGCheckBoxGroup :ZGContainer {
    NSMutableArray* checkBoxArray;
}

@property (nonatomic, retain) NSMutableArray* checkBoxArray;

- (void) addCheckBoxToGroup: (ZGCheckBox*) checkBox;

@end
