//
//  ViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 9/21/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//
#define DOWNWARD (0)
#define FORWARD  (1)
#define SNAKE    (2)
#define SQUARE   (3)


#pragma-mark __SCALE_MACROS_SUPER_IMPORTANT
#define I    (root)
#define bII  (root+1)
#define II   (root+2)
#define bIII (root+3)
#define III  (root+4)
#define bIV  (root+4)
#define IV   (root+5)
#define sIV  (root+6)
#define bV   (root+6)
#define V    (root+7)
#define bVI  (root+8)
#define VI   (root+9)
#define bVII (root+10)
#define VII  (root+11)


#import "ViewController.h"

@interface ViewController (){
    //MIDI values from csound
    float* ChannelPitchPtr;
    float* ChannelVelocityPtr;
    float* ChannelVelocityOffPtr;
    int noteNumber;
    int lastNoteNumberNotZero;
    int noteNumberComparator;
    int noteVelocity;
    BOOL noteOffFlag;
    //Keep track of the note being currently played
    int currentPitch;
    //DSP-related variables for indexing, etc.
    long int sr;
    int ksmps;
    int i;
    int j;
    int l;
    int a;
    //machine sequence
    NSMutableArray *theTransferedArray;
    NSMutableArray *theArpeggiatedMelody;
    NSMutableArray *theTransposedMelody;
    NSMutableArray *myMelodyArray1;
    NSMutableArray *myTimeIntervalArray;
    CFTimeInterval lastTime;
    CFTimeInterval currentTime;
    NSInteger melodyIndex;
    short int melodyArrayFlag;
    float myTime;
    BOOL didItStop;
    //tempo related
    int resultedTempo;
    int lastTempo;
    int n, m;
    //Time Signature
    int theFinalTimeSig;
    int theTimeSig;
    int lastTimeSig;
    //instrument design views
    int lastButtonInstrument;
    //tracker view
    int lastButtonTracker;
    int trackerType;
    int substractor;
    int substractor2;
    int substractor3;
    int flag;
    int snakeComparator;
    int incrementer;
    int measureCounter;
    int measureCountSinceLastNote;
    int theRandomLengthOfTheDrone;
    //envelope var
    float* kAttackAmpPtr;
    float kAttackAmp;
    float* kAttackTimePtr;
    float* kDecayAmpPtr;
    float* kDecayTimePtr;
    float* kSustainAmpPtr;
    float* kReleaseTimePtr;
    int theTag;
    int thePreviousButton;
    //octave range var
    int theOctaveCoef1;
    int theOctaveCoef2;
    int lastOctaveCoef1;
    int lastOctaveCoef2;
    int theFinalOctaveCoef1;
    int theFinalOctaveCoef2;
    //scale+mode
    int root;
    int theStep;
    int aMode;
    NSMutableArray *theScaleArray;
    //Midi monitoring
    int incrementerForArray;
    NSString *theStringVelocity;
    NSString *theStringMIDINoteNumber;
    UILabel *theMIDIlabel;
    UILabel *theVelocityLabel;
    //fx send variables Player
    float* volumeAmountPlayerPtr;
    float* reverbSendAmountPlayerPtr;
    float* chorusSendAmountPlayerPtr;
    float* delaySendAmountPlayerPtr;
    float* distoSendAmountPlayerPtr;
    float* delayTimePtr;
    float volumeAmountPlayer;
    float reverbSendAmountPlayer;
    float chorusSendAmountPlayer;
    float delaySendAmountPlayer;
    float distoSendAmountPlayer;
    float delayTime;
    //fx send variables Player
    float* volumeAmountMachinePtr;
    float* reverbSendAmountMachinePtr;
    float* chorusSendAmountMachinePtr;
    float* delaySendAmountMachinePtr;
    float* distoSendAmountMachinePtr;
    //fx send variables Player
    float* volumeAmountDronePtr;
    float* reverbSendAmountDronePtr;
    float* chorusSendAmountDronePtr;
    float* delaySendAmountDronePtr;
    float* distoSendAmountDronePtr;
    //filter values
    float* filterTypePtr;
    float* filterCutoffPtr;
    float* filterResonancePtr;
    //distribution
    BOOL randomMode;
    BOOL fractalMode;
    BOOL transpMode;
    BOOL phraseMode;
    BOOL arpegMode;
    BOOL mirrorMode;
    BOOL sendArrayFlag;
    float theTimeInterval;
    BOOL didRandomTrigger;
    NSInteger lastModeChosen;
    NSArray *distributionModeArray;
    //instrument design variables
    float lfoDestinationNumberPlayer;
    float lfoAmountPlayer;
    float lfoRatePlayer;
    float lfoWavetypePlayer;
    float* lfoDestinationPlayerPtr;
    float* lfoAmountPlayerPtr;
    float* lfoRatePlayerPtr;
    float* lfoWavetypePlayerPtr;
    int ftableNumberPlayer;
    float *ftableNumberPlayerPtr;
    //velocity variables stuff
    BOOL velocityRandInstrument1;
    BOOL velocityRandInstrument2;
}

@property (nonatomic, strong) NSString *channelNamePitch;
@property (nonatomic, strong) NSString *channelNameVelocity;
@property (nonatomic, strong) NSString *channelNameVelocityOff;
@property (nonatomic, strong) NSString* tempFile;
@property (nonatomic, strong) NSTimer* myTimerMetronome;
@property (nonatomic, strong) NSTimer* myTimerNoteGenerate;
@property (nonatomic, strong) NSTimer* noteEventTimer;
@property (nonatomic, strong) NSTimer* mirrorTimer;
@property (nonatomic, strong) NSTimer* fractalTimer;
@property (nonatomic, strong) NSTimer* randomTimer;

@property (strong, nonatomic) NSDictionary *xLocations;
@property (strong, nonatomic) NSDictionary *yLocations;
@property (strong, nonatomic) NSString *theWholeLocation;
@property (strong, nonatomic) NSMutableArray *xyLocationsArray;
@property (strong, nonatomic) NSMutableDictionary *NoteDensity1;

//the things we need for mainview
@property (nonatomic) float theAttackAmpProp;
@property (nonatomic) float theAttackTimeProp;
@property (nonatomic) float theDecayAmpProp;
@property (nonatomic) float theDecayTimeProp;
@property (nonatomic) float theSustainAmpProp;
@property (nonatomic) float theReleaseTimeProp;

@property (nonatomic) int lastButtonLFO;
@property (nonatomic) float resultedAmount;
@property (nonatomic) float resultedRate;
@property (nonatomic) float lastAmount;
@property (nonatomic) float lastRate;

@property (strong, nonatomic) NSMutableDictionary *distributionDictionary;

@property (strong, nonatomic) NSMutableDictionary *octaveRangeDictionary1;
@property (strong, nonatomic) NSMutableDictionary *octaveRangeDictionary2;

@property (strong, nonatomic) NSMutableDictionary *envDeviationDictionary1;
@property (strong, nonatomic) NSMutableDictionary *envDeviationDictionary2;

@property (strong, nonatomic) NSMutableDictionary *velocityRangeLow1;
@property (strong, nonatomic) NSMutableDictionary *velocityRangeHigh1;
@property (strong, nonatomic) NSMutableDictionary *velocityRangeLow2;
@property (strong, nonatomic) NSMutableDictionary *velocityRangeHigh2;
@property (strong, nonatomic) CustomSliderControl* velocityRangeSlider1;
@property (strong, nonatomic) CustomSliderControl* velocityRangeSlider2;

//Envelope View
@property (strong, nonatomic) EnvelopeController* envelopeView;
@property (strong, nonatomic) InstrumentDesignViewController *childView;
@end

@implementation ViewController
@synthesize levelMeter, csound, myTimerMetronome, myTimerNoteGenerate, tempFile, playRandom, stopRandom, noteEventTimer,stopButtonPushed,pauseRandom,recordPushed,recordRandom, modeLabel, xyPad, instrumentView, lineSeparatorMidiMonitor, envelopeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    //VIEWS INIT
    envelopeView =[[EnvelopeController alloc]initWithFrame:CGRectMake(406, 491, 400/1.5, 200/1.5)];
    envelopeView.layer.cornerRadius = 10;
    envelopeView.layer.masksToBounds = YES;
    [envelopeView initStuff:1.5];
    [self.view addSubview:envelopeView];
    envelopeView.myEnvelopeDelegate = self;
    
    NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
    NSArray *sortDescriptors = @[ascendingSort];
    self.unpushedLfo1 = [self.unpushedLfo1 sortedArrayUsingDescriptors:sortDescriptors];
    self.pushedLfo1 = [self.pushedLfo1 sortedArrayUsingDescriptors:sortDescriptors];
    self.lfoAmount1View.lfo1Delegate = self;
    self.lforate1View.lfo1Delegate = self;
    self.lfoDestination = [[SelectLfoDestinationViewController alloc]initWithNibName:@"SelectLfoDestinationViewController" bundle:nil];
    self.lfoDestination.lfoDestDelegate = self;
    
    self.selectFtableInstace = [[SelectSourcePlayerViewController alloc]initWithNibName:@"SelectSourcePlayerView" bundle:nil];
    
    self.mixerPlayerInstance = [[MixerPlayerViewController alloc]initWithNibName:@"MixerPlayerView" bundle:nil];
    self.mixerPlayerInstance.mixerPlayerDelegate = self;
    
    UIImageView *padImage= [[UIImageView alloc] initWithFrame:CGRectMake(695, 38, 288, 288)]; //create ImageView
    
    padImage.image = [UIImage imageNamed:@"menu_300x200@2x.png"];
    [self.view addSubview:padImage];
    //xy pad added
    xyPad = [[XYPadView alloc]initWithFrame:CGRectMake(695, 38, 288, 288)];
    [xyPad setBackgroundColor:[UIColor clearColor]];
    [xyPad initStuff];
    [self.view addSubview:xyPad];

    instrumentView = [[InstrumentDesignViewController alloc]init];
    
    lineSeparatorMidiMonitor = [[LineDrawingMainView alloc]initWithFrame:CGRectMake(544, 137, 119, 200)];
    [lineSeparatorMidiMonitor setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lineSeparatorMidiMonitor];
    
    xyPad.myPadDelegate = self;
    self.xLocations = [[NSDictionary alloc ]initWithObjectsAndKeys: [NSNumber numberWithInt:0], @"1",[NSNumber numberWithInt:36], @"2",[NSNumber numberWithInt:72], @"3",[NSNumber numberWithInt:108], @"4",[NSNumber numberWithInt:144], @"5",[NSNumber numberWithInt:180], @"6",[NSNumber numberWithInt:216], @"7",[NSNumber numberWithInt:252], @"8", nil];
    self.yLocations = [[NSDictionary alloc ]initWithObjectsAndKeys: [NSNumber numberWithInt:0], @"A",[NSNumber numberWithInt:36], @"B",[NSNumber numberWithInt:72], @"C",[NSNumber numberWithInt:108], @"D",[NSNumber numberWithInt:144], @"E",[NSNumber numberWithInt:180], @"F",[NSNumber numberWithInt:216], @"G",[NSNumber numberWithInt:252], @"H", nil];
    
    self.xyLocationsArray = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:36],[NSNumber numberWithInt:72],[NSNumber numberWithInt:108],[NSNumber numberWithInt:144],[NSNumber numberWithInt:180],[NSNumber numberWithInt:216],[NSNumber numberWithInt:252], nil];
    //distribution arrays
    self.unpushedDistributionButtons = [self.unpushedDistributionButtons sortedArrayUsingDescriptors:sortDescriptors];
    self.pushedDistributionButtons = [self.pushedDistributionButtons sortedArrayUsingDescriptors:sortDescriptors];
    //first slider dictionnary in order to record automation
    _NoteDensity1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1/1",
         @"1A",@"1/1",@"2A",@"1/1",@"3A",@"1/1",@"4A",@"1/1",@"5A",@"1/1",@"6A",@"1/1",@"7A",@"1/1",@"8A",@"1/1",
         @"1B",@"1/1",@"2B",@"1/1",@"3B",@"1/1",@"4B",@"1/1",@"5B",@"1/1",@"6B",@"1/1",@"7B",@"1/1",@"8B",@"1/1",
         @"1C",@"1/1",@"2C",@"1/1",@"3C",@"1/1",@"4C",@"1/1",@"5C",@"1/1",@"6C",@"1/1",@"7C",@"1/1",@"8C",@"1/1",
         @"1D",@"1/1",@"2D",@"1/1",@"3D",@"1/1",@"4D",@"1/1",@"5D",@"1/1",@"6D",@"1/1",@"7D",@"1/1",@"8D",@"1/1",
         @"1E",@"1/1",@"2E",@"1/1",@"3E",@"1/1",@"4E",@"1/1",@"5E",@"1/1",@"6E",@"1/1",@"7E",@"1/1",@"8E",@"1/1",
         @"1F",@"1/1",@"2F",@"1/1",@"3F",@"1/1",@"4F",@"1/1",@"5F",@"1/1",@"6F",@"1/1",@"7F",@"1/1",@"8F",@"1/1",
         @"1G",@"1/1",@"2G",@"1/1",@"3G",@"1/1",@"4G",@"1/1",@"5G",@"1/1",@"6G",@"1/1",@"7G",@"1/1",@"8G",@"1/1",
         @"1H",@"1/1",@"2H",@"1/1",@"3H",@"1/1",@"4H",@"1/1",@"5H",@"1/1",@"6H",@"1/1",@"7H",@"1/1",@"8H",nil];
    //I only init one dictionary with all the keys and then ust copy them into the other ones
    NSArray *allTheKeys = [[NSArray alloc] init];
    allTheKeys = [self.NoteDensity1 allKeys];
    self.velocityRangeLow1 = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    self.velocityRangeHigh1 = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    self.velocityRangeLow2 = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    self.velocityRangeHigh2 = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    self.distributionDictionary = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    self.octaveRangeDictionary1 = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    self.octaveRangeDictionary2 = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    self.envDeviationDictionary1 = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    self.envDeviationDictionary2 = [[NSMutableDictionary alloc]initWithDictionary:_NoteDensity1];
    
    //creating our custom slider
    CGRect sliderFrameVelRange1 = CGRectMake(100, 453, 200, 30);
    CGRect sliderFrameVelRange2 = CGRectMake(100, 521, 200, 30);
    _velocityRangeSlider1 = [[CustomSliderControl alloc]initWithFrame:sliderFrameVelRange1];
    [self.view addSubview:_velocityRangeSlider1];
    [_velocityRangeSlider1 addTarget:self
                     action:@selector(VelocityRange1Changed:)
           forControlEvents:UIControlEventValueChanged];
    _velocityRangeSlider2 = [[CustomSliderControl alloc]initWithFrame:sliderFrameVelRange2];
    [self.view addSubview:_velocityRangeSlider2];
    [_velocityRangeSlider2 addTarget:self
                              action:@selector(VelocityRange2Changed:)
                    forControlEvents:UIControlEventValueChanged];
    [self updateState];
    
