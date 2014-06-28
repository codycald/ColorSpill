//
//  FLTPhotoEditorViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/19/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTPhotoEditorViewController.h"
#import "GPUImage.h"
#import "FLTMenuItemCell.h"
#import "FLTMenuItemTitleView.h"
#import "FLTHorizontalScrollMenuLayout.h"

@interface FLTPhotoEditorViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UIImage *filteredImage;
@property (strong, nonatomic) UICollectionView *currentMenu;

@property (weak, nonatomic) IBOutlet GPUImageView *originalImageView;
@property (weak, nonatomic) IBOutlet GPUImageView *filteredImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *editingToolBar;

@end

typedef NS_ENUM(NSInteger, MenuType) {
    FilterMenuType = 1 << 0,
    ToolMenuType = 1 << 1
};

@implementation FLTPhotoEditorViewController

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Start out with no menu to display
        self.currentMenu = nil;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self reconfigureImageViews];
    
    // Process image and display it in the image views
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:self.image smoothlyScaleOutput:YES];
    [imagePicture addTarget:self.originalImageView];
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    [imagePicture addTarget:filter];
    [filter addTarget:self.filteredImageView];
    [filter useNextFrameForImageCapture];
    [imagePicture processImage];
    
    self.filteredImage = [filter imageFromCurrentFramebuffer];
    
    [self.originalImageView setHidden:YES];
    [self.filteredImageView setHidden:NO];
}

#pragma mark - UICollectionView data source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FLTMenuItemCell *cell = [collectView dequeueReusableCellWithReuseIdentifier:@"FLTMenuItemCell"
                                                                        forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"contrast"];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    FLTMenuItemTitleView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:@"title" withReuseIdentifier:@"FLTMenuItemTitleView" forIndexPath:indexPath];
    
    if (collectionView.tag == FilterMenuType) {
        titleView.label.text = @"hi";
    }
    return titleView;
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
            // Display the original image
            [self.originalImageView setHidden:NO];
            [self.filteredImageView setHidden:YES];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.originalImageView.isHidden) {
        // Display the filtered image
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
    
    GPUImageFilter *dummyFilter = [[GPUImageFilter alloc] init];
    [imagePicture addTarget:dummyFilter];
    [dummyFilter useNextFrameForImageCapture];
    
    [imagePicture processImage];
    self.filteredImage = [dummyFilter imageFromCurrentFramebuffer];
    
    [self.originalImageView setHidden:YES];
    [self.filteredImageView setHidden:NO];
}

- (IBAction)showFilterMenu:(id)sender {
    [self displayMenuOfType:FilterMenuType];
}

- (IBAction)showToolMenu:(id)sender {
    [self displayMenuOfType:ToolMenuType];
}

- (IBAction)shareImage:(id)sender {

    NSArray *imageToShare = @[self.filteredImage];
    UIActivityViewController *avc = [[UIActivityViewController alloc]
                                     initWithActivityItems:imageToShare applicationActivities:nil];
    avc.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:avc animated:YES completion:NULL];
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
    
    FLTHorizontalScrollMenuLayout *scrollMenuLayout = [[FLTHorizontalScrollMenuLayout alloc] init];
    
    // The tool menu items have no title, so we adjust the edge insets
    if (type == ToolMenuType) {
        scrollMenuLayout.edgeInsets = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        scrollMenuLayout.titleHeight = 0.0f;
    }
    
    self.currentMenu = [[UICollectionView alloc] initWithFrame:CGRectZero
                                            collectionViewLayout:scrollMenuLayout];
    
    // Place the menu directly above our bottom toolbar
    self.currentMenu.frame = CGRectMake(0, self.editingToolBar.frame.origin.y - scrollMenuLayout.collectionViewContentSize.height, self.view.bounds.size.width, scrollMenuLayout.collectionViewContentSize.height);
    
    UINib *cellNib = [UINib nibWithNibName:@"FLTMenuItemCell" bundle:nil];
    [self.currentMenu registerNib:cellNib forCellWithReuseIdentifier:@"FLTMenuItemCell"];
    
    [self.currentMenu registerClass:[FLTMenuItemTitleView class] forSupplementaryViewOfKind:@"title" withReuseIdentifier:@"FLTMenuItemTitleView"];
    
    self.currentMenu.dataSource = self;
    self.currentMenu.delegate = self;
    self.currentMenu.tag = type;
    [self.currentMenu setShowsHorizontalScrollIndicator:NO];
    self.currentMenu.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];

}

@end
