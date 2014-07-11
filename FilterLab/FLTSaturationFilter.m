//
//  FLTSaturationFilter.m
//  FilterLab
//
//  Created by Cody Caldwell on 7/4/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTSaturationFilter.h"

@implementation FLTSaturationFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Saturation";
        self.imageName = @"saturation";
        self.type = FLTToolFilterType;
        self.maximumFilterValue = 2.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 1.0;
        self.gpuFilter = [[GPUImageSaturationFilter alloc] init];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageSaturationFilter *filter = (GPUImageSaturationFilter *)self.gpuFilter;
    filter.saturation = intensity;
}

@end
