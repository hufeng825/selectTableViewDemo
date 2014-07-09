//
//  ViewController.m
//  TBSwipTableViewCell
//
//  Created by jason on 9/7/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import "ViewController.h"
#import "TBSwipTableViewCell.h"
#import "TBCustonSelectTableViewCell.h"
#import "TBCustSelectTableView.h"
@interface ViewController () {
    NSMutableArray *_testArray;
}

@property (nonatomic, weak) IBOutlet TBCustSelectTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.allowsSelection = NO; // We essentially implement our own selection
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    
    _testArray = [[NSMutableArray alloc] init];
    
    // Add test data to our test array
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    [_testArray addObject:[NSDate date]];
    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        for (int i = 0; i < [_tableView numberOfSections]; i++) {
////            for (int j = 0; j < [_tableView numberOfRowsInSection:i]; j++) {
////                NSUInteger ints[2] = {i,j};
////                NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
////                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
////                //Here is your code
////            
////            }
////        }
//        [_tableView setEditing:YES animated:YES];
//    });
//    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_tableView selectAllIndex];
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _testArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{\
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %ld", (long)indexPath.row);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *cellIdentifier = @"tmp";
//    TBCustonSelectTableViewCell *cell = (TBCustonSelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    UILabel *label ;
//    if (cell == nil) {
//        cell =  [[TBCustonSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
//        [cell.contentView addSubview:label];
//        [label setBackgroundColor:[UIColor redColor]];
//    }
//    label.text = [NSString stringWithFormat:@"the index is %ld" ,(long)indexPath.row];
//    cell.tableView = (TBCustSelectTableView *)tableView;
//    cell.indexPath = indexPath;
//    return cell;
    
    
    
    if (indexPath.row !=2) {
    static NSString *cellIdentifier = @"Cell";
    
    TBSwipTableViewCell *cell = (TBSwipTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [leftUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                 icon:[UIImage imageNamed:@"check.png"]];
        [leftUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                 icon:[UIImage imageNamed:@"clock.png"]];
        [leftUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                 icon:[UIImage imageNamed:@"cross.png"]];
        [leftUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                 icon:[UIImage imageNamed:@"list.png"]];
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                 title:@"More"];
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 title:@"Delete"];
        
        cell = [[TBSwipTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:_tableView // Used for row height and selection
                                   leftUtilityButtons:leftUtilityButtons
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
        
    NSDate *dateObject = _testArray[indexPath.row];
    cell.textLabel.text = [dateObject description];
    cell.detailTextLabel.text = @"Some detail text";
//    cell.cellScrollEnabled = NO;
    return cell;
    }else{
        
        
        UIView *viewr = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        UIView *viewl = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 100, 40)];
        viewr.backgroundColor = [UIColor redColor];
        viewl.backgroundColor = [UIColor yellowColor];

       static NSString *cellIdentifierD = @"CellView";
          TBSwipTableViewCell *cell = (TBSwipTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierD];
        
        if (cell == nil) {
       
        cell = [[TBSwipTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"CellView"
                                  containingTableView:_tableView // Used for row height and selection
                                   leftUtilityView:viewl rightUtilityView:viewr];
        }
        cell.delegate = self;
        NSDate *dateObject = _testArray[indexPath.row];
        cell.textLabel.text = [dateObject description];
        cell.detailTextLabel.text = @"Some detail text";
        return cell;
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scroll view did begin dragging");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want white
}

#pragma mark - TBSwipTableViewDelegate

- (void)swippableTableViewCell:(TBSwipTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swippableTableViewCell:(TBSwipTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [_testArray removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
