//
//  CellGridView.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CAPredatorPrey.h"
#import "CACellularAutomata.h"

typedef struct _ColorMap {
    NSColor * __autoreleasing * colors;
    unsigned int length;
} ColorMap;

@interface CACellGridView : NSView
{
}

@property CellGrid cellGrid;
@property ColorMap colorMap;

@end
