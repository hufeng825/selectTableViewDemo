//
//  TBCustSelectTableView.m
//
//  Created by jason on 14-7-8.
//  Copyright (c) 2014年Taobao. All rights reserved.
//

#import "TBCustSelectTableView.h"

@implementation TBCustSelectTableView

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [self setContentOffset:self.contentOffset animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super setEditing:editing animated:animated];
    });
}

- (void)selectAllIndex{
    [self.selectArray removeAllObjects];
    [self.selectArray addObjectsFromArray:[self getAllIndexPaths]];
    [self reloadData];
}


-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


- (NSArray *)getAllIndexPaths{
    NSInteger nSections = [self numberOfSections];
    NSMutableArray *array = [NSMutableArray array];
    for (int j=0; j<nSections; j++) {
        NSInteger nRows = [self numberOfRowsInSection:j];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
            [array addObject:indexPath];
        }
    }
    return array;
}


@end
