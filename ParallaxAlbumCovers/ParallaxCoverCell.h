//
//  ParallaxCoverCell.h
//  ParallaxAlbumCovers
//
//  Created by Nick Jensen on 1/16/14.
//  Copyright (c) 2014 Nick Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kParallaxCoverCellIdent @"ParallaxCoverCellIdent"

@interface ParallaxCoverCell : UICollectionViewCell

@property (nonatomic, readonly) CGFloat parallaxAmount;
@property (nonatomic, readonly) NSArray *imageViews;

- (void)setParallaxPosition:(CGFloat)position;

@end