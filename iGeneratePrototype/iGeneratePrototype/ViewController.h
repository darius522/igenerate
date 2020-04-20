//
//  ViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 9/21/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//
@class XYPadView;
@class CustomSliderControl;
#import <UIKit/UIKit.h>
#import "CsoundObj.h"
#import <AVFoundation/AVFoundation.h>
#import "LevelMeterView.h"
#import "CsoundMIDI.h"
#import "SelectScaleViewController.h"
#import "SelectMode.h"
#import "DragValue.h"
#import "EnvelopeController.h"
#import "XYPadView.h"
#import "InstrumentDesignViewController.h"
#import "LineSeparator.h"
#import "CustomSliderControl.h"
#import "LineDrawingMainView.h"
#import "SelectLfoDestinationViewController.h"
#import "SelectSourcePlayerViewController.h"
#import "MixerPlayerViewController.h"
#import <math.h>

@interface ViewController : UIViewController
<CsoundObjListener, CsoundBinding, mySelectScaleDelegate, mySelectModeDelegate, TempoDrag, myXYPadDelegate, TimeSignature,OctRangeInstr1, OctRangeInstr2, EnvelopeDelegate, Lfo1AmountDrag, SelectLfoDestInstrumentDelegate, SelectFtablePlayerDelegate, MixerPlayerDelegate>

// These protocol names are new, csound iOS API change -> April 2015
//Declare a Csound object
@property (nonatomic, retain) CsoundObj* csound;
@property (nonatomic, strong) LevelMeterView* levelMeter;

//I/O, ETC.
@property (strong, nonatomic) IBOutlet UILabel *pitchLabel;
@property (strong, nonatomic) IBOutlet UILabel *velocityLabel;


//TRANSPORT
- (IBAction)playRandom:(UIButton *)sender;
- (IBAction)stopRandom:(UIButton *)sender;
- (IBAction)record:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *playRandom;
@property (strong, nonatomic) IBOutlet UIButton *pauseRandom;
@property (strong, nonatomic) IBOutlet UIButton *stopRandom;
@property (strong, nonatomic) IBOutlet UIButton *stopButtonPushed;
@property (strong, nonatomic) IBOutlet UIButton *recordRandom;
@property (strong, nonatomic) IBOutlet UIButton *recordPushed;


//Select scale
@property(nonatomic, retain)SelectScaleViewController* selectScaleView;
@property(nonatomic, retain)UIPopoverController* selectScalePopup;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;

//Select mode
@property(nonatomic, strong)SelectMode* selectModeView;
@property(nonatomic, retain)UIPopoverController* selectModePopup;
@property (strong, nonatomic) IBOutlet UILabel *modeLabel;

//Tempo View
@property (strong, nonatomic)IBOutlet DragValue *tempoView;
@property (strong, nonatomic) IBOutlet UILabel *tempoLabel;

//Time Signature View
@property (strong, nonatomic) IBOutlet UILabel *timeSignatureLabel;
@property (strong, nonatomic) IBOutlet DragValue *timeSignatureView;


- (void)addToCsoundObj:(CsoundObj *)csoundObj
        forChannelName:(NSString *)channelName;

//Instrument Designer View
@property (strong, nonatomic) InstrumentDesignViewController* instrumentView;
- (IBAction)switchInstrumentDesign:(UIButton *)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pushedButtonDesign;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *unpshedButtonDesign;




//Pad View
@property (strong, nonatomic) XYPadView* xyPad;
@property (strong, nonatomic) IBOutlet UILabel *xPositionGrid;
@property (strong, nonatomic) IBOutlet UILabel *yPositionGrid;


//Tracker biz
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pushedTracker;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *unpushedTracker;
- (IBAction)switchTracker:(UIButton *)sender;

//variable view thingy

//2. Velocity related
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *velocityRangeLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *velocityRandOnButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *velocityRandOffButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *velocityRandOnLabels;

//3. Env. Deviation related
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *envelopeDeviationLabels;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *envelopeDeviationOnButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *envelopeDeviationoffButtons;
- (IBAction)envelopeDeviationOn:(UIButton *)sender;
//4. OctaveRange related
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *octaveRangeLabels;
@property (strong, nonatomic) IBOutlet DragValue *octaveRange1View;
@property (strong, nonatomic) IBOutlet DragValue *octaveRange2View;
//5. Set density
- (IBAction)changeDensity:(UIButton *)sender;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *noteDensityLabels;
//6. Distribution
- (IBAction)randomDistribution:(UIButton *)sender;
- (IBAction)fractalDistribution:(UIButton *)sender;
- (IBAction)transpositionDistribution:(UIButton *)sender;
- (IBAction)phraseDistribution:(UIButton *)sender;
- (IBAction)arpegDsitribution:(UIButton *)sender;
- (IBAction)mirrorDistribution:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *unpushedDistributionButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pushedDistributionButtons;

//MIDI MONITORING
@property (nonatomic, strong) LineDrawingMainView *lineSeparatorMidiMonitor;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *noteNumberMidiMonitor;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *velocityMidiMonitor;

//INSTRUMENT PLAYER VIEWS
//lfo
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *unpushedLfo1;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pushedLfo1;
- (IBAction)changeLfo1:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet DragValue *lfoAmount1View;
@property (strong, nonatomic) IBOutlet UILabel *lfoAmount1Label;
@property (strong, nonatomic) IBOutlet DragValue *lforate1View;
@property (strong, nonatomic) IBOutlet UILabel *lfoRate1Label;
@property (strong, nonatomic) SelectLfoDestinationViewController *lfoDestination;
@property (nonatomic, strong) UIPopoverController * lfoDestinationPopup;
- (IBAction)lfoDestinationPopup:(UIButton *)sender;

//ftable select
@property (nonatomic, strong) SelectSourcePlayerViewController *selectFtableInstace;
@property (nonatomic, strong) UIPopoverController * selectFtablePopup;
//mixer player
@property (nonatomic, strong) MixerPlayerViewController *mixerPlayerInstance;
@property (nonatomic, strong) UIPopoverController * mixerlayerPopup;





@end

