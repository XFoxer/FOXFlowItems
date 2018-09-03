//
//  FOXHorizontalItemView.m
//  FOXFlowItems
//
//  Created by XFoxer on 2017/12/22.
//  Copyright © 2017年 XFoxer. All rights reserved.
//

#import "FOXFlowHorizontalItemView.h"
#import "FOXFlowItemsView.h"
#import "FOXFlowVerticalItemView.h"
#import <Masonry/Masonry.h>

@interface FOXFlowHorizontalItemView()<FOXFlowItemDelegate,FOXFlowVerticalItemViewDelegate>

@property (nonatomic, strong) FOXFlowItemsView *itemView;
@property (nonatomic, strong) FOXFlowVerticalItemView *verticalView;
@property (nonatomic, strong) UIView *rightCustomView;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation FOXFlowHorizontalItemView

- (void)dealloc {
    NSLog(@"__%s__",__FUNCTION__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.itemView];
        [self addSubview:self.rightCustomView];
        [self.rightCustomView addSubview:self.rightBtn];
        [self buildUI];
    }
    return self;
}

- (FOXFlowItemsView *)itemView {
    if (!_itemView) {
        _itemView = [[FOXFlowItemsView alloc] initWithDirection:UICollectionViewScrollDirectionHorizontal alignmentType:FOXFlowItemsViewAlignmentDefault];
        [_itemView setDelegate:self];
    }
    return _itemView;
}

- (FOXFlowVerticalItemView *)verticalView {
    if (!_verticalView) {
        _verticalView = [[FOXFlowVerticalItemView alloc] initWithAlignmentType:FOXFlowItemsViewAlignmentJustified];
        _verticalView.verticalDataSource = [_horizontalDataSource copy];
        _verticalView.delegate = self;
    }
    return _verticalView;
}

- (UIView *)rightCustomView {
    if (!_rightCustomView) {
        _rightCustomView = [UIView new];
        [_rightCustomView setBackgroundColor:[UIColor lightGrayColor]];
        [_rightCustomView.layer setShadowOffset:CGSizeMake(0, -3)];
        [_rightCustomView.layer setShadowColor:[UIColor lightTextColor].CGColor];
    }
    return _rightCustomView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[self rightBtnImage] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)buildUI {
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.right.equalTo(self.rightCustomView.mas_left);
    }];
    
    [self.rightCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.itemView.mas_right);
        make.width.equalTo(@(50.0f));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rightCustomView);
    }];
}

- (UIImage *)rightBtnImage {
    return [UIImage imageNamed:@"common_downArrow"];
}

- (void)setDefaultSelectIndex:(NSUInteger)defaultSelectIndex {
    self.itemView.defaultSelectIndex = defaultSelectIndex;
}

#pragma mark - FOXFlowItemsViewDelegate

- (void)itemView:(FOXFlowItemsView *)itemView itemDidSelected:(FOXFlowItem *)selectItem{
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalItem:currentSelectItem:)]) {
        [self.delegate horizontalItem:self currentSelectItem:selectItem];
    }
}

#pragma mark - FOXFlowVerticalItemViewDelegate

- (void)verticalItem:(FOXFlowVerticalItemView *)itemView currentSelectItem:(FOXFlowItem *)selectItem {
    self.itemView.currentSelectItem = selectItem;
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalItem:currentSelectItem:)]) {
        [self.delegate horizontalItem:self currentSelectItem:selectItem];
    }
}

#pragma mark - Setter

- (void)setHorizontalDataSource:(NSArray<NSString *> *)horizontalDataSource {
    _horizontalDataSource = [horizontalDataSource copy];
    self.itemView.dataSource = [horizontalDataSource copy];
}

- (void)showRightView:(UIView *)rightView {
    for (UIView *subView in self.rightCustomView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (self.itemView.superview) {
        [self.rightCustomView removeFromSuperview];
    }

    if (rightView) {
        [self addSubview:self.rightCustomView];
        [self.rightCustomView addSubview:rightView];

        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.rightCustomView);
        }];

        [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.right.equalTo(self.rightCustomView.mas_left);
        }];

        [self.rightCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.left.equalTo(self.itemView.mas_right);
            make.width.equalTo(@(50.0f));
        }];
    }
}

#pragma mark - Action
- (void)rightBtnAction:(UIButton *)btn {
    UIView *parentView = self.superview;
    [self.verticalView currentSelectViewItem:self.itemView.currentSelectItem];
    [self.verticalView showInView:parentView];
}

@end