//    levelMeter = [[LevelMeterView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-21,120,45,200)];
//    [levelMeter setBackgroundColor: [UIColor blackColor]];
//    levelMeter.layer.cornerRadius = 1;
//    levelMeter.layer.masksToBounds = YES;
//    [self.view addSubview:levelMeter];
    //TO DO: GET YO SHIT TOGETHER
#pragma-mark __Var-init
    velocityRandInstrument1 = TRUE;
    velocityRandInstrument2 = FALSE;
    volumeAmountPlayer = 0.8;
    ftableNumberPlayer = 1;
    lfoDestinationNumberPlayer = 0;
    lfoAmountPlayer = 0.5;
    lfoRatePlayer = 4.0;
    lfoWavetypePlayer = 0.0;
    _lastButtonLFO = 0;
    _resultedAmount = 50.0;
    _resultedRate = 10.0;
    
    measureCounter = 0;
    measureCountSinceLastNote = 0;
    theRandomLengthOfTheDrone = 0;
    didRandomTrigger = false;
    randomMode = false;
    fractalMode = false;
    transpMode = false;
    phraseMode = true;
    arpegMode = false;
    mirrorMode = false;
    lastModeChosen = 0;
    sendArrayFlag = false;
    distributionModeArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithBool:randomMode],[NSNumber numberWithBool:fractalMode], [NSNumber numberWithBool:transpMode], [NSNumber numberWithBool:phraseMode], [NSNumber numberWithBool:arpegMode], [NSNumber numberWithBool:mirrorMode], nil];
    melodyIndex = 0;
    currentPitch = 60;
    noteOffFlag = false;
    resultedTempo = 120;
    didItStop = true;
    lastButtonInstrument = 0;
    lastButtonTracker = 0;
    trackerType = DOWNWARD;
    substractor = -1;
    substractor2 = -1;
    substractor3 = -1;
    snakeComparator = 7;
    incrementer = 0;
    theFinalTimeSig = 4;
    theTimeSig = 4;
    flag = 0;
    _theWholeLocation = @"1A";
    _scaleLabel.text = @"C";
    modeLabel.text = @"Ionian";
    theTag = 0;
    thePreviousButton = 1;
    theOctaveCoef1 = 1;
    theOctaveCoef2 = 1;
    lastOctaveCoef1 = 1;
    theFinalOctaveCoef1 = 1;
    theFinalOctaveCoef2 = 1;
    root = 48;
    theStep = 0;
    aMode = 0;
    theScaleArray = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:I],[NSNumber numberWithInt:II],[NSNumber numberWithInt:III],[NSNumber numberWithInt:IV],[NSNumber numberWithInt:V],[NSNumber numberWithInt:VI],[NSNumber numberWithInt:VII], nil];
    incrementerForArray = 0;
    delayTime = 0.1666667;
    
    i = 0;
    j = 0;
    l = 0;
    n = 1;
    m = 0;
    a = 0;
    self.selectScaleView = [[SelectScaleViewController alloc]initWithNibName:@"SelectScale" bundle:nil];
    self.selectModeView = [[SelectMode alloc]initWithNibName:@"SelectModeView" bundle:nil];
    _tempoView.valueDelegate = self;
    _timeSignatureView.timeSignatureDelegate = self;
    _octaveRange1View.octaveRangeChange1Delegate = self;
    _octaveRange2View.octaveRangeChange2Delegate = self;
    
    //GETTING CSOUND READY TO ROCK
    tempFile = [[NSBundle mainBundle] pathForResource:@"dsp" ofType:@"csd"];
    
    self.csound = [[CsoundObj alloc] init];
//    self.csound.useAudioInput = YES;
    [self.csound addListener:self];
    //will enable MIDI input from CoreMIDI directly into Csound
    [self.csound setMidiInEnabled:YES];
    
    [self addToCsoundObj:self.csound forChannelName:@"pitch"];
    [self addToCsoundObj:self.csound forChannelName:@"velocity"];
    [self.csound setMessageCallback:@selector(messageCallback:) withListener:self];
    [self.csound stop];
    
    [self.csound play:tempFile];
    myMelodyArray1 = [[NSMutableArray alloc]initWithCapacity:32];
    theTransferedArray = [[NSMutableArray alloc]initWithCapacity:32];
    myTimeIntervalArray = [[NSMutableArray alloc]initWithCapacity:48];
    theArpeggiatedMelody = [[NSMutableArray alloc]initWithCapacity:32];
    theTransposedMelody = [[NSMutableArray alloc]initWithCapacity:32];
    lastTime = 0.0;
    self.selectFtableInstace.ftablePlayerDelegate = self;
    [self addChildViewController:instrumentView];
    //THIS FOLLOWING LINE BASICALLY PROVES THAT I'M THE BEST
    _childView = self.childViewControllers[0];
}

- (void)messageCallback:(NSValue *)infoObj

