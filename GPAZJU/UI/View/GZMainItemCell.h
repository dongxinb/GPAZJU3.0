//
//  GZMainItemCell.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZCourse;

@interface GZMainItemCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *cnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cinfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *gradeLabel;
@property (assign, nonatomic) BOOL loading;

@property (assign, nonatomic) BOOL lastLine;
- (void)bindCourse:(GZCourse *)course;

@end
