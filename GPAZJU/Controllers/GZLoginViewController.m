//
//  GZLoginViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 12/18/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZLoginViewController.h"
#import "JVFloatLabeledTextField.h"
#import "WDActivityIndicator.h"

@interface GZLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *stuIDTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordTextField;
@property (strong, nonatomic) WDActivityIndicator *indicator;
@property (weak, nonatomic) IBOutlet UILabel *tintLabel;

@end

@implementation GZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    self.navigationBarBackgroundHidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"check"] style:UIBarButtonItemStylePlain target:self action:@selector(onSignIn:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"up"] style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    
    self.stuIDTextField.font = [UIFont fontWithStyle:GZFontStyleBig];
    self.passwordTextField.font = [UIFont fontWithStyle:GZFontStyleBig];
    self.stuIDTextField.floatingLabelFont = [UIFont fontWithStyle:GZFontStyleDescription];
    self.passwordTextField.floatingLabelFont = [UIFont fontWithStyle:GZFontStyleDescription];
    self.stuIDTextField.floatingLabelActiveTextColor = [UIColor blackColor];
    self.stuIDTextField.floatingLabelTextColor = [UIColor blackColor];
    self.passwordTextField.floatingLabelActiveTextColor = [UIColor blackColor];
    self.passwordTextField.floatingLabelTextColor = [UIColor blackColor];
    
    self.stuIDTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Student ID" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x9B9B9B), NSFontAttributeName: [UIFont fontWithStyle:GZFontStyleMain]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x9B9B9B), NSFontAttributeName: [UIFont fontWithStyle:GZFontStyleMain]}];
    
    self.tintLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
    
    [self.stuIDTextField becomeFirstResponder];
}

- (void)onSignIn:(id)btn
{
    WS(weakSelf);
    [self setIndicatorLoading:YES];
    [GZUser loginWithStuID:self.stuIDTextField.text andPassword:self.passwordTextField.text withBlock:^(NSError *error, GZUser *user) {
        if (error) {
            weakSelf.tintLabel.text = [error localizedDescription];
        }else {
            [weakSelf onClose:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
        }
        [weakSelf setIndicatorLoading:NO];
    }];
}

- (void)onClose:(id)btn
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}

- (void)setIndicatorLoading:(BOOL)loading
{
    if (loading) {
        self.tintLabel.hidden = YES;
        CGSize size = [self.stuIDTextField sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        self.indicator.center = CGPointMake(CGRectGetMinX(self.stuIDTextField.frame) + size.width + 10, CGRectGetMidY(self.stuIDTextField.frame) + 8);
        [self.view addSubview:self.indicator];
        [self.indicator startAnimating];
    }else {
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        self.tintLabel.hidden = NO;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.stuIDTextField) {
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }else {
        if ([self.stuIDTextField.text length] == 0 || [self.passwordTextField.text length] == 0) {
            return NO;
        }else {
            [self onSignIn:nil];
            return YES;
        }
    }
}

#pragma mark - Getter

- (WDActivityIndicator *)indicator
{
    if (!_indicator) {
        _indicator = [[WDActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _indicator.hidesWhenStopped = YES;
    }
    return _indicator;
}


@end
