//
//  ViewController.h
//  ParallaxAlbumCovers
//
//  Created by Nick Jensen on 1/16/14.
//  Copyright (c) 2014 Nick Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, readonly) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, readonly) NSTimer *scrollTimer;

@end
