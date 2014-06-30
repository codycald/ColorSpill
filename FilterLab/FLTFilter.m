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
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 1.0;
    }
    return self;
}

- (UIImage *)filteredImageWithImage:(UIImage *)image destinationView:(GPUImageView *)imageView intensity:(CGFloat)intensity {
    
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    GPUImageSepiaFilter *dummyFilter = [[GPUImageSepiaFilter alloc] init];
    [imagePicture addTarget:dummyFilter];
    
    [dummyFilter addTarget:imageView];
    [dummyFilter useNextFrameForImageCapture];
    [dummyFilter forceProcessingAtSizeRespectingAspectRatio:imageView.bounds.size];
    [imagePicture processImage];
    return [dummyFilter imageFromCurrentFramebuffer];
    
}

@end
