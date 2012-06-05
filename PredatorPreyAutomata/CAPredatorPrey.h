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

@property (nonatomic) CellGrid cellGrid;
@property (nonatomic) float probabilityA;
@property (nonatomic) float probabilityB;
@property (nonatomic) float probabilityC;
@property (nonatomic) BOOL isIsotropic;

- (id)initWithWidth:(int)width Height:(int)height;
- (void)nextIteration;

@end
