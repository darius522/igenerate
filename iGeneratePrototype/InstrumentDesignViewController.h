//
//  InstrumentDesignViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/5/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvelopeController.h"
#import "DragValue.h"
#import "SelectLfoDestinationViewController.h"
#import "SelectPresetInstrumentViewController.h"
#import "LineSeparator.h"
#import "CsoundObj.h"
#import "FXRackMachineViewController.h"
#import "SelectPresetDroneViewController.h"
#import "MixerDroneViewController.h"

//@protocol EnvelopeValueThroughSiblingsDelegate <NSObject>
//-(void)kAttackTimeSiblings:(float)theTime;
//-(void)kAttackAmpSiblings:(float)theAmp;
//-(void)kDecayTimeSiblings:(float)theTime;
//-(void)kDecayAmpSiblings:(float)theAmp;
//-(void)kSustainAmpSiblings:(float)theAmp;
//-(void)kReleaseTimeSiblings:(float)theTime;
//@end

@interface InstrumentDesignViewController : UIViewController
<FilterCutoff,FilterQuality, SelectPresetInstrumentDelegate, MixerMachineDelegate, SelectPresetDroneDelegate, MixerDroneDelegate>


@property (nonatomic, strong) LineSeparator* lineSeparator;

//filter values+views
@property (strong, nonatomic) IBOutlet DragValue *cutoffView;
@property (strong, nonatomic) IBOutlet UILabel *CutoffLabel;
@property (strong, nonatomic) IBOutlet DragValue *QualityView;
@property (strong, nonatomic) IBOutlet UILabel *QualityLabel;




@property(strong, nonatomic)EnvelopeController *envelopeView;
//@property (weak, nonatomic) id<EnvelopeValueThroughSiblingsDelegate> envelopeSiblings;
//fx racks stuff instrument#1
@property (strong, nonatomic) FXRackMachineViewController *mixerMachineInstance;
@property (nonatomic, strong) UIPopoverController * mixerMachinePopover;
@property (nonatomic) float volumeAmountMachine;
@property (nonatomic) float reverbSendAmountMachine;
@property (nonatomic) float chorusSendAmountMachine;
@property (nonatomic) float delaySendAmountMachine;
@property (nonatomic) float distoSendAmountMachine;
//fx racks stuff instrument#2
@property (strong, nonatomic) MixerDroneViewController *mixerDroneInstance;
@property (nonatomic, strong) UIPopoverController * mixerDronePopover;
@property (nonatomic) float volumeAmountDrone;
@property (nonatomic) float reverbSendAmountDrone;
@property (nonatomic) float chorusSendAmountDrone;
@property (nonatomic) float delaySendAmountDrone;
@property (nonatomic) float distoSendAmountDrone;


//the things we need for mainview
@property (nonatomic) long resultedAmountCutoff;
@property (nonatomic) int resultedAmountQuality;
@property (nonatomic) float resultedAmountFinalQuality;

//preset instrument#1
@property (strong, nonatomic) SelectPresetInstrumentViewController *presetInstrument;
@property (nonatomic, strong) UIPopoverController * instrumentPresetPopover;
- (IBAction)presetInstrumentPopup:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *presetLabel;

//preset instrument#2
@property (strong, nonatomic) SelectPresetDroneViewController *presetDroneInstrument;
@property (nonatomic, strong) UIPopoverController * dronePresetPopover;
- (IBAction)presetDronePopup:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *presetDroneLabel;


//tableview stuff
@property (nonatomic) NSNumber* instrumentNumber;
@property (nonatomic) NSNumber* instrumentNumberDrone;


@end
