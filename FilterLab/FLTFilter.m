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

- (UIImage *)filteredImageWithImage:(UIImage *)image destinationViews:(NSArray *)imageViews intensity:(CGFloat)intensity {
    
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    GPUImageSepiaFilter *dummyFilter = [[GPUImageSepiaFilter alloc] init];
    dummyFilter.intensity = intensity;
    [imagePicture addTarget:dummyFilter];
    
    for (GPUImageView *imageView in imageViews) {
        [dummyFilter addTarget:imageView];
    }
    [dummyFilter useNextFrameForImageCapture];
    GPUImageView *view = [imageViews firstObject];
    [dummyFilter forceProcessingAtSizeRespectingAspectRatio:view.bounds.size];
    [imagePicture processImage];
    return [dummyFilter imageFromCurrentFramebuffer];
    
}

@end
