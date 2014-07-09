//
//  TBSwipTableViewCell.m
//  TBSwipTableViewCell
//
//  Created by jason on 9/7/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import "TBSwipTableViewCell.h"

#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 90


typedef NS_ENUM(NSInteger , TBSWTableInitMehod){
    TBSWTableInitWithView,
    TBSWTableInitWithButton
} ;


static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";


#pragma mark - SWUtilityButtonView

@interface SWUtilityButtonView : UIView

@property (nonatomic, strong) NSArray *utilityButtons;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, weak) TBSwipTableViewCell *parentCell;
@property (nonatomic) SEL utilityButtonSelector;



- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(TBSwipTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(TBSwipTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;


@end

@implementation SWUtilityButtonView

#pragma mark - SWUtilityButonView initializers

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(TBSwipTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super init];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(TBSwipTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
    }
    
    return self;
}

#pragma mark Populating utility buttons

- (CGFloat)calculateUtilityButtonWidth {
    CGFloat buttonWidth = kUtilityButtonWidthDefault;
    if (buttonWidth * _utilityButtons.count > kUtilityButtonsWidthMax) {
        CGFloat buffer = (buttonWidth * _utilityButtons.count) - kUtilityButtonsWidthMax;
        buttonWidth -= (buffer / _utilityButtons.count);
    }
    return buttonWidth;
}

- (CGFloat)utilityButtonsWidth {
    return (_utilityButtons.count * _utilityButtonWidth);
}

- (void)populateUtilityButtons {
    NSUInteger utilityButtonsCounter = 0;
    for (UIButton *utilityButton in _utilityButtons) {
        CGFloat utilityButtonXCord = 0;
        if (utilityButtonsCounter >= 1) utilityButtonXCord = _utilityButtonWidth * utilityButtonsCounter;
        [utilityButton setFrame:CGRectMake(utilityButtonXCord, 0, _utilityButtonWidth, CGRectGetHeight(self.bounds))];
        [utilityButton setTag:utilityButtonsCounter];
        [utilityButton addTarget:_parentCell action:_utilityButtonSelector forControlEvents:UIControlEventTouchDown];
        [self addSubview: utilityButton];
        utilityButtonsCounter++;
    }
}

@end


@interface TBSwipTableViewCell () <UIScrollViewDelegate> {
    TBSwipCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
}

// Scroll view to be added to UITableViewCell
@property (nonatomic, weak) UIScrollView *cellScrollView;

// The cell's height
@property (nonatomic) CGFloat height;

// Views that live in the scroll view
@property (nonatomic, weak) UIView *scrollViewContentView;


//two method init
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewRight;

@property (nonatomic, strong) UIView *leftUtilityView;
@property (nonatomic, strong) UIView *rightUtilityView;

// Used for row height and selection
@property (nonatomic, weak) UITableView *containingTableView;

// Flag the initWith method

@property (nonatomic, assign) TBSWTableInitMehod initWithMethod;



@end

@implementation TBSwipTableViewCell

#pragma mark Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightUtilityButtons = rightUtilityButtons;
        self.leftUtilityButtons = leftUtilityButtons;
        self.height = containingTableView.rowHeight;
        self.containingTableView = containingTableView;
        self.highlighted = NO;
        self.initWithMethod = TBSWTableInitWithButton;
        [self initializer];
    }
    
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityView:(UIView *)leftUtilityView rightUtilityView:(UIView *)rightUtilityView{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    self.rightUtilityView = rightUtilityView;
    self.leftUtilityView = leftUtilityView;
    self.containingTableView = containingTableView;
    self.height = containingTableView.rowHeight;
    self.highlighted = NO;
    self.initWithMethod = TBSWTableInitWithView;
    [self initializer];
    }
    return self;
    
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (void)initializer {
    // Set up scroll view that will host our cell content
    UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height)];
    cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityAllPadding], _height);
    cellScrollView.contentOffset = [self scrollViewContentOffset];
    cellScrollView.delegate = self;
    cellScrollView.showsHorizontalScrollIndicator = NO;
    cellScrollView.scrollEnabled = _cellScrollEnabled = YES;

    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
    [cellScrollView addGestureRecognizer:tapGestureRecognizer];
    
    self.cellScrollView = cellScrollView;
    
    // Set up the views that will hold the utility buttons
    if (_initWithMethod == TBSWTableInitWithButton) {
        SWUtilityButtonView *scrollViewButtonViewLeft = [[SWUtilityButtonView alloc] initWithUtilityButtons:_leftUtilityButtons parentCell:self utilityButtonSelector:@selector(leftUtilityButtonHandler:)];
        [scrollViewButtonViewLeft setFrame:CGRectMake([self leftUtilityWidth], 0, [self leftUtilityWidth], _height)];
        self.scrollViewButtonViewLeft = scrollViewButtonViewLeft;
        [self.cellScrollView addSubview:scrollViewButtonViewLeft];
        
        SWUtilityButtonView *scrollViewButtonViewRight = [[SWUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];
        [scrollViewButtonViewRight setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityWidth], _height)];
        self.scrollViewButtonViewRight = scrollViewButtonViewRight;
        [self.cellScrollView addSubview:scrollViewButtonViewRight];
        
        // Populate the button views with utility buttons
        [scrollViewButtonViewLeft populateUtilityButtons];
        [scrollViewButtonViewRight populateUtilityButtons];

    }else{
        [_leftUtilityView setFrame:CGRectMake([self leftUtilityWidth], 0, [self leftUtilityWidth], _height)];
        [_rightUtilityView setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityWidth], _height)];
        
        [self.cellScrollView addSubview:_leftUtilityView];
        [self.cellScrollView addSubview:_rightUtilityView];
        
    }

    
    // Create the content view that will live in our scroll view
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake([self leftUtilityWidth], 0, CGRectGetWidth(self.bounds), _height)];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.cellScrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    // Add the cell scroll view to the cell
    UIView *contentViewParent = self;
    if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = [self.subviews objectAtIndex:0];
    }
    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:cellScrollView atIndex:0];
    for (UIView *subview in cellSubviews) {
        [self.scrollViewContentView addSubview:subview];
    }
    
    self.cellScrollView.scrollEnabled = _cellScrollEnabled = YES;
}

