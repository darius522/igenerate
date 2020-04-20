//
//  MixerDroneViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/28/15.
//  Copyright © 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MixerDroneDelegate <NSObject>
-(void)VolumeDrone:(float)theValue;
-(void)ReverbDrone:(float)theValue;
-(void)DelayDrone:(float)theValue;
-(void)ChorusDrone:(float)theValue;
-(void)DistortionDrone:(float)theValue;
@end
@interface MixerDroneViewController : UIViewController

@property (nonatomic, weak) id <MixerDroneDelegate> mixerDroneDelegate;
@property (nonatomic, strong) IBOutletCollection(UISlider) NSArray *slidersCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelEffectsCollection;

@end
