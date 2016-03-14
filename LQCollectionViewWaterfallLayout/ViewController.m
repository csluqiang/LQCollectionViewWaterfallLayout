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
@property (nonatomic, strong) NSMutableArray *cellHeightArray;
@property (nonatomic, assign) CGFloat headerHeight;
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
    self.headerHeight = 200;
    
    //构造高度数据
    self.cellHeightArray = [NSMutableArray arrayWithCapacity:30];
    for (NSInteger i = 0; i < 30; i++) {
        CGFloat height = arc4random()%100 + 200;
        [self.cellHeightArray addObject:@(height)];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //模拟尺寸
    CGFloat height = [self.cellHeightArray[indexPath.row] doubleValue];
    
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 5)/2, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, self.headerHeight);
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
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 250, 30)];
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitle:@"click to animate the header" forState:UIControlStateNormal];
        [_collectionViewHeader addSubview:btn];
        [btn addTarget:self action:@selector(animationChangeHeader:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 0;
    }
    return _collectionViewHeader;
}

- (void)animationChangeHeader:(UIButton *)btn
{
    if (btn.tag == 0) {
        btn.tag = 1;
        self.headerHeight = 100;
        [UIView animateWithDuration:0.8 animations:^{
            self.collectionViewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.headerHeight);
            [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y - self.headerHeight, obj.frame.size.width, obj.frame.size.height);
            }];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
    } else {
        btn.tag = 0;
        self.headerHeight = 200;
        [UIView animateWithDuration:0.8 animations:^{
            self.collectionViewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.headerHeight);
            [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 obj.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y + self.headerHeight, obj.frame.size.width, obj.frame.size.height);
            }];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
    }
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
