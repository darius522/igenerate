//
//  FXRackMachineViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/25/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MixerMachineDelegate <NSObject>
-(void)VolumeMachine:(float)theValue;
-(void)ReverbMachine:(float)theValue;
-(void)DelayMachine:(float)theValue;
-(void)ChorusMachine:(float)theValue;
-(void)DistortionMachine:(float)theValue;
@end
@interface FXRackMachineViewController : UIViewController

@property (nonatomic, weak) id <MixerMachineDelegate> mixerMachineDelegate;
@property (nonatomic, strong) IBOutletCollection(UISlider) NSArray *slidersCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelEffectsCollection;


@end
