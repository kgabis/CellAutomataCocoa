//
//  MyMainWindowViewController.h
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyCellGridView.h"

@interface MyController : NSViewController
{
    IBOutlet MyCellGridView *cellGridView;
    IBOutlet NSSlider *simulationSpeedSlider;
    IBOutlet NSSlider *preyBornSlider;
    IBOutlet NSSlider *predatorBornSlider;
}


-(IBAction)startAutomata:(id)sender;
-(IBAction)stopAutomata:(id)sender;
-(IBAction)resetAutomata:(id)sender;
-(IBAction)sliderChanged:(NSSlider*)sender;

@end
