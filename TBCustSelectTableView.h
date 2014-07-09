//
//  TBCustSelectTableView.h
//
//  Created by jason on 14-7-8.
//  Copyright (c) 2014年Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBCustSelectTableView : UITableView

@property (nonatomic,strong) NSMutableArray *selectArray;

/*
 *重载setedit 方法 防止uitablview 滑动时调用 应先把tableview 停止在调用动画
 *overwrite method
 */
-(void)setEditing:(BOOL)editing animated:(BOOL)animated;

- (void)selectAllIndex;

@end
