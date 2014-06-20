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

@property (weak, nonatomic) IBOutlet GPUImageView *imageView;

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
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    
    [imagePicture addTarget:self.imageView];
    [self.imageView setInputRotation:rotationMode atIndex:0];
    [imagePicture processImage];
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    
    if (self.delegate) {
        [self.delegate photoEditorViewControllerDidCancel:self];
    }
}


@end
