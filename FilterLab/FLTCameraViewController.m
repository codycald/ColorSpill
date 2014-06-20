//
//  FLTCameraViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/15/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTCameraViewController.h"
#import "GPUImage.h"
#import "FLTPhotoPreviewViewController.h"

@interface FLTCameraViewController () <FLTPhotoPreviewViewControllerDelegate>

@property (strong, nonatomic) GPUImageStillCamera *camera;
@property (strong, nonatomic) GPUImageFilter *currentFilter;

@property (weak, nonatomic) IBOutlet GPUImageView *imageView;

@end

@implementation FLTCameraViewController

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.camera = [[GPUImageStillCamera alloc] init];
        self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        self.currentFilter = [[GPUImageFilter alloc] init];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.camera addTarget:self.currentFilter];
    [self.currentFilter addTarget:self.imageView];
    [self.camera startCameraCapture];
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Photo preview delegate methods

- (void)photoPreviewCancelPreview:(FLTPhotoPreviewViewController *)photoPreview {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)photoPreview:(FLTPhotoPreviewViewController *)photoPreview useImage:(UIImage *)image {
    
    if (self.delegate) {
        [self.delegate cameraViewController:self didCaptureImage:image];
    }
}

#pragma mark - Actions

- (IBAction)capturePhoto:(id)sender {
    
    [self.camera capturePhotoAsImageProcessedUpToFilter:self.currentFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (!error) {
            FLTPhotoPreviewViewController *pvc = [[FLTPhotoPreviewViewController alloc] init];
            pvc.image = processedImage;
            pvc.delegate = self;
            [self presentViewController:pvc animated:YES completion:NULL];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not capture photo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)cancelPhotoCapture:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
