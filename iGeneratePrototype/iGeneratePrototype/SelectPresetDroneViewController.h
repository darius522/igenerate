//
//  SelectPresetDroneViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/28/15.
//  Copyright © 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectPresetDroneDelegate <NSObject>
-(void)getInstrumentDroneNumber:(NSNumber*)theInstrument;
@end

@interface SelectPresetDroneViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *presetDroneTableView;
@property (retain,nonatomic) NSNumber* presetDroneNumber;
@property (weak, nonatomic) id<SelectPresetDroneDelegate>presetDroneDelegate;
@end