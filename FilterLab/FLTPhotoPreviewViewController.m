//
//  FLTPhotoPreviewViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/16/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTPhotoPreviewViewController.h"
#import "GPUImage.h"

@interface FLTPhotoPreviewViewController ()

@property (weak, nonatomic) IBOutlet GPUImageView *imageView;

@end

@implementation FLTPhotoPreviewViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:self.image smoothlyScaleOutput:YES];
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
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imagePicture addTarget:self.imageView];
    [self.imageView setInputRotation:rotationMode atIndex:0];
    [imagePicture processImage];
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    
    if (self.delegate) {
        [self.delegate photoPreviewCancelPreview:self];
    }
}

- (IBAction)usePhoto:(id)sender {
    
    if (self.delegate) {
        [self.delegate photoPreview:self useImage:self.image];
    }
}

@end
