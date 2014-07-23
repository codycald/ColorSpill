//
//  CSLockewoodFilter.m
//  ColorSpill
//
//  Created by Cody Caldwell on 7/8/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSTimberFilter.h"
#import "GPUImageIntensityToneCurveFilter.h"

@implementation CSTimberFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Timber";
        self.imageName = @"timber";
        self.type = CSGeneralFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 0.5;
        self.gpuFilter = [[GPUImageIntensityToneCurveFilter alloc] initWithACV:@"timber"];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageIntensityToneCurveFilter *filter = (GPUImageIntensityToneCurveFilter *)self.gpuFilter;
    filter.intensity = intensity;
}

@end
