//
//  MixerPlayerViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/25/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "MixerPlayerViewController.h"

@interface MixerPlayerViewController ()

@end

@implementation MixerPlayerViewController
@synthesize mixerPlayerDelegate, slidersCollection;

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

- (IBAction)reverbSend:(UISlider *)sender {
    [self.mixerPlayerDelegate ReverbPlayer:(sender.value/100.0)];
    [[self.labelsEffectCollection objectAtIndex:0] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}

- (IBAction)delaySend:(UISlider *)sender {
    [self.mixerPlayerDelegate DelayPlayer:(sender.value/100.0)];
    [[self.labelsEffectCollection objectAtIndex:1] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}

- (IBAction)chorusSend:(UISlider *)sender {
    [self.mixerPlayerDelegate ChorusPlayer:(sender.value/100.0)];
    [[self.labelsEffectCollection objectAtIndex:2] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}

- (IBAction)distoSend:(UISlider *)sender {
    [self.mixerPlayerDelegate DistortionPlayer:(sender.value/100.0)];
    [[self.labelsEffectCollection objectAtIndex:3] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}

- (IBAction)masterVolume:(UISlider *)sender {
    [self.mixerPlayerDelegate VolumePlayer:(sender.value/100.0)];
    [[self.labelsEffectCollection objectAtIndex:4] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
@end
