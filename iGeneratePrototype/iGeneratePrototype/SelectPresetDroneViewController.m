//
//  SelectPresetDroneViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/28/15.
//  Copyright © 2015 com.DariusPetermann. All rights reserved.
//
#define DRONE_1 (31)
#define DRONE_2 (32)
#define DRONE_3 (33)

#import "SelectPresetDroneViewController.h"

@interface SelectPresetDroneViewController ()

@end

@implementation SelectPresetDroneViewController
@synthesize presetDroneDelegate, presetDroneNumber, presetDroneTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma __UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    static NSString *identifier = @"identifier";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    switch(indexPath.row){
        case 0: cell.textLabel.text = @"Drone 1"; break;
        case 1: cell.textLabel.text = @"Drone 2"; break;
        case 2: cell.textLabel.text = @"Drone 3"; break;
    }
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:166.0/255.0 blue:168.0/255.0 alpha:1.0]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Greek" size:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch(indexPath.row){
        case 0: presetDroneNumber = [NSNumber numberWithInt:DRONE_1]; break;
        case 1: presetDroneNumber = [NSNumber numberWithInt:DRONE_2]; break;
        case 2: presetDroneNumber = [NSNumber numberWithInt:DRONE_3]; break;
    }
    [self.presetDroneDelegate getInstrumentDroneNumber:presetDroneNumber];
}
@end
