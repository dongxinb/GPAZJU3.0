//
//  GZTipGoundView.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZTipGoundView.h"
#import "GZTipRope.h"
#import "GZTipSquare.h"

#import <CoreMotion/CoreMotion.h>

@interface GZTipGoundView ()

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
//@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachment;
@property (strong, nonatomic) UISnapBehavior *hiddenSnap;

@property (strong, nonatomic) GZTipRope *rope;
@property (strong, nonatomic) GZTipSquare *square;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation GZTipGoundView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setUpWorld];
		[self setUpRope];
		self.motionManager = [[CMMotionManager alloc] init];
		if (self.motionManager.isAccelerometerAvailable) {
			[self.motionManager setAccelerometerUpdateInterval:1. / 5];
		}
        self.panEnabled = YES;
	}
	return self;
}

- (void)setUpWorld
{
	self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
	self.gravity = [[UIGravityBehavior alloc] init];
	//    self.collision = [[UICollisionBehavior alloc] init];
	//    self.collision.translatesReferenceBoundsIntoBoundary = YES;
	[self.animator addBehavior:self.gravity];
	//    [self.animator addBehavior:self.collision];
}

- (void)setUpRope
{
	CGFloat width = 2;
	CGFloat height = 0.1;
	CGRect ropeFrame = CGRectMake(CGRectGetWidth(self.bounds) - width - 32, -2, width, height);
	self.rope = [[GZTipRope alloc] initWithFrame:ropeFrame numSegments:6 referenceView:self];
	[self addSubview:self.rope];

	self.square = [[GZTipSquare alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
	self.square.center = CGPointMake(CGRectGetMinX(self.rope.frame) + self.rope.links.lastObject.center.x - 22, CGRectGetMinY(self.rope.frame) + self.rope.links.lastObject.center.y + self.rope.segmentLength / 2.0);

	self.hiddenSnap = [[UISnapBehavior alloc] initWithItem:self.square snapToPoint:CGPointMake(self.square.center.x, -CGRectGetHeight(self.square.frame))];
	self.hiddenSnap.damping = 0.25;

	[self addSubview:self.square];
	[self.square addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[self.square addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.square addGestureRecognizer:longPress];
    

	self.rope.attachedView = self.square;
	//    [self.collision addItem:self.square];
	[self.gravity addItem:self.square];

	for (UIView *link in self.rope.links) {
		[self.gravity addItem:link];
	}

	[self.rope addToAnimator:self.animator];

	UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:self.rope.links.lastObject offsetFromCenter:UIOffsetMake(0, CGRectGetHeight(self.rope.links.lastObject.frame) / 2) attachedToItem:self.square offsetFromCenter:UIOffsetMake(22, -15)];
	attachment.length = 0;
	attachment.damping = 1;
	attachment.frequency = 5;
	attachment.frictionTorque = 10;
	[self.animator addBehavior:attachment];

	UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[self.square]];
	item.friction = INT_MAX;
	item.resistance = 2;
	item.density = 5;
	//    item.resistance = 5;
	item.allowsRotation = NO;
	[self.animator addBehavior:item];
}

- (void)setSquareHidden:(BOOL)squareHidden
{
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]] && ![[(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController topViewController] isKindOfClass:NSClassFromString(@"GZMainViewController")] && !squareHidden) {
        squareHidden = YES;
    }
	if (squareHidden != _squareHidden) {
		_squareHidden = squareHidden;
		if (squareHidden) {
			[self.animator addBehavior:self.hiddenSnap];
		} else {
			[self.animator removeBehavior:self.hiddenSnap];
		}
		[self.animator updateItemUsingCurrentState:self.square];
	}
}

- (void)setAccelerometerEnabled:(BOOL)accelerometerEnabled
{
	if (accelerometerEnabled == _accelerometerEnabled) {
		return;
	}
	_accelerometerEnabled = accelerometerEnabled;
	if (!self.motionManager.isAccelerometerAvailable) {
		return;
	}
	if (accelerometerEnabled) {
		if (self.motionManager.isAccelerometerActive) {
			return;
		}
		[self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
			//            NSLog(@"%f%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y);
			CGFloat x = accelerometerData.acceleration.x;
			//            x = ABS(x) < 0.1? 0: (ABS(x) - 0.1) / 0.9 * ABS(x) / x;
			CGFloat y = accelerometerData.acceleration.y - 0.1;
			//            y = y < 0.1? (y - 0.1) / 1.1: (y - 0.1) / 0.9;
			if (x < 0) {
				if (y < 0) {
					self.gravity.angle = atan(ABS(x / y)) + M_PI_2;
				} else {
					self.gravity.angle = -atan(ABS(x / y)) + M_PI_2 * 3;
				}
			} else {
				if (y < 0) {
					self.gravity.angle = -atan(ABS(x / y)) + M_PI_2;
				} else {
					self.gravity.angle = atan(ABS(x / y)) + M_PI_2 * 3;
				}
			}
		}];
	} else {
		[self.motionManager stopAccelerometerUpdates];
		self.gravity.angle = M_PI_2;
	}
}

#pragma mark - action

- (void)startLoadingAnimation
{
	[self.square.indicator startAnimating];
}

- (void)stopLoadingAnimation
{
	[self.square.indicator stopAnimating];
}

- (void)setGPA:(NSString *)gpa animated:(BOOL)animated
{
	if (!animated) {
		self.square.gpa = gpa;
	} else {
		[self setSquareHidden:YES];
		//		UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.square] mode:UIPushBehaviorModeInstantaneous];
		//		pushBehavior.pushDirection = CGVectorMake(0, -1);
		//		pushBehavior.magnitude = 50;
		//		[self.animator addBehavior:pushBehavior];
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
			self.square.gpa = gpa;
			//			[self.animator removeBehavior:pushBehavior];
			[self setSquareHidden:NO];
		});
	}
}

#pragma mark - gesture

- (void)pan:(UIPanGestureRecognizer *)gesture
{
	if (!self.panEnabled) {
		return;
	}
	CGPoint point = [gesture locationInView:self];
	if (gesture.state == UIGestureRecognizerStateBegan) {
		self.panAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.square attachedToAnchor:point];
		[self.animator addBehavior:self.panAttachment];
		[self.gravity removeItem:self.square];
	} else if (gesture.state == UIGestureRecognizerStateChanged) {
		self.panAttachment.anchorPoint = point;
	} else {
		[self.animator removeBehavior:self.panAttachment];
		[self.gravity addItem:self.square];
		self.panAttachment = nil;

		CGPoint velocity = [gesture velocityInView:self];
		CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
		UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.square] mode:UIPushBehaviorModeInstantaneous];
		pushBehavior.pushDirection = CGVectorMake((velocity.x / 10), (velocity.y / 10));
		pushBehavior.magnitude = magnitude / 35;
		[self.animator addBehavior:pushBehavior];
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
			[self.animator removeBehavior:pushBehavior];
		});
	}
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.touchBlock) {
        self.touchBlock(self);
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    self.accelerometerEnabled = !self.accelerometerEnabled;
}

@end
