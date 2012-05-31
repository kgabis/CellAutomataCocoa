//
//  MyMainWindowViewController.m
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import "MyController.h"

@implementation MyController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)resetAutomata:(id)sender
{
    
}

-(void)startAutomata:(id)sender
{
    
}

-(void)stopAutomata:(id)sender
{
    
}

-(void)sliderChanged:(NSSlider *)sender
{
    if (sender == self->simulationSpeedSlider) {
        
    }
    else if (sender == self->preyBornSlider) {
        
    }
    else if (sender == self->predatorBornSlider) {
        
    }
}

@end
