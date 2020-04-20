//
//  InstrumentDesignViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/5/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

//INSTRUMENT DEFINITION
#define PLUCK   (0)
#define MARIMBA (1)
#define FLUTE   (2)
#define BELL    (3)
//LFO DESTINATION DEFINITION
#define AMP     (0)
#define PITCH   (1)
#define FILTCUT (2)
#define PAN     (3)


#import "InstrumentDesignViewController.h"

@interface InstrumentDesignViewController (){
    float lastAmount;
    int lastAmountCutoff;
    int lastAmountQuality;
    bool cutoffEnded;
    int i;
    float* volumeMachinePtr;
    
}
@property(nonatomic)int lastButtonFilter;

@end



@implementation

InstrumentDesignViewController

@synthesize lineSeparator, lastButtonFilter, envelopeView, cutoffView, QualityView, resultedAmountCutoff, resultedAmountQuality, resultedAmountFinalQuality, instrumentNumber, volumeAmountMachine, reverbSendAmountMachine, distoSendAmountMachine, chorusSendAmountMachine, delaySendAmountMachine, instrumentNumberDrone, volumeAmountDrone, reverbSendAmountDrone, distoSendAmountDrone, chorusSendAmountDrone, delaySendAmountDrone;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.QualityView.filterQualityDelegate = self;
    
    //instrument#1
    self.presetInstrument = [[SelectPresetInstrumentViewController alloc]initWithNibName:@"SelectPresetInstrument" bundle:nil];
    
    self.mixerMachineInstance = [[FXRackMachineViewController alloc]initWithNibName:@"FXRackMachineView" bundle:nil];
    
    //instrument#2
    self.presetDroneInstrument = [[SelectPresetDroneViewController alloc]initWithNibName:@"SelectPresetDroneView" bundle:nil];
    self.mixerDroneInstance = [[MixerDroneViewController alloc]initWithNibName:@"MixerDroneView" bundle:nil];
    
    //variable init
    i = 1;
    lastButtonFilter = 0;
    resultedAmountCutoff = 9500;
    resultedAmountQuality = 100.0;
    resultedAmountFinalQuality = 1.0;
    cutoffEnded = true;
    self.cutoffView.filterCutoffDelegate = self;
    self.presetInstrument.presetInstrumentDelegate = self;
    instrumentNumber = @(21);
    volumeAmountMachine = 0.8;
    distoSendAmountMachine = 0.0;
    delaySendAmountMachine = 0.0;
    chorusSendAmountMachine = 0.0;
    reverbSendAmountMachine = 0.0;
    
    instrumentNumberDrone = @(31);
    volumeAmountDrone = 0.8;
    distoSendAmountDrone = 0.0;
    delaySendAmountDrone = 0.0;
    chorusSendAmountDrone = 0.0;
    reverbSendAmountDrone = 0.0;
    
}


