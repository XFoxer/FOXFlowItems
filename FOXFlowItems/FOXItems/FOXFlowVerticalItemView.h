//
//  FOXFlowLayoutView.h
//  FOXFlowItems
//
//  Created by XFoxer on 2017/12/19.
//  Copyright © 2017年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FOXFlowItemsView.h"


@class FOXFlowVerticalItemView;
@protocol FOXFlowVerticalItemViewDelegate <NSObject>
@optional
- (void)verticalItem:(FOXFlowVerticalItemView *)itemView currentSelectItem:(FOXFlowItem *)selectItem;

@end

@interface FOXFlowVerticalItemView : UIView
@property (nonatomic, weak)   id<FOXFlowVerticalItemViewDelegate>delegate;
@property (nonatomic, strong) NSArray<NSString *> *verticalDataSource;

+ (instancetype)initWithType:(FOXFlowItemsViewAlignmentType)alignType;
- (instancetype)initWithAlignmentType:(FOXFlowItemsViewAlignmentType)alignType;

- (void)currentSelectViewItem:(FOXFlowItem *)selectItem;

/** Custom bottomView，will replace the default bottomView */
- (void)showBottomView:(UIView *)bottomView;

/** show view */
- (void)showInView:(UIView *)parentView;

@end
