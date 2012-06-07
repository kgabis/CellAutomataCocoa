//
//  MyPredatorPreyModel.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CACellularAutomata.h"

typedef enum _CellType {
    CTEmpty = 0,
    CTPrey = 1,
    CTPredator = 2
} CellType;


@interface CAPredatorPrey : NSObject <CACellularAutomata>
{
}

@property (readonly) CellGrid cellGrid;
@property float probabilityA;
@property float probabilityB;
@property float probabilityC;
@property (readonly) int totalCellCount;
@property (readonly) int preyCellCount;
@property (readonly) int predatorCellCount;

- (id)initWithWidth:(int)width Height:(int)height;
- (void)nextIteration;

@end
