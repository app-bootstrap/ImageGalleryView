//
//  ImageGalleryView.h
//  ImageGalleryView
//
//  Created by xdf on 3/1/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate <NSObject>
- (void)tapImageViewTappedWithObject:(id) sender;
@end

@interface ImageGalleryView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, assign) id<ImgScrollViewDelegate> delegate;
- (void)setContentWithFrame:(CGRect) rect;
- (void)setImage:(UIImage *) image;
- (void)setAnimationRect;
- (void)rechangeInitRdct;
@end