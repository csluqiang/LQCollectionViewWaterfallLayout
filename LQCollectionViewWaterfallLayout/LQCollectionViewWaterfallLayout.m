//
//  LQCollectionViewWaterfallLayout.m
//  LQCollectionViewWaterfallLayout
//
//  Created by renren on 16/3/9.
//  Copyright © 2016年 luqiang. All rights reserved.
//

#import "LQCollectionViewWaterfallLayout.h"

@interface LQCollectionViewWaterfallLayout ()

@property (nonatomic, strong) NSMutableDictionary *layoutInformation;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, assign) CGFloat headerHeight;

@end

@implementation LQCollectionViewWaterfallLayout

- (void)prepareLayout
{
    
    self.layoutInformation = [NSMutableDictionary dictionary];
    self.heightArray = [NSMutableArray array];
    
    //collectionView header
    CGSize headerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:0];
    UICollectionViewLayoutAttributes *headerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    headerAttr.frame = CGRectMake(0, 0, headerSize.width, headerSize.height);
    self.headerHeight = headerSize.height;
    [self.layoutInformation setObject:headerAttr forKey:@"header"];
    
    for (NSInteger i = 0; i < self.colNum; i++) {
        [self.heightArray addObject:@(self.headerHeight)];
    }
    
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numSections; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self attributesAtIndexPath:indexPath];
            [self.layoutInformation setObject:attributes forKey:indexPath];
        }
    }

}

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    // 寻找最小高度
    NSInteger col = 0;
    float minHeight = [[self.heightArray objectAtIndex:col] floatValue];
    for (NSInteger i = 1; i < self.heightArray.count; i++) {
        float height = [[self.heightArray objectAtIndex:i] floatValue];
        if (height < minHeight) {
            minHeight = height;
            col = i;
        }
    }
    float top = [[self.heightArray objectAtIndex:col] floatValue];
    // 计算frame
    CGRect frame = CGRectMake(col * (itemSize.width + self.colSpace), top + self.rowSpace, itemSize.width, itemSize.height);
    [self.heightArray replaceObjectAtIndex:col withObject:@(frame.origin.y + frame.size.height)];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;

    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.layoutInformation.allValues) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:attributes];
        }
    }
    UICollectionViewLayoutAttributes *headerAttr = [self.layoutInformation objectForKey:@"header"];
    if (headerAttr && CGRectIntersectsRect(rect, headerAttr.frame)) {
        [attributesArray addObject:headerAttr];
    }
    
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.layoutInformation objectForKey:indexPath];
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return [self.layoutInformation objectForKey:@"header"];
}

- (CGSize)collectionViewContentSize
{
    
    float maxHeight = [[self.heightArray objectAtIndex:0] floatValue];
    for (NSNumber *height in self.heightArray) {
        if (height.floatValue > maxHeight) {
            maxHeight = height.floatValue;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, maxHeight);
}

@end
