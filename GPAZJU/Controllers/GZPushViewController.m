//
//  GZPushViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/26/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZPushViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface GZPushViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pushLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *pushSwitch;
@property (assign, nonatomic) BOOL loaded;

@end

@implementation GZPushViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];
    
    WS(weakSelf);
    self.pushSwitch.userInteractionEnabled = NO;
    self.loaded = NO;
    [[GZUser currentUser] fetchPushEnabledWithBlock:^(BOOL push, NSString *deviceToken, NSError *error) {
        weakSelf.pushSwitch.userInteractionEnabled = YES;
        weakSelf.pushSwitch.on = push;
        weakSelf.loaded = YES;
    }];
    self.pushLabel.text = [AVAnalytics getConfigParams:@"pushInfo"];
    self.pushSwitch.enabled = [[AVAnalytics getConfigParams:@"pushEnabled"] boolValue];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)configureUI
{
	[self customNavigationItemWithTitle:@"推送设置"];
	[self.pushSwitch addTarget:self action:@selector(oneSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.pushLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
    self.pushLabel.textColor = [UIColor darkGrayColor];
    
    self.label.font = [UIFont fontWithStyle:GZFontStyleNormal];
}

#pragma mark - Observer
- (void)oneSwitchValueChanged:(UISwitch *)sender
{
	NSLog(@"%@", sender.isOn ? @"ON" : @"OFF");
    if (self.loaded) {
        sender.userInteractionEnabled = NO;
        WS(weakSelf);
        [[GZUser currentUser] setPushEnabled:sender.isOn withBlock:^(BOOL push, NSString *deviceToken, NSError *error) {
            if (error) {
                [DBMessageView showWithMessage:[error localizedDescription]];
            }else {
                if (push != weakSelf.pushSwitch.isOn) {
                    [DBMessageView showWithMessage:@"设置失败!"];
                }else {
                    [DBMessageView showWithMessage:@"设置成功!"];
                }
                weakSelf.pushSwitch.on = push;
            }
            weakSelf.pushSwitch.userInteractionEnabled = YES;
        }];
    }
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
