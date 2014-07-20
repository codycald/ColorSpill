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
#import "MBProgressHUD.h"

@interface FLTCameraViewController () <FLTPhotoPreviewViewControllerDelegate>

@property (strong, nonatomic) GPUImageStillCamera *camera;
@property (strong, nonatomic) GPUImageFilter *currentFilter;

@property (weak, nonatomic) IBOutlet GPUImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;


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
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    if (self.delegate) {
        [self.delegate cameraViewController:self didCaptureImage:image];
    }
}

#pragma mark - Actions

- (IBAction)capturePhoto:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.margin = 15.0f;
    self.captureButton.enabled = NO;
    [self.camera capturePhotoAsImageProcessedUpToFilter:self.currentFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            
            FLTPhotoPreviewViewController *pvc = [[FLTPhotoPreviewViewController alloc] init];
            pvc.image = processedImage;
            pvc.delegate = self;
            [self presentViewController:pvc animated:YES completion:NULL];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Could not capture photo"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        self.captureButton.enabled = YES;
    }];
}

- (IBAction)cancelPhotoCapture:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)switchCamera:(id)sender {
    
    [self.camera rotateCamera];
    
    // We must horizontally mirror the camera when the front facing
    // camera is active, or the output will be upside down when in
    // landscape mode.
    if (self.camera.cameraPosition == AVCaptureDevicePositionFront) {
        self.camera.horizontallyMirrorFrontFacingCamera = YES;
    } else {
        self.camera.horizontallyMirrorFrontFacingCamera = NO;
        
    }
}

@end
