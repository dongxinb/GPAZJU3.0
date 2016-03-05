//
//  GZFeedbackViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/26/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "DoImagePickerController.h"
#import "GZFeedbackViewController.h"

@interface GZFeedbackViewController ()<DoImagePickerControllerDelegate>

@end

@implementation GZFeedbackViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.contactHeaderHidden = YES;
		self.feedbackCellFont = [UIFont fontWithStyle:GZFontStyleDescription];
		self.feedbackTitle = [GZUser currentUser].stuID;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];
}

- (void)configureUI
{
    [self customNavigationItemWithTitle:@"应用反馈"];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Override

- (void)addImageButtonClicked:(id)sender
{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 1;
    cont.nColumnCount = 3;
    
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
    cont.wantsNavigationBarVisible = NO;
    [self.navigationController pushViewController:cont animated:YES];
}

#pragma mark - GMImagePickerControllerDelegate

- (void)didCancelDoImagePickerController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self didFinishPickWithImage:[aSelected firstObject]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)filterError:(NSError *)error
{
    if (error) {
        [DBMessageView showWithMessage:[error localizedDescription]];
        return NO;
    }
    return YES;
}

@end
