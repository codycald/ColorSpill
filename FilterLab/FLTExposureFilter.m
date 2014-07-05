//
//  FLTExposureFilter.m
//  FilterLab
//
//  Created by Cody Caldwell on 7/4/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTExposureFilter.h"

@implementation FLTExposureFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Exposure";
        self.imageName = @"contrast";
        self.type = FLTToolFilterType;
        self.maximumFilterValue = 4.0;
        self.minimumFilterValue = -4.0;
        self.startingFilterValue = 0.0;
        self.gpuFilter = [[GPUImageExposureFilter alloc] init];
        self.intensity = 0.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageExposureFilter *filter = (GPUImageExposureFilter *)self.gpuFilter;
    filter.exposure = intensity;
}

@end
