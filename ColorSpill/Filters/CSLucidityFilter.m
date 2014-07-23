//
//  CSLucidityFilter.m
//  ColorSpill
//
//  Created by Cody Caldwell on 7/8/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSLucidityFilter.h"
#import "GPUImageIntensityToneCurveFilter.h"

@implementation CSLucidityFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Lucidity";
        self.imageName = @"lucidity";
        self.type = CSGeneralFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 0.5;
        self.gpuFilter = [[GPUImageIntensityToneCurveFilter alloc] initWithACV:@"lucidity"];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageIntensityToneCurveFilter *filter = (GPUImageIntensityToneCurveFilter *)self.gpuFilter;
    filter.intensity = intensity;
}

@end
