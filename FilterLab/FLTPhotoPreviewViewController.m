//
//  FLTPhotoPreviewViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/16/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTPhotoPreviewViewController.h"

@interface FLTPhotoPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FLTPhotoPreviewViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.imageView.image = self.image;
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    
    if (self.delegate) {
        [self.delegate photoPreviewCancelPreview:self];
    }
}

- (IBAction)usePhoto:(id)sender {
    
    if (self.delegate) {
        [self.delegate photoPreviewUsePhoto:self];
    }
}

@end
