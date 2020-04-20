//
//  FXRackMachineViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/25/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "FXRackMachineViewController.h"

@interface FXRackMachineViewController ()

@end

@implementation FXRackMachineViewController
@synthesize mixerMachineDelegate, slidersCollection;
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
- (IBAction)volumeMachine:(UISlider *)sender {
    [self.mixerMachineDelegate VolumeMachine:sender.value];
    [[self.labelEffectsCollection objectAtIndex:4] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
- (IBAction)reverbMachine:(UISlider *)sender {
    [self.mixerMachineDelegate ReverbMachine:sender.value];
    [[self.labelEffectsCollection objectAtIndex:0] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
- (IBAction)delayMachine:(UISlider *)sender {
    [self.mixerMachineDelegate DelayMachine:sender.value];
    [[self.labelEffectsCollection objectAtIndex:1] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
- (IBAction)chorusMachine:(UISlider *)sender {
    [self.mixerMachineDelegate ChorusMachine:sender.value];
    [[self.labelEffectsCollection objectAtIndex:2] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}
- (IBAction)distoMachine:(UISlider *)sender {
    [self.mixerMachineDelegate DistortionMachine:sender.value];
    [[self.labelEffectsCollection objectAtIndex:3] setValue:[NSString stringWithFormat:@"%d%%", (int)sender.value] forKey:@"text"];
}

@end
