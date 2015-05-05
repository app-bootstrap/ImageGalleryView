//
//  ImageGalleryView.m
//  ImageGalleryView
//
//  Created by xdf on 3/1/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "ImageGalleryView.h"

@interface ImageGalleryView()
@property (strong) UIImageView *imgView;
@property (assign) CGRect scaleOriginRect;
@property (assign) CGSize imgSize;
@property (assign) CGRect initRect;
@end

@implementation ImageGalleryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.imgView = [[UIImageView alloc] init];
        self.imgView.clipsToBounds = YES;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview: self.imgView];
    }
    return self;
}

- (void)setContentWithFrame:(CGRect) rect {
    self.imgView.frame = rect;
    self.initRect = rect;
}

- (void)setAnimationRect {
    self.imgView.frame = self.scaleOriginRect;
}

- (void)rechangeInitRdct {
    self.zoomScale = 1.0;
    self.imgView.frame = self.initRect;
}

- (void)setImage:(UIImage *) image {
    if (image) {
        self.imgView.image = image;
        self.imgSize = image.size;
        float scaleX = self.frame.size.width / self.imgSize.width;
        float scaleY = self.frame.size.height / self.imgSize.height;
        
        if (scaleX > scaleY) {
            float imgViewWidth = self.imgSize.width * scaleY;
            self.maximumZoomScale = self.frame.size.width / imgViewWidth;
            self.scaleOriginRect = (CGRect) {
                self.frame.size.width / 2 - imgViewWidth / 2, 0, imgViewWidth, self.frame.size.height
            };
        } else {
            float imgViewHeight = self.imgSize.height * scaleX;
            self.maximumZoomScale = self.frame.size.height / imgViewHeight;
            self.scaleOriginRect = (CGRect) {0, self.frame.size.height / 2 - imgViewHeight / 2, self.frame.size.width, imgViewHeight};
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width / 2, contentSize.height / 2);
    
    if (imgFrame.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width/2;
    }
    
    if (imgFrame.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height/2;
    }
    self.imgView.center = centerPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(tapImageViewTappedWithObject:)]) {
        [self.delegate tapImageViewTappedWithObject:self];
    }
}

@end