#pragma mark UITableView Swip  Enable

-(void)setCellScrollEnabled:(BOOL)cellScrollEnabled
{
    if (_cellScrollEnabled != cellScrollEnabled) {
        _cellScrollEnabled = cellScrollEnabled;
        _cellScrollView.scrollEnabled = cellScrollEnabled;
    }
    NSLog(@"UITableViewCell setCellScrollEnabled: %@", cellScrollEnabled ? @"YES" : @"NO");
}

#pragma mark Selection

- (void)scrollViewPressed:(id)sender {
    if(_cellState == kTBSwipCellStateCenter) {
        // Selection hack
        if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [_containingTableView indexPathForCell:self];
            [self.containingTableView.delegate tableView:_containingTableView didSelectRowAtIndexPath:cellIndexPath];
        }
        // Highlight hack
        if (!self.highlighted) {
            self.scrollViewButtonViewLeft.hidden = YES;
            self.scrollViewButtonViewRight.hidden = YES;
            self.leftUtilityView.hidden = YES;
            self.rightUtilityView.hidden = YES;
            NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
            [self setHighlighted:YES];
        }
    } else {
        // Scroll back to center
        [self hideUtilityAnimated:YES];
    }
}

- (void)timerEndCellHighlight:(id)sender {
    if (self.highlighted) {
        self.leftUtilityView.hidden = NO;
        self.rightUtilityView.hidden = NO;
        self.scrollViewButtonViewLeft.hidden = NO;
        self.scrollViewButtonViewRight.hidden = NO;
        [self setHighlighted:NO];
    }
}

