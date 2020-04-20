//
//  SelectPresetInstrumentViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/21/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//
//INSTRUMENT DEFINITION
#define PLUCK   (0)
#define MARIMBA (1)
#define FLUTE   (2)
#define BELL    (3)

#import "SelectPresetInstrumentViewController.h"

@interface SelectPresetInstrumentViewController ()

@end

@implementation SelectPresetInstrumentViewController
@synthesize presetNumber, presetTableView, presetInstrumentDelegate;

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
    return 4;
    
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
        case 0: cell.textLabel.text = @"Pluck"; break;
        case 1: cell.textLabel.text = @"Marimba"; break;
        case 2: cell.textLabel.text = @"Flute"; break;
        case 3: cell.textLabel.text = @"Bell"; break;
    }
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:166.0/255.0 blue:168.0/255.0 alpha:1.0]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Greek" size:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch(indexPath.row){
        case 0: presetNumber = [NSNumber numberWithInt:PLUCK]; break;
        case 1: presetNumber = [NSNumber numberWithInt:MARIMBA]; break;
        case 2: presetNumber = [NSNumber numberWithInt:FLUTE]; break;
        case 3: presetNumber = [NSNumber numberWithInt:BELL]; break;
    }
    [self.presetInstrumentDelegate getInstrumentNumber:presetNumber];
}

@end
