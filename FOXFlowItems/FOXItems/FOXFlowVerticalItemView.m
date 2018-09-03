//
//  FOXFlowLayoutView.m
//  FOXFlowItems
//
//  Created by XFoxer on 2017/12/19.
//  Copyright © 2017年 XFoxer. All rights reserved.
//

#import "FOXFlowVerticalItemView.h"
#import <Masonry/Masonry.h>

static CGFloat const kBottomViewHeight = 45.0f;

@interface FOXFlowVerticalItemView()<FOXFlowItemDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UILabel *seprateLine;
@property (nonatomic, strong) FOXFlowItemsView *itemView;
@property (nonatomic, assign) FOXFlowItemsViewAlignmentType alignmentType;

@end

@implementation FOXFlowVerticalItemView

- (void)dealloc {
    NSLog(@"__%s__",__FUNCTION__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

+ (instancetype)initWithType:(FOXFlowItemsViewAlignmentType)alignType {
    FOXFlowVerticalItemView *verticalItemView = [[FOXFlowVerticalItemView alloc] initWithAlignmentType:alignType];
    return verticalItemView;
}

- (instancetype)initWithAlignmentType:(FOXFlowItemsViewAlignmentType)alignType {
    self = [super init];
    if (self) {
        self.alignmentType = alignType;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.itemView];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.seprateLine];
    [self.bottomView addSubview:self.dismissBtn];
    [self buildUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.backView addGestureRecognizer:tapGesture];
}

#pragma mark - Accesser

- (FOXFlowItemsView *)itemView {
    if (!_itemView) {
        kEdgeInsetOffset = 10.0f;
        _itemView = [[FOXFlowItemsView alloc] initWithDirection:UICollectionViewScrollDirectionVertical alignmentType:self.alignmentType];
        [_itemView setDelegate:self];
    }
    return _itemView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [_backView setBackgroundColor:[UIColor colorWithRed:101/255 green:101/255 blue:101/255 alpha:0.3]];
    }
    return _backView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [_bottomView setBackgroundColor:[UIColor grayColor]];
    }
    return _bottomView;
}

- (UILabel *)seprateLine {
    if (!_seprateLine) {
        _seprateLine = [[UILabel alloc] init];
        [_seprateLine setBackgroundColor:[UIColor blueColor]];
    }
    return _seprateLine;
}

- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setImage:[self backImage] forState:UIControlStateNormal];
        [_dismissBtn setTransform:CGAffineTransformMakeRotation(M_PI)];
        [_dismissBtn addTarget:self action:@selector(dismissItemView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setHidden:YES];
    }
    return _contentView;
}

- (void)buildUI {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(150.0f));
    }];
    
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    CGSize iamgeSize = [self backImage].size;
    [self.dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(iamgeSize.width + 15, iamgeSize.height + 15));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kBottomViewHeight));
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10.0f);
        make.right.equalTo(self.bottomView).offset(-10.0f);
        make.top.equalTo(self.bottomView);
        make.height.equalTo(@(1.0f));
    }];
}

- (UIImage *)backImage {
    return [UIImage imageNamed:@"common_downArrow"];
}

#pragma mark - Setter

- (void)setVerticalDataSource:(NSArray<NSString *> *)verticalDataSource {
    _verticalDataSource = [verticalDataSource copy];
    self.itemView.dataSource = [verticalDataSource copy];
}

- (void)showBottomView:(UIView *)customView {
    for (UIView *subView in self.bottomView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (customView) {
        [self.bottomView addSubview:customView];
        [customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomView);
        }];
    }
}

- (void)currentSelectViewItem:(FOXFlowItem *)selectItem; {
    self.itemView.currentSelectItem = selectItem;
}

#pragma mark - FOXFlowItemViewDelegate

- (void)itemView:(FOXFlowItemsView *)itemView itemDidSelected:(FOXFlowItem *)selectItem {
    [self dismissItemView];
}


#pragma mark - Show And Dismiss

- (void)showInView:(UIView *)parentView {
    [self setFrame:parentView.frame];
    [parentView addSubview:self];
    
    CGFloat contentHeight = [self contentViewHeight];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(contentHeight));
    }];
    
    [self.contentView setTransform:CGAffineTransformMakeTranslation(0, -contentHeight)];
    [self.contentView setHidden:NO];
    [UIView animateWithDuration:0.25 animations:^{
       [self.backView setAlpha:0.5];
       [self.contentView setTransform:CGAffineTransformMakeTranslation(0,0)];
    } completion:^(BOOL finished) {

    }];
}

- (void)dismissItemView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(verticalItem:currentSelectItem:)]) {
        [self.delegate verticalItem:self currentSelectItem:self.itemView.currentSelectItem];
    }
    
    CGFloat contentHeight = [self contentViewHeight];;
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setTransform:CGAffineTransformMakeTranslation(0, -contentHeight)];
        [self.backView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (CGFloat)contentViewHeight {
    CGFloat visibleHeight = [self.itemView itemViewContentSize].height + kBottomViewHeight;
    if (visibleHeight > self.frame.size.height*2/3) {
        visibleHeight = self.frame.size.height*2/3;
    }
    return visibleHeight;
}

- (void)tapAction {
    [self dismissItemView];
}


@end
