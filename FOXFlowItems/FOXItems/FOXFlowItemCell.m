//
//  FOXFlowItem.m
//  FOXFlowItems
//
//  Created by XFoxer on 2017/12/19.
//  Copyright © 2017年 XFoxer. All rights reserved.
//

#import "FOXFlowItemCell.h"
#import <Masonry/Masonry.h>

#define FOX_PINK_COLOR     [UIColor colorWithRed:251./255 green:114./255 blue:153./255 alpha:1]
#define FOX_GRAY_COLOR_33  [UIColor colorWithWhite:33./255 alpha:1]
#define FOX_GRAY_COLOR_246 [UIColor colorWithWhite:246./255 alpha:1]

@interface FOXFlowItemCell ()

@property (nonatomic, strong) UILabel *itemLabel;

@end

@implementation FOXFlowItemCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.itemLabel];
        [self buildUI];
    }
    return self;
}

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.font = [UIFont systemFontOfSize:14.0f];
        [_itemLabel setTextAlignment:NSTextAlignmentCenter];
        [_itemLabel setTextColor:FOX_GRAY_COLOR_33];
        [_itemLabel setBackgroundColor:FOX_GRAY_COLOR_246];
        [_itemLabel.layer setBorderColor:FOX_GRAY_COLOR_33.CGColor];
        [_itemLabel.layer setBorderWidth:1.0];
        [_itemLabel.layer setMasksToBounds:YES];
        [_itemLabel.layer setCornerRadius:kFlowItemHeight/2];
    }
    return _itemLabel;
}

- (void)buildUI {
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setItemName:(NSString *)name {
    self.itemLabel.text = name;
}

- (void)setItemSelected:(BOOL)selected {
    if (selected) {
        [_itemLabel setTextColor:FOX_PINK_COLOR];
        [_itemLabel.layer setBorderColor:FOX_PINK_COLOR.CGColor];
    } else {
        [_itemLabel setTextColor:FOX_GRAY_COLOR_33];
        [_itemLabel.layer setBorderColor:FOX_GRAY_COLOR_33.CGColor];
    }
}


@end
