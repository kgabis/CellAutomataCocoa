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
}


-(IBAction)restartAutomata:(id)sender;
@end
