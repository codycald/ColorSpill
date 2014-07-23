//
//  CSPhotoEditorViewController.m
//  ColorSpill
//
//  Created by Cody Caldwell on 6/19/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSPhotoEditorViewController.h"
#import "GPUImage.h"
#import "CSMenuItemCell.h"
#import "CSMenuItemTitleView.h"
#import "CSHorizontalScrollMenuLayout.h"
#import "CSFilterManager.h"
#import "CSImageEffectType.h"
#import "CSFilter.h"
#import "MBProgressHUD.h"

@interface CSPhotoEditorViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) GPUImagePicture *filteredImagePicture;
@property (strong, nonatomic) UIImage *filteredImage;
@property (strong, nonatomic) UICollectionView *currentMenu;
@property (strong, nonatomic) CSFilterManager *filterManager;
@property (strong, nonatomic) CSFilter *currentFilter;

@property (weak, nonatomic) IBOutlet GPUImageView *originalImageView;
@property (weak, nonatomic) IBOutlet GPUImageView *filteredImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *editingToolBar;
@property (weak, nonatomic) IBOutlet UIToolbar *filterSlider;

@property (weak, nonatomic) IBOutlet UIView *filterNameView;

@end

typedef NS_ENUM(NSInteger, MenuType) {
    GeneralFilterMenuType = 1 << 0,
    ToolFilterMenuType = 1 << 1
};

@implementation CSPhotoEditorViewController

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Start out with no menu to display
        self.currentMenu = nil;
        self.filterManager = [[CSFilterManager alloc] init];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.originalImageView setBackgroundColorRed:0.145 green:0.145 blue:0.145 alpha:1.0];
    [self.filteredImageView setBackgroundColorRed:0.145 green:0.145 blue:0.145 alpha:1.0];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.margin = 5.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self reconfigureImageViews];
    
    // Process image and display it in the image views
    self.filteredImagePicture = [[GPUImagePicture alloc] initWithImage:self.image smoothlyScaleOutput:YES];
    [self.filteredImagePicture addTarget:self.originalImageView];
    GPUImageFilter *filter = [[GPUImageFilter alloc] init];
    [self.filteredImagePicture addTarget:filter];
    [filter addTarget:self.filteredImageView];
    [filter useNextFrameForImageCapture];
    [self.filteredImagePicture processImageWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
    self.filteredImage = [filter imageFromCurrentFramebuffer];
    
    [self displayFilterSlider:NO];
    
    [self.originalImageView setHidden:YES];
    [self.filteredImageView setHidden:NO];
}

#pragma mark - UIViewController overrides

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - UICollectionView data source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (collectionView.tag) {
        case GeneralFilterMenuType:
            return self.filterManager.generalFilters.count;
            
        case ToolFilterMenuType:
            return self.filterManager.toolFilters.count;
            
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSMenuItemCell *cell = [collectView dequeueReusableCellWithReuseIdentifier:@"CSMenuItemCell"
                                                                        forIndexPath:indexPath];
    CSFilter *filter;
    if (collectView.tag == GeneralFilterMenuType) {
        filter = self.filterManager.generalFilters[indexPath.row];
    } else {
        filter = self.filterManager.toolFilters[indexPath.row];
    }
    cell.imageView.image = [UIImage imageNamed:filter.imageName];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    CSMenuItemTitleView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:@"title" withReuseIdentifier:@"CSMenuItemTitleView" forIndexPath:indexPath];
    
    CSFilter *filter;
    if (collectionView.tag == GeneralFilterMenuType) {
        filter = self.filterManager.generalFilters[indexPath.row];
        titleView.label.text = filter.filterName;
    }
    return titleView;
}

#pragma mark - UICollectionView delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == GeneralFilterMenuType) {
        self.currentFilter = self.filterManager.generalFilters[indexPath.row];
    } else {
        self.currentFilter = self.filterManager.toolFilters[indexPath.row];
    }
    
    // Setup the filter name view
    UILabel *filterName = (UILabel *)[self.filterNameView viewWithTag:100];
    filterName.text = self.currentFilter.filterName;
    
    // Set up filter slider
    UISlider *slider = (UISlider *)[self.filterSlider viewWithTag:100];
    slider.maximumValue = self.currentFilter.maximumFilterValue;
    slider.minimumValue = self.currentFilter.minimumFilterValue;
    slider.value = self.currentFilter.startingFilterValue;
    
    [self displayFilterSlider:YES];
    
    // Setup fiter chain and process image
    [self.filteredImagePicture removeAllTargets];
    [self.filteredImagePicture addTarget:self.currentFilter];
    [self.currentFilter addTarget:self.filteredImageView];
    self.currentFilter.intensity = slider.value;
    [self.currentFilter forceProcessingAtSizeRespectingAspectRatio:self.filteredImageView.bounds.size];
    [self reconfigureImageViews];
    [self.filteredImagePicture processImage];
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqualToString:@"Go to home"] && buttonIndex == 1) {
        
        if (self.delegate) {
            [self.delegate photoEditorViewControllerDidCancel:self];
        }
        
    } else if ([alertView.title isEqualToString:@"Discard changes"] && buttonIndex == 1) {
        
        self.filteredImagePicture = [[GPUImagePicture alloc] initWithImage:self.image];
        
        GPUImageFilter *dummyFilter = [[GPUImageFilter alloc] init];
        [self.filteredImagePicture addTarget:dummyFilter];
        [dummyFilter useNextFrameForImageCapture];
        [dummyFilter addTarget:self.originalImageView];
        [dummyFilter addTarget:self.filteredImageView];
        
        [self reconfigureImageViews];
        [self.filteredImagePicture processImage];
        
        [self.originalImageView setHidden:YES];
        [self.filteredImageView setHidden:NO];
    }
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Go to home" message:@"Go back to home screen?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go back", nil];
    [alert show];
}

