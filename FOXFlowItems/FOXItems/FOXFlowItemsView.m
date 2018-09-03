//
//  FOXFlowItemsView.m
//  FOXFlowItems
//
//  Created by XFoxer on 2017/12/19.
//  Copyright © 2017年 XFoxer. All rights reserved.
//

#import "FOXFlowItemsView.h"
#import "FOXFlowItemCell.h"
#import "FOXFlowAlignedFlowLayout.h"
#import <Masonry/Masonry.h>

@implementation FOXFlowItem

- (instancetype)initWithItemName:(NSString *)name {
    self = [super init];
    if (self) {
        _itemName = [name copy];
        _itemSize = [self _getItemSizeWithName:name];
    }
    return self;
}

#pragma mark - Private Methods

- (CGSize)_getItemSizeWithName:(NSString *)name {
    CGFloat hMargin = 6.0f;  ///top and bottom margin
    CGFloat sMagrin = 10.0f; ///left and rignt margin
    CGSize itemSize = [self _itemSizeWithFont:[UIFont systemFontOfSize:14] itemName:name];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat turthWidth = itemSize.width + 2*sMagrin;
    if (turthWidth > screenWidth) {
        turthWidth = 3*screenWidth/4;
    }
    
    return CGSizeMake(turthWidth, itemSize.height + 2*hMargin);
}

- (CGSize)_itemSizeWithFont:(UIFont *)itemFont itemName:(NSString *)name {
    NSDictionary *attributeName = @{ NSFontAttributeName : itemFont };
    return [name boundingRectWithSize:CGSizeZero
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attributeName context:nil].size;
}

@end



CGFloat kEdgeInsetOffset = 5.0f;

@interface FOXFlowItemsView() <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray <FOXFlowItem *>*itemArray;
@property (nonatomic, strong) UICollectionView *itemCollectionView;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign) FOXFlowItemsViewAlignmentType alignmentType;

@property (nonatomic, assign) NSUInteger currentSelectIndex;

@end

@implementation FOXFlowItemsView

- (instancetype)initWithDirection:(UICollectionViewScrollDirection)direction
                    alignmentType:(FOXFlowItemsViewAlignmentType)alignType {
    self = [super init];
    if (self) {
        self.scrollDirection = direction;
        self.alignmentType = alignType;
        [self addSubview:self.itemCollectionView];
        [self buildUI];
    }
    return self;
}

- (void)setDataSource:(NSArray<NSString *> *)dataSource {
    NSAssert(dataSource.count != 0, @"nil data input");
    
    self.itemArray = [NSMutableArray array];
    [dataSource enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger index, BOOL * _Nonnull stop) {
        FOXFlowItem *item = [[FOXFlowItem alloc] initWithItemName:obj];
        item.itemIndex = index;
        [self.itemArray addObject:item];
    }];
    [self.itemCollectionView reloadData];
}

#pragma mark  - Accessor

- (UICollectionView *)itemCollectionView {
    if (!_itemCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [self getFlowLayout];
        flowLayout.scrollDirection = self.scrollDirection;
        _itemCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _itemCollectionView.delegate = self;
        _itemCollectionView.dataSource = self;
        [_itemCollectionView setShowsHorizontalScrollIndicator:NO];
        [_itemCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_itemCollectionView registerClass:[FOXFlowItemCell class] forCellWithReuseIdentifier:[FOXFlowItemCell description]];
    }
    return _itemCollectionView;
}

- (UICollectionViewFlowLayout *)getFlowLayout {
    FOXFlowAlignedFlowLayout *flowLayout = [[FOXFlowAlignedFlowLayout alloc] init];
    flowLayout.flowAlignmentType = self.alignmentType;
    flowLayout.minimumLineSpacing = kEdgeInsetOffset;
    flowLayout.minimumInteritemSpacing = kEdgeInsetOffset;
    flowLayout.sectionInset = UIEdgeInsetsMake(kEdgeInsetOffset, kEdgeInsetOffset, kEdgeInsetOffset, kEdgeInsetOffset);
    return flowLayout;
}


- (void)buildUI {
    [self.itemCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (CGSize)itemViewContentSize {
    [self layoutIfNeeded];
    return self.itemCollectionView.contentSize;
}

- (void)setCurrentSelectItem:(FOXFlowItem *)currentSelectItem{
    self.currentSelectIndex = currentSelectItem.itemIndex;
    [self.itemCollectionView reloadData];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        NSIndexPath *selectIndex = [NSIndexPath indexPathForRow:currentSelectItem.itemIndex inSection:0];
        [self.itemCollectionView scrollToItemAtIndexPath:selectIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (FOXFlowItem *)currentSelectItem {
    return self.itemArray[self.currentSelectIndex];
}

- (void)setDefaultSelectIndex:(NSUInteger)defaultSelectIndex {
    self.currentSelectIndex = defaultSelectIndex;
    [self.itemCollectionView reloadData];
}

#pragma mark - CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FOXFlowItemCell *itemCell = (FOXFlowItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[FOXFlowItemCell description] forIndexPath:indexPath];
    return itemCell;
}

#pragma mark - CollectionView FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FOXFlowItem *item = self.itemArray[indexPath.row];
    CGSize collectionSize = collectionView.frame.size;
    return collectionSize.height == 0 ? CGSizeZero : item.itemSize ;
}


#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    FOXFlowItem *item = self.itemArray[indexPath.row];
    if ([cell isKindOfClass:[FOXFlowItemCell class]]) {
        FOXFlowItemCell *itemCell = (FOXFlowItemCell *)cell;
        [itemCell setItemName:item.itemName];
        if (self.currentSelectIndex == indexPath.row) {
            [itemCell setItemSelected:YES];
            [item setItemSelected:YES];
        } else {
            [itemCell setItemSelected:NO];
            [item setItemSelected:NO];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    [self changeSelectItemAtIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemView:itemDidSelected:)]) {
       [self.delegate itemView:self itemDidSelected:self.itemArray[indexPath.row]];
    }
}

- (void)changeSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.itemArray enumerateObjectsUsingBlock:^(FOXFlowItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
            obj.itemSelected = YES;
        } else {
            obj.itemSelected = NO;
        }
    }];
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentSelectIndex inSection:indexPath.section];
    FOXFlowItemCell *oldSelectCell = (FOXFlowItemCell *)[self.itemCollectionView cellForItemAtIndexPath:oldIndexPath];
    [oldSelectCell setItemSelected:NO];
    
    FOXFlowItemCell *currentSelectCell = (FOXFlowItemCell *)[self.itemCollectionView cellForItemAtIndexPath:indexPath];
    [currentSelectCell setItemSelected:YES];
    
    self.currentSelectIndex = indexPath.row;
}

@end
