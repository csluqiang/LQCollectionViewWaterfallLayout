//
//  LQCollectionViewWaterfallLayout.h
//  LQCollectionViewWaterfallLayout
//
//  Created by renren on 16/3/9.
//  Copyright © 2016年 luqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQCollectionViewWaterfallLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, assign) NSInteger colNum; //列数
@property (nonatomic, assign) NSInteger colSpace; //列间距
@property (nonatomic, assign) NSInteger rowSpace; //行间距

@end
