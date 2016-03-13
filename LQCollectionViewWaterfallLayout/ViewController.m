//
//  ViewController.m
//  LQCollectionViewWaterfallLayout
//
//  Created by renren on 16/3/9.
//  Copyright © 2016年 luqiang. All rights reserved.
//

#import "ViewController.h"
#import "LQCollectionViewWaterfallLayout.h"

@interface ViewController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *collectionViewHeader;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LQCollectionViewWaterfallLayout *layout = [[LQCollectionViewWaterfallLayout alloc] init];
    layout.delegate = self;
    layout.colNum = 2;
    layout.colSpace = 5;
    layout.rowSpace = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kCollectionCell" ];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"kHeader"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //模拟尺寸
    CGFloat height = arc4random()%100 + 200;
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 5)/2, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kCollectionCell" forIndexPath:indexPath];
    if (indexPath.item % 2 == 0) {
        cell.backgroundColor = [UIColor blueColor];
    } else {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
      header =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"kHeader" forIndexPath:indexPath];
        [header addSubview:self.collectionViewHeader];
    }
    return header;
}

- (UIView *)collectionViewHeader
{
    if (!_collectionViewHeader) {
        _collectionViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        _collectionViewHeader.backgroundColor = [UIColor greenColor];
    }
    return _collectionViewHeader;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
