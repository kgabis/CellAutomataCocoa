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
-(void)restartAutomata:(id)sender
{
    NSRect oldBounds = cellGridView.bounds;
//    cellGridView = [[MyCellGridView alloc] initWithFrame:oldBounds];
    [cellGridView setNeedsDisplay:YES];
}
@end
