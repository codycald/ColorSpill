//
//  FLTFilter.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/28/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTFilter.h"
#import "GPUImage.h"
#import "FLTImageEffectType.h"

@implementation FLTFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Original";
        self.imageName = @"none";
        self.type = FLTGeneralFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 1.0;
        self.intensity = 1.0;
        self.gpuFilter = [[GPUImageFilter alloc] init];
    }
    return self;
}

#pragma mark - GPUImageOutput overrides

- (void)addTarget:(id<GPUImageInput>)newTarget {
    [self.gpuFilter addTarget:newTarget];
}

- (void)useNextFrameForImageCapture {
    [self.gpuFilter useNextFrameForImageCapture];
}

- (UIImage *)imageFromCurrentFramebuffer {
    return [self.gpuFilter imageFromCurrentFramebuffer];
}

- (UIImage *)imageFromCurrentFramebufferWithOrientation:(UIImageOrientation)imageOrientation {
    return [self.gpuFilter imageFromCurrentFramebufferWithOrientation:imageOrientation];
}

#pragma mark - GPUImageInput protocol

- (CGSize)maximumOutputSize {
    return [self.gpuFilter maximumOutputSize];
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex {
    [self.gpuFilter newFrameReadyAtTime:frameTime atIndex:textureIndex];
}

- (BOOL)wantsMonochromeInput {
    return [self.gpuFilter wantsMonochromeInput];
}

- (NSInteger)nextAvailableTextureIndex {
    return [self.gpuFilter nextAvailableTextureIndex];
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [self.gpuFilter setInputSize:newSize atIndex:textureIndex];
}

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue {
    [self.gpuFilter setCurrentlyReceivingMonochromeInput:newValue];
}

- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex {
    [self.gpuFilter setInputFramebuffer:newInputFramebuffer atIndex:textureIndex];
}

- (void)setInputRotation:(GPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex {
    [self.gpuFilter setInputRotation:newInputRotation atIndex:textureIndex];
}

- (void)endProcessing {
    [self.gpuFilter endProcessing];
}

@end
