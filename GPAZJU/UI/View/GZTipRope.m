//
//  GZTipRope.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZTipRope.h"

@interface GZTipRope ()

@property (assign, nonatomic) CGRect originalFrame;

@end

@implementation GZTipRope

- (instancetype)initWithFrame:(CGRect)frame numSegments:(NSInteger)numSegments referenceView:(UIView *)view
{
	self = [super initWithFrame:view.frame];
	if (self) {
		self.links = [NSArray array];
		self.numSegments = numSegments;
		self.originalFrame = frame;
		self.clipsToBounds = NO;
		self.backgroundColor = [UIColor clearColor];
		[self addLinks];
	}
	return self;
}

- (void)addLinks
{
	NSMutableArray *tmp = [NSMutableArray array];
	for (NSInteger i = 0; i < self.numSegments; i++) {
		CGRect linkFrame = CGRectMake(CGRectGetMinX(self.originalFrame), CGRectGetMinY(self.originalFrame) + i * self.segmentLength, self.segmentWidth, self.segmentLength * 10);
		GZTranparentView *link = [[GZTranparentView alloc] initWithFrame:linkFrame];
		link.backgroundColor = [UIColor clearColor];
		[self addSubview:link];
		[tmp addObject:link];
		//        link.backgroundColor = [UIColor greenColor];
	}
	self.links = [tmp copy];
}

- (void)addToAnimator:(UIDynamicAnimator *)animator
{
	for (NSInteger i = 0; i < self.links.count; i++) {
		UIAttachmentBehavior *attachment;
		UIView *link = self.links[i];
		if (i == 0) {
			attachment = [[UIAttachmentBehavior alloc] initWithItem:link offsetFromCenter:UIOffsetMake(0, -self.segmentLength / 2.) attachedToAnchor:self.originalFrame.origin];
		} else {
			UIView *previousLink = self.links[i - 1];
			attachment = [[UIAttachmentBehavior alloc] initWithItem:link offsetFromCenter:UIOffsetMake(0, -self.segmentLength / 2.) attachedToItem:previousLink offsetFromCenter:UIOffsetMake(0, self.segmentLength / 2.)];
		}
		attachment.length = 0;

		attachment.damping = 1;
		attachment.frequency = 5;
        
		[attachment setAction:^{
			[self setNeedsDisplay];
		}];
		[animator addBehavior:attachment];
	}
	UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:[self.links subarrayWithRange:NSMakeRange(1, self.links.count - 1)]];
	itemBehavior.density = 0;
	itemBehavior.friction = 0;
	itemBehavior.charge = INT_MAX;
	itemBehavior.resistance = 2;
	[animator addBehavior:itemBehavior];
    
	itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[[self.links firstObject]]];
	itemBehavior.density = 0;
	itemBehavior.friction = 0;
	itemBehavior.resistance = 2;
	itemBehavior.charge = INT_MAX;
	itemBehavior.anchored = YES;
	[animator addBehavior:itemBehavior];
}

- (void)drawRect:(CGRect)rect
{
	UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:self.attachedView.frame];
	[[UIColor whiteColor] setFill];
	[rectanglePath fill];

	NSMutableArray *points = [NSMutableArray array];
	for (NSInteger j = 0; j < self.links.count; j++) {
		[points addObject:[NSValue valueWithCGPoint:CGPointMake((NSInteger)self.links[j].center.x, (NSInteger)self.links[j].center.y)]];
	}
	[points addObject:[NSValue valueWithCGPoint:CGPointMake((NSInteger)(self.attachedView.center.x + 22), (NSInteger)(self.attachedView.center.y - 15))]];

	//    NSMutableArray *derivative = [[NSMutableArray alloc] init];
	//
	//    for(NSInteger j=0;j<points.count;j++) {
	//        CGPoint prev = [points[MAX(j-1,0)] CGPointValue];
	//        CGPoint next = [points[MIN(j+1,self.links.count-1)] CGPointValue];
	//
	//        [derivative addObject:[NSValue valueWithCGPoint:CGPointMake((next.x - prev.x) / 2., (next.y - prev.y) / 2.)]];
	//    }

	UIBezierPath *path = [UIBezierPath bezierPath];
	path.lineCapStyle = kCGLineCapRound;
	path.lineJoinStyle = kCGLineCapRound;
