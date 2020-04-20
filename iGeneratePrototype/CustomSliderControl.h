//
//  CustomSliderControl.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/20/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnobLayer.h"
#import "SliderTrackColor.h"

@interface CustomSliderControl : UIControl

@property (nonatomic) float maximumValue;
@property (nonatomic) float minimumValue;
@property (nonatomic) float upperValue;
@property (nonatomic) float lowerValue;

@property (nonatomic) UIColor* trackColour;
@property (nonatomic) UIColor* trackHighlightColour;
@property (nonatomic) UIColor* knobColour;
@property (nonatomic) float curvaceousness;
@property (nonatomic) BOOL setTwoKnobs;

- (float) positionForValue:(float)value;
-(void)setKnobsNumber:(BOOL)twoKnobs;

@end
