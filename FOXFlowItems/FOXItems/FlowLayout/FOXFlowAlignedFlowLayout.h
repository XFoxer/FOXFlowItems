//
//  FOXFlowLeftAlignedLayout.h
//  FOXFlowItems
//
//  Created by XFoxer on 2018/1/25.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,FOXFlowItemsViewAlignmentType) {
    FOXFlowItemsViewAlignmentDefault,   ///The system default aligenment,Fully-justified,The last line in a paragraph is natural-aligned.
    FOXFlowItemsViewAlignmentJustified, ///Fully-justified. The item in one line will FitSize to adjuest minimumInteritemSpacing
    FOXFlowItemsViewAlignmentLeft,      ///Left aligenment
    FOXFlowItemsViewAlignmentRight,     ///Right aligenment
    FOXFlowItemsViewAlignmentCenter     ///Center aligenment
};

@interface FOXFlowAlignedFlowLayout : UICollectionViewFlowLayout

/// Collectionview items alignment type
@property (nonatomic, assign) FOXFlowItemsViewAlignmentType flowAlignmentType;

@end
