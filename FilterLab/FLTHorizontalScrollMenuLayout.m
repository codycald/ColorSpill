//
//  FLTHorizontalScrollMenuLayout.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/26/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTHorizontalScrollMenuLayout.h"

static NSString *const FLTMenuItemCellLayout = @"FLTMenuItemCellLayout";
static NSString *const FLTMenuItemTitleLayout = @"FLTMenuItemTitleLayout";

@interface FLTHorizontalScrollMenuLayout ()

@property (strong, nonatomic) NSMutableDictionary *layoutInfo;

@end

@implementation FLTHorizontalScrollMenuLayout

#pragma mark - Initializers

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupDefaults];
    }
    return self;
}

#pragma mark - Overrides

- (void)prepareLayout {
    
    NSMutableDictionary *cellViewLayouts = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleViewLayouts = [NSMutableDictionary dictionary];
    
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    
    for (NSInteger i = 0; i < numSections; ++i) {
        
        NSInteger numItems = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numItems; ++j) {
            
            indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *cellLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            UICollectionViewLayoutAttributes *titleViewLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"title" withIndexPath:indexPath];
            
            cellLayoutAttributes.frame = [self frameForCellWithIndexPath:indexPath];
            titleViewLayoutAttributes.frame = [self frameForTitleWithIndexPath:indexPath];
            
            cellViewLayouts[indexPath] = cellLayoutAttributes;
            titleViewLayouts[indexPath] = titleViewLayoutAttributes;
        }
    }
    self.layoutInfo[FLTMenuItemCellLayout] = cellViewLayouts;
    self.layoutInfo[FLTMenuItemTitleLayout] = titleViewLayouts;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *resultLayoutAttributes = [NSMutableArray array];
    
    for (NSString *key in self.layoutInfo) {
        NSDictionary *typeLayoutInfo = self.layoutInfo[key];
        
        for (NSIndexPath *indexPath in typeLayoutInfo) {
            
            UICollectionViewLayoutAttributes *layoutAttributes = typeLayoutInfo[indexPath];
            if (CGRectIntersectsRect(rect, layoutAttributes.frame)) {
                [resultLayoutAttributes addObject:layoutAttributes];
            }
        }
    }
    return resultLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInfo[FLTMenuItemCellLayout][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInfo[FLTMenuItemTitleLayout][indexPath];
}

#pragma Accessors

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    
    _edgeInsets = edgeInsets;
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize {
    
    _itemSize = itemSize;
    [self invalidateLayout];
}

- (void)setInterItemSpacingX:(CGFloat)interItemSpacingX {
    
    _interItemSpacingX = interItemSpacingX;
    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight {
    
    _titleHeight = titleHeight;
    [self invalidateLayout];
}

- (CGSize)collectionViewContentSize {
    
    NSInteger numItems = [self.collectionView numberOfItemsInSection:0];
    CGFloat width = self.edgeInsets.left + (self.itemSize.width + self.interItemSpacingX) * numItems - self.interItemSpacingX +
    self.edgeInsets.right;
    
    CGFloat height = self.edgeInsets.top + self.itemSize.height + self.titleHeight + self.edgeInsets.bottom;
    
    return CGSizeMake(width, height);
}

#pragma mark - Helper methods

- (CGRect)frameForCellWithIndexPath:(NSIndexPath *)indexPath {
    
    CGRect frame = CGRectMake(self.edgeInsets.left + (self.itemSize.width + self.interItemSpacingX) * indexPath.row,
                              self.edgeInsets.top,
                              self.itemSize.width,
                              self.itemSize.height);
    return frame;
}

- (CGRect)frameForTitleWithIndexPath:(NSIndexPath *)indexPath {
    
    // Places the title labels directly below the cells
    CGRect frame = [self frameForCellWithIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    return frame;
}

- (void)setupDefaults {
    
    self.layoutInfo = [NSMutableDictionary dictionary];
    self.edgeInsets = UIEdgeInsetsMake(5.0f, 10.0f, 0.0f, 10.0f);
    self.itemSize = CGSizeMake(50.0f, 50.0f);
    self.interItemSpacingX = 20.0f;
    self.titleHeight = 20.0f;
}

@end
