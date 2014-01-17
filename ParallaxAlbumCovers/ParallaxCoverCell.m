//
//  ParallaxCoverCell.m
//  ParallaxAlbumCovers
//
//  Created by Nick Jensen on 1/16/14.
//  Copyright (c) 2014 Nick Jensen. All rights reserved.
//

#import "ParallaxCoverCell.h"

@implementation ParallaxCoverCell

@synthesize parallaxAmount, imageViews;

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        const NSInteger numberImageViews = 5;
        const CGFloat   alphaDecrease    = 0.20;
        const CGFloat   deviceScale      = [[UIScreen mainScreen] scale];
        
        // We use the height for the size of each image view. So the parallax
        // amount will be the difference in width divided by 2 for each side.
        parallaxAmount = (frame.size.width - frame.size.height) / 2.0;
        
        CGRect imageRect;
        imageRect = CGRectInset(frame, parallaxAmount, 0);
        imageRect.size.height = imageRect.size.width;
        imageRect.origin.x = 0.5 * (frame.size.width - imageRect.size.width);
        imageRect.origin.y = frame.size.height - imageRect.size.height;
        
        NSMutableArray *mutable = [NSMutableArray array];
        for (NSInteger i = 0; i < numberImageViews; i++) {
            
            UIImageView *imageView;
            imageView = [[UIImageView alloc] initWithFrame:imageRect];
            [imageView setAlpha:MAX(0.0, 1.0 - (alphaDecrease * i))];
            [[imageView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
            [[imageView layer] setBorderWidth:1.0 / deviceScale];
            [[imageView layer] setShouldRasterize:YES];
            [[imageView layer] setRasterizationScale:deviceScale];
            
            [self insertSubview:imageView atIndex:0];
            [mutable addObject:imageView];
            [imageView release];
        }
        imageViews = [[NSArray arrayWithArray:mutable] retain];
        [self setParallaxPosition:-1];
    }
    return self;
}

- (void)setParallaxPosition:(CGFloat)position {
    
    const CGFloat minPosition = 1.0;
    const CGFloat maxPosition = -1.0;
    const CGFloat minOffsetX  = -parallaxAmount;
    const CGFloat maxOffsetX  = parallaxAmount;
    
    // Linear Equation
    CGFloat offsetX = (maxOffsetX - minOffsetX) / (maxPosition - minPosition) * (position - minPosition) + minOffsetX;
    offsetX /= ([imageViews count] - 1);
    
    const CGFloat offsetMultiple = 2.0f;
    
    CGRect frame = [[imageViews objectAtIndex:0] frame];
    
    for (NSInteger i = 1; i < [imageViews count]; i++) {
        
        CGFloat width = frame.size.width - (offsetMultiple * i);
        CGFloat height = frame.size.height - (offsetMultiple * i);
        CGFloat yPos = frame.origin.y - (offsetMultiple * i);
        CGFloat xPos = frame.origin.x + 0.5 * (frame.size.width - width) + (offsetX * i);
        
        UIImageView *imageView = [imageViews objectAtIndex:i];
        [imageView setFrame:CGRectMake(xPos, yPos, width, height)];
    }
}

- (void)dealloc {
    
    [imageViews release];
    [super dealloc];
}

@end