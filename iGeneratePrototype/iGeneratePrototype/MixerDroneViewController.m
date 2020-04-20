//
//  MixerDroneViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/28/15.
//  Copyright © 2015 com.DariusPetermann. All rights reserved.
//

#import "MixerDroneViewController.h"

@interface MixerDroneViewController ()

@end

@implementation MixerDroneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI/2);
    for(UISlider* b in self.slidersCollection){
        b.transform = transform;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)volumeDrone:(UISlider *)sender {
    [self.mixerDroneDelegate VolumeDrone:sender.value];
    [[self.labelEffectsCollection objectAtIndex:4] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
- (IBAction)reverbDrone:(UISlider *)sender {
    [self.mixerDroneDelegate ReverbDrone:sender.value];
    [[self.labelEffectsCollection objectAtIndex:0] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
- (IBAction)delayDrone:(UISlider *)sender {
    [self.mixerDroneDelegate DelayDrone:sender.value];
    [[self.labelEffectsCollection objectAtIndex:1] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
- (IBAction)chorusDrone:(UISlider *)sender {
    [self.mixerDroneDelegate ChorusDrone:sender.value];
    [[self.labelEffectsCollection objectAtIndex:2] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
- (IBAction)distoDrone:(UISlider *)sender {
    [self.mixerDroneDelegate DistortionDrone:sender.value];
    [[self.labelEffectsCollection objectAtIndex:3] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}


@end
