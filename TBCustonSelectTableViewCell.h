//
//  TBCustonSelectTableViewCell.h
//
//  Created by jason on 14-7-7.
//  Copyright (c) 2014年Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TBCustSelectTableView;

@interface TBCustonSelectTableViewCell : UITableViewCell

@property (nonatomic,weak)   TBCustSelectTableView *tableView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,readonly, strong) UIButton *selectButton;
@property (nonatomic,assign,getter = isEditingFlag)  BOOL editingFlag;
@property (nonatomic,copy) void (^selectButtonClickBlock)(NSIndexPath *indexPath);
@end