- (IBAction)revertChanges:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Discard changes" message:@"Are you sure you want to discard all changes?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Discard", nil];
    [alert show];
}

- (IBAction)showFilterMenu:(id)sender {
    [self displayMenuOfType:GeneralFilterMenuType];
}

- (IBAction)showToolMenu:(id)sender {
    [self displayMenuOfType:ToolFilterMenuType];
}

- (IBAction)shareImage:(id)sender {

    // Create a copy of the filtered image with the same orientation as the original image
    UIImage *finalImage = [UIImage imageWithCGImage:self.filteredImage.CGImage
                                              scale:1.0f
                                        orientation:self.image.imageOrientation];
    
    NSArray *imageToShare = @[finalImage];
    UIActivityViewController *avc = [[UIActivityViewController alloc]
                                     initWithActivityItems:imageToShare applicationActivities:nil];
    avc.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    avc.completionHandler = ^(NSString *activityType, BOOL completed) {
        
        if (completed && [activityType isEqualToString:UIActivityTypeSaveToCameraRoll]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Complete" message:@"The image has been saved to your camera roll" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    };
    [self presentViewController:avc animated:YES completion:NULL];
}

- (IBAction)sliderCancel:(id)sender {
    
    self.currentFilter = nil;
    
    [self reconfigureImageViews];
    
    [self.filteredImagePicture removeAllTargets];
    [self.filteredImagePicture addTarget:self.filteredImageView];
    [self.filteredImagePicture processImage];
    
    [self displayFilterSlider:NO];
}

- (IBAction)sliderConfirm:(id)sender {
    
    UISlider *slider = (UISlider *)[self.filterSlider viewWithTag:100];
    [self reconfigureImageViews];
    
    [self.currentFilter useNextFrameForImageCapture];
    self.currentFilter.intensity = slider.value;
    [self.filteredImagePicture processImageWithCompletionHandler:^{
        
        // Grab filtered image once processing completes
        self.filteredImage = [self.currentFilter imageFromCurrentFramebuffer];
        self.filteredImagePicture = [[GPUImagePicture alloc] initWithImage:self.filteredImage];
        
        // Update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayFilterSlider:NO];
        });
    }];
}

- (IBAction)sliderValueChanged:(id)sender {
    [self reconfigureImageViews];
    self.currentFilter.intensity = [(UISlider *)sender value];
    [self.filteredImagePicture processImage];
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
    
    CSHorizontalScrollMenuLayout *scrollMenuLayout = [[CSHorizontalScrollMenuLayout alloc] init];
    
    // The tool menu items have no title, so we adjust the edge insets
    if (type == ToolFilterMenuType) {
        scrollMenuLayout.edgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        scrollMenuLayout.itemSize = CGSizeMake(32.0f, 32.0f);
        scrollMenuLayout.titleHeight = 0.0f;
        scrollMenuLayout.interItemSpacingX = 10.0f;
    }
    
    self.currentMenu = [[UICollectionView alloc] initWithFrame:CGRectZero
                                            collectionViewLayout:scrollMenuLayout];
    
    // Place the menu directly above our bottom toolbar
    self.currentMenu.frame = CGRectMake(0, self.editingToolBar.frame.origin.y - scrollMenuLayout.collectionViewContentSize.height, self.view.bounds.size.width, scrollMenuLayout.collectionViewContentSize.height);
    
    UINib *cellNib = [UINib nibWithNibName:@"CSMenuItemCell" bundle:nil];
    [self.currentMenu registerNib:cellNib forCellWithReuseIdentifier:@"CSMenuItemCell"];
    
    [self.currentMenu registerClass:[CSMenuItemTitleView class] forSupplementaryViewOfKind:@"title" withReuseIdentifier:@"CSMenuItemTitleView"];
    
    self.currentMenu.dataSource = self;
    self.currentMenu.delegate = self;
    self.currentMenu.tag = type;
    [self.currentMenu setShowsHorizontalScrollIndicator:NO];
    self.currentMenu.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.75];

}

- (void)displayFilterSlider:(BOOL)shouldDisplaySlider {
    
    [self.currentMenu setHidden:shouldDisplaySlider];
    [self.editingToolBar setHidden:shouldDisplaySlider];
    [self.filterSlider setHidden:!shouldDisplaySlider];
    [self.filterNameView setHidden:!shouldDisplaySlider];
}

@end
