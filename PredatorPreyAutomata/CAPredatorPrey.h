//
//  MyPredatorPreyModel.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum _CellType {
    CTEmpty = 0,
    CTPrey = 1,
    CTPredator = 2
} CellType;


@interface CAPredatorPrey : NSObject
{
}

@property (nonatomic) CellType** grid;
@property (nonatomic) float probabilityA;
@property (nonatomic) float probabilityB;
@property (nonatomic) BOOL isIsotropic;

- (id)initWithWidth:(int)width Height:(int)height;
- (void)nextIteration;

@end
