//
//  GZMenuBar.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/2/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZMenuBar.h"
#import "POP.h"

@interface GZMenuBar ()

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *itemLabels;

@end

@implementation GZMenuBar

- (instancetype)initWithItemTitles:(NSArray *)array andFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor blackColor];
		for (NSString *str in array) {
			UIView *view = [UIView new];
			view.backgroundColor = RGBACOLOR(255, 255, 255, 0.7);
			[self.items addObject:view];
			[self addSubview:view];

			UILabel *label = [UILabel new];
			label.textAlignment = NSTextAlignmentCenter;
			label.text = str;
			label.textColor = [UIColor whiteColor];
            label.hidden = YES;
			label.font = [UIFont fontWithStyle:GZFontStyleDescription];
			[label sizeToFit];
			[self.itemLabels addObject:label];
			[self addSubview:label];
		}
		for (NSInteger i = 0; i < self.items.count; i++) {
			UIView *view = self.items[i];
			CGRect rect = view.frame;
			rect.size = CGSizeMake(20, 20);
			view.frame = rect;
			view.center = CGPointMake(CGRectGetWidth(frame) / (self.items.count + 1) * (i + 1), CGRectGetHeight(frame) / 2. - 5);

			UILabel *label = self.itemLabels[i];
			label.center = CGPointMake(view.center.x, CGRectGetMaxY(view.frame) + 12);
		}
        _selectedIndex = -1;
	}
	return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex >= (NSInteger)self.items.count) {
        return;
    }
	if (selectedIndex != _selectedIndex) {
        if (selectedIndex >= 0) {
            [self setItemIndex:selectedIndex selected:YES];
        }
        if (_selectedIndex >= 0) {
            [self setItemIndex:_selectedIndex selected:NO];
        }
        _selectedIndex = selectedIndex;
	}
}

- (void)setItemIndex:(NSInteger)index selected:(BOOL)selected
{
    
	UIView *vv = self.items[index];
	UILabel *label = self.itemLabels[index];
	if (selected) {
        POPSpringAnimation *animation = [vv pop_animationForKey:@"scale"];
        if (animation) {
            [vv pop_removeAnimationForKey:@"scale"];
        }
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        animation.springBounciness = 20;
        animation.springSpeed = 3;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2f, 1.2f)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)];
        [vv pop_addAnimation:animation forKey:@"scale"];
        
        vv.layer.cornerRadius = 5;
        vv.backgroundColor = RGBACOLOR(255, 255, 255, 1);
        
        label.hidden = NO;
	} else {
        label.hidden = YES;
        vv.layer.cornerRadius = 0.;
        vv.backgroundColor = RGBACOLOR(255, 255, 255, 0.7);
	}
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextBeginPath(context);

	CGFloat pixelAdjustOffset = 0;
	if (((int)(SINGLE_LINE_WIDTH * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
		pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
	}

	CGContextMoveToPoint(context, 10, CGRectGetMaxY(rect) - pixelAdjustOffset);
	CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - 10, CGRectGetMaxY(rect) - pixelAdjustOffset);

	CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextStrokePath(context);
}

#pragma mark - getter

- (NSMutableArray *)items
{
	if (!_items) {
		_items = [NSMutableArray array];
	}
	return _items;
}

- (NSMutableArray *)itemLabels
{
	if (!_itemLabels) {
		_itemLabels = [NSMutableArray array];
	}
	return _itemLabels;
}

@end
