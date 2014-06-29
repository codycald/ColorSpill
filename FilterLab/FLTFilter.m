//
//  FLTFilter.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/28/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTFilter.h"
#import "GPUImage.h"

@implementation FLTFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Filter";
        self.imageName = @"contrast";
        self.type = FLTGeneralFilterType;
    }
    return self;
}

- (UIImage *)filteredImageWithImage:(UIImage *)image destinationViews:(NSArray *)imageViews intensity:(NSInteger)intensity {
    
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    GPUImageFilter *dummyFilter = [[GPUImageFilter alloc] init];
    [imagePicture addTarget:dummyFilter];
    
    for (GPUImageView *imageView in imageViews) {
        [dummyFilter addTarget:imageView];
    }
    [dummyFilter useNextFrameForImageCapture];
    
    [imagePicture processImage];
    return [dummyFilter imageFromCurrentFramebuffer];
    
}

@end
