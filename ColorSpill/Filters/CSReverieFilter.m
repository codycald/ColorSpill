//
//  CSDaydreamFilter.m
//  ColorSpill
//
//  Created by Cody Caldwell on 7/8/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSReverieFilter.h"
#import "GPUImageIntensityToneCurveFilter.h"

@implementation CSReverieFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Reverie";
        self.imageName = @"reverie";
        self.type = CSGeneralFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 0.5;
        self.gpuFilter = [[GPUImageIntensityToneCurveFilter alloc] initWithACV:@"reverie"];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageIntensityToneCurveFilter *filter = (GPUImageIntensityToneCurveFilter *)self.gpuFilter;
    filter.intensity = intensity;
}

@end
