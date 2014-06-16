//
//  FLTCameraViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/15/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTCameraViewController.h"
#import "GPUImage.h"

@interface FLTCameraViewController ()

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

#pragma mark - Actions

@end