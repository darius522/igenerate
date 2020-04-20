//
//  SelectMode.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/3/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "SelectMode.h"

@interface SelectMode ()

@end

@implementation SelectMode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma __UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 7;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString* title = @"Choose A Mode";

    return title;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    static NSString *identifier = @"identifier";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
        switch(indexPath.row){
            case 0: cell.textLabel.text = @"Ionian";break;
            case 1: cell.textLabel.text = @"Dorian";break;
            case 2: cell.textLabel.text = @"Phrygian";break;
            case 3: cell.textLabel.text = @"Lydian";break;
            case 4: cell.textLabel.text = @"Mixo.";break;
            case 5: cell.textLabel.text = @"Aeolian";break;
            case 6: cell.textLabel.text = @"Locrian";break;
    }
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    [cell.contentView setBackgroundColor:[UIColor grayColor]];
    cell.textLabel.font = [UIFont fontWithName:@"Greek" size:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* theCell = [tableView cellForRowAtIndexPath:indexPath];
    [self.myModeDelegate selectedMode:theCell.textLabel.text];
}

@end
