//
//  GZMainItemViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZDetailViewController.h"
#import "GZMainItemViewController.h"

#import "GZCollectionViewLayout.h"
#import "GZMainItemCell.h"
#import "GZBlankView.h"

@interface GZMainItemViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) GZCollectionViewLayout *layout;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@property (assign, nonatomic) BOOL dragging;

@property (strong, nonatomic) GZBlankView *blankView;

@end

@implementation GZMainItemViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)configureUI
{
	self.collectionView.collectionViewLayout = self.layout;
	self.collectionView.backgroundColor = [UIColor whiteColor];

    if (self.loginMode) {
        self.loginMode = _loginMode;
    }
    [self setCourses:_courses];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.courses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	GZMainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GZMainItemCell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
	[cell bindCourse:self.courses[indexPath.row]];
	if (self.courses.count - 1 == indexPath.row || (self.courses.count - 2 == indexPath.row && self.courses.count % 2 == 0)) {
		cell.lastLine = YES;
	} else {
		cell.lastLine = NO;
	}
	return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ([self.delegate respondsToSelector:@selector(mainItemViewController:didScrollToOffset:dragging:)]) {
		[self.delegate mainItemViewController:self didScrollToOffset:scrollView.contentOffset dragging:self.dragging];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	self.dragging = NO;
}

#pragma mark - UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	//	if (self.selectedIndexPath && self.selectedIndexPath.row == indexPath.row) {
	//		self.selectedIndexPath = nil;
	//	} else {
	//		self.selectedIndexPath = indexPath;
	//	}
	//	GZMainItemCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
	//	[collectionView bringSubviewToFront:cell];
	//	[self.collectionView performBatchUpdates:nil completion:nil];
	//	[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    self.currentIndexPath = indexPath;
    GZDetailViewController *vc = [GZDetailViewController viewControllerFromStoryboard];
    vc.course = self.courses[indexPath.row];
    WS(weakSelf);
    [vc setReadBlock:^{
        [weakSelf.collectionView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	//	if (self.selectedIndexPath && self.selectedIndexPath.row == indexPath.row) {
	//		return CGSizeMake(SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
	//	} else {
	return CGSizeMake((SCREEN_WIDTH - 20) / 2, (SCREEN_WIDTH - 20) / 2 - 10);
	//	}
}


#pragma mark - Getter & Setter

- (GZCollectionViewLayout *)layout
{
	if (!_layout) {
		_layout = [[GZCollectionViewLayout alloc] init];
		_layout.minimumInteritemSpacing = 0;
		_layout.minimumLineSpacing = 0;
		_layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		_layout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
	}
	return _layout;
}

- (void)setLoginMode:(BOOL)loginMode
{
    _loginMode = loginMode;
    if (self.loginMode) {
        [self.collectionView addSubview:self.blankView];
        self.blankView.info = @"您还未登录，点击此处登录";
        WS(weakSelf);
        [self.blankView setTouchBlock:^(GZBlankView *view) {
            [weakSelf showLogin];
        }];
    }else {
        if (self.courses.count > 0) {
            [self.blankView removeFromSuperview];
        }
    }
}

- (void)setCourses:(NSArray<GZCourse *> *)courses
{
    _courses = courses;
    if (self.collectionView) {
        [self.collectionView reloadData];
        if (courses.count == 0 && !self.loginMode) {
            [self.collectionView addSubview:self.blankView];
        }
    }
}

- (GZBlankView *)blankView
{
    if (!_blankView) {
        _blankView = [[GZBlankView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70)];
        _blankView.info = @"暂无成绩、考试数据";
        
    }
    return _blankView;
}

@end
