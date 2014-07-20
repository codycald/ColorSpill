//
//  FLTPhotoPreviewViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/16/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTPhotoPreviewViewController.h"
#import "GPUImage.h"
#import "MBProgressHUD.h"

@interface FLTPhotoPreviewViewController ()

@property (weak, nonatomic) IBOutlet GPUImageView *imageView;

@end

@implementation FLTPhotoPreviewViewController

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.margin = 5.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // We must process the image in viewDidAppear due to a bug with GPUImage
    // where processing the image in viewDidLoad or viewWillAppear will sometimes
    // cause the image to be streched on 3.5inch devices.
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
    
    [self.imageView setBackgroundColorRed:0.145 green:0.145 blue:0.145 alpha:1.0];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imagePicture addTarget:self.imageView];
    [self.imageView setInputRotation:rotationMode atIndex:0];
    [imagePicture processImageWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
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
