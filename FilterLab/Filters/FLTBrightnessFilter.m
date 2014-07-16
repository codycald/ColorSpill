//
//  FLTBrightnessFilter.m
//  FilterLab
//
//  Created by Cody Caldwell on 7/4/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTBrightnessFilter.h"

@implementation FLTBrightnessFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Brightness";
        self.imageName = @"brightness";
        self.type = FLTToolFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = -1.0;
        self.startingFilterValue = 0.0;
        self.gpuFilter = [[GPUImageBrightnessFilter alloc] init];
        self.intensity = 0.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageBrightnessFilter *filter = (GPUImageBrightnessFilter *)self.gpuFilter;
    filter.brightness = intensity;
}

@end
