//
//  CSNimbusFilter.m
//  ColorSpill
//
//  Created by Cody Caldwell on 7/13/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSNimbusFilter.h"
#import "GPUImageIntensityGrayscaleFilter.h"
#import "GPUImageIntensityToneCurveFilter.h"

@interface CSNimbusFilter ()

@property (strong, nonatomic) GPUImageIntensityToneCurveFilter *intensityFilter;
@property (strong, nonatomic) GPUImageIntensityGrayscaleFilter *grayscaleFilter;

@end

@implementation CSNimbusFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Nimbus";
        self.imageName = @"nimbus";
        self.type = CSGeneralFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 1.0;
        [self setupFilter];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    self.intensityFilter.intensity = intensity;
    self.grayscaleFilter.intensity = intensity;
}

- (void)setupFilter {
    
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    self.grayscaleFilter = [[GPUImageIntensityGrayscaleFilter alloc] init];
    self.intensityFilter = [[GPUImageIntensityToneCurveFilter alloc] initWithACV:@"nimbus"];
    [filterGroup addFilter:self.grayscaleFilter];
    [filterGroup addFilter:self.intensityFilter];
    [self.grayscaleFilter addTarget:self.intensityFilter];
    filterGroup.initialFilters = [NSArray arrayWithObjects:self.grayscaleFilter, nil];
    filterGroup.terminalFilter = self.intensityFilter;
    self.gpuFilter = filterGroup;
}

@end
