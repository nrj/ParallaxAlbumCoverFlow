//
//  ViewController.m
//  ParallaxAlbumCovers
//
//  Created by Nick Jensen on 1/16/14.
//  Copyright (c) 2014 Nick Jensen. All rights reserved.
//

#import "ViewController.h"
#import "ParallaxCoverCell.h"

// The amount of room on each side of the cells to be used for the
// parallax effect.
#define kParallaxAmount   30.0

// Change this to however big you want your cells to be.
#define kAlbumCoverHeight 82.0

// Leave this. The width will be the same as the height (a square)
// plus the parallax amount specified for each side.
#define kAlbumCoverWidth  (kAlbumCoverHeight + 2 * kParallaxAmount)

@implementation ViewController

@synthesize collectionView, collectionViewLayout, scrollTimer;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(kAlbumCoverWidth, kAlbumCoverHeight)];
    [collectionViewLayout setMinimumLineSpacing:-kParallaxAmount];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    CGRect collectionViewRect = CGRectMake(0.0, 22.0, 320.0, 130.0);
    collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewLayout];
    [collectionView registerClass:[ParallaxCoverCell class] forCellWithReuseIdentifier:kParallaxCoverCellIdent];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    [[self view] addSubview:collectionView];
    [collectionView release];
    [collectionViewLayout release];
}

/*
 * Computes the location of a cell in the collectionView on a scale of -1 to 1
 *    -1 : The cell is all the way left
 *     0 : The cell is directly centered
 *     1 : The cell is all the way right
 */
- (CGFloat)parallaxPositionForCell:(UICollectionViewCell *)cell {
    
    CGRect frame = [cell frame];
    CGPoint point = [[cell superview] convertPoint:frame.origin toView:collectionView];
    
    const CGFloat minX = CGRectGetMinX([collectionView bounds]) - frame.size.width; // off screen to the left
    const CGFloat maxX = CGRectGetMaxX([collectionView bounds]);                    // off screen to the right
    const CGFloat minPos = -1.0f;
    const CGFloat maxPos = 1.0f;
    
    // Compute the position with a linear equation.
    return (maxPos - minPos) / (maxX - minX) * (point.x - minX) + minPos;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    for (ParallaxCoverCell *cell in [collectionView visibleCells]) {

        // Update the parallax position for all visible cells as we
        // are scrolling.
        CGFloat position = [self parallaxPositionForCell:cell];
        [cell setParallaxPosition:position];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ParallaxCoverCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kParallaxCoverCellIdent forIndexPath:indexPath];
    UIImage *daftPunkCover = [UIImage imageNamed:@"cover"];
    UIImageView *frontImageView = [[cell imageViews] objectAtIndex:0];
    [frontImageView setImage:daftPunkCover];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark - Autoscroll

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self startAutoScrolling];
}

- (void)startAutoScrolling {
    
    if (!scrollTimer) {
        scrollTimer = [[NSTimer scheduledTimerWithTimeInterval:0.015
                                                        target:self
                                                      selector:@selector(scroll)
                                                      userInfo:nil
                                                       repeats:YES] retain];
    }
}

- (void)scroll {
    
    CGSize contentSize = [collectionView contentSize];
    CGRect collectionRect = [collectionView frame];
    CGPoint offset = [collectionView contentOffset];
    CGPoint endOffset = CGPointMake(contentSize.width - collectionRect.size.width, 0);
    
    if (CGPointEqualToPoint(offset, endOffset)) {
        [scrollTimer invalidate];
        [scrollTimer release];
        scrollTimer = nil;
    }
    
    [collectionView setContentOffset:CGPointMake(offset.x + 1.0, offset.y)];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // Stop the autoscrolling when touched
    if (scrollTimer) {
        [scrollTimer invalidate];
        [scrollTimer release];
        scrollTimer = nil;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end