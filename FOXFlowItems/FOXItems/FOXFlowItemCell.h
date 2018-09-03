//
//  FOXFlowItem.h
//  FOXFlowItems
//
//  Created by XFoxer on 2017/12/19.
//  Copyright © 2017年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kFlowItemHeight = 30.0f;

@interface FOXFlowItemCell : UICollectionViewCell

- (void)setItemName:(NSString *)name;
- (void)setItemSelected:(BOOL)selected;

@end
