//
//  FOXFlowItemsView.h
//  FOXFlowItems
//
//  Created by XFoxer on 2017/12/19.
//  Copyright © 2017年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FOXFlowAlignedFlowLayout.h"


@class FOXFlowItem;
@class FOXFlowItemsView;
@protocol FOXFlowItemDelegate <NSObject>

- (void)itemView:(FOXFlowItemsView *)itemView itemDidSelected:(FOXFlowItem *)selectItem;

@end



@interface  FOXFlowItem : NSObject 

@property (nonatomic, copy)   NSString *itemName;
@property (nonatomic, assign) CGSize itemSize; ///originSize
@property (nonatomic, assign) NSUInteger itemIndex;
@property (nonatomic, assign) BOOL itemSelected;

- (instancetype)initWithItemName:(NSString *)name;

@end


UIKIT_EXTERN CGFloat kEdgeInsetOffset;

@interface FOXFlowItemsView : UIView
@property (nonatomic, weak)   id<FOXFlowItemDelegate>delegate;
@property (nonatomic, strong) NSArray<NSString *> *dataSource;

//Highlight the item, which means the item is selected
@property (nonatomic, assign) FOXFlowItem *currentSelectItem;

//The first layout select index, default is 0
@property (nonatomic, assign) NSUInteger defaultSelectIndex;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)new  UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithDirection:(UICollectionViewScrollDirection)direction
                    alignmentType:(FOXFlowItemsViewAlignmentType)alignType;

- (CGSize)itemViewContentSize;

@end
