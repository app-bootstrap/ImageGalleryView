//
//  ImageTapView.h
//  ImageTapView
//
//  Created by xdf on 3/1/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapImageViewDelegate <NSObject>
- (void) tappedWithObject:(id) sender;
@end

@interface ImageTapView : UIImageView
@property (nonatomic, strong) id identifier;
@property (weak, nonatomic) id<TapImageViewDelegate> delegate;
@end