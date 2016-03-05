//
//  GZCollectionViewLayout.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/13/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZCollectionViewLayout.h"

@implementation GZCollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
	for (int i = 0; i < [attributes count]; ++i) {
		UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        if (ABS(currentLayoutAttributes.center.x - SCREEN_WIDTH / 2.) <= 2) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = self.sectionInset.left;
            currentLayoutAttributes.frame = frame;
        }
	}
	return attributes;
}


@end
