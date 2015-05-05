//
//  ImageTapView.m
//  ImageTapView
//
//  Created by xdf on 3/1/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "ImageTapView.h"

@implementation ImageTapView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
        [self addGestureRecognizer:tap];
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) Tapped:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(tappedWithObject:)]) {
        [self.delegate tappedWithObject:self];
    }
}

@end