#pragma-mark view_popover
//instrument#1
- (IBAction)revealMixerMeloMachine:(UIButton *)sender {
    self.mixerMachinePopover = [[UIPopoverController alloc]initWithContentViewController:self.mixerMachineInstance];
    self.mixerMachinePopover.popoverContentSize = CGSizeMake(350.0, 185.0);
    [self.mixerMachinePopover presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.mixerMachineInstance.mixerMachineDelegate = self;
}

- (IBAction)presetInstrumentPopup:(UIButton *)sender{
    self.instrumentPresetPopover = [[UIPopoverController alloc]initWithContentViewController:self.presetInstrument];
    self.instrumentPresetPopover.popoverContentSize = CGSizeMake(150.0, 172.0);
    [self.instrumentPresetPopover presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.presetInstrument.presetInstrumentDelegate = self;
}
//instrument#2
- (IBAction)revealDroneMixer:(UIButton *)sender {
    self.mixerDronePopover = [[UIPopoverController alloc]initWithContentViewController:self.mixerDroneInstance];
    self.mixerDronePopover.popoverContentSize = CGSizeMake(350.0, 185.0);
    [self.mixerDronePopover presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.mixerDroneInstance.mixerDroneDelegate = self;
}
- (IBAction)presetDronePopup:(UIButton *)sender{
    self.dronePresetPopover = [[UIPopoverController alloc]initWithContentViewController:self.presetDroneInstrument];
    self.dronePresetPopover.popoverContentSize = CGSizeMake(150.0, 129.0);
    [self.dronePresetPopover presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.presetDroneInstrument.presetDroneDelegate = self;
}


#pragma __value-change management
-(void)CutoffChange:(NSInteger)theValue{
    if(theValue == 0)theValue = 1;
    //TO DO: CHANGE CUTOFF TRANSFER CURVE TO EXP. CURVE
//    NSLog(@"the plain value = %ld\n", (long)theValue);
    if(theValue < 0){
        theValue = abs((int)theValue);
      resultedAmountCutoff -= (pow(1.07, theValue)-lastAmountCutoff);
        lastAmountCutoff = (log2(theValue));
//        NSLog(@"the log value = %f\n", (log2(theValue)));
    }else{
    resultedAmountCutoff += (pow(1.07, theValue)-lastAmountCutoff);
        lastAmountCutoff = (pow(1.07, theValue));
//        NSLog(@"the pow value = %f\n", (pow(1.07, theValue)));
    }
    if(resultedAmountCutoff <= 20){
        resultedAmountCutoff = 20;
    }else if(resultedAmountCutoff >= 9500){
        resultedAmountCutoff = 9500.0;
    }
//     NSLog(@"the resulted amount = %ld\n", resultedAmountCutoff);
    _CutoffLabel.text = [NSString stringWithFormat:@"%dHz", (int)resultedAmountCutoff];
}

-(void)CutoffEnded{
    resultedAmountCutoff = (int)[_CutoffLabel.text integerValue];
    lastAmountCutoff = 0;
}

-(void)QualityChange:(NSInteger)theValue{
    
    resultedAmountQuality += (theValue-lastAmountQuality);
    if(resultedAmountQuality <= 10){
        resultedAmountQuality = 10;
    }else if(resultedAmountQuality >= 400){
        resultedAmountQuality = 400;
    }
    resultedAmountFinalQuality = resultedAmountQuality/100.0;
    _QualityLabel.text = [NSString stringWithFormat:@"%.2f", (float)resultedAmountFinalQuality];
    lastAmountQuality = (int)theValue;
}

-(void)QualityEnded{
    resultedAmountQuality = (int)[_QualityLabel.text integerValue]*100;
    lastAmountCutoff = 0;
}

#pragma __Popover-Delegates
//INSTRUMENT#1
//get instrument number
-(void)getInstrumentNumber:(NSNumber *)theInstrument{
    if([theInstrument  isEqual: @(0)]){
        instrumentNumber = @(21);
        self.presetLabel.text = @"PLUCK";
    }else if([theInstrument  isEqual: @(1)]){
        instrumentNumber = @(22);
        self.presetLabel.text = @"MARIMBA";
    }else if([theInstrument  isEqual: @(2)]){
        instrumentNumber = @(23);
        self.presetLabel.text = @"FLUTE";
    }else if([theInstrument  isEqual: @(3)]){
        instrumentNumber = @(24);
        self.presetLabel.text = @"BELL";
    }
}
//mixer
-(void)VolumeMachine:(float)theValue{
    volumeAmountMachine = (theValue/100.0);
}
-(void)ReverbMachine:(float)theValue{
    reverbSendAmountMachine = (theValue/100.0);
}
-(void)DelayMachine:(float)theValue{
    delaySendAmountMachine = (theValue/100.0);
}
-(void)ChorusMachine:(float)theValue{
    chorusSendAmountMachine = (theValue/100.0);
}
-(void)DistortionMachine:(float)theValue{
    distoSendAmountMachine = (theValue/100.0);
}

//INSTRUMENT#2
// getinstrument number
-(void)getInstrumentDroneNumber:(NSNumber *)theInstrument{
    instrumentNumberDrone = theInstrument;
    if([theInstrument  isEqual: @(31)]){
        self.presetDroneLabel.text = @"DRONE 1";
    }else if([theInstrument  isEqual: @(32)]){
        self.presetDroneLabel.text = @"DRONE 2";
    }else if([theInstrument  isEqual: @(33)]){
        self.presetDroneLabel.text = @"DRONE 3";
    }
    NSLog(@"%@\n", instrumentNumberDrone);
}
//mixer
-(void)VolumeDrone:(float)theValue{
    volumeAmountDrone = (theValue/100.0);
}
-(void)ReverbDrone:(float)theValue{
    reverbSendAmountDrone = (theValue/100.0);
}
-(void)DelayDrone:(float)theValue{
    delaySendAmountDrone = (theValue/100.0);
}
-(void)ChorusDrone:(float)theValue{
    chorusSendAmountDrone = (theValue/100.0);
}
-(void)DistortionDrone:(float)theValue{
    distoSendAmountDrone = (theValue/100.0);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
