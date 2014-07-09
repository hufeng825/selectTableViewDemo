//
//  TBSwipTableViewCell.h
//  TBSwipTableViewCell
//
//  Created by jason on 9/7/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "TBCustonSelectTableViewCell.h"


@class TBSwipTableViewCell;

typedef enum {
    kTBSwipCellStateCenter,
    kTBSwipCellStateLeft,
    kTBSwipCellStateRight
} TBSwipCellState;


@interface NSMutableArray (TBSwipUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;

@end

@protocol TBSwipTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(TBSwipTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(TBSwipTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(TBSwipTableViewCell *)cell scrollingToState:(TBSwipCellState)state;

@end

@interface TBSwipTableViewCell : TBCustonSelectTableViewCell

@property (nonatomic,strong) NSArray *leftUtilityButtons;
@property (nonatomic,strong) NSArray *rightUtilityButtons;
@property (nonatomic,getter = isCellScrollEnabled) BOOL cellScrollEnabled;
@property (nonatomic,weak) id <TBSwipTableViewCellDelegate> delegate;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityView:(UIView *)leftUtilityView rightUtilityView:(UIView *)rightUtilityView;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityAnimated:(BOOL)animated;


@end



