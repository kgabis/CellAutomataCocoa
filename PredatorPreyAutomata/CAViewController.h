//
//  CAViewController.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CACellGridView.h"

@interface CAViewController : NSViewController
{
}

@property (nonatomic, retain) IBOutlet CACellGridView *cellGridView;
@property (nonatomic, retain) IBOutlet NSSlider *simulationSpeedSlider;
@property (nonatomic, retain) IBOutlet NSSlider *preyBirthRateSlider;
@property (nonatomic, retain) IBOutlet NSSlider *predatorBirthRateSlider;
@property (nonatomic, retain) IBOutlet NSSlider *predatorDeathRateSlider;

-(IBAction)startAutomata:(id)sender;
-(IBAction)stopAutomata:(id)sender;
-(IBAction)resetAutomata:(id)sender;
-(IBAction)sliderChanged:(NSSlider*)sender;

@end
