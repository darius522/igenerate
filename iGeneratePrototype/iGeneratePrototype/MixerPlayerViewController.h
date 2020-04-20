//
//  MixerPlayerViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/25/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MixerPlayerDelegate <NSObject>
-(void)VolumePlayer:(float)theValue;
-(void)ReverbPlayer:(float)theValue;
-(void)DelayPlayer:(float)theValue;
-(void)ChorusPlayer:(float)theValue;
-(void)DistortionPlayer:(float)theValue;
@end
@interface MixerPlayerViewController : UIViewController

@property (nonatomic, weak) id <MixerPlayerDelegate> mixerPlayerDelegate;
@property (nonatomic, strong) IBOutletCollection(UISlider) NSArray *slidersCollection;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelsEffectCollection;

- (IBAction)reverbSend:(UISlider *)sender;
- (IBAction)delaySend:(UISlider *)sender;
- (IBAction)chorusSend:(UISlider *)sender;
- (IBAction)distoSend:(UISlider *)sender;
- (IBAction)masterVolume:(UISlider *)sender;



@end