#pragma mark UITableViewCell overrides

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.scrollViewContentView.backgroundColor = backgroundColor;
}

#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerRightUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
    }
}

- (void)leftUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerLeftUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonTag];
    }
}

- (void)hideUtilityAnimated:(BOOL)animated {
    // Scroll back to center
    [self.cellScrollView setContentOffset:CGPointMake([self leftUtilityWidth], 0) animated:animated];
    _cellState = kTBSwipCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kTBSwipCellStateCenter];
    }
}


#pragma mark - Overriden methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityAllPadding], _height);
    
    self.cellScrollView.contentOffset = CGPointMake([self leftUtilityWidth], 0);
    
    self.scrollViewButtonViewLeft.frame = CGRectMake([self leftUtilityWidth], 0, [self leftUtilityWidth], _height);
    self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityWidth], _height);
    
    
    self.leftUtilityView.frame = CGRectMake([self leftUtilityWidth], 0, [self leftUtilityWidth], _height);
    self.rightUtilityView.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityWidth], _height);
    
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityWidth], 0, CGRectGetWidth(self.bounds), _height);
}

#pragma mark - Setup helpers

- (CGFloat)leftUtilityWidth {
    return (self.initWithMethod ==  TBSWTableInitWithButton) ?
    [_scrollViewButtonViewLeft utilityButtonsWidth] :
    [_leftUtilityView frame].size.width;
}

- (CGFloat)rightUtilityWidth {
    return (self.initWithMethod ==  TBSWTableInitWithButton) ?
    [_scrollViewButtonViewRight utilityButtonsWidth] :
    [_rightUtilityView frame].size.width;

}

- (CGFloat)utilityAllPadding {
    return (self.initWithMethod ==  TBSWTableInitWithButton) ?
    ([_scrollViewButtonViewLeft utilityButtonsWidth] + [_scrollViewButtonViewRight utilityButtonsWidth]) :
     [_leftUtilityView frame].size.width + [_rightUtilityView frame].size.width;
}

- (CGPoint)scrollViewContentOffset {
    
    return (self.initWithMethod ==  TBSWTableInitWithButton) ?
    CGPointMake([_scrollViewButtonViewLeft utilityButtonsWidth], 0):
    CGPointMake([_leftUtilityView frame].size.width, 0)
    ;
}

#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityAllPadding];
    _cellState = kTBSwipCellStateRight;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kTBSwipCellStateRight];
    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = [self leftUtilityWidth];
    _cellState = kTBSwipCellStateCenter;

    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kTBSwipCellStateCenter];
    }
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kTBSwipCellStateLeft;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kTBSwipCellStateLeft];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kTBSwipCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityAllPadding] - ([self rightUtilityWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kTBSwipCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x >= ([self utilityAllPadding] - [self rightUtilityWidth] / 2))
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x > [self leftUtilityWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kTBSwipCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= [self leftUtilityWidth] / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < ([self utilityAllPadding] - [self rightUtilityWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [self leftUtilityWidth]) {
        // Expose the right button view
        if (_initWithMethod ==  TBSWTableInitWithButton) {
            self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityWidth]), 0.0f, [self rightUtilityWidth], _height);
        }else{
            self.rightUtilityView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityWidth]), 0.0f, [self rightUtilityWidth], _height);
        }
    } else {
        // Expose the left button view
        if (_initWithMethod ==  TBSWTableInitWithButton) {
            self.scrollViewButtonViewLeft.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityWidth], _height);
        }else{
            self.leftUtilityView.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityWidth], _height);
        }
    }
}

@end


#pragma mark NSMutableArray class extension helper

@implementation NSMutableArray (TBSwipUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addObject:button];
}

- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setImage:icon forState:UIControlStateNormal];
    [self addObject:button];
}

@end