//	path.lineWidth = self.segmentWidth;
    path.lineWidth = 1.5;

	//    [path moveToPoint:[[points firstObject] CGPointValue]];
	//    CGFloat tension = 500;
	//    for(NSUInteger i=0;i<points.count;i++) {
	//        if(i==0) {
	//            [path moveToPoint:[points[i] CGPointValue]];
	//        } else {
	//            CGPoint endPoint = [points[i] CGPointValue];
	//            CGPoint cp1 = CGPointMake([points[i-1] CGPointValue].x + [derivative[i-1] CGPointValue].x / tension, [points[i-1] CGPointValue].y + [derivative[i-1] CGPointValue].y / tension);
	//            CGPoint cp2 = CGPointMake([points[i] CGPointValue].x + [derivative[i] CGPointValue].x / tension, [points[i] CGPointValue].y + [derivative[i] CGPointValue].y / tension);
	//
	//            [path addCurveToPoint:endPoint controlPoint1:cp1 controlPoint2:cp2];
	//        }
	//    }
	NSArray *pointsAsNSValues = [NSArray arrayWithArray:points];
	NSInteger nCurves = [pointsAsNSValues count] - 1;
	BOOL closed = NO;
	for (NSInteger ii = 0; ii < nCurves; ++ii) {
		NSValue *value = pointsAsNSValues[ii];

		CGPoint curPt, prevPt, nextPt, endPt;
		[value getValue:&curPt];
		if (ii == 0)
			[path moveToPoint:curPt];

		NSInteger nextii = (ii + 1) % [pointsAsNSValues count];
		NSInteger previi = (ii - 1 < 0 ? [pointsAsNSValues count] - 1 : ii - 1);

		[pointsAsNSValues[previi] getValue:&prevPt];
		[pointsAsNSValues[nextii] getValue:&nextPt];
		endPt = nextPt;

		CGFloat mx, my;
		if (closed || ii > 0) {
			mx = (nextPt.x - curPt.x) * 0.5 + (curPt.x - prevPt.x) * 0.5;
			my = (nextPt.y - curPt.y) * 0.5 + (curPt.y - prevPt.y) * 0.5;
		} else {
			mx = (nextPt.x - curPt.x) * 0.5;
			my = (nextPt.y - curPt.y) * 0.5;
		}

		CGPoint ctrlPt1;
		ctrlPt1.x = curPt.x + mx / 3.0;
		ctrlPt1.y = curPt.y + my / 3.0;

		[pointsAsNSValues[nextii] getValue:&curPt];

		nextii = (nextii + 1) % [pointsAsNSValues count];
		previi = ii;

		[pointsAsNSValues[previi] getValue:&prevPt];
		[pointsAsNSValues[nextii] getValue:&nextPt];

		if (closed || ii < nCurves - 1) {
			mx = (nextPt.x - curPt.x) * 0.5 + (curPt.x - prevPt.x) * 0.5;
			my = (nextPt.y - curPt.y) * 0.5 + (curPt.y - prevPt.y) * 0.5;
		} else {
			mx = (curPt.x - prevPt.x) * 0.5;
			my = (curPt.y - prevPt.y) * 0.5;
		}

		CGPoint ctrlPt2;
		ctrlPt2.x = curPt.x - mx / 3.0;
		ctrlPt2.y = curPt.y - my / 3.0;

		[path addCurveToPoint:endPt controlPoint1:ctrlPt1 controlPoint2:ctrlPt2];
	}

	[[UIColor blackColor] setStroke];
	[path stroke];

	UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.attachedView.center.x + 22 - 3, self.attachedView.center.y - 12 - 3, 6, 6)];
	[[UIColor whiteColor] setFill];
	[ovalPath fill];
	[[UIColor blackColor] setStroke];
	ovalPath.lineWidth = 1.5;
	[ovalPath stroke];
}

#pragma mark - Getter

- (CGFloat)segmentWidth
{
	return self.originalFrame.size.width;
}

- (CGFloat)segmentLength
{
	return self.originalFrame.size.height / self.numSegments;
}

@end
