//
//  FLTPhotoEditorViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/19/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTPhotoEditorViewController.h"
#import "GPUImage.h"

@interface FLTPhotoEditorViewController ()

@property (weak, nonatomic) IBOutlet GPUImageView *originalImageView;
@property (weak, nonatomic) IBOutlet GPUImageView *filteredImageView;

@end

@implementation FLTPhotoEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 
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

@end