{
    
    @autoreleasepool {
        
        
        
        Message info;
        
        [infoObj getValue:&info];
        
        char message[1024];
        
        vsnprintf(message, 1024, info.format, info.valist);
        
        NSString *messageStr = [NSString stringWithFormat:@"%s", message];
        
        NSLog(@"%@", messageStr);
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //init all the dictionary for the dynamic variables here:
    int indexOfMatrice;
    NSMutableArray *distributionModeStrings = [[NSMutableArray alloc]initWithObjects:@"random", @"transp",@"arpeg",@"random",@"fractal",@"mirror", nil];
    NSMutableArray *noteDensityStrings = [[NSMutableArray alloc]initWithObjects:@"1/1", @"1/1",@"1/1", nil];
    NSString *initWithDistributionMode;
    NSString *initWithDensityString;
    NSString *envelopeDev1;
    NSString *envelopeDev2;
    NSNumber *initialLowVelocity;
    NSNumber *initialHighVelocity;
    NSNumber *octaveRange1;
    NSNumber *octaveRange2;
for(NSString* key in self.velocityRangeLow1.allKeys){
    indexOfMatrice = [[key substringToIndex:1]integerValue];
    initWithDistributionMode = (NSString*)[distributionModeStrings objectAtIndex:((indexOfMatrice-1)%6)];
    initWithDensityString = (NSString*)[noteDensityStrings objectAtIndex:((indexOfMatrice-1)%3)];
    if(indexOfMatrice % 2){
        envelopeDev1 = (NSString*)@"OFF";
        envelopeDev2 = (NSString*)@"ON";
        initialLowVelocity = [NSNumber numberWithInt:40];
        initialHighVelocity = [NSNumber numberWithInt:100];
        octaveRange1 = [NSNumber numberWithInt:0];
        octaveRange2 = [NSNumber numberWithInt:2];
    }else{
        envelopeDev1 = (NSString*)@"ON";
        envelopeDev2 = (NSString*)@"OFF";
        initialLowVelocity = [NSNumber numberWithInt:10];
        initialHighVelocity = [NSNumber numberWithInt:70];
        octaveRange1 = [NSNumber numberWithInt:2];
        octaveRange2 = [NSNumber numberWithInt:0];
        }
        [self.distributionDictionary setObject:initWithDistributionMode forKey:key];
        [self.NoteDensity1 setObject:initWithDensityString forKey:key];
        [self.velocityRangeLow1 setObject:initialLowVelocity forKey:key];
        [self.velocityRangeLow2 setObject:initialLowVelocity forKey:key];
        [self.velocityRangeHigh1 setObject:initialHighVelocity forKey:key];
        [self.velocityRangeHigh2 setObject:initialHighVelocity forKey:key];
        [self.envDeviationDictionary1 setObject:envelopeDev1 forKey:key];
        [self.envDeviationDictionary2 setObject:envelopeDev2 forKey:key];
        [self.octaveRangeDictionary1 setObject:octaveRange1 forKey:key];
        [self.octaveRangeDictionary2 setObject:octaveRange2 forKey:key];
    
    }
//    for(NSString* key in self.velocityRangeHigh1.allKeys){
//        [self.velocityRangeHigh1 setObject:[NSNumber numberWithInt:100] forKey:key];
//    }
//    for(NSString* key in self.velocityRangeLow2.allKeys){
//        [self.velocityRangeLow2 setObject:[NSNumber numberWithInt:40] forKey:key];
//    }
//    for(NSString* key in self.velocityRangeHigh2.allKeys){
//        [self.velocityRangeHigh2 setObject:[NSNumber numberWithInt:100] forKey:key];
//    }
//    NSString *initWithDistributionMode = @"phrase";
//    for(NSString* key in self.distributionDictionary.allKeys){
//
//        [self.distributionDictionary setObject:initWithDistributionMode forKey:key];
//    }
//    for(NSString* key in self.octaveRangeDictionary1.allKeys){
//        [self.octaveRangeDictionary1 setObject:[NSNumber numberWithInt:0] forKey:key];
//    }
//    for(NSString* key in self.octaveRangeDictionary2.allKeys){
//        [self.octaveRangeDictionary2 setObject:[NSNumber numberWithInt:0] forKey:key];
//    }
//    for(NSString* key in self.envDeviationDictionary1.allKeys){
//        [self.envDeviationDictionary1 setObject:(NSString*)@"OFF"forKey:key];
//    }
//    for(NSString* key in self.envDeviationDictionary2.allKeys){
//        [self.envDeviationDictionary2 setObject:(NSString*)@"OFF"forKey:key];
//    }
    UIButton *theButtonToPush = [self.unpushedDistributionButtons objectAtIndex:3];
    [theButtonToPush sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)addToCsoundObj:(CsoundObj *)csoundObj forChannelName:(NSString *)channelName_
{
    if([channelName_ isEqualToString:@"pitch"]){
    [csoundObj addBinding:self];
    self.channelNamePitch = channelName_;
    }else if([channelName_ isEqualToString:@"velocity"]){
        [csoundObj addBinding:self];
        self.channelNameVelocity = channelName_;
    }
}


#pragma-mark __PLAY/STOP/RECORD
- (IBAction)playRandom:(UIButton *)sender {
    if(sender.tag == 0){
        playRandom.hidden = true;
        playRandom.enabled = false;
        pauseRandom.hidden = false;
        pauseRandom.enabled = true;
        stopRandom.hidden = false;
        stopRandom.enabled = true;
        stopButtonPushed.hidden = true;
        stopButtonPushed.enabled = false;
        //making sure n and m are correctly init regarding the tracking mode chosen
        if(didItStop == TRUE){
            switch(trackerType){
                case FORWARD: n = 0; m = 1; break;
                case DOWNWARD: n = 1; m = 0; break;
                case SNAKE: n = 1; m = 0; break;
                case SQUARE: n = 1; m = 0; break;
            }
        }
        myTimerMetronome = [NSTimer scheduledTimerWithTimeInterval:(60.0/resultedTempo) target:self selector:@selector(timeFiredForMetro:) userInfo:nil repeats:YES];
        [myTimerMetronome fire];
        didItStop = false;

    }else{
        playRandom.hidden = false;
        playRandom.enabled = true;
        pauseRandom.hidden = true;
        pauseRandom.enabled = false;
        stopRandom.hidden = false;
        stopRandom.enabled = true;
        stopButtonPushed.hidden = true;
        stopButtonPushed.enabled = false;
        [myTimerMetronome invalidate];
        myTimerMetronome = nil;
        if(_randomTimer){
            [_randomTimer invalidate];
            _randomTimer = nil;
        }
    }
}

- (IBAction)stopRandom:(UIButton *)sender {
    if(sender.tag == 0){
        measureCounter = 0;
        didItStop = true;
        playRandom.hidden = false;
        playRandom.enabled = true;
        stopRandom.hidden = true;
        stopRandom.enabled = false;
        stopButtonPushed.hidden = false;
        stopButtonPushed.enabled = true;
        pauseRandom.hidden = true;
        pauseRandom.enabled = false;
        //invalidating timers
        [myTimerMetronome invalidate];
        myTimerMetronome = nil;
        [myTimerNoteGenerate invalidate];
        myTimerNoteGenerate = nil;
        _theWholeLocation = @"1A";
        a = 0;
        measureCountSinceLastNote = 0;
        measureCounter = 0;
        [self updateLocaterPosition:0 and:0];
        [self.csound sendScore:[NSString stringWithFormat:@"i97 0 0.1 %ld\ni97 0 0.1 31\n", (long)[self.childViewControllers[0] instrumentNumber]]];
    }
}

//TO DO: IMPLEMENT RECORD OPTION
- (IBAction)record:(UIButton *)sender {
    if(sender.tag == 0){
        recordRandom.hidden = true;
        recordRandom.enabled = false;
        recordPushed.hidden = false;
        recordPushed.enabled = true;
    }else{
        recordRandom.hidden = false;
        recordRandom.enabled = true;
        recordPushed.hidden = true;
        recordPushed.enabled = false;
    }
}



#pragma-mark __csound-stuff

-(void)csoundObjDidStart:(CsoundObj *)csoundObj
{
}
-(void)csoundObjComplete:(CsoundObj *)csoundObj
{
}
-(void)setup:(CsoundObj *)csoundObj{
    
    

                    //OUTPUT TO CSOUND//
    
    
    //ENVELOPE
    NSString *kAttackAmpStringPtr = @"AttackAmp";
    NSString *kAttackTimeStringPtr = @"AttackTime";
    NSString *kDecayAmpStringPtr = @"DecayAmp";
    NSString *kDecayTimeStringPtr = @"DecayTime";
    NSString *kSustainAmpStringPtr = @"SustainTime";
    NSString *kReleaseTimeStringPtr = @"ReleaseTime";
    kAttackAmpPtr = [csoundObj getInputChannelPtr:kAttackAmpStringPtr channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    kAttackTimePtr = [csoundObj getInputChannelPtr:kAttackTimeStringPtr channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    kDecayAmpPtr = [csoundObj getInputChannelPtr:kDecayAmpStringPtr channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    kDecayTimePtr = [csoundObj getInputChannelPtr:kDecayTimeStringPtr channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    kSustainAmpPtr = [csoundObj getInputChannelPtr:kSustainAmpStringPtr channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    kReleaseTimePtr = [csoundObj getInputChannelPtr:kReleaseTimeStringPtr channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    
    //FX SEND PLAYER
    NSString *reverbSendAmountString = @"rvbAmountPlayer";
    NSString *delaySendAmountString = @"delayAmountPlayer";
    NSString *delayTimeStringString = @"delayTime";
    NSString *chorusSendAmountString = @"chorusAmountPlayer";
    NSString *distoSendAmountString = @"distoAmountPlayer";
    NSString *volumeAmountPlayerString = @"volumeAmountPlayer";
    delayTimePtr = [csoundObj getInputChannelPtr:delayTimeStringString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    reverbSendAmountPlayerPtr = [csoundObj getInputChannelPtr:reverbSendAmountString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    delaySendAmountPlayerPtr = [csoundObj getInputChannelPtr:delaySendAmountString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    chorusSendAmountPlayerPtr = [csoundObj getInputChannelPtr:chorusSendAmountString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    distoSendAmountPlayerPtr = [csoundObj getInputChannelPtr:distoSendAmountString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    volumeAmountPlayerPtr = [csoundObj getInputChannelPtr:volumeAmountPlayerString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    
    //FX SEND MACHINE
    NSString *reverbSendAmountMachineString = @"rvbAmountMachine";
    NSString *delaySendAmountMachineString = @"delayAmountMachine";
    NSString *chorusSendAmountMachineString = @"chorusAmountMachine";
    NSString *distoSendAmountMachineString = @"distoAmountMachine";
    NSString *volumeAmountMachineString = @"volumeAmountMachine";
    reverbSendAmountMachinePtr = [csoundObj getInputChannelPtr:reverbSendAmountMachineString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    delaySendAmountMachinePtr = [csoundObj getInputChannelPtr:delaySendAmountMachineString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    chorusSendAmountMachinePtr = [csoundObj getInputChannelPtr:chorusSendAmountMachineString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    distoSendAmountMachinePtr = [csoundObj getInputChannelPtr:distoSendAmountMachineString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    volumeAmountMachinePtr = [csoundObj getInputChannelPtr:volumeAmountMachineString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    
    //FX SEND DRONE
    NSString *reverbSendAmountDroneString = @"rvbAmountDrone";
    NSString *delaySendAmountDroneString = @"delayAmountDrone";
    NSString *chorusSendAmountDroneString = @"chorusAmountDrone";
    NSString *distoSendAmountDroneString = @"distoAmountDrone";
    NSString *volumeAmountDroneString = @"volumeAmountDrone";
    reverbSendAmountDronePtr = [csoundObj getInputChannelPtr:reverbSendAmountDroneString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    delaySendAmountDronePtr = [csoundObj getInputChannelPtr:delaySendAmountDroneString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    chorusSendAmountDronePtr = [csoundObj getInputChannelPtr:chorusSendAmountDroneString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    distoSendAmountDronePtr = [csoundObj getInputChannelPtr:distoSendAmountDroneString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    volumeAmountDronePtr = [csoundObj getInputChannelPtr:volumeAmountDroneString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    
    //FILTER VALUES
    NSString *filterCutoffString = @"filterCutoff";
    NSString *filterResonanceString = @"filterResonance";
    filterCutoffPtr = [csoundObj getInputChannelPtr:filterCutoffString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    filterResonancePtr = [csoundObj getInputChannelPtr:filterResonanceString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    
    //LFO FLAG
    NSString *lfoDestinationString = @"lfoDestination";
    NSString *lfoWavetypeString = @"lfoWaveType";
    NSString *lfoRateString = @"lfoRate";
    NSString *lfoAmountString = @"lfoAmount";
    lfoDestinationPlayerPtr = [csoundObj getInputChannelPtr:lfoDestinationString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    lfoWavetypePlayerPtr = [csoundObj getInputChannelPtr:lfoWavetypeString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    lfoRatePlayerPtr = [csoundObj getInputChannelPtr:lfoRateString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    lfoAmountPlayerPtr = [csoundObj getInputChannelPtr:lfoAmountString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    
    //FTABLE INSTRUMENT
    NSString *ftablePlayerString = @"instrPlayerFlag";
    ftableNumberPlayerPtr = [csoundObj getInputChannelPtr:ftablePlayerString channelType:CSOUND_CONTROL_CHANNEL | CSOUND_INPUT_CHANNEL];
    
 
                    //OUTPUT FROM CSOUND//
    
    
    
    //OUTPUT FOR PITCH AND AMP CHANNELS
    ChannelPitchPtr = [csoundObj getOutputChannelPtr:self.channelNamePitch channelType:CSOUND_CONTROL_CHANNEL];
    ChannelVelocityPtr = [csoundObj getOutputChannelPtr:self.channelNameVelocity channelType:CSOUND_CONTROL_CHANNEL];
    
    //GETTING GLOBAL VARIABLES FROM CSOUND
    CSOUND *cs = [csoundObj getCsound];
    sr = csoundGetSr(cs);
    ksmps = csoundGetKsmps(cs);
//    csoundSetMIDIInput(cs, "IAC Driver Bus 1");
    
}
-(void)updateValuesToCsound{
    
    //ENV. VALUES
    *kAttackAmpPtr = _theAttackAmpProp;
    *kAttackTimePtr = _theAttackTimeProp;
    *kDecayAmpPtr = _theDecayAmpProp;
    *kDecayTimePtr = _theDecayTimeProp;
    *kSustainAmpPtr = _theSustainAmpProp;
    *kReleaseTimePtr = _theReleaseTimeProp;
    
    //INSTRUMENT NUMBER
    *ftableNumberPlayerPtr = ftableNumberPlayer;
    
    //EFFECTS VALUES
    *reverbSendAmountPlayerPtr = reverbSendAmountPlayer;
    *chorusSendAmountPlayerPtr = chorusSendAmountPlayer;
    *distoSendAmountPlayerPtr = distoSendAmountPlayer;
    *delaySendAmountPlayerPtr = delaySendAmountPlayer;
    *volumeAmountPlayerPtr    = volumeAmountPlayer;
    *delayTimePtr = delayTime;
    
    //LFO VALUE
    *lfoDestinationPlayerPtr = lfoDestinationNumberPlayer;
    *lfoAmountPlayerPtr = lfoAmountPlayer;
    *lfoRatePlayerPtr  = lfoRatePlayer;
    *lfoWavetypePlayerPtr = lfoWavetypePlayer;
    
    //INSTRUMENT DESIGN VALUES FOR INSTRUMENT#1
    *volumeAmountMachinePtr = self.childView.volumeAmountMachine;
    *reverbSendAmountMachinePtr = self.childView.reverbSendAmountMachine;
    *chorusSendAmountMachinePtr = self.childView.chorusSendAmountMachine;
    *delaySendAmountMachinePtr = self.childView.delaySendAmountMachine;
    *distoSendAmountMachinePtr = self.childView.distoSendAmountMachine;
    
    //INSTRUMENT DESIGN VALUES FOR INSTRUMENT#2
    *volumeAmountDronePtr = self.childView.volumeAmountDrone;
    *reverbSendAmountDronePtr = self.childView.reverbSendAmountDrone;
    *chorusSendAmountDronePtr = self.childView.chorusSendAmountDrone;
    *delaySendAmountDronePtr = self.childView.delaySendAmountDrone;
    *distoSendAmountDronePtr = self.childView.distoSendAmountDrone;
    
    //Filter value
    *filterCutoffPtr = (float)self.childView.resultedAmountCutoff;
    *filterResonancePtr = self.childView.resultedAmountFinalQuality;
}

-(void)updateValuesFromCsound{
    
    //THIS WHOLE BLOCK ALLOW US TO SAVE SOME CPU PROCESS BY UPDATING THE noteNumber ONCE EVERY X SAMPLES
    static NSInteger count = 0;
    //called every 220 samples
  if(playRandom.hidden == true){
    if (count % ((sr/ksmps)/100) == 0) {
        
        noteVelocity = *ChannelVelocityPtr;
        if(noteVelocity != 0){
            noteOffFlag = true;
        }
        if(noteNumber != 0){
            noteNumberComparator = noteNumber;
        }
        noteNumber = *ChannelPitchPtr;
        //make sure we catch the "real" pitch
        if(noteNumber != 0){
            lastNoteNumberNotZero = noteNumber;
        }
        //conditional statement using a flag along with the velocity value to go through the whole block only once once the veloctiy = 0
        if((lastNoteNumberNotZero > 100 && sendArrayFlag == true) || i >= 32){
//            [myMelodyArray1 replaceObjectAtIndex:i withObject:]
            if([myMelodyArray1 count] > 3){
            i = 0;
            [self newPhraseEvent:myMelodyArray1];
            [myMelodyArray1 removeAllObjects];
            sendArrayFlag = false;

            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        //new note event
        if(noteNumberComparator != lastNoteNumberNotZero && lastNoteNumberNotZero < 72 && noteOffFlag == true){
            //only write into the array if one of the "non-realtime" methods is on
            if(phraseMode == true || transpMode == true || arpegMode == true){
            [myMelodyArray1 addObject:[NSNumber numberWithInt:lastNoteNumberNotZero]];
            //if "real time" method is on, then trigger the note as soon as a note is played
            }else if(mirrorMode == true){
                NSMutableArray *theNoteInfos = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:lastNoteNumberNotZero], [NSNumber numberWithInt:noteVelocity], nil];
                _mirrorTimer = [NSTimer scheduledTimerWithTimeInterval:((60.0/resultedTempo)*1.0) target:self selector:@selector(getTheMirroredNote:) userInfo:theNoteInfos repeats:NO];
                
            }else if(fractalMode == true){
                NSMutableArray *theNoteInfos = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:lastNoteNumberNotZero], [NSNumber numberWithInt:noteVelocity], nil];
                _mirrorTimer = [NSTimer scheduledTimerWithTimeInterval:((60.0/resultedTempo)*1.0) target:self selector:@selector(getTheFragmentedNote:) userInfo:theNoteInfos repeats:NO];
                
            }
            if(i != 0){
            [self retrieveTimeIntervalBetweenTwoNotes];
            }else{
                lastTime = CACurrentMediaTime();
            }
            noteOffFlag = false;
            i++;
//            NSLog(@"i = %d, lastnotenumber = %d, notecomp = %d\n", i, lastNoteNumberNotZero, noteNumberComparator);
        }
            if(noteVelocity == 0){
                noteOffFlag = false;
            }
        //WE WANT AT LEAST 3 NOTES IN THE ARRAY
        if(i > 3){
            sendArrayFlag = true;
        }
        _velocityLabel.text = [NSString stringWithFormat:@"%d",noteVelocity];
            _pitchLabel.text = [NSString stringWithFormat:@"%d",lastNoteNumberNotZero];
        });
    }
    count++;
    
    if (count > INT_MAX) {
        count -= INT_MAX;
        }
    }
    
}

-(float)retrieveTimeIntervalBetweenTwoNotes{

    currentTime = CACurrentMediaTime();
        theTimeInterval = currentTime - lastTime;

    lastTime = CACurrentMediaTime();
    [myTimeIntervalArray insertObject:[NSNumber numberWithFloat:theTimeInterval] atIndex:(i-1)];

    return theTimeInterval;
}

#pragma-mark __new-note-related-method
//include any events you want to happen when new note occuring
-(void)newPhraseEvent:(NSMutableArray*)theMelodyArray{
    /* Value declaration + init */
    theTransferedArray = [[NSMutableArray alloc]initWithArray:theMelodyArray copyItems:YES];

    //IF ARPEG MODE IS ON, WE NEED TO GET THE NEW SORTED ARRAY BEFORE PERFORMANCE
    if(arpegMode == true){
        [theArpeggiatedMelody removeAllObjects];
        [theArpeggiatedMelody addObjectsFromArray:[self getTheArpeggiatedSortedArrayWithArray:theTransferedArray]];
    }else if(transpMode == true){
        [theTransposedMelody removeAllObjects];
        [theTransposedMelody addObjectsFromArray:[self getTheTransposedSortedArrayWithArray:theTransferedArray]];
        NSLog(@"%@ transposed \n", theTransposedMelody);
    }
    //sort the time interval array so its more fun
    if(phraseMode == true){
    myTimeIntervalArray = [self sortTheTimeIntervalArray:myTimeIntervalArray];
    }
    
    float theInitialTime = [[myTimeIntervalArray objectAtIndex:0]floatValue];
    myTimerNoteGenerate = [NSTimer scheduledTimerWithTimeInterval:theInitialTime target:self selector:@selector(timeFiredForSound:) userInfo:nil repeats:NO];
    [myTimerNoteGenerate fire];
    
}

-(NSMutableArray*)sortTheTimeIntervalArray:(NSMutableArray*)theArray{
    NSSortDescriptor *sortingArray;
    int randFactor;
    
    randFactor = arc4random_uniform(3);
    if(randFactor == 0){
        sortingArray = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        [theArray sortUsingDescriptors:[NSArray arrayWithObject:sortingArray]];
    }else if(randFactor == 1){
        sortingArray = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        [theArray sortUsingDescriptors:[NSArray arrayWithObject:sortingArray]];
    }
    return theArray;
}

- (IBAction)dumpTheSequence:(UIButton *)sender {
    [myMelodyArray1 removeAllObjects];
    myMelodyArray1 = [[NSMutableArray alloc]initWithCapacity:33];
    int x = 0;
    for(x = 0; x < 33; x++){
    [myMelodyArray1 addObject:[NSNull null]];
    }
}


#pragma-mark __PLAY
-(void)timeFiredForMetro:(NSTimer*)theTimerForMetro{
    int getTheInstrumentNumber;
    int theDroneFrequencyFirst;
    int theDroneFrequencySecond;
    int theIndexForTheSecondFrequency;
    float theTotalDuration;
    float theAttack;
    float theSustain;
    float theRelease;
    float theAmpOfTheDrone;
    float theCutoff;
    int coef2;
    int multiplierFactor = 2;
    float theRandomAttackFactor;
    float theRandomReleaseFactor;


    
    //STATEMENT INDUCING A NEW MEASURE
    if(a >= theFinalTimeSig){
        
        a = 0;
        measureCounter++;
        measureCountSinceLastNote++;
        [self updateMatrixLocaterWhenPlaying];
        
        //ONCE THE MEASURECOUNTER REACHES THE ENGTH OF THE NOTE, IF GENERATE A NEW ONE
        if(measureCountSinceLastNote > theRandomLengthOfTheDrone || measureCounter == 0){
            getTheInstrumentNumber = (int)[[self.childViewControllers[0] instrumentNumberDrone]integerValue];
            measureCountSinceLastNote = 0;
            theRandomLengthOfTheDrone = arc4random_uniform(3);
            theRandomLengthOfTheDrone += 1;
            theRandomLengthOfTheDrone *= multiplierFactor;
            int rand[5] = {0, 1, -1, 2, -2};
            switch(theFinalOctaveCoef2){
                case 0: coef2 = 0; break;
                case 2: coef2 = rand[arc4random_uniform(3)]; break;
                case 4: coef2 = rand[arc4random_uniform(5)]; break;
                default: coef2 = 0; break;
            }

            //CALCULATING PFIELD'S FOR DRONE
//            P4=FREQ P5=ATTACK P6=AMP p7=SUSTAIN P7=RELEASE P8=CUTOFF
            //FREQUENCY FOR ROOT AND 2ND NOTE
            theDroneFrequencyFirst = (int)[[theScaleArray objectAtIndex:(arc4random_uniform(5))]integerValue];
            theIndexForTheSecondFrequency = (int)[theScaleArray indexOfObject:@(theDroneFrequencyFirst)];
            theIndexForTheSecondFrequency += 3; //A THIRD ABOVE THE ROOT
            if(theIndexForTheSecondFrequency >= [theScaleArray count])theIndexForTheSecondFrequency -= 7;
            theDroneFrequencyFirst -= 24;
            theDroneFrequencySecond = (int)[[theScaleArray objectAtIndex:theIndexForTheSecondFrequency]integerValue];
            theDroneFrequencySecond -= 12;

            //other pfields....
            theTotalDuration  = (theRandomLengthOfTheDrone * ((60.0/resultedTempo)*8.0));
            theAttack         = (theTotalDuration/10.0);
            theSustain        = ((8*theTotalDuration)/10.0);
            theRelease        = (theTotalDuration/10.0);
            theCutoff         =  150+(150*abs(coef2));
            if(velocityRandInstrument2 == TRUE){
                int theVelocity = [self velocityPickUpForSliderNumber:2];
                theAmpOfTheDrone = 127.0/theVelocity;
            }else{
                theAmpOfTheDrone = 1.0;
            }
            //calculating random envelope
            UILabel *theLabel = [self.envelopeDeviationLabels objectAtIndex:1];
            if([theLabel.text isEqualToString:@"ON"]){
                int theRandomAttackFactorInt = arc4random_uniform(((theTotalDuration/10.0)*1000));
                theRandomAttackFactor = (float)theRandomAttackFactorInt/1000.0;
                if(arc4random_uniform(1) == 0){
                    theRandomAttackFactor *= (-1);
                    theRandomReleaseFactor = theRandomAttackFactor*(-1);
                }else{
                    theRandomAttackFactor *= 1;
                    theRandomReleaseFactor = theRandomAttackFactor*(-1);
                }
            }else{
                theRandomAttackFactor = 0;
                theRandomReleaseFactor = 0;
            }
            NSString *theDroneScoreEventFirst = [NSString stringWithFormat:@"i%d 0 %f %d %f %f %f %f %f\n",getTheInstrumentNumber ,theTotalDuration+4.0,(theDroneFrequencyFirst+(12*coef2)), theAttack+theRandomAttackFactor, theAmpOfTheDrone, theSustain, theRelease+theRandomReleaseFactor+2.0, theCutoff];
            NSString *theDroneScoreEventSecond = [NSString stringWithFormat:@"i%d 0 %f %d %f %f %f %f %f\n",getTheInstrumentNumber ,theTotalDuration+4.0,(theDroneFrequencySecond+(12*coef2)), theAttack+theRandomAttackFactor, theAmpOfTheDrone, theSustain, theRelease+theRandomReleaseFactor+2.0, theCutoff];
            NSLog(@"%@\n%@\n", theDroneScoreEventFirst, theDroneScoreEventSecond);
            [self.csound sendScore:theDroneScoreEventFirst];
            [self.csound sendScore:theDroneScoreEventSecond];
        }
    }
    //triggering random notes if randmode is ON
    if(randomMode == true && didRandomTrigger == false){
        _randomTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getTheRandomSequence:) userInfo:nil repeats:NO];
        [_randomTimer fire];
        didRandomTrigger = true;
        NSLog(@"sup\n");
    }else {
        didRandomTrigger = false;
        if(_randomTimer){
        [_randomTimer invalidate];
        _randomTimer = nil;
        }
    }
    //UPDATING MEASURE# LABEL
    xyPad.beatTracker.text = [NSString stringWithFormat:@"%d/4", a+1];
    a++;
             
}
-(NSMutableArray*)getRandomEnvelope{
    double theRandomAttackFactor;
    double theRandomReleaseFactor;
    theRandomAttackFactor = arc4random_uniform(1000);
    theRandomAttackFactor += 100;
    theRandomAttackFactor = (double)(theRandomAttackFactor/1000.0);
    
    theRandomReleaseFactor = arc4random_uniform(1000);
    theRandomReleaseFactor += 100;
    theRandomReleaseFactor = (double)(theRandomReleaseFactor/1000.0);
    
    if(theRandomAttackFactor < 0.001){
        theRandomAttackFactor = 0;
    }
    if(theRandomReleaseFactor < 0.0001){
        theRandomReleaseFactor = 0.01;
    }
    NSMutableArray *envelopeValues = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithDouble:theRandomAttackFactor], [NSNumber numberWithDouble:theRandomReleaseFactor], nil];
    return envelopeValues;
}

//_______________________START OF DISTRIBUTION DEFINITION_______________________//

-(void)timeFiredForSound:(NSTimer*)theTimer{
    //THIS METHOD IS ONLY GETTING CALLED IF ONE OF THE THREE "REAL-TIME" DISTRIBUTION METHOD ARE BEING ON
    //OTHER WISE THE SCORE STRING WILL BE GENERATED LOCALLY IN THE RESPECTIVE DISTRIBUTION METHOD
    dispatch_async(dispatch_get_main_queue(), ^{
        int maxIndex;
        int theNoteNumber;
        int theVelocity;
        float theNoteTimeValue = 0.0;
        int getTheInstrumentNumber;
        NSString *theScore;
        int coef1;
        int realDensityCoef;
        int densityCoef;
        NSString *theDensityFactor;
        UILabel *theCurrentDensityLabel;
        double theRandomAttackFactor;
        double theRandomReleaseFactor;
        
        theCurrentDensityLabel = (UILabel*)[self.noteDensityLabels objectAtIndex:0];
        theDensityFactor = theCurrentDensityLabel.text;
        
        theDensityFactor = theCurrentDensityLabel.text;
        if([theDensityFactor isEqualToString:@"1/3"]){
            densityCoef = 2;
        }else if([theDensityFactor isEqualToString:@"1/2"]){
            densityCoef = 1;
        }else{
            densityCoef = 0;
        }
        if(melodyIndex == 0){
            realDensityCoef = 0;
        }else{
                realDensityCoef = (int)melodyIndex*densityCoef;
            }
        //Get current instrument selected from tableview
        getTheInstrumentNumber = (int)[[self.childViewControllers[0] instrumentNumber]integerValue];
        
        //calculating the length of the recorded array
        maxIndex = (int)[theTransferedArray count];
        //1. GET TIME VALUE
        //timeinterval array has one less object than the melody ones
    
        if(melodyIndex+realDensityCoef != (maxIndex-1)){
            theNoteTimeValue = [[myTimeIntervalArray objectAtIndex:melodyIndex+realDensityCoef]floatValue];
        }
        //2. GET NOTE NUMBER
        if([theTransferedArray objectAtIndex:(melodyIndex+realDensityCoef)] != [NSNull null]){
        if(arpegMode == true){
           theNoteNumber = (int)[[theArpeggiatedMelody objectAtIndex:(melodyIndex+realDensityCoef)]integerValue];
        }else if(phraseMode == true){
           theNoteNumber = (int)[[theTransferedArray objectAtIndex:(melodyIndex+realDensityCoef)]integerValue];
        }else if(transpMode == true){
            theNoteNumber = (int)[[theTransposedMelody objectAtIndex:(melodyIndex+realDensityCoef)]integerValue];
        }
        
        //3. GET VELOCITY
            if(velocityRandInstrument1 == TRUE){
                theVelocity = [self velocityPickUpForSliderNumber:1];
            }else{
                theVelocity = 100;
            }
        //3'. GET THE OCTAVE RANGE COEFFICIENT
        int rand[5] = {0, 1, -1, 2, -2};
        switch(theFinalOctaveCoef2){
            case 0: coef1 = 0; break;
            case 2: coef1 = rand[arc4random_uniform(3)]; break;
            case 4: coef1 = rand[arc4random_uniform(5)]; break;
            default: coef1 = 0; break;
        }
        //3''. CALCULATE THE ATTACK+RELEASE RAND
            //calculating random envelope
            UILabel *theLabel = [self.envelopeDeviationLabels objectAtIndex:0];
            if([theLabel.text isEqualToString:@"ON"]){
                NSMutableArray *tmpArray = (NSMutableArray*)[[NSMutableArray alloc]initWithArray:[self getRandomEnvelope] copyItems:YES];
                theRandomAttackFactor = [[tmpArray objectAtIndex:0]floatValue];
                theRandomReleaseFactor = [[tmpArray objectAtIndex:1]floatValue];
            }else{
                if(getTheInstrumentNumber == 23){
                    theRandomAttackFactor = 0.18;
                    theRandomReleaseFactor = 0.18;
                }else{
                    theRandomAttackFactor = 0.007;
                    theRandomReleaseFactor = 0.5;
                }
            }

        //4. GENERATE SCORE STRING (since fmbell require 2 extra pfield we need to make a conditional statement)
        theScore = [NSString stringWithFormat:@"i%d 0 3 %d %d %f %f\n",getTheInstrumentNumber,(theNoteNumber+(coef1*12)),theVelocity, theRandomAttackFactor, theRandomReleaseFactor];
        //NOTE PERFORMANCE ACCORDING TO MODE

            [self.csound sendScore:theScore];
    
    melodyIndex++;
        
    [self updateMIDIMonitoringListForVelocity:theVelocity andMidiNote:theNoteNumber];
    [myTimerNoteGenerate invalidate];
    myTimerNoteGenerate = nil;
    myTimerNoteGenerate = [NSTimer scheduledTimerWithTimeInterval:theNoteTimeValue target:self selector:@selector(timeFiredForSound:) userInfo:nil repeats:NO];
    if((melodyIndex+realDensityCoef) >= maxIndex-realDensityCoef){
        melodyIndex -= melodyIndex;
        [myTimerNoteGenerate invalidate];
        myTimerNoteGenerate = nil;
    }
        }else{
            melodyIndex -= melodyIndex;
            [myTimerNoteGenerate invalidate];
            myTimerNoteGenerate = nil;
        }
    });
}
#pragma __triggering-events

//2. TRANSPO MODE METHODS
-(NSMutableArray*)getTheTransposedSortedArrayWithArray:(NSMutableArray*)theArray{
    NSMutableArray *theNewTransposedArray;
    NSLog(@" theuntransposedarray = %@\n", theArray);
    int theNewTransposedNote = 0;
    int theIndexOfTheNoteInTheScale;
    int theNoteToTranspose;
    int index;
    float theOctaveRangeOfTheNote;
    
    //INIT THE ARRAY TO PASS
    theNewTransposedArray = [[NSMutableArray alloc]initWithCapacity:[theArray count]];
    for(index = 0; index < [theArray count]; index++){
        NSNumber *b = [theArray objectAtIndex:index];
        
        theNoteToTranspose = (int)[b integerValue];
        theOctaveRangeOfTheNote = ((theNoteToTranspose - root)/12);
        if(theNoteToTranspose < root){
            theOctaveRangeOfTheNote -= 1;
            theOctaveRangeOfTheNote = trunc(theOctaveRangeOfTheNote);
        }else{
            theOctaveRangeOfTheNote = trunc(theOctaveRangeOfTheNote);
        }
        //Modulo 12 then +12 brings the note back to its right range (to find it in our array)
        theNoteToTranspose %= 12;
        theNoteToTranspose += root;
        theIndexOfTheNoteInTheScale = (int)[theScaleArray indexOfObject:@(theNoteToTranspose)];
        if([theScaleArray containsObject:@(theNoteToTranspose)]){
            switch(theIndexOfTheNoteInTheScale){
                    //if note is root then mirror is root
                case 0: theIndexOfTheNoteInTheScale = 1; break;
                    //if note is II then note is VII
                case 1: theIndexOfTheNoteInTheScale = 2; break;
                    //if note is III then note is VI
                case 2: theIndexOfTheNoteInTheScale = 3; break;
                    //if note is IV then note is V
                case 3: theIndexOfTheNoteInTheScale = 4; break;
                    //if note is V then note is IV
                case 4: theIndexOfTheNoteInTheScale = 5; break;
                    //if note is VI then note is III
                case 5: theIndexOfTheNoteInTheScale = 6; break;
                    //if note is VII then note is II
                case 6: theIndexOfTheNoteInTheScale = 0; break;
                default: break;
            }
    
    //CHECK IF THE NOTE IS PART OF THE CURRENT SCALE
    if([theScaleArray containsObject:[NSNumber numberWithInt:theNoteToTranspose]]){
            //TO DO: MAKE THIS SHIT WORK
            theNewTransposedNote = (int)[[theScaleArray objectAtIndex:theIndexOfTheNoteInTheScale]integerValue];
            
            theNewTransposedNote += 12*theOctaveRangeOfTheNote;
        }
    //IF NOTE IS NOT PART OF CURRENT SCALE, DEFAULT IT TO THE ROOT
    }else{
        theNewTransposedNote = root;
    }
    
    //WRITE THE NEW NOTEI NTO THE ARRAY AT THE RIGHT INDEX
    [theNewTransposedArray insertObject:@(theNewTransposedNote) atIndex:index];
//    NSLog(@"theoriginal = %d || thetransposed = %d\n", theNoteToTranspose, theNewTransposedNote);
    }
    NSLog(@"the old array = %@ thetransposedarray = %@\n", theArray,theNewTransposedArray);
                              return theNewTransposedArray;
}

//3. ARPEG METHOD
-(NSMutableArray*)getTheArpeggiatedSortedArrayWithArray:(NSMutableArray*)theArray{
    //RANDOMIZATION OF ASCENDING-DESCENDING
    NSSortDescriptor *sortingArray;
    int chooseDirectionRand;
    
    chooseDirectionRand = arc4random_uniform(2);
    
    if(chooseDirectionRand == 0){
    sortingArray = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    }else{
        sortingArray = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    }
    
    [theArray sortUsingDescriptors:[NSArray arrayWithObject:sortingArray]];
    
    return theArray;
    
}

//4. MIRROR METHOD
-(void)getTheMirroredNote:(NSTimer*)theTimer{
    
    
    int theNote;
    int theVelocity;
    int getTheInstrumentNumber;
    int theMirroredNote;
    int theIndexOfTheNoteToMirror;
    int theOctaveRangeOfTheNote = 0;
    double theRandomAttackFactor;
    double theRandomReleaseFactor;
    NSString *theScore;
    NSMutableArray *theNoteInfos;
    
    getTheInstrumentNumber = (int)[[self.childViewControllers[0] instrumentNumber]integerValue];
    
    theNoteInfos = (NSMutableArray*)[theTimer userInfo];
    theNote = (int)[[theNoteInfos objectAtIndex:0]integerValue];
    theVelocity = (int)[[theNoteInfos objectAtIndex:1]integerValue];
    
    theOctaveRangeOfTheNote = ((theNote - root)/12);
    NSLog(@"theoctaverange = %d\n", theOctaveRangeOfTheNote);
    if(theMirroredNote < root){
        theOctaveRangeOfTheNote -= 1;
        theOctaveRangeOfTheNote = trunc(theOctaveRangeOfTheNote);
    }else{
        theOctaveRangeOfTheNote = trunc(theOctaveRangeOfTheNote);
    }
    NSLog(@"theoctaverange = %d\n", theOctaveRangeOfTheNote);
    //Modulo 12 then +12 brings the note back to its right range (to find it in our array)
    theNote %= 12;
    theNote += root;
    theIndexOfTheNoteToMirror = (int)[theScaleArray indexOfObject:@(theNote)];
    if([theScaleArray containsObject:@(theNote)]){
        switch(theIndexOfTheNoteToMirror){
            //if note is root then mirror is root
            case 0: theIndexOfTheNoteToMirror = 0; break;
            //if note is II then note is VII
            case 1: theIndexOfTheNoteToMirror = 6; break;
            //if note is III then note is VI
            case 2: theIndexOfTheNoteToMirror = 5; break;
            //if note is IV then note is V
            case 3: theIndexOfTheNoteToMirror = 4; break;
            //if note is V then note is IV
            case 4: theIndexOfTheNoteToMirror = 3; break;
            //if note is VI then note is III
            case 5: theIndexOfTheNoteToMirror = 2; break;
            //if note is VII then note is II
            case 6: theIndexOfTheNoteToMirror = 1; break;
            default: break;
        }
    }else{
        //to do: do something when note is out of the scale
    }
        theMirroredNote = (int)[[theScaleArray objectAtIndex:theIndexOfTheNoteToMirror]integerValue];
    
        theMirroredNote += 12*theOctaveRangeOfTheNote;

    
    NSLog(@"the root = %d || the note = %d || theindex = %d || the mirror note = %d\n", root,theNote, theIndexOfTheNoteToMirror, theMirroredNote);
    //3''. CALCULATE THE ATTACK+RELEASE RAND
    //calculating random envelope
    UILabel *theLabel = [self.envelopeDeviationLabels objectAtIndex:0];
    if([theLabel.text isEqualToString:@"ON"]){
        NSMutableArray *tmpArray = (NSMutableArray*)[[NSMutableArray alloc]initWithArray:[self getRandomEnvelope] copyItems:YES];
        theRandomAttackFactor = [[tmpArray objectAtIndex:0]floatValue];
        theRandomReleaseFactor = [[tmpArray objectAtIndex:1]floatValue];
    }else{
        theRandomAttackFactor = 0.007;
        theRandomReleaseFactor = 0.5;
    }
    theMirroredNote += (theOctaveRangeOfTheNote*12);
    theScore = [NSString stringWithFormat:@"i%d 0 3 %d %d %f %f\n",getTheInstrumentNumber,(int)theMirroredNote,theVelocity, theRandomAttackFactor, theRandomReleaseFactor];
    [self.csound sendScore:theScore];
//    [_mirrorTimer invalidate];
//    _mirrorTimer = nil;
}

//5. FRAGMENTED METHOD
-(void)getTheFragmentedNote:(NSTimer*)theTimer{
    int theNote;
    int theVelocity;
    int getTheInstrumentNumber;
    int theFragmentedNote;
    int theIndexOfTheNoteToFragmented;
    int theOctaveRangeOfTheNote;
    double theRandomAttackFactor;
    double theRandomReleaseFactor;
    NSString *theScore;
    NSMutableArray *theNoteInfos;
    
    //INIT THE ARRAY TO PASS
    getTheInstrumentNumber = (int)[[self.childViewControllers[0] instrumentNumber]integerValue];
    
    theNoteInfos = (NSMutableArray*)[theTimer userInfo];
    theNote = (int)[[theNoteInfos objectAtIndex:0]integerValue];
    NSLog(@"the initial note = %d\n", theNote);
    theVelocity = (int)[[theNoteInfos objectAtIndex:1]integerValue];
    
        theOctaveRangeOfTheNote = ((theNote - root)/12);
        if(theNote < root){
            theOctaveRangeOfTheNote -= 1;
            theOctaveRangeOfTheNote = trunc(theOctaveRangeOfTheNote);
        }else{
            theOctaveRangeOfTheNote = trunc(theOctaveRangeOfTheNote);
        }
        //Modulo 12 then +12 brings the note back to its right range (to find it in our array)
        theNote %= 12;
        theNote += root;
        theIndexOfTheNoteToFragmented = (int)[theScaleArray indexOfObject:@(theNote)];
        if([theScaleArray containsObject:@(theNote)]){
            switch(theIndexOfTheNoteToFragmented){
                    //if note is root then mirror is root
                case 0: theIndexOfTheNoteToFragmented = 1; break;
                    //if note is II then note is VII
                case 1: theIndexOfTheNoteToFragmented = 2; break;
                    //if note is III then note is VI
                case 2: theIndexOfTheNoteToFragmented = 3; break;
                    //if note is IV then note is V
                case 3: theIndexOfTheNoteToFragmented = 4; break;
                    //if note is V then note is IV
                case 4: theIndexOfTheNoteToFragmented = 5; break;
                    //if note is VI then note is III
                case 5: theIndexOfTheNoteToFragmented = 6; break;
                    //if note is VII then note is II
                case 6: theIndexOfTheNoteToFragmented = 0; break;
                default: break;
                }
                //TO DO: MAKE THIS SHIT WORK
                theFragmentedNote = (int)[[theScaleArray objectAtIndex:theIndexOfTheNoteToFragmented]integerValue];
                
                theFragmentedNote += 12*theOctaveRangeOfTheNote;
            //IF NOTE IS NOT PART OF CURRENT SCALE, DEFAULT IT TO THE ROOT
            }else{
                theFragmentedNote = root;
        }
    NSLog(@"the root = %d || the note = %d || theindex = %d || the mirror note = %d\n", root,theNote, theIndexOfTheNoteToFragmented, theFragmentedNote);
    //3''. CALCULATE THE ATTACK+RELEASE RAND
    //calculating random envelope
    UILabel *theLabel = [self.envelopeDeviationLabels objectAtIndex:0];
    if([theLabel.text isEqualToString:@"ON"]){
        NSMutableArray *tmpArray = (NSMutableArray*)[[NSMutableArray alloc]initWithArray:[self getRandomEnvelope] copyItems:YES];
        theRandomAttackFactor = [[tmpArray objectAtIndex:0]floatValue];
        theRandomReleaseFactor = [[tmpArray objectAtIndex:1]floatValue];
    }else{
        theRandomAttackFactor = 0.007;
        theRandomReleaseFactor = 0.5;
    }
    theScore = [NSString stringWithFormat:@"i%d 0 3 %d %d %f %f\n",getTheInstrumentNumber,(int)theFragmentedNote,theVelocity, theRandomAttackFactor, theRandomReleaseFactor];
    [self.csound sendScore:theScore];
}

//6. RANDOM METHOD
-(void)getTheRandomSequence:(NSTimer*)theTimer{
    int theRandomNoteNumber;
    int theOctaveCoef;
    int theVelocity;
    float theRandomTime;
    double theRandomAttackFactor;
    double theRandomReleaseFactor;
    int getTheInstrumentNumber;
    NSString *theScore;
    //1. GET THE RANDOM NOTE + INSTRUMENT #
    theRandomNoteNumber = [self randomNoteNumberPickUp];
    getTheInstrumentNumber = (int)[[self.childViewControllers[0] instrumentNumber]integerValue];
    //2. GET HIGHER OCTAVE RANGE
    
    //3. GET VELOCITY
    if(velocityRandInstrument1 == TRUE){
        theVelocity = [self velocityPickUpForSliderNumber:1];
    }else{
        theVelocity = 100;
    }
    UILabel *theLabel = [self.envelopeDeviationLabels objectAtIndex:0];
    if([theLabel.text isEqualToString:@"ON"]){
        NSMutableArray *tmpArray = (NSMutableArray*)[[NSMutableArray alloc]initWithArray:[self getRandomEnvelope] copyItems:YES];
        theRandomAttackFactor = [[tmpArray objectAtIndex:0]floatValue];
        theRandomReleaseFactor = [[tmpArray objectAtIndex:1]floatValue];
    }else{
        if(getTheInstrumentNumber == 23){
            theRandomAttackFactor = 0.18;
            theRandomReleaseFactor = 0.18;
        }else{
            theRandomAttackFactor = 0.007;
            theRandomReleaseFactor = 0.5;
        }
    }
    theScore = [NSString stringWithFormat:@"i%d 0 3 %d %d %f %f\n",getTheInstrumentNumber,theRandomNoteNumber,theVelocity, theRandomAttackFactor, theRandomReleaseFactor];
    [self.csound sendScore:theScore];
    //4. GET RANDOM TIME
    theRandomTime = [self timePickUp];
    _randomTimer = [NSTimer scheduledTimerWithTimeInterval:theRandomTime target:self selector:@selector(getTheRandomSequence:) userInfo:nil repeats:NO];
}
//_______________________END OF DISTRIBUTION DEFINITION_______________________//

-(int)randomNoteNumberPickUp{
    int theNote;
    int theRand;
    switch (theRand) {
        case 4: theRand = 0; break;
        case 6: theRand = 0; break;
        default: theRand = arc4random_uniform(7); break;
    }
    
    theNote = (int)[[theScaleArray objectAtIndex:(theRand)]integerValue];
    return theNote;
}
-(float)frequencyPickup{
    int theFrequency;
    int rand = arc4random_uniform(7);
    theFrequency = (int)[[theScaleArray objectAtIndex:rand]integerValue];
    return theFrequency;
}
-(int)velocityPickUpForSliderNumber:(int)sliderNumber{
    int theFinalVelocity;
    int rand;
    int theRange;
    if(sliderNumber == 1){
    theRange = (self.velocityRangeSlider1.upperValue - self.velocityRangeSlider1.lowerValue);
        rand = arc4random_uniform(theRange);
    theFinalVelocity = rand + self.velocityRangeSlider1.lowerValue;
    }else if(sliderNumber == 2){
        theRange = (self.velocityRangeSlider2.upperValue - self.velocityRangeSlider2.lowerValue);
        rand = arc4random_uniform(theRange);
        theFinalVelocity = rand + self.velocityRangeSlider2.lowerValue;
    }
    
    return theFinalVelocity;
}
//!!!DEPRECATED!!!
-(float)timePickUp{
    float theTimeValue;
    int rand;
    
        rand = arc4random_uniform(5);
        rand += 3;
    switch(rand) {
        // 2x whole note
        case 0: theTimeValue = ((60.0/resultedTempo)*16.0);break;
        // whole note
        case 1: theTimeValue = ((60.0/resultedTempo)*8.0);break;
        // half note
        case 2: theTimeValue = ((60.0/resultedTempo)*4.0);break;
        // quarter note
        case 3: theTimeValue = ((60.0/resultedTempo)*2.0);break;
        // eight note
        case 4: theTimeValue = ((60.0/resultedTempo)*1.0);break;
        // sixteen note
        case 5: theTimeValue = ((60.0/resultedTempo)*0.5);break;
        // sixteen note
        case 6: theTimeValue = ((60.0/resultedTempo)*0.25);break;
        // 32th note
        case 7: theTimeValue = ((60.0/resultedTempo)*0.125);break;
            
        default:
            break;
    }
    return theTimeValue;
}

#pragma-mark __MIDI-Monitoring
-(void)updateMIDIMonitoringListForVelocity:(int)theVelocity andMidiNote:(int)theNoteNumber{
    theMIDIlabel.textColor = [UIColor blackColor];
    theVelocityLabel.textColor = [UIColor blackColor];
    theStringMIDINoteNumber = [NSString stringWithFormat:@"%d", theNoteNumber];
    theStringVelocity = [NSString stringWithFormat:@"%d", theVelocity];
    theMIDIlabel = [self.noteNumberMidiMonitor objectAtIndex:incrementerForArray];
    theVelocityLabel = [self.velocityMidiMonitor objectAtIndex:incrementerForArray];
    theMIDIlabel.text = theStringMIDINoteNumber;
    theVelocityLabel.text = theStringVelocity;
    theMIDIlabel.textColor = [UIColor redColor];
    theVelocityLabel.textColor = [UIColor redColor];
    incrementerForArray++;
    if(incrementerForArray > 7){
        incrementerForArray = 0;
    }
}

#pragma-mark __UI-updates/MiscViews
//ENVELOPE DELEGATE METHODS

-(void)kAttackAmp:(float)theAmp{
    //    [self.envelopeSiblings kAttackAmpSiblings:theAmp];
    _theAttackAmpProp = theAmp;
    if(theAmp < 0.05){
        theAmp = 0.0000;
    }
}
-(void)kAttackTime:(float)theTime{
    //    [self.envelopeSiblings kAttackTimeSiblings:theTime];
    _theAttackTimeProp = (theTime);
}
-(void)kDecayAmp:(float)theAmp{
    //    [self.envelopeSiblings kDecayAmpSiblings:theAmp];
    _theDecayAmpProp = theAmp;
    if(theAmp < 0.05){
        theAmp = 0.0000;
    }
}
-(void)kDecayTime:(float)theTime{
    //    [self.envelopeSiblings kDecayTimeSiblings:theTime];
    _theDecayTimeProp = (theTime);
}
-(void)kSustainAmp:(float)theAmp{
    //    [self.envelopeSiblings kSustainAmpSiblings:theAmp];
    _theSustainAmpProp = theAmp;
    if(theAmp < 0.05){
        theAmp = 0.0000;
    }
}
-(void)kReleaseTime:(float)theTime{
    //    [self.envelopeSiblings kReleaseTimeSiblings:theTime];
    _theReleaseTimeProp = (theTime);
}

//LFO
- (IBAction)changeLfo1:(UIButton *)sender {
    if(sender.tag == 0){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedLfo1 objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@YES forKey:@"hidden"];
        [[_unpushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@NO forKey:@"hidden"];
        [[_unpushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@YES forKey:@"enabled"];
        lfoWavetypePlayer = 0;
        
    }else if(sender.tag == 1){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedLfo1 objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@YES forKey:@"hidden"];
        [[_unpushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@NO forKey:@"hidden"];
        [[_unpushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@YES forKey:@"enabled"];
        lfoWavetypePlayer = 3;
    }else if(sender.tag == 2){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedLfo1 objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@YES forKey:@"hidden"];
        [[_unpushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@NO forKey:@"hidden"];
        [[_unpushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@YES forKey:@"enabled"];
        lfoWavetypePlayer = 1;
    }else if(sender.tag == 3){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedLfo1 objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@YES forKey:@"hidden"];
        [[_unpushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@NO forKey:@"hidden"];
        [[_unpushedLfo1 objectAtIndex:_lastButtonLFO]setValue:@YES forKey:@"enabled"];
        lfoWavetypePlayer = 4;
    }
    _lastButtonLFO = (int)sender.tag;
    
}

#pragma __Delegate method
-(void)lfoAmountChange1:(NSInteger)theAmount{
    _resultedAmount += (theAmount-_lastAmount);
    if(_resultedAmount <= 0.0){
        _resultedAmount = 0.0;
    }else if(_resultedAmount >= 100.0){
        _resultedAmount = 100.0;
    }
    _lfoAmount1Label.text = [NSString stringWithFormat:@"%d%%", (int)_resultedAmount];
    _lastAmount = (int)theAmount;
}

-(void)lfoAmountEnded1{
    _resultedAmount = (int)[_lfoAmount1Label.text integerValue];
    lfoAmountPlayer = (_resultedAmount/100.0);
    _lastAmount = 0;
}

-(void)lfoRateChange1:(NSInteger)theValue{
    _resultedRate += (theValue-_lastRate);
    if(_resultedRate <= 1.0){
        _resultedRate = 1.0;
    }else if(_resultedRate >= 200.0){
        _resultedRate = 200.0;
    }
    _lfoRate1Label.text = [NSString stringWithFormat:@"%dHz", (int)_resultedRate];
    _lastRate = (int)theValue;
}

-(void)lfoRateEnded1{
    _resultedRate = (int)[_lfoRate1Label.text integerValue];
    lfoRatePlayer = _resultedRate;
    _lastRate = 0;
}

-(void)getLfoDest:(NSNumber *)theDest{
    lfoDestinationNumberPlayer = (float)[theDest floatValue];

}

- (IBAction)lfoDestinationPopup:(UIButton *)sender {
    self.lfoDestinationPopup = [[UIPopoverController alloc]initWithContentViewController:self.lfoDestination];
    self.lfoDestinationPopup.popoverContentSize = CGSizeMake(150.0, 172.0);
    [self.lfoDestinationPopup presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
//FTABLE DELEGATE
- (IBAction)selectFtablePopup:(UIButton *)sender {
    self.selectFtablePopup = [[UIPopoverController alloc]initWithContentViewController:self.selectFtableInstace];
    self.selectFtablePopup.popoverContentSize = CGSizeMake(150.0, 172.0);
    [self.selectFtablePopup presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)getFtableNumber:(NSNumber *)theFtable{
    ftableNumberPlayer = (int)[theFtable integerValue];
}
//MIXER DELEGATE FOR SOURCE SOUND
- (IBAction)revealMixerPlayer:(UIButton *)sender {
    self.mixerlayerPopup = [[UIPopoverController alloc]initWithContentViewController:self.mixerPlayerInstance];
    self.mixerlayerPopup.popoverContentSize = CGSizeMake(350.0, 185.0);
    [self.mixerlayerPopup presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)VolumePlayer:(float)theValue{
    volumeAmountPlayer = theValue;
}
-(void)ReverbPlayer:(float)theValue{
    reverbSendAmountPlayer = theValue;
}
-(void)ChorusPlayer:(float)theValue{
    chorusSendAmountPlayer = theValue;
}
-(void)DelayPlayer:(float)theValue{
    delaySendAmountPlayer = theValue;
}
-(void)DistortionPlayer:(float)theValue{
    distoSendAmountPlayer = theValue;
}
//INSTRUMENT DESIGNER VIEWS + DELEGATES
- (IBAction)switchInstrumentDesign:(UIButton *)sender {
    
    if(sender.tag == 0){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedButtonDesign objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@YES forKey:@"hidden"];
        [[_unpshedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@NO forKey:@"hidden"];
        [[_unpshedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@YES forKey:@"enabled"];
    }else if(sender.tag == 1){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedButtonDesign objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@YES forKey:@"hidden"];
        [[_unpshedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@NO forKey:@"hidden"];
        [[_unpshedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@YES forKey:@"enabled"];
    }else if(sender.tag == 2){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedButtonDesign objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@YES forKey:@"hidden"];
        [[_unpshedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@NO forKey:@"hidden"];
        [[_unpshedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@YES forKey:@"enabled"];
    }else if(sender.tag == 3){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedButtonDesign objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@YES forKey:@"hidden"];
        [[_unpshedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@NO forKey:@"hidden"];
        [[_unpshedButtonDesign objectAtIndex:lastButtonInstrument]setValue:@YES forKey:@"enabled"];
    }
    lastButtonInstrument = (int)sender.tag;
}



- (IBAction)switchTracker:(UIButton *)sender {
    if(sender.tag == 0){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedTracker objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedTracker objectAtIndex:lastButtonTracker]setValue:@YES forKey:@"hidden"];
        [[_unpushedTracker objectAtIndex:lastButtonTracker]setValue:@NO forKey:@"hidden"];
        [[_unpushedTracker objectAtIndex:lastButtonTracker]setValue:@YES forKey:@"enabled"];
        trackerType = DOWNWARD;
    }else if(sender.tag == 1){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedTracker objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedTracker objectAtIndex:lastButtonTracker]setValue:@YES forKey:@"hidden"];
        [[_unpushedTracker objectAtIndex:lastButtonTracker]setValue:@NO forKey:@"hidden"];
        [[_unpushedTracker objectAtIndex:lastButtonTracker]setValue:@YES forKey:@"enabled"];
        trackerType = FORWARD;
    }else if(sender.tag == 2){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedTracker objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedTracker objectAtIndex:lastButtonTracker]setValue:@YES forKey:@"hidden"];
        [[_unpushedTracker objectAtIndex:lastButtonTracker]setValue:@NO forKey:@"hidden"];
        [[_unpushedTracker objectAtIndex:lastButtonTracker]setValue:@YES forKey:@"enabled"];
        trackerType = SNAKE;
    }else if(sender.tag == 3){
        sender.hidden = true;
        sender.enabled = false;
        [[_pushedTracker objectAtIndex:sender.tag]setValue:@NO forKey:@"hidden"];
        [[_pushedTracker objectAtIndex:lastButtonTracker]setValue:@YES forKey:@"hidden"];
        [[_unpushedTracker objectAtIndex:lastButtonTracker]setValue:@NO forKey:@"hidden"];
        [[_unpushedTracker objectAtIndex:lastButtonTracker]setValue:@YES forKey:@"enabled"];
        trackerType = SQUARE;
    }
    lastButtonTracker = (int)sender.tag;

}
#pragma __Scale+Mode_SelectView
//DEFINE THE SCALE
-(IBAction)SelectScale:(UIButton*)sender{
    self.selectScalePopup = [[UIPopoverController alloc]initWithContentViewController:self.selectScaleView];
    self.selectScalePopup.popoverContentSize = CGSizeMake(205.0, 317.0);
    [self.selectScalePopup presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    _selectScaleView.myScaleDelegate = self;
}
-(void)selectedScale:(NSString *)theScale{
    _scaleLabel.text = theScale;
    if([theScale isEqualToString:@"C"]){
        theStep = 48;
    }else if([theScale isEqualToString:@"D♭"]){
        theStep = 49;
    }else if([theScale isEqualToString:@"D"]){
        theStep = 50;
    }else if([theScale isEqualToString:@"E♭"]){
        theStep = 51;
    }else if([theScale isEqualToString:@"E"]){
        theStep = 52;
    }else if([theScale isEqualToString:@"F"]){
        theStep = 53;
    }else if([theScale isEqualToString:@"F♯"]){
        theStep = 54;
    }else if([theScale isEqualToString:@"G♭"]){
        theStep = 54;
    }else if([theScale isEqualToString:@"G"]){
        theStep = 55;
    }else if([theScale isEqualToString:@"A♭"]){
        theStep = 56;
    }else if([theScale isEqualToString:@"A"]){
        theStep = 57;
    }else if([theScale isEqualToString:@"B♭"]){
        theStep = 58;
    }else if([theScale isEqualToString:@"B"]){
        theStep = 59;
    }
    [self defineTheScaleArrayForTheKeyOf:theStep inTheMode:aMode];
}
- (IBAction)SelectMode:(UIButton *)sender {
    self.selectModePopup = [[UIPopoverController alloc]initWithContentViewController:self.selectModeView];
    self.selectModePopup.popoverContentSize = CGSizeMake(205.0, 317.0);
    [self.selectModePopup presentPopoverFromRect:sender.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    _selectModeView.myModeDelegate = self;
}
-(void)selectedMode:(NSString *)theMode{
    modeLabel.text = theMode;
    if([theMode isEqualToString:@"Ionian"]){
        aMode = 0;
    }else if([theMode isEqualToString:@"Dorian"]){
        aMode = 1;
    }else if([theMode isEqualToString:@"Phrygian"]){
        aMode = 2;
    }else if([theMode isEqualToString:@"Lydian"]){
        aMode = 3;
    }else if([theMode isEqualToString:@"Mixo."]){
        aMode = 4;
    }else if([theMode isEqualToString:@"Aeolian"]){
        aMode = 5;
    }else if([theMode isEqualToString:@"Locrian"]){
        aMode = 6;
    }

    [self defineTheScaleArrayForTheKeyOf:theStep inTheMode:aMode];
}

-(void)defineTheScaleArrayForTheKeyOf:(int)theKey inTheMode:(int)theMode{
    //TRANSPOSE
    root = theStep;
    [theScaleArray removeAllObjects];
    //SWITCHING MODES
    switch(theMode){
        //IONIAN (MAJOR)
        case 0: [theScaleArray addObjectsFromArray:@[[NSNumber numberWithInt:I],[NSNumber numberWithInt:II],[NSNumber numberWithInt:III],[NSNumber numberWithInt:IV],[NSNumber numberWithInt:V],[NSNumber numberWithInt:VI],[NSNumber numberWithInt:VII]]];break;
        //DORIAN (LOWERED 3TH, 7TH)
        case 1: [theScaleArray addObjectsFromArray:@[[NSNumber numberWithInt:I],[NSNumber numberWithInt:II],[NSNumber numberWithInt:bIII],[NSNumber numberWithInt:IV],[NSNumber numberWithInt:V],[NSNumber numberWithInt:VI],[NSNumber numberWithInt:bVII]]];break;
        //PHYGIAN (LOWERED 2ND, 3RD, 6TH, 7TH)
        case 2: [theScaleArray addObjectsFromArray:@[[NSNumber numberWithInt:I],[NSNumber numberWithInt:bII],[NSNumber numberWithInt:bIII],[NSNumber numberWithInt:IV],[NSNumber numberWithInt:V],[NSNumber numberWithInt:bVI],[NSNumber numberWithInt:bVII]]];break;
        //LYDIAN (RAISED 4TH)
        case 3: [theScaleArray addObjectsFromArray:@[[NSNumber numberWithInt:I],[NSNumber numberWithInt:II],[NSNumber numberWithInt:III],[NSNumber numberWithInt:sIV],[NSNumber numberWithInt:V],[NSNumber numberWithInt:VI],[NSNumber numberWithInt:VII]]];break;
        //MIXOLYDIAN (LOWERED 7TH)
        case 4: [theScaleArray addObjectsFromArray:@[[NSNumber numberWithInt:I],[NSNumber numberWithInt:II],[NSNumber numberWithInt:III],[NSNumber numberWithInt:IV],[NSNumber numberWithInt:V],[NSNumber numberWithInt:VI],[NSNumber numberWithInt:bVII]]];break;
        //AEOLIAN (LOWERED 3RD, 6TH, 7TH)
        case 5: [theScaleArray addObjectsFromArray:@[[NSNumber numberWithInt:I],[NSNumber numberWithInt:II],[NSNumber numberWithInt:bIII],[NSNumber numberWithInt:IV],[NSNumber numberWithInt:V],[NSNumber numberWithInt:bVI],[NSNumber numberWithInt:bVII]]];break;
        //LOCRIAN (LOWERED 2ND, 3RD, 5TH, 6TH, 7TH)
        case 6: [theScaleArray addObjectsFromArray:@[[NSNumber numberWithInt:I],[NSNumber numberWithInt:bII],[NSNumber numberWithInt:bIII],[NSNumber numberWithInt:IV],[NSNumber numberWithInt:bV],[NSNumber numberWithInt:bVI],[NSNumber numberWithInt:bVII]]];break;
    }
}
//DEFINE TEMPO
-(void)tempoChange:(NSInteger)theValue{
    resultedTempo += (theValue-lastTempo);
    if(resultedTempo <= 40){
        resultedTempo = 40;
    }else if(resultedTempo >= 240){
        resultedTempo = 240;
    }
    _tempoLabel.text = [NSString stringWithFormat:@"%d", resultedTempo];
    lastTempo = (int)theValue;
}
-(void)tempoTouchEnded{
    resultedTempo = (int)[_tempoLabel.text integerValue];
    lastTempo = 0;
    if(playRandom.hidden == true && stopRandom.hidden == false){
        [myTimerMetronome invalidate];
        myTimerMetronome = nil;
        [myTimerNoteGenerate invalidate];
        myTimerNoteGenerate = nil;
    myTimerMetronome = [NSTimer scheduledTimerWithTimeInterval:(60.0/resultedTempo) target:self selector:@selector(timeFiredForMetro:) userInfo:nil repeats:YES];
    [myTimerMetronome fire];
    }
    delayTime = ((60.0/resultedTempo)/3.0);
}

//DEFINE TIME SIGNATURE
-(void)timeSignatureChange:(NSInteger)theValue{
    theTimeSig += (int)(theValue-lastTimeSig);
    if(theTimeSig >= (-25)){
        theFinalTimeSig = 4;
    }else if(theTimeSig <= (-25) && theTimeSig > (-50)){
        theFinalTimeSig = 3;
    }else if(theTimeSig <= (-50) && theTimeSig > (-75)){
        theFinalTimeSig = 2;
    }else if(theTimeSig <= (-75)){
        theFinalTimeSig = 1;
    }
        _timeSignatureLabel.text = [NSString stringWithFormat:@"%d/4", theFinalTimeSig];
    lastTimeSig = (int)theValue;
}
-(void)timeSignatureEnded{
    lastTimeSig = 0;
}

#pragma-mark __matrix motion

-(void)updateLocaterPosition:(int)xCoordinate and:(int)yCoordinate{
    if(xCoordinate >= [[self.xLocations objectForKey:@"1"]integerValue] && xCoordinate < [[self.xLocations objectForKey:@"2"]integerValue]){
        _xPositionGrid.text = @"1";
    }else if(xCoordinate >= [[self.xLocations objectForKey:@"2"]integerValue] && xCoordinate < [[self.xLocations objectForKey:@"3"]integerValue]){
        _xPositionGrid.text = @"2";
    }else if(xCoordinate >= [[self.xLocations objectForKey:@"3"]integerValue] && xCoordinate < [[self.xLocations objectForKey:@"4"]integerValue]){
        _xPositionGrid.text = @"3";
    }else if(xCoordinate >= [[self.xLocations objectForKey:@"4"]integerValue] && xCoordinate < [[self.xLocations objectForKey:@"5"]integerValue]){
        _xPositionGrid.text = @"4";
    }else if(xCoordinate >= [[self.xLocations objectForKey:@"5"]integerValue] && xCoordinate < [[self.xLocations objectForKey:@"6"]integerValue]){
        _xPositionGrid.text = @"5";
    }else if(xCoordinate >= [[self.xLocations objectForKey:@"6"]integerValue] && xCoordinate < [[self.xLocations objectForKey:@"7"]integerValue]){
        _xPositionGrid.text = @"6";
    }else if(xCoordinate >= [[self.xLocations objectForKey:@"7"]integerValue] && xCoordinate < [[self.xLocations objectForKey:@"8"]integerValue]){
        _xPositionGrid.text = @"7";
    }else if(xCoordinate >= [[self.xLocations objectForKey:@"8"]integerValue]){
        _xPositionGrid.text = @"8";
    }
    
    if(yCoordinate >= [[self.yLocations objectForKey:@"A"]integerValue] && yCoordinate < [[self.yLocations objectForKey:@"B"]integerValue]){
        _yPositionGrid.text = @"A";
    }else if(yCoordinate >= [[self.yLocations objectForKey:@"B"]integerValue] && yCoordinate < [[self.yLocations objectForKey:@"C"]integerValue]){
        _yPositionGrid.text = @"B";
    }else if(yCoordinate >= [[self.yLocations objectForKey:@"C"]integerValue] && yCoordinate < [[self.yLocations objectForKey:@"D"]integerValue]){
        _yPositionGrid.text = @"C";
    }else if(yCoordinate >= [[self.yLocations objectForKey:@"D"]integerValue] && yCoordinate < [[self.yLocations objectForKey:@"E"]integerValue]){
        _yPositionGrid.text = @"D";
    }else if(yCoordinate >= [[self.yLocations objectForKey:@"E"]integerValue] && yCoordinate < [[self.yLocations objectForKey:@"F"]integerValue]){
        _yPositionGrid.text = @"E";
    }else if(yCoordinate >= [[self.yLocations objectForKey:@"F"]integerValue] && yCoordinate < [[self.yLocations objectForKey:@"G"]integerValue]){
        _yPositionGrid.text = @"F";
    }else if(yCoordinate >= [[self.yLocations objectForKey:@"G"]integerValue] && yCoordinate < [[self.yLocations objectForKey:@"H"]integerValue]){
        _yPositionGrid.text = @"G";
    }else if(yCoordinate >= [[self.yLocations objectForKey:@"H"]integerValue]){
        _yPositionGrid.text = @"H";
    }
    [xyPad truncateLocaterPosition:(int)[[self.xLocations objectForKey:_xPositionGrid.text]integerValue]and:(int)[[self.yLocations objectForKey:_yPositionGrid.text]integerValue]];
    
    //Find Variables values using the whole location
    _theWholeLocation = [NSString stringWithFormat:@"%@%@",_xPositionGrid.text, _yPositionGrid.text];
    
    [self RetrieveValuesAtTheLocation:_theWholeLocation];
    [self retrieveTheDistributionModeAtTheLocation:_theWholeLocation];
    [self retrieveOctaveRangesAtTheLocation:_theWholeLocation forOctaveRange:1];
    [self retrieveOctaveRangesAtTheLocation:_theWholeLocation forOctaveRange:2];
    [self retrieveEnvelopeDevAtTheLocation:_theWholeLocation forEnvelope:1];
    [self retrieveEnvelopeDevAtTheLocation:_theWholeLocation forEnvelope:2];
}

-(void)RetrieveValuesAtTheLocation:(NSString*)theLocation{
    NSString* valueNoteDensity1;
    int lowVelocityValue1;
    int highVelocityValue1;
    int lowVelocityValue2;
    int highVelocityValue2;
    //SET NOTE DENSITY SLIDERS
    valueNoteDensity1 = (NSString*)[self.NoteDensity1 objectForKey:theLocation];
    //TO DO: DO THIS FOR EVERY LABELS IN THE ARRAY
    [self setNoteDensityForLabel:0 andForString:valueNoteDensity1];
    
    //SET THE VELOCITY RANGES FOR SLIDER 1
    lowVelocityValue1 = (int)[[self.velocityRangeLow1 valueForKey:theLocation]integerValue];
    highVelocityValue1 = (int)[[self.velocityRangeHigh1 valueForKey:theLocation]integerValue];
    [self.velocityRangeSlider1 setLowerValue:lowVelocityValue1];
    [self.velocityRangeSlider1 setUpperValue:highVelocityValue1];
    [self setVelocityRangeLabels:lowVelocityValue1 andMaxValue:highVelocityValue1 forLabelNumber:0];
    
    //SET THE VELOCITY RANGES FOR SLIDER 2
    lowVelocityValue2 = (int)[[self.velocityRangeLow2 valueForKey:theLocation]integerValue];
    highVelocityValue2 = (int)[[self.velocityRangeHigh2 valueForKey:theLocation]integerValue];
    [self.velocityRangeSlider2 setLowerValue:lowVelocityValue2];
    [self.velocityRangeSlider2 setUpperValue:highVelocityValue2];
    [self setVelocityRangeLabels:lowVelocityValue2 andMaxValue:highVelocityValue2 forLabelNumber:1];
}

-(void)retrieveTheDistributionModeAtTheLocation:(NSString*)theLocation{
    NSString *theDistributionModeAtTheLocation = [self.distributionDictionary objectForKey:theLocation];
    
    if([theDistributionModeAtTheLocation isEqualToString:@"random"]){
        UIButton *theButtonToPush = [self.unpushedDistributionButtons objectAtIndex:0];
        [theButtonToPush sendActionsForControlEvents:UIControlEventTouchDown];
    }else if([theDistributionModeAtTheLocation isEqualToString:@"fractal"]){
        UIButton *theButtonToPush = [self.unpushedDistributionButtons objectAtIndex:1];
        [theButtonToPush sendActionsForControlEvents:UIControlEventTouchDown];
    }else if([theDistributionModeAtTheLocation isEqualToString:@"transp"]){
        UIButton *theButtonToPush = [self.unpushedDistributionButtons objectAtIndex:2];
        [theButtonToPush sendActionsForControlEvents:UIControlEventTouchDown];
    }else if([theDistributionModeAtTheLocation isEqualToString:@"phrase"]){
        UIButton *theButtonToPush = [self.unpushedDistributionButtons objectAtIndex:3];
        [theButtonToPush sendActionsForControlEvents:UIControlEventTouchDown];
    }else if([theDistributionModeAtTheLocation isEqualToString:@"arpeg"]){
        UIButton *theButtonToPush = [self.unpushedDistributionButtons objectAtIndex:4];
        [theButtonToPush sendActionsForControlEvents:UIControlEventTouchDown];
    }else if([theDistributionModeAtTheLocation isEqualToString:@"mirror"]){
        UIButton *theButtonToPush = [self.unpushedDistributionButtons objectAtIndex:5];
        [theButtonToPush sendActionsForControlEvents:UIControlEventTouchDown];
    }
}
-(void)retrieveOctaveRangesAtTheLocation:(NSString*)theLocation forOctaveRange:(int)octaveRangeNumber{
    
    if(octaveRangeNumber == 1){
        int theRetrieveOctaveCoef1 = (int)[[self.octaveRangeDictionary1 objectForKey:theLocation]integerValue];
        [[self.octaveRangeLabels objectAtIndex:0]setValue:[NSString stringWithFormat:@"%d", theRetrieveOctaveCoef1] forKey:@"text"];
    }else if(octaveRangeNumber == 2){
        int theRetrieveOctaveCoef2 = (int)[[self.octaveRangeDictionary2 objectForKey:theLocation]integerValue];
        [[self.octaveRangeLabels objectAtIndex:1]setValue:[NSString stringWithFormat:@"%d", theRetrieveOctaveCoef2] forKey:@"text"];
    }
}
-(void)retrieveEnvelopeDevAtTheLocation:(NSString*)theLocation forEnvelope:(int)envelopeNumber{

if(envelopeNumber == 1){
    UIButton *theOffButton = [self.envelopeDeviationoffButtons objectAtIndex:0];
    UIButton *theOnButton = [self.envelopeDeviationOnButtons objectAtIndex:0];
    NSString *envStatusStringFor1 = (NSString*)[self.envDeviationDictionary1 objectForKey:theLocation];
    UILabel *theCurrentStringState = [self.envelopeDeviationLabels objectAtIndex:0];
    
    if([envStatusStringFor1 isEqualToString:@"ON"] && envStatusStringFor1 != theCurrentStringState.text){
        theCurrentStringState.text = envStatusStringFor1;
        theOffButton.hidden = true;
        theOffButton.enabled = false;
        theOnButton.hidden = false;
        theOnButton.enabled = true;
    }else if([envStatusStringFor1 isEqualToString:@"OFF"] && envStatusStringFor1 != theCurrentStringState.text){
        theCurrentStringState.text = envStatusStringFor1;
        theOffButton.hidden = false;
        theOffButton.enabled = true;
        theOnButton.hidden = true;
        theOnButton.enabled = false;
    }
}else{
    UIButton *theOffButton = [self.envelopeDeviationoffButtons objectAtIndex:1];
    UIButton *theOnButton = [self.envelopeDeviationOnButtons objectAtIndex:1];
    NSString *envStatusStringFor1 = (NSString*)[self.envDeviationDictionary2 objectForKey:theLocation];
    UILabel *theCurrentStringState = [self.envelopeDeviationLabels objectAtIndex:1];
    
    if([envStatusStringFor1 isEqualToString:@"ON"] && envStatusStringFor1 != theCurrentStringState.text){
        theCurrentStringState.text = envStatusStringFor1;
        theOffButton.hidden = true;
        theOffButton.enabled = false;
        theOnButton.hidden = false;
        theOnButton.enabled = true;
    }else if([envStatusStringFor1 isEqualToString:@"OFF"] && envStatusStringFor1 != theCurrentStringState.text){
        theCurrentStringState.text = envStatusStringFor1;
        theOffButton.hidden = false;
        theOffButton.enabled = true;
        theOnButton.hidden = true;
        theOnButton.enabled = false;
        }
    }
}

-(void)updateMatrixLocaterWhenPlaying{
    int xPosition;
    int yPosition;
    xPosition = (int)[[self.xyLocationsArray objectAtIndex:m]integerValue];
    yPosition = (int)[[self.xyLocationsArray objectAtIndex:n]integerValue];
    [self updateLocaterPosition:xPosition and:yPosition];
    if(trackerType == DOWNWARD){
    n++;
    if(n >=8){
        n = 0;
        m++;
        if(m >= 8){
            m = 0;
            }
        }
    }else if(trackerType == FORWARD){
        m++;
        if(m >=8){
            m = 0;
            n++;
            if(n >= 8){
                n = 0;
            }
        }
    }else if(trackerType == SNAKE){
    if(m == 0 || m == 2 || m == 4 || m == 6){
        substractor = -1;
        n++;
        if(n >=8){
            m++;
        }
    }
    if(m == 1 || m == 3 || m == 5 || m == 7){
        substractor++;
        n = (7-substractor);
        if(n < 0){
            n = 0;
            m++;
            if(m >= 8){
                m = 0;
             }
          }
      }
   }else if(trackerType == SQUARE){
       if(n == 3 && m == 4){
           n = -1;
           m = 0;
           snakeComparator = 7;
           substractor2 = 0;
           substractor3 = 0;
           flag = 0;
       }
       //downward vertical segment
       if(flag == 0){
       n++;
       if(n >=snakeComparator){
           flag = 1;
         }
      //forward horizontal segment
      }else if(flag ==1){
           m++;
          if(m >=snakeComparator){
              flag = 2;
          }
      //upward vertical segment
      }if(flag ==2){
          substractor2++;
          n = (7-substractor2);
          if(n <= (0+(7-snakeComparator))){
              flag = 3;
          }
      //backward horizontal segment
      }if(flag ==3){
          substractor3++;
          m = (7-substractor3);
          if(m <= (7-(snakeComparator-1))){
              flag = 0;
              substractor2 = (7-snakeComparator);
              substractor3 = (7-snakeComparator);
              snakeComparator --;
          }
      }
   }
}

#pragma-mark __variables management
//1. VELOCITY RELATED
- (void)VelocityRange1Changed:(id)control
{
    int lowerValue = _velocityRangeSlider1.lowerValue;
    int upperValue = _velocityRangeSlider1.upperValue;
    NSString *theString = [NSString stringWithFormat:@"%d - %d", lowerValue,upperValue];
    [[self.velocityRangeLabel objectAtIndex:0]setValue:theString forKey:@"text"];
    
    [self.velocityRangeLow1 setObject:[NSNumber numberWithInt:lowerValue] forKey:_theWholeLocation];
    [self.velocityRangeHigh1 setObject:[NSNumber numberWithInt:upperValue] forKey:_theWholeLocation];
}
- (void)VelocityRange2Changed:(id)control
{
    int lowerValue = _velocityRangeSlider2.lowerValue;
    int upperValue = _velocityRangeSlider2.upperValue;
    NSString *theString = [NSString stringWithFormat:@"%d - %d", lowerValue, upperValue];
    [[self.velocityRangeLabel objectAtIndex:1]setValue:theString forKey:@"text"];
    
    [self.velocityRangeLow2 setObject:[NSNumber numberWithInt:lowerValue] forKey:_theWholeLocation];
    [self.velocityRangeHigh2 setObject:[NSNumber numberWithInt:upperValue] forKey:_theWholeLocation];
}

-(void)setVelocityRangeLabels:(int)AtMinValue andMaxValue:(int)MaxValue forLabelNumber:(int)labelNumber
{
    NSString *theString = [NSString stringWithFormat:@"%d - %d", AtMinValue, MaxValue];
    [[self.velocityRangeLabel objectAtIndex:labelNumber]setValue:theString forKey:@"text"];
}

- (void)updateState
{
    UIColor *sliderColor = [UIColor colorWithRed:74.0/255.0 green:93.0/255.0 blue:114.0/255.0 alpha:1.0];
    
    //TO DO: TRANSFER ALL THE SHIT FROM INIFRAME TO CUSTOM FUNCTION
    
    [self.velocityRangeSlider1 setMinimumValue:0];
    [self.velocityRangeSlider1 setMaximumValue:127];
    [self.velocityRangeSlider1 setLowerValue:40];
    [self.velocityRangeSlider1 setUpperValue:100];
    _velocityRangeSlider1.trackHighlightColour = sliderColor;
    _velocityRangeSlider1.curvaceousness = 0.1;
    
    [self.velocityRangeSlider2 setMinimumValue:0];
    [self.velocityRangeSlider2 setMaximumValue:127];
    [self.velocityRangeSlider2 setLowerValue:40];
    [self.velocityRangeSlider2 setUpperValue:100];
    _velocityRangeSlider2.trackHighlightColour = sliderColor;
    _velocityRangeSlider2.curvaceousness = 0.1;

}

- (IBAction)velocityRandOn:(UIButton *)sender {
    theTag = (int)sender.tag;
    UIButton *theOffButton = [self.velocityRandOffButtons objectAtIndex:theTag];
    UIButton *theOnButton = [self.velocityRandOnButtons objectAtIndex:theTag];
    if(theOnButton.hidden == true){
        theOnButton.hidden = false;
        theOnButton.enabled = true;
        theOffButton.hidden = true;
        theOffButton.enabled = false;
        [[self.velocityRandOnLabels objectAtIndex:theTag]setValue:@"ON" forKey:@"text"];
    }else if (theOnButton.hidden == false){
        theOnButton.hidden = true;
        theOnButton.enabled = false;
        theOffButton.hidden = false;
        theOffButton.enabled = true;
        [[self.velocityRandOnLabels objectAtIndex:theTag]setValue:@"OFF" forKey:@"text"];
    }
}

//2.ENVELOPE DEVIATION STUFF
- (IBAction)envelopeDeviationOn:(UIButton *)sender{
    theTag = (int)sender.tag;
    UIButton *theOffButton = [self.envelopeDeviationoffButtons objectAtIndex:theTag];
    UIButton *theOnButton = [self.envelopeDeviationOnButtons objectAtIndex:theTag];
    if(theOnButton.hidden == true){
        theOnButton.hidden = false;
        theOnButton.enabled = true;
        theOffButton.hidden = true;
        theOffButton.enabled = false;
        [[self.envelopeDeviationLabels objectAtIndex:theTag]setValue:@"ON" forKey:@"text"];
        if(theTag == 0){
            [self.envDeviationDictionary1 setValue:@"ON" forKey:self.theWholeLocation];
        }else{
            [self.envDeviationDictionary2 setValue:@"ON" forKey:self.theWholeLocation];
        }
    }else if (theOnButton.hidden == false){
        theOnButton.hidden = true;
        theOnButton.enabled = false;
        theOffButton.hidden = false;
        theOffButton.enabled = true;
        [[self.envelopeDeviationLabels objectAtIndex:theTag]setValue:@"OFF" forKey:@"text"];
        if(theTag == 0){
            [self.envDeviationDictionary1 setValue:@"OFF" forKey:self.theWholeLocation];
        }else{
            [self.envDeviationDictionary2 setValue:@"OFF" forKey:self.theWholeLocation];
        }
    }
}

//4. Octave Range Change
-(void)OctRange1Change:(NSInteger)theValue{
    theOctaveCoef1 += (int)(theValue-lastOctaveCoef1);
    if(theOctaveCoef1 >= 50){
        theFinalOctaveCoef1 = 4;
    }else if(theOctaveCoef1 >= 25 && theOctaveCoef1 < 50){
        theFinalOctaveCoef1 = 2;
    }else if(theOctaveCoef1 < 25){
        theFinalOctaveCoef1 = 0;
    }
    NSString *theCoef = [NSString stringWithFormat:@"%d", (theFinalOctaveCoef1)];
    [[self.octaveRangeLabels objectAtIndex:0]setValue:theCoef forKey:@"text"];
    lastOctaveCoef1= (int)theValue;
}
-(void)OctRange1Ended{
    lastOctaveCoef1 = 0;
    [self.octaveRangeDictionary1 setValue:[NSNumber numberWithInt:theFinalOctaveCoef1] forKey:self.theWholeLocation];
}
-(void)OctRange2Change:(NSInteger)theValue{
    theOctaveCoef2 += (int)(theValue-lastOctaveCoef2);
    if(theOctaveCoef2 >= 50){
        theFinalOctaveCoef2 = 4;
    }else if(theOctaveCoef2 >= 25 && theOctaveCoef2 < 50){
        theFinalOctaveCoef2 = 2;
    }else if(theOctaveCoef2 < 25){
        theFinalOctaveCoef2 = 0;
    }
    NSString *theCoef = [NSString stringWithFormat:@"%d", (theFinalOctaveCoef2)];
    [[self.octaveRangeLabels objectAtIndex:1]setValue:theCoef forKey:@"text"];
    lastOctaveCoef2= (int)theValue;
}
-(void)OctRange2Ended{
    lastOctaveCoef2 = 0;
    [self.octaveRangeDictionary2 setValue:[NSNumber numberWithInt:theFinalOctaveCoef2] forKey:self.theWholeLocation];
}
//5. CHANGE DENSITY
- (IBAction)changeDensity:(UIButton *)sender {
    UILabel* theLabel = [self.noteDensityLabels objectAtIndex:sender.tag];
    if([theLabel.text isEqualToString:@"1/3"]){
        [[self.noteDensityLabels objectAtIndex:sender.tag]setValue:@"1/2" forKey:@"text"];
    }else if([theLabel.text isEqualToString:@"1/2"]){
        [[self.noteDensityLabels objectAtIndex:sender.tag]setValue:@"1/1" forKey:@"text"];
    }else if([theLabel.text isEqualToString:@"1/1"]){
        [[self.noteDensityLabels objectAtIndex:sender.tag]setValue:@"1/3" forKey:@"text"];
    }
    if(sender.tag == 0){
        [self.NoteDensity1 setValue:(NSString*)theLabel.text forKey:self.theWholeLocation];
    }
}
-(void)setNoteDensityForLabel:(int)labelNumber andForString:(NSString*)theString{
    UILabel* theLabel = [self.noteDensityLabels objectAtIndex:labelNumber];
    theLabel.text = theString;
}

//6. DISTRIBUTION
- (IBAction)randomDistribution:(UIButton *)sender {
    UIButton *theUnpushedButton = [self.unpushedDistributionButtons objectAtIndex:0];
    UIButton *thePushedButton = [self.pushedDistributionButtons objectAtIndex:0];
    if(theUnpushedButton.hidden == false){
        sender.hidden = true;
        sender.enabled = false;
        thePushedButton.hidden = false;
        thePushedButton.enabled = true;
    }
    if(lastModeChosen != sender.tag){
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"hidden"];
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"enabled"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"hidden"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"enabled"];
    }
    lastModeChosen = 0;
    randomMode = true;
    fractalMode = false;
    transpMode = false;
    phraseMode = false;
    arpegMode = false;
    mirrorMode = false;
    [self.distributionDictionary setValue:@"random" forKey:self.theWholeLocation];
}

- (IBAction)fractalDistribution:(UIButton *)sender {
    UIButton *theUnpushedButton = [self.unpushedDistributionButtons objectAtIndex:1];
    UIButton *thePushedButton = [self.pushedDistributionButtons objectAtIndex:1];
    if(theUnpushedButton.hidden == false){
        sender.hidden = true;
        sender.enabled = false;
        thePushedButton.hidden = false;
        thePushedButton.enabled = true;
    }
    if(lastModeChosen != sender.tag){
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"hidden"];
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"enabled"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"hidden"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"enabled"];
    }
    lastModeChosen = 1;
    randomMode = false;
    fractalMode = true;
    transpMode = false;
    phraseMode = false;
    arpegMode = false;
    mirrorMode = false;
    [self.distributionDictionary setValue:@"fractal" forKey:self.theWholeLocation];
}

- (IBAction)transpositionDistribution:(UIButton *)sender {
    UIButton *theUnpushedButton = [self.unpushedDistributionButtons objectAtIndex:2];
    UIButton *thePushedButton = [self.pushedDistributionButtons objectAtIndex:2];
    if(theUnpushedButton.hidden == false){
        sender.hidden = true;
        sender.enabled = false;
        thePushedButton.hidden = false;
        thePushedButton.enabled = true;
    }
    if(lastModeChosen != sender.tag){
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"hidden"];
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"enabled"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"hidden"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"enabled"];
    }
    lastModeChosen = 2;
    randomMode = false;
    fractalMode = false;
    transpMode = true;
    phraseMode = false;
    arpegMode = false;
    mirrorMode = false;
    [self.distributionDictionary setValue:@"transp" forKey:self.theWholeLocation];
}

- (IBAction)phraseDistribution:(UIButton *)sender {
    UIButton *theUnpushedButton = [self.unpushedDistributionButtons objectAtIndex:3];
    UIButton *thePushedButton = [self.pushedDistributionButtons objectAtIndex:3];
    if(theUnpushedButton.hidden == false){
        sender.hidden = true;
        sender.enabled = false;
        thePushedButton.hidden = false;
        thePushedButton.enabled = true;
    }
    if(lastModeChosen != sender.tag){
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"hidden"];
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"enabled"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"hidden"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"enabled"];
    }
    lastModeChosen = 3;
    randomMode = false;
    fractalMode = false;
    transpMode = false;
    phraseMode = true;
    arpegMode = false;
    mirrorMode = false;
    [self.distributionDictionary setValue:@"phrase" forKey:self.theWholeLocation];
}

- (IBAction)arpegDsitribution:(UIButton *)sender {
    UIButton *theUnpushedButton = [self.unpushedDistributionButtons objectAtIndex:4];
    UIButton *thePushedButton = [self.pushedDistributionButtons objectAtIndex:4];
    if(theUnpushedButton.hidden == false){
        sender.hidden = true;
        sender.enabled = false;
        thePushedButton.hidden = false;
        thePushedButton.enabled = true;
    }
    if(lastModeChosen != sender.tag){
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"hidden"];
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"enabled"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"hidden"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"enabled"];
    }
    lastModeChosen = 4;
    randomMode = false;
    fractalMode = false;
    transpMode = false;
    phraseMode = false;
    arpegMode = true;
    mirrorMode = false;
    [self.distributionDictionary setValue:@"arpeg" forKey:self.theWholeLocation];
}

- (IBAction)mirrorDistribution:(UIButton *)sender {
    UIButton *theUnpushedButton = [self.unpushedDistributionButtons objectAtIndex:5];
    UIButton *thePushedButton = [self.pushedDistributionButtons objectAtIndex:5];
    if(theUnpushedButton.hidden == false){
        sender.hidden = true;
        sender.enabled = false;
        thePushedButton.hidden = false;
        thePushedButton.enabled = true;
    }
    if(lastModeChosen != sender.tag){
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"hidden"];
        [[self.unpushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"enabled"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@YES forKey:@"hidden"];
        [[self.pushedDistributionButtons objectAtIndex:lastModeChosen]setValue:@NO forKey:@"enabled"];
    }
    lastModeChosen = 5;
    randomMode = false;
    fractalMode = false;
    transpMode = false;
    phraseMode = false;
    arpegMode = false;
    mirrorMode = true;
    [self.distributionDictionary setValue:@"mirror" forKey:self.theWholeLocation];
    [myMelodyArray1 removeAllObjects];
}
////small temporary midi generator trigger
- (IBAction)generateMIDI:(UISwitch *)sender {
    int randNote = arc4random_uniform(12);
    randNote += 48;
    if(sender.on){
        //[self.csound sendScore:[NSString stringWithFormat:@"i98 0 6\n"]];
        [self.csound sendScore:[NSString stringWithFormat:@"i1 0 0.5 48 100\ni1 1 0.5 38 100\ni1 2.0 0.5 40 100\ni1 3.0 0.5 55 100\ni1 4.0 0.5 57 100\n"]];
        [self.csound sendScore:[NSString stringWithFormat:@"i1 5.0 0.5 108 100\n"]];
    }else{
        [self.csound sendScore:[NSString stringWithFormat:@"i97 0 0.1 98\ni97 0 0.1 1\n"]];
    }
}


#pragma-mark __memory-stuff
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
