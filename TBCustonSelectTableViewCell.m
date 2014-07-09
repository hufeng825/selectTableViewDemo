//
//  TBCustonSelectTableViewCell.m
//
//  Created by jason on 14-7-7.
//  Copyright (c) 2014年Taobao. All rights reserved.
//

#import "TBCustonSelectTableViewCell.h"
#import "TBCustSelectTableView.h"

static const float kMoveLength = 35.f;


@implementation TBCustonSelectTableViewCell{

    UIButton *_selectButton;
    BOOL _isEditingFlag;
}



- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setFrame:CGRectMake(0., 25., 40, 40)];
        [_selectButton setImage:[UIImage imageNamed:@"tb_bg_checkbox_check"] forState:UIControlStateSelected];
        [_selectButton setImage:[UIImage imageNamed:@"tb_bg_checkbox_normal"] forState:UIControlStateNormal];
          [_selectButton setImage:[UIImage imageNamed:@"tb_bg_checkbox_disable"] forState:UIControlStateDisabled];
        [self.contentView addSubview:_selectButton];
        [_selectButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self layoutIfNeeded];
    }
    
    return _selectButton;
}

- (void)buttonClicked{
    if (_selectButtonClickBlock) {
        _selectButtonClickBlock(self.indexPath);
    }
    _selectButton.selected = !_selectButton.selected;
    [self operateDeleteArray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
    if (self.tableView.isEditing && !self.isEditingFlag )  {
        [self beginEditWithAnimation:animated];
    }
    if (!self.tableView.isEditing && self.isEditingFlag ) {
        [self endEditWithAnimation:animated];
    }
    
    if (self.tableView.isEditing) {
        NSIndexPath *index = [self findIndex:self.indexPath];
        index ? (self.selectButton.selected = YES) : (self.selectButton.selected = NO );

    }
}





-(void)beginEditWithAnimation:(BOOL)animated{
    if (animated) {
        self.selectButton.alpha = .3;
        [self addSubview:self.selectButton];
        [UIView animateWithDuration:.25   delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            for( UIView *subview in self.contentView.subviews )
            {
                subview.frame = CGRectMake(subview.frame.origin.x+kMoveLength, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height);
            }
            self.selectButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self bringSubviewToFront:self.selectButton];
            self.editingFlag =  YES;
            // self.selectDelButton.enabled = self.canDelete;
        }];
    }else{
        [self addSubview:self.selectButton];
        for( UIView *subview in self.contentView.subviews )
        {
            subview.frame = CGRectMake(subview.frame.origin.x+kMoveLength, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height);
        }
        self.editingFlag =  YES;
        [self bringSubviewToFront:self.selectButton];
    }
}

-(void)endEditWithAnimation:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:.25   delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            for( UIView *subview in self.contentView.subviews )
            {
                subview.frame = CGRectMake(subview.frame.origin.x-kMoveLength, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height);
            }
            self.selectButton.alpha = .3;
        } completion:^(BOOL finished) {
            self.editingFlag =  NO;
            [self.selectButton removeFromSuperview];
            //            self.selectDelButton.enabled = self.canDelete;
        }];
    }else{
        for( UIView *subview in self.contentView.subviews )
        {
            subview.frame = CGRectMake(subview.frame.origin.x-kMoveLength, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height);
        }
        self.editingFlag =  NO;
        [self.selectButton removeFromSuperview];
    }
    
}


- (void)operateDeleteArray{
    self.selectButton.selected ? [self addToSelectArray]:[self removeFromSelectArray];
}

- (void) addToSelectArray{
    if (self.indexPath ){
        NSIndexPath *index = [self findIndex:self.indexPath];
        !index ? [self.tableView.selectArray addObject:self.indexPath ]  : nil ;
    }
}

- (void)removeFromSelectArray{
    if (self.indexPath) {
        NSIndexPath *index = [self findIndex:self.indexPath];
        index ? [self.tableView.selectArray removeObject:self.indexPath ] :nil ;
    }
}

- (NSIndexPath *)findIndex :(NSIndexPath*)index{
    for (NSIndexPath *indexPath in  self.tableView.selectArray ) {
        if ([index compare:indexPath] == NSOrderedSame) {
            return indexPath;
        }
    }
    return nil;
}

@end
