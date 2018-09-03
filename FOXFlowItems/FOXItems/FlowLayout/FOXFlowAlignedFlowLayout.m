//
//  FOXFlowLeftAlignedLayout.m
//  FOXFlowItems
//
//  Created by XFoxer on 2018/1/25.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "FOXFlowAlignedFlowLayout.h"

@implementation FOXFlowAlignedFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    //Nothing TODO:
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray <UICollectionViewLayoutAttributes *> *attributesArray = [super layoutAttributesForElementsInRect:rect];
    
    if (self.flowAlignmentType == FOXFlowItemsViewAlignmentJustified) {
        return [self layoutAttributesForJustifiedAlignmentWithArray:attributesArray];
    }
    else if (self.flowAlignmentType == FOXFlowItemsViewAlignmentCenter) {
        return [self layoutAttributesForCenterAlignmentWithArray:attributesArray];
    }
    else {
        for (UICollectionViewLayoutAttributes *attrbutes in attributesArray) {
            if (nil == attrbutes.representedElementKind) {
                NSIndexPath *indexPath = attrbutes.indexPath;
                attrbutes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
            }
        }
        return attributesArray;
    }
}


- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes;
    switch (self.flowAlignmentType) {
        case FOXFlowItemsViewAlignmentLeft:
        {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                attributes = [self layoutAttributesForLeftAlignmentForItemAtIndexPath:indexPath];
            } else {
                attributes = [self layoutAttributesForTopAlignmentForItemAtIndexPath:indexPath];
            }
        }
            break;
        case FOXFlowItemsViewAlignmentRight:
        {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                attributes = [self layoutAttributesForRightAlignmentForItemAtIndexPath:indexPath];
            } else {
                attributes = [self layoutAttributesForBottomAlignmentForItemAtIndexPath:indexPath];
            }
        }
            break;
        case FOXFlowItemsViewAlignmentDefault:
        {
            attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
        }
            break;
            
            
        default:
            attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
            break;
    }
    return attributes;
}

#pragma mark - Sort And Fillter Attrbutes

- (NSArray <NSArray *> *)sortAndFilterAttributesWithArray:(NSArray <UICollectionViewLayoutAttributes *> *)originAttributes {
    NSMutableArray *itemAttributesArray = [NSMutableArray new];
    NSMutableDictionary *rowAttributesDict = [NSMutableDictionary new];
    NSArray *copyOriginAttributes = [originAttributes copy];
    
    ///Get equel origin.y, which means attributes in one line
    for (UICollectionViewLayoutAttributes *attrbutes in copyOriginAttributes) {
        if (nil == attrbutes.representedElementKind) {
            NSString *originY = [NSString stringWithFormat:@"%f",attrbutes.frame.origin.y];
            [rowAttributesDict  setObject:@(attrbutes.hash) forKey:originY];
        }
    }
    
    ///Sort origin.y ascend
    NSArray *frameOriginYArray = [rowAttributesDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString *_Nonnull obj2) {
        NSUInteger first = [obj1 integerValue];
        NSUInteger second = [obj2 integerValue];
        return [@(first) compare:@(second)]; //升序
    }];
    
    //Filter attributes in one line
    for (NSString *originY in frameOriginYArray) {
        NSMutableArray *lineAttributesArray = [NSMutableArray new];
        for (UICollectionViewLayoutAttributes *attrbutes in copyOriginAttributes) {
            NSString *frameOriginY = [NSString stringWithFormat:@"%f",attrbutes.frame.origin.y];
            if ([frameOriginY isEqualToString:originY]) {
                [lineAttributesArray addObject:attrbutes];
            }
        }
        [itemAttributesArray addObject:lineAttributesArray];
    }
    
    return [itemAttributesArray copy];
}




#pragma mark - AlignmentLeft

- (UICollectionViewLayoutAttributes *)layoutAttributesForLeftAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    
    if (attributes.frame.origin.x <= self.sectionInset.left) {
        return attributes;
    }
    
    if (indexPath.item == 0) {
        frame.origin.x = self.sectionInset.left + self.minimumInteritemSpacing;
    } else {
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes *previousAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
        
        if (attributes.frame.origin.y > previousAttributes.frame.origin.y) {
            frame.origin.x = self.sectionInset.left + self.minimumInteritemSpacing;
        } else {
            frame.origin.x = CGRectGetMaxX(previousAttributes.frame) + self.minimumInteritemSpacing;
        }
    }
    
    attributes.frame = frame;
    
    return attributes;
}

#pragma mark - AlignmentTop

- (UICollectionViewLayoutAttributes *)layoutAttributesForTopAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    
    if (attributes.frame.origin.y <= self.sectionInset.top) {
        return attributes;
    }
    
    if (indexPath.item == 0) {
        frame.origin.y = self.sectionInset.top;
    } else {
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes *previousAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
        
        if (attributes.frame.origin.x > previousAttributes.frame.origin.x) {
            frame.origin.y = self.sectionInset.top;
        } else {
            frame.origin.y = CGRectGetMaxY(previousAttributes.frame) + self.minimumInteritemSpacing;
        }
    }
    
    attributes.frame = frame;
    
    return attributes;
}

#pragma mark - AlignmentRight

