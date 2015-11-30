///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarSelect.h
/// @brief
///
/// descirption
///
/// @version    0.0.1
/// @date       2011.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

#import "ZGComponent.h"

@interface ZGSelect : ZGComponent < UITableViewDelegate, UITableViewDataSource >{
    NSInteger count;
    UIView		*_currView;
    UILabel			*_selectContentLabel;
    UIButton		*_pulldownButton;
    UIButton		*_hiddenButton;
    UITableView		*_comboBoxTableView;
    NSArray			*_comboBoxDatasource;
    BOOL			_showComboBox;
}

@property (nonatomic, retain) NSArray *comboBoxDatasource;
@property (assign) UIView *_currView;

- (void)initVariables;
- (void)setContent:(NSString *)content;
- (void)show;
- (void)hidden;
- (void)drawListFrameWithFrame:(CGRect)frame withContext:(CGContextRef)context;
- (void)pulldownButtonWasClicked:(id)sender;

@end

