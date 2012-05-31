//
//  MyPredatorPreyModel.h
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum _CellType {
    CTEmpty = 0,
    CTPrey = 1,
    CTPredator = 2
} CellType;


@interface MyPredatorPreyModel : NSObject
{
    @private
    //probA + probB + probC = 1
    float probabilityA; //probability of birth of prey
    float probabilityB; //probability of birth or predator and death of prey
    float probabilityC; //probability of death of predator
}

@property (nonatomic) CellType** grid;
@property (nonatomic) float probabilityA;
@property (nonatomic) float probabilityB;

- (id)initGridWithWidht:(int)width Height:(int)height;
- (void)nextIteration;

@end
