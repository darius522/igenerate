//
//  DragValue.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/3/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TempoDrag <NSObject>
//tempo's transport delegates method
-(void)tempoChange:(NSInteger)theValue;
-(void)tempoTouchEnded;
@end
@protocol Lfo1AmountDrag <NSObject>
//tempo's transport delegates method
-(void)lfoAmountChange1:(NSInteger)theValue;
-(void)lfoAmountEnded1;
-(void)lfoRateChange1:(NSInteger)theValue;
-(void)lfoRateEnded1;
@end
@protocol TimeSignature <NSObject>
-(void)timeSignatureChange:(NSInteger)theValue;
-(void)timeSignatureEnded;
@end
@protocol FilterCutoff <NSObject>
-(void)CutoffChange:(NSInteger)theValue;
-(void)CutoffEnded;
@end
@protocol FilterQuality <NSObject>
-(void)QualityChange:(NSInteger)theValue;
-(void)QualityEnded;
@end
@protocol OctRangeInstr1 <NSObject>
-(void)OctRange1Change:(NSInteger)theValue;
-(void)OctRange1Ended;
@end
@protocol OctRangeInstr2 <NSObject>
-(void)OctRange2Change:(NSInteger)theValue;
-(void)OctRange2Ended;
@end
@protocol OctRangeInstr3 <NSObject>
-(void)OctRange3Change:(NSInteger)theValue;
-(void)OctRange3Ended;
@end
@protocol OctRangeInstr4 <NSObject>
-(void)OctRange4Change:(NSInteger)theValue;
-(void)OctRange4Ended;
@end
@interface DragValue : UIView

@property (nonatomic, weak) id<TempoDrag> valueDelegate;
@property (nonatomic, weak) id<Lfo1AmountDrag> lfo1Delegate;
@property (nonatomic, weak) id<TimeSignature> timeSignatureDelegate;
@property (nonatomic, weak) id<FilterCutoff> filterCutoffDelegate;
@property (nonatomic, weak) id<FilterQuality> filterQualityDelegate;
@property (nonatomic, weak) id<OctRangeInstr1>octaveRangeChange1Delegate;
@property (nonatomic, weak) id<OctRangeInstr2>octaveRangeChange2Delegate;
@property (nonatomic, weak) id<OctRangeInstr3>octaveRangeChange3Delegate;
@property (nonatomic, weak) id<OctRangeInstr4>octaveRangeChange4Delegate;
@property (nonatomic) int whatView;

@end
