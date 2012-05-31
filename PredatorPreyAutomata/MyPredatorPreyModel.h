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
    //probA + probB + probC = 1
    float probA; //probability of birth of prey
    float probB; //probability of birth or predator and death of prey
    float probC; //probability of death of predator
}

- (id)initGridWithWidht:(int)width Height:(int)height;
- (void)nextIteration;
@property (nonatomic) CellType** grid;

@end
