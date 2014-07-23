//
//  CSFilter.h
//  ColorSpill
//
//  Created by Cody Caldwell on 6/28/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSImageEffectType.h"
#import "GPUImage.h"

@interface CSFilter : GPUImageOutput<GPUImageInput>

@property (copy, nonatomic) NSString *filterName;
@property (copy, nonatomic) NSString *imageName;
@property (assign, nonatomic) CSImageEffectType type;
@property (assign, nonatomic) CGFloat intensity;
@property (assign, nonatomic) CGFloat maximumFilterValue;
@property (assign, nonatomic) CGFloat minimumFilterValue;
@property (assign, nonatomic) CGFloat startingFilterValue;
@property (strong, nonatomic) GPUImageOutput<GPUImageInput> *gpuFilter;

@end
