//
//  CSTemperatureFilter.m
//  ColorSpill
//
//  Created by Cody Caldwell on 7/6/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSTemperatureFilter.h"

@implementation CSTemperatureFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Temperature";
        self.imageName = @"temperature";
        self.type = CSToolFilterType;
        self.maximumFilterValue = 7500.0;
        self.minimumFilterValue = 2500.0;
        self.startingFilterValue = 5000.0;
        self.gpuFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        self.intensity = 5000.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageWhiteBalanceFilter *filter = (GPUImageWhiteBalanceFilter *)self.gpuFilter;
    filter.temperature = intensity;
}

@end
