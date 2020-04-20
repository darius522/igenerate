//
//  SelectPresetInstrumentViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/21/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectPresetInstrumentDelegate <NSObject>
-(void)getInstrumentNumber:(NSNumber*)theInstrument;
@end

@interface SelectPresetInstrumentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *presetTableView;
@property (retain,nonatomic) NSNumber* presetNumber;
@property (weak, nonatomic) id<SelectPresetInstrumentDelegate>presetInstrumentDelegate;
@end
