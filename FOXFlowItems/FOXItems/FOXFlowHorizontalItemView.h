//
//  FOXHorizontalItemView.h
//  FOXFlowItems
//
//  Created by XFoxer on 2017/12/22.
//  Copyright © 2017年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FOXFlowHorizontalItemView;
@class FOXFlowItem;
@protocol FOXFlowHorizontalItemViewDelegate <NSObject>

@optional
- (void)horizontalItem:(FOXFlowHorizontalItemView *)itemView currentSelectItem:(FOXFlowItem *)selectItem;

@end

@interface FOXFlowHorizontalItemView : UIView
@property (nonatomic, weak)   id<FOXFlowHorizontalItemViewDelegate>delegate;
@property (nonatomic, strong) NSArray<NSString *> *horizontalDataSource;
@property (nonatomic, assign) NSUInteger defaultSelectIndex;

/** Custom rightView, default is a button */
- (void)showRightView:(UIView *)rightView;

@end
