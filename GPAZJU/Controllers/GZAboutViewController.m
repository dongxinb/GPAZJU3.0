//
//  GZAboutViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/26/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZAboutViewController.h"

@interface GZAboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *logoLabel;

@end

@implementation GZAboutViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self configureUI];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [self customNavigationItemWithTitle:@"关于GPA.ZJU"];
    self.logoLabel.font = [UIFont fontWithName:@"TypeOne" size:34];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
