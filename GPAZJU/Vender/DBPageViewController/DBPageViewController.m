//
//  DBPageView.m
//  YunGeZi
//
//  Created by Xinbao Dong on 1/6/16.
//  Copyright © 2016 ZJU. All rights reserved.
//

#import "DBCollectionView.h"
#import "DBPageViewController.h"
@interface DBPageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) DBCollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;

@property (strong, nonatomic) NSMutableDictionary *indexDic;

@end

@implementation DBPageViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.extendedLayoutIncludesOpaqueBars = YES;
	[self.view addSubview:self.collectionView];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
	for (UIViewController *vc in _viewControllers) {
		[vc removeFromParentViewController];
	}
	_viewControllers = viewControllers;
	for (UIViewController *vc in viewControllers) {
		[self addChildViewController:vc];
	}
	[self.collectionView reloadData];
	if (viewControllers.count > 0 && [self.delegate respondsToSelector:@selector(scrollPageViewController:didScrollToIndex:)]) {
		[self.delegate scrollPageViewController:self didScrollToIndex:self.currentIndex];
	}
}

- (void)viewDidLayoutSubviews
{
	//    NSLog(@"viewDidLayoutSubviews: %@", NSStringFromCGSize(self.view.frame.size));
	self.collectionViewLayout.itemSize = self.view.frame.size;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	//    cell.backgroundColor = RGBACOLOR(arc4random() % 256, arc4random() % 256, arc4random() % 256, 1.);
	self.viewControllers[indexPath.row].view.frame = CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), CGRectGetHeight(cell.contentView.frame));
	[cell.contentView addSubview:self.viewControllers[indexPath.row].view];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	//    NSLog(@"willDisplayCell: %@", @([[collectionView indexPathsForVisibleItems] firstObject].row));
	_currentIndex = indexPath.row;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.viewControllers.count > indexPath.row) {
		[self.viewControllers[indexPath.row].view removeFromSuperview];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSIndexPath *index = [[self.collectionView indexPathsForVisibleItems] firstObject];
	if ([self.delegate respondsToSelector:@selector(scrollPageViewController:didScrollToIndex:)]) {
		[self.delegate scrollPageViewController:self didScrollToIndex:index.row];
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return collectionView.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
	if (!_collectionView) {
		_collectionView = [[DBCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
		_collectionView.backgroundColor = [UIColor whiteColor];
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.showsVerticalScrollIndicator = NO;
		[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.pagingEnabled = YES;
		_collectionView.bounces = NO;
		_collectionView.frame = CGRectMake(0, self.navigationController.navigationBarSize.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationController.navigationBarSize.height);
	}
	return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewLayout
{
	if (!_collectionViewLayout) {
		_collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
		//        _collectionViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
		_collectionViewLayout.minimumInteritemSpacing = 0;
		_collectionViewLayout.minimumLineSpacing = 0;
		_collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	}
	return _collectionViewLayout;
}

- (void)setCurrentIndex:(NSUInteger)index animated:(BOOL)animated
{
	if (self.viewControllers.count == 0) {
		return;
	}
	[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

- (NSMutableDictionary *)indexDic
{
	if (!_indexDic) {
		_indexDic = [NSMutableDictionary dictionary];
		[_indexDic setObject:@(0) forKey:@(0)];
	}
	return _indexDic;
}

- (UIViewController *)currentViewController
{
	return self.viewControllers[self.currentIndex];
}
@end
