//
//  FLTTimelessFilter.m
//  FilterLab
//
//  Created by Cody Caldwell on 7/8/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTTimelessFilter.h"
#import "GPUImageIntensityToneCurveFilter.h"

@implementation FLTTimelessFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Timeless";
        self.imageName = @"timeless";
        self.type = FLTGeneralFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 1.0;
        self.gpuFilter = [[GPUImageIntensityToneCurveFilter alloc] initWithACV:@"timeless"];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageIntensityToneCurveFilter *filter = (GPUImageIntensityToneCurveFilter *)self.gpuFilter;
    filter.intensity = intensity;
}

@end