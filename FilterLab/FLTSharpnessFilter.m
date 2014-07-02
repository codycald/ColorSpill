//
//  FLTSharpnessFilter.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/29/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTSharpnessFilter.h"

@implementation FLTSharpnessFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Sharpness";
        self.imageName = @"contrast";
        self.type = FLTToolFilterType;
        self.maximumFilterValue = 4.0;
        self.minimumFilterValue = -1.0;
        self.startingFilterValue = 0.0;
        self.gpuFilter = [[GPUImageSharpenFilter alloc] init];
        self.intensity = 0.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageSharpenFilter *filter = (GPUImageSharpenFilter *)self.gpuFilter;
    filter.sharpness = intensity;
}

- (void)addTarget:(id<GPUImageInput>)newTarget {
    [self.gpuFilter addTarget:newTarget];
}

@end
