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
        const CGFloat   insetAmount      = 2.0f;
        
        // We only use the height dimension for our image view. So the padding
        // on either side will be the difference in width divided by 2.
        parallaxAmount = (frame.size.width - frame.size.height) / 2.0;
        
        CGRect imageRect;
        imageRect = CGRectInset(frame, parallaxAmount, 0);
        imageRect.size.height = imageRect.size.width;
        imageRect.origin.x = 0.5 * (frame.size.width - imageRect.size.width);
        imageRect.origin.y = frame.size.height - imageRect.size.height;
        
        NSMutableArray *mutable = [NSMutableArray array];
        for (NSInteger i = 0; i < numberImageViews; i++) {
            
            if (i > 0) {
                imageRect.size.width -= insetAmount;
                imageRect.origin.y -= insetAmount;
            }
            
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
    
    const CGFloat minOffsetX  = -parallaxAmount;
    const CGFloat maxOffsetX  = parallaxAmount;
    
    const CGFloat minPosition = 1.0;
    const CGFloat maxPosition = -1.0;

    // Compute the total offset using a linear equation
    CGFloat offsetX = (maxOffsetX - minOffsetX) / (maxPosition - minPosition) * (position - minPosition) + minOffsetX;

    // Divide the total offset among the moving images
    offsetX /= ([imageViews count] - 1);
    
    // Apply the offsetX to each image relative to the first one
    CGRect fixedRect = [[imageViews objectAtIndex:0] frame];
    for (NSInteger i = 1; i < [imageViews count]; i++) {
        
        UIImageView *imageView = [imageViews objectAtIndex:i];
        CGRect imageRect = [imageView frame];
        CGFloat imageWidth = imageRect.size.width;
        imageRect.origin.x = CGRectGetMidX(fixedRect) - 0.5 * imageWidth + (offsetX * i);
        [imageView setFrame:imageRect];
    }
}

- (void)dealloc {
    
    [imageViews release];
    [super dealloc];
}

@end