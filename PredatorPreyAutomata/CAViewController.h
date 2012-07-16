//
//  CAViewController.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CACellGridView.h"
#import "CAPlotView.h"

@interface CAViewController : NSViewController
{
}

@property (nonatomic, retain) IBOutlet CACellGridView *cellGridView;
@property (nonatomic, retain) IBOutlet CAPlotView *plotView;
@property (nonatomic, retain) IBOutlet NSSlider *simulationSpeedSlider;
@property (nonatomic, retain) IBOutlet NSSlider *preyBirthRateSlider;
@property (nonatomic, retain) IBOutlet NSSlider *predatorBirthRateSlider;
@property (nonatomic, retain) IBOutlet NSSlider *predatorDeathRateSlider;
@property (nonatomic, retain) IBOutlet NSTextField *generationTextField;
@property (nonatomic, retain) IBOutlet NSTextField *preyCountTextField;
@property (nonatomic, retain) IBOutlet NSTextField *predatorCountTextField;
@property (nonatomic, retain) IBOutlet NSTextField *preyBirthRateTextField;
@property (nonatomic, retain) IBOutlet NSTextField *predatorBirthRateTextField;
@property (nonatomic, retain) IBOutlet NSTextField *predatorDeathRateTextField;

-(IBAction)startAutomata:(id)sender;
-(IBAction)stopAutomata:(id)sender;
-(IBAction)resetAutomata:(id)sender;
-(IBAction)sliderChanged:(NSSlider*)sender;

@end
