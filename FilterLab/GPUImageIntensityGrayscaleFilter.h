//
//  GPUImageIntensityGrayscaleFilter.h
//  FilterLab
//
//  Created by Cody Caldwell on 7/13/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTFilter.h"

/*
 This class is a slight modification of Brad Larson's GPUImageGrayscaleFilter class, giving
 one the ability to modify the intensity of the original effect by adjusting the new intensity property.
 The intensity can range from 0.0 to 1.0. A majority of the credit for this class' implementation
 goes to Brad Larson (github.com/BradLarson).
 */

@interface GPUImageIntensityGrayscaleFilter : GPUImageFilter {
    GLuint intensityUniform;
}

@property (assign, nonatomic) CGFloat intensity;

@end