- (UICollectionViewLayoutAttributes *)layoutAttributesForRightAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    
    if (CGRectGetMaxX(attributes.frame) >= self.collectionViewContentSize.width - self.sectionInset.right) {
        return attributes;
    }
    
    if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
        frame.origin.x = self.collectionViewContentSize.width - self.sectionInset.right - frame.size.width - self.minimumInteritemSpacing;
    } else {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes *nextAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
        
        if (attributes.frame.origin.y < nextAttributes.frame.origin.y) {
            frame.origin.x = self.collectionViewContentSize.width - self.sectionInset.right - frame.size.width - self.minimumInteritemSpacing;
        } else {
            frame.origin.x = nextAttributes.frame.origin.x - self.minimumInteritemSpacing - attributes.frame.size.width;
        }
    }
    
    attributes.frame = frame;
    
    return attributes;
}

#pragma mark - AlignmentBottom

- (UICollectionViewLayoutAttributes *)layoutAttributesForBottomAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    
    if (CGRectGetMaxY(attributes.frame) >= self.collectionViewContentSize.height - self.sectionInset.left) {
        return attributes;
    }
    
    if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section]) {
        frame.origin.y = self.collectionViewContentSize.height - self.sectionInset.bottom - frame.size.height;
    } else {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes *nextAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
        
        if (attributes.frame.origin.x < nextAttributes.frame.origin.x) {
            frame.origin.y = self.collectionViewContentSize.height - self.sectionInset.bottom - frame.size.height;
        } else {
            frame.origin.y = nextAttributes.frame.origin.y - self.minimumInteritemSpacing - attributes.frame.size.height;
        }
    }
    
    attributes.frame = frame;
    
    return attributes;
}

#pragma mark - AlignmentCenter

- (NSArray <UICollectionViewLayoutAttributes *> *)layoutAttributesForCenterAlignmentWithArray:(NSArray <UICollectionViewLayoutAttributes *> *)originAttributes
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return originAttributes;
    }
    
    NSArray <NSArray *> *sortAttributes = [self sortAndFilterAttributesWithArray:originAttributes];
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) -self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    NSMutableArray <UICollectionViewLayoutAttributes *> *attributesArray = [NSMutableArray new];
    for (NSArray <UICollectionViewLayoutAttributes *> *filterArray in sortAttributes) {
        CGFloat totalItemWidth = 0.0f;
        for (UICollectionViewLayoutAttributes *attribute in filterArray) {
            totalItemWidth += attribute.frame.size.width;
        }

        CGFloat totalInterSpaceX = (filterArray.count - 1)*self.minimumInteritemSpacing;
        CGFloat startPostionX = (collectionViewWidth - totalItemWidth - totalInterSpaceX)/2;
        UICollectionViewLayoutAttributes *cacheAttributes;
        for (UICollectionViewLayoutAttributes *attrbutes in filterArray) {
            if (nil == attrbutes.representedElementKind) {
                NSInteger index = [filterArray indexOfObject:attrbutes];
                CGRect frame = attrbutes.frame;
                if (index == 0) {
                    frame.origin.x = startPostionX;
                } else {
                    frame.origin.x = CGRectGetMaxX(cacheAttributes.frame) + self.minimumInteritemSpacing;
                }
                attrbutes.frame = frame;
                cacheAttributes = attrbutes;
                [attributesArray addObject:attrbutes];
            }
        }
    }
    
    return attributesArray;
}


#pragma mark - AlignmentJustified

- (NSArray <UICollectionViewLayoutAttributes *> *)layoutAttributesForJustifiedAlignmentWithArray:(NSArray <UICollectionViewLayoutAttributes *> *)originAttributes
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return originAttributes;
    }
    
    NSArray <NSArray *> *sortAttributes = [self sortAndFilterAttributesWithArray:originAttributes];
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) -self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    NSMutableArray <UICollectionViewLayoutAttributes *> *attributesArray = [NSMutableArray new];
    for (NSArray <UICollectionViewLayoutAttributes *> *filterArray in sortAttributes) {
        CGFloat totalItemWidth = 0.0f;
        for (UICollectionViewLayoutAttributes *attribute in filterArray) {
            totalItemWidth += attribute.frame.size.width;
        }
        
        CGFloat totalInterSpaceX = (filterArray.count + 1)*self.minimumInteritemSpacing;
        CGFloat preWidth = (collectionViewWidth - totalItemWidth - totalInterSpaceX)/[filterArray count];
        UICollectionViewLayoutAttributes *cacheAttributes;
        for (UICollectionViewLayoutAttributes *attrbutes in filterArray) {
            if (nil == attrbutes.representedElementKind) {
                NSInteger index = [filterArray indexOfObject:attrbutes];
                CGRect frame = attrbutes.frame;
                if (index == 0) {
                    frame.origin.x = self.minimumInteritemSpacing;
                    frame.size.width += preWidth;
                } else {
                    frame.origin.x = CGRectGetMaxX(cacheAttributes.frame) + self.minimumInteritemSpacing;
                    frame.size.width += preWidth;
                }
                attrbutes.frame = frame;
                cacheAttributes = attrbutes;
                [attributesArray addObject:attrbutes];
            }
        }
    }
    
    return attributesArray;
}


@end
