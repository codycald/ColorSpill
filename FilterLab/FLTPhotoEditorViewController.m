//
//  FLTPhotoEditorViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/19/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTPhotoEditorViewController.h"
#import "GPUImage.h"

@interface FLTPhotoEditorViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *currentMenu;
@property (assign, nonatomic) NSInteger menuPadding;

@property (weak, nonatomic) IBOutlet GPUImageView *originalImageView;
@property (weak, nonatomic) IBOutlet GPUImageView *filteredImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *editingToolBar;

@end

typedef enum {
    kFilterMenu = 1,
    kToolMenu = 2
} MenuType;

@implementation FLTPhotoEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.menuPadding = 10;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self reconfigureImageViews];
    
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:self.image smoothlyScaleOutput:YES];
    [imagePicture addTarget:self.originalImageView];
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    [imagePicture addTarget:filter];
    [filter addTarget:self.filteredImageView];
    [imagePicture processImage];
    
    [self.originalImageView setHidden:YES];
    [self.filteredImageView setHidden:NO];
}

#pragma mark - UICollectionView data source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell"
                                                                        forIndexPath:indexPath];
    
    switch (collectView.tag) {
        case kFilterMenu:
            cell.backgroundColor = [UIColor whiteColor];
            break;
            
        case kToolMenu:
            cell.backgroundColor = [UIColor blueColor];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UICollectionView delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected item #%ld", indexPath.row);
}

#pragma mark - Touch event handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.originalImageView];
    if (touch) {
        if (CGRectContainsPoint(self.originalImageView.bounds, location)) {
            [self.originalImageView setHidden:NO];
            [self.filteredImageView setHidden:YES];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.originalImageView.isHidden) {
        [self.originalImageView setHidden:YES];
        [self.filteredImageView setHidden:NO];
    }
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    
    if (self.delegate) {
        [self.delegate photoEditorViewControllerDidCancel:self];
    }
}

- (IBAction)revertChanges:(id)sender {
    
    [self reconfigureImageViews];
    
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:self.image smoothlyScaleOutput:YES];
    [imagePicture addTarget:self.originalImageView];
    [imagePicture addTarget:self.filteredImageView];
    [imagePicture processImage];
    
    [self.originalImageView setHidden:YES];
    [self.filteredImageView setHidden:NO];
}

- (IBAction)showFilterMenu:(id)sender {
    [self displayMenuOfType:kFilterMenu];
}

- (IBAction)showToolMenu:(id)sender {
    [self displayMenuOfType:kToolMenu];
}

#pragma mark - Helper methods

- (void)reconfigureImageViews {
    
    self.originalImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.filteredImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // We must reset the rotationMode of the GPUImageViews everytime
    // we want to reprocess an image
    GPUImageRotationMode rotationMode = kGPUImageNoRotation;
    
    switch (self.image.imageOrientation) {
        case UIImageOrientationUp:
            break;
        case UIImageOrientationDown:
            rotationMode = kGPUImageRotate180;
            break;
        case UIImageOrientationLeft:
            rotationMode = kGPUImageRotateLeft;
            break;
        case UIImageOrientationRight:
            rotationMode = kGPUImageRotateRight;
            break;
        default:
            break;
    }
    
    [self.originalImageView setInputRotation:rotationMode atIndex:0];
    [self.filteredImageView setInputRotation:rotationMode atIndex:0];
}

- (void)displayMenuOfType:(MenuType)type {
    
    UICollectionView *previousMenu = self.currentMenu;
    
    // If there is no menu showing, or if the currently
    // displayed menu is of a different type than the requested
    // menu, recreate the menu
    if (!self.currentMenu || self.currentMenu.tag != type) {
        
        [self configureScrollMenuOfType:type];
        [self.view addSubview:self.currentMenu];
        
    } else {
        self.currentMenu = nil;
    }
    
    // Hide the previous menu if it exists
    if (previousMenu) {
        [previousMenu removeFromSuperview];
    }
}

- (void)configureScrollMenuOfType:(MenuType)type {
    
    UICollectionViewFlowLayout *scrollMenuLayout = [[UICollectionViewFlowLayout alloc] init];
    scrollMenuLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    scrollMenuLayout.sectionInset = UIEdgeInsetsMake(0, self.menuPadding, 0, self.menuPadding);
    
    CGFloat menuItemSize;
    switch (type) {
        case kToolMenu:
            menuItemSize = 50;
            break;
        case kFilterMenu:
            menuItemSize = 30;
            break;
    }
    
    scrollMenuLayout.itemSize = CGSizeMake(menuItemSize, menuItemSize);
    
    self.currentMenu = [[UICollectionView alloc] initWithFrame:CGRectZero
                                            collectionViewLayout:scrollMenuLayout];
    [self.currentMenu registerClass:[UICollectionViewCell class]
           forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.currentMenu.dataSource = self;
    self.currentMenu.delegate = self;
    self.currentMenu.tag = type;
    [self.currentMenu setShowsHorizontalScrollIndicator:NO];
    self.currentMenu.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    CGFloat scrollMenuHeight = menuItemSize + self.menuPadding * 2;
    self.currentMenu.frame = CGRectMake(0,
                                        self.editingToolBar.frame.origin.y - scrollMenuHeight,
                                        self.view.bounds.size.width,
                                        scrollMenuHeight);
}

@end
