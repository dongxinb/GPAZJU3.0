//
//  GZSettingsViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/26/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZSettingsViewController.h"

#import "GZCollectionViewLayout.h"
#import "GZMainItemCell.h"

#import "LCUserFeedbackAgent.h"

@interface GZSettingsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) GZCollectionViewLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *itemArray;

@end

@implementation GZSettingsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self reload];
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

	[self customNavigationItemWithTitle:@"设置"];
}

- (void)logout
{
	static BOOL loading = NO;
	if (!loading) {
		loading = YES;
		__weak typeof(GZMainItemCell) *cell;
		for (NSInteger i = 0; i < (NSInteger)self.itemArray.count; i++) {
			if ([[self.itemArray[i] objectForKey:@"selector"] isEqualToString:@"logout"]) {
				cell = (id)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
			}
		}
		if (cell) {
			cell.loading = YES;
		}
		[[GZUser currentUser] logoutWithCompleteBlock:^(NSError *error) {
			if (error) {
				[DBMessageView showWithMessage:[error localizedDescription]];
			} else {
				[DBMessageView showWithMessage:@"登出成功!"];
				[self reload];
			}
			if (cell) {
				cell.loading = NO;
			}
			loading = NO;
		}];
	}
}

- (void)reload
{
	_itemArray = nil;
	[self.collectionView reloadData];
}

- (NSString *)subTitleForTitle:(NSString *)title
{
	NSDictionary *dic = @{ @"应用反馈": @"使用中有什么问题？", @"关于GPA.ZJU": @"一些信息" };
	return [dic objectForKey:title];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	__block GZMainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GZMainItemCell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
	cell.cnameLabel.text = [self.itemArray[indexPath.row] valueForKey:@"title"];
	cell.cinfoLabel.text = [self subTitleForTitle:cell.cnameLabel.text];
	if (self.itemArray.count - 1 == indexPath.row || (self.itemArray.count - 2 == indexPath.row && self.itemArray.count % 2 == 0)) {
		cell.lastLine = YES;
	} else {
		cell.lastLine = NO;
	}
	if ([cell.cnameLabel.text isEqualToString:@"应用反馈"]) {
		[[LCUserFeedbackAgent sharedInstance] countUnreadFeedbackThreadsWithBlock:^(NSInteger number, NSError *error) {
			if (!error && number > 0) {
				cell.cinfoLabel.text = [NSString stringWithFormat:@"%@条未读消息", @(number)];
			}
		}];
	} else if ([cell.cnameLabel.text isEqualToString:@"推送设置"]) {
		if ([GZUser hasLogin]) {
			cell.loading = YES;
			[[GZUser currentUser] fetchPushEnabledWithBlock:^(BOOL push, NSString *deviceToken, NSError *error) {
				if (!error) {
					cell.cinfoLabel.text = push ? @"开启" : @"关闭";
				} else {
					[DBMessageView showWithMessage:[error localizedDescription]];
					cell.cinfoLabel.text = @"不知道";
				}
				cell.loading = NO;
			}];
		} else {
			cell.cinfoLabel.text = @"未登录";
		}
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *str = [self.itemArray[indexPath.row] valueForKey:@"vc"];
	BOOL needLogin = [[self.itemArray[indexPath.row] valueForKey:@"needLogin"] boolValue];
	if (needLogin && ![GZUser hasLogin]) {
		[DBMessageView showWithMessage:[[NSError errorWithCode:GZErrorCodeNotLogged andDescription:nil] localizedDescription]];
		return;
	}
	if ([str length] > 0) {
		Class c = NSClassFromString(str);
		[self.navigationController pushViewController:[c viewControllerFromStoryboard] animated:YES];
	} else {
		SEL selector = NSSelectorFromString([self.itemArray[indexPath.row] valueForKey:@"selector"]);
		[self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake((SCREEN_WIDTH - 20) / 2, (SCREEN_WIDTH - 20) / 2 - 10);
}

#pragma mark - Getter

- (GZCollectionViewLayout *)layout
{
	if (!_layout) {
		_layout = [[GZCollectionViewLayout alloc] init];
		_layout.minimumInteritemSpacing = 0;
		_layout.minimumLineSpacing = 0;
		_layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		_layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
	}
	return _layout;
}

- (NSArray *)itemArray
{
	if (!_itemArray) {
		if ([GZUser hasLogin]) {
			_itemArray = @[@{ @"title": @"推送设置", @"vc": @"GZPushViewController", @"needLogin": @(YES) }, @{ @"title": @"应用反馈", @"vc": @"GZFeedbackViewController" }, @{ @"title": @"关于GPA.ZJU", @"vc": @"GZAboutViewController" }, @{ @"title": @"退出登录", @"vc": @"", @"selector": @"logout" }];
		} else {
			_itemArray = @[@{ @"title": @"推送设置", @"vc": @"GZPushViewController", @"needLogin": @(YES) }, @{ @"title": @"应用反馈", @"vc": @"GZFeedbackViewController" }, @{ @"title": @"关于GPA.ZJU", @"vc": @"GZAboutViewController" }];
		}
	}
	return _itemArray;
}

@end
