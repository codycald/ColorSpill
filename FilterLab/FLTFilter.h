//
//  FLTFilter.h
//  FilterLab
//
//  Created by Cody Caldwell on 6/28/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLTImageEffectType.h"
#import "GPUImage.h"

@interface FLTFilter : NSObject

@property (copy, nonatomic) NSString *filterName;
@property (copy, nonatomic) NSString *imageName;
@property (assign, nonatomic) FLTImageEffectType type;

- (UIImage *)filteredImageWithImage:(UIImage *)image destinationViews:(NSArray *)imageView intensity:(NSInteger)intensity;

@end
