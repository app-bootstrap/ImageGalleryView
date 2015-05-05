//
//  ViewController.m
//  ImageGalleryView
//
//  Created by xdf on 4/20/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "ViewController.h"
#import "ImageGalleryView.h"
#import "ImageTapView.h"

@interface ViewController ()
@property (nonatomic, strong) NSBundle *mainBundle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *parentScrollView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (strong) UIView *scrollPanel;
@property (strong) UIView *maskView;
@property (strong) UIScrollView *innerScrollView;
@property (assign) NSInteger currentIndex;
@property (assign) NSInteger currentRow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = @"ImageGalleryView";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview: self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.mainBundle = [NSBundle mainBundle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (NSInteger)getImagesNum:(NSInteger)index {
    long intTemp = 0;
    switch (index) {
        case 0:
            intTemp = 6;
            break;
        case 1:
            intTemp = 4;
            break;
        case 2:
            intTemp = 3;
            break;
    }
    return intTemp;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    self.currentRow = indexPath.row;
    long tempInt = [self getImagesNum: indexPath.row];
    NSString *stringInt = [NSString stringWithFormat:@"%ld_0", (long)indexPath.row];
    NSString *stringItemNum = [NSString stringWithFormat:@"%lditems", tempInt];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *imagePath = [self.mainBundle pathForResource: stringInt ofType:@"jpg"];
    UIImage *imgFromUrl = [[UIImage alloc] initWithContentsOfFile:imagePath];
    CGSize newSize = CGSizeMake(self.view.frame.size.width * 0.6, self.view.frame.size.width * 0.6 * imgFromUrl.size.height / imgFromUrl.size.width);
    imgFromUrl = [self scaleToSize:imgFromUrl size:newSize];
    UIImageView* imageView=[[UIImageView alloc]initWithImage: imgFromUrl];
    imageView.frame = CGRectMake(self.view.frame.size.width * 0.2, self.view.frame.size.width * 0.2, newSize.width, newSize.height);
    [cell addSubview: imageView];
    UILabel *itemLabel = [[UILabel alloc]initWithFrame: CGRectMake((self.view.frame.size.width - 45) / 2, self.view.frame.size.width * 0.2 + newSize.height + 20, 45, 20)];
    itemLabel.text = stringItemNum;
    itemLabel.textColor = [UIColor grayColor];
    itemLabel.font = [itemLabel.font fontWithSize:14];
    [cell addSubview: itemLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringInt = [NSString stringWithFormat:@"%ld_0", (long)indexPath.row];
    NSString *imagePath = [self.mainBundle pathForResource:stringInt ofType:@"jpg"];
    UIImage *imgFromUrl = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return self.view.frame.size.width * 0.8 * imgFromUrl.size.height / imgFromUrl.size.width + self.view.frame.size.width * 0.3;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    long tempInt = [self getImagesNum: indexPath.row];
    self.parentScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.parentScrollView.backgroundColor = [UIColor whiteColor];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.closeBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 45, self.view.frame.size.height - 200, 90, 35);
    [self.closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeParentLayer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.parentScrollView addSubview: self.closeBtn];
    
    self.scrollPanel = [[UIView alloc] initWithFrame: self.parentScrollView.bounds];
    self.scrollPanel.backgroundColor = [UIColor clearColor];
    self.scrollPanel.alpha = 0;
    
    self.maskView = [[UIView alloc] initWithFrame: self.scrollPanel.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.scrollPanel addSubview: self.maskView];
    
    self.innerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.scrollPanel addSubview: self.innerScrollView];
    self.innerScrollView.pagingEnabled = YES;
    self.innerScrollView.delegate = self;
    CGSize contentSize = self.innerScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = tempInt * self.view.bounds.size.width;
    self.innerScrollView.contentSize = contentSize;
    [self.view addSubview: self.parentScrollView];
    
    for (int i = 0; i < tempInt; i ++) {
        NSInteger row = round(i / 3);
        NSInteger p = i % 3;
        ImageTapView *imageView = [[ImageTapView alloc] initWithFrame:CGRectMake(p * 130, row * 90 + 30, 120, 80)];
        imageView.delegate = self;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld_%d.jpg", (long)indexPath.row, i]];
        imageView.tag = 20 + i;
        [self.parentScrollView addSubview: imageView];
        ImageTapView *tmpView = (ImageTapView *)[self.parentScrollView viewWithTag: imageView.tag];
        tmpView.identifier = self;
    }
    
    [self.parentScrollView addSubview: self.scrollPanel];
}

-(void) closeParentLayer:(id)sender {
    [self.parentScrollView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) addSubImgView {
    for (UIView *tmpView in self.innerScrollView.subviews) {
        [tmpView removeFromSuperview];
    }
    long tempInt = [self getImagesNum: self.currentRow];
    for (int i = 0; i < tempInt; i ++) {
        if (i == self.currentIndex) {
            continue;
        }
        ImageTapView *tmpView = (ImageTapView *)[self.view viewWithTag: 20 + i];
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        ImageGalleryView *scrollView = [[ImageGalleryView alloc] initWithFrame:(CGRect){i * self.innerScrollView.bounds.size.width, 0, self.innerScrollView.bounds.size}];
        [scrollView setContentWithFrame:convertRect];
        [scrollView setImage:tmpView.image];
        [self.innerScrollView addSubview: scrollView];
        scrollView.delegate = self;
        [scrollView setAnimationRect];
    }
}

- (void) setMaskFrame:(ImageGalleryView *) sender {
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        self.maskView.alpha = 0.95;
    }];
}

- (void) tappedWithObject:(id)sender {
    [self.view bringSubviewToFront: self.scrollPanel];
    self.scrollPanel.alpha = 1.0;
    ImageTapView *tmpView = sender;
    self.currentIndex = tmpView.tag - 20;
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    CGPoint contentOffset = self.innerScrollView.contentOffset;
    contentOffset.x = self.currentIndex * self.view.bounds.size.width;
    self.innerScrollView.contentOffset = contentOffset;
    [self addSubImgView];
    ImageGalleryView *tmpImgScrollView = [[ImageGalleryView alloc] initWithFrame:(CGRect){contentOffset, self.innerScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [self.innerScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.delegate = self;
    [self performSelector:@selector(setMaskFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

- (void) tapImageViewTappedWithObject:(id)sender {
    ImageGalleryView *tmpImgView = sender;
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        self.scrollPanel.alpha = 0;
    }];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    self.currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

@end