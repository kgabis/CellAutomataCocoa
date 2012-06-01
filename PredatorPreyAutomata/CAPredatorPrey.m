//
//  MyPredatorPreyModel.m
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import "CAPredatorPrey.h"

@interface CAPredatorPrey ()

- (void) populateGrid;
- (void) freeGrid:(CellType**)grid;
- (CellType**) allocGrid;
- (float) calculateCoefOf:(CellType)type inArray:(CellType*)array withLen:(int)len;

@end

@implementation CAPredatorPrey 
{
    int _width, _height;
    CellType **_grid, **_newGrid;
    //probA + probB + probC = 1
    float _probabilityA; //probability of birth of prey
    float _probabilityB; //probability of birth or predator and death of prey
    float _probabilityC; //probability of death of predator

}

@synthesize grid = _grid;
@synthesize isIsotropic;

@synthesize probabilityA = _probabilityA;
-(void)setProbabilityA:(float)probA
{
    self->_probabilityA = probA;
    _probabilityC = 1.0f - _probabilityA - _probabilityB;
}

@synthesize probabilityB = _probabilityB;
-(void)setProbabilityB:(float)probB
{
    self->_probabilityB = probB;
    _probabilityC = 1.0f - _probabilityA - _probabilityB;
}


-(id)initWithWidth:(int)width Height:(int)height
{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        [self populateGrid];        
    }
    return self;
}


-(void)nextIteration
{
    
    CellType middle = CTEmpty;
    CellType neighbors[4];
    float neighborPreyCoef, neighborPredatorCoef;
    float r;
    int tempIndex; // To wrap array
    
    for (int y = 0; y < _height; y++) {
        for (int x = 0; x < _width; x++) {
            
            middle = _grid[y][x];
            neighbors[0] = _grid[(y + 1) % _height][x]; //above
            neighbors[1] = _grid[y][(x + 1) % _width]; //right
            
            if (isIsotropic) {
                tempIndex = y == 0 ? _height - 1 : y - 1;            
                neighbors[2] = _grid[tempIndex][x]; //below
                tempIndex = x == 0 ? _width - 1 : x - 1;
                neighbors[3] = _grid[y][tempIndex]; //left
                
                neighborPreyCoef = [self calculateCoefOf:CTPrey 
                                                 inArray:neighbors 
                                                 withLen:4];
                neighborPredatorCoef = [self calculateCoefOf:CTPredator
                                                     inArray:neighbors 
                                                     withLen:4];
            }
            else {
                neighborPreyCoef = [self calculateCoefOf:CTPrey 
                                                 inArray:neighbors 
                                                 withLen:2];
                neighborPredatorCoef = [self calculateCoefOf:CTPredator
                                                     inArray:neighbors 
                                                     withLen:2];
            }
            
            r = (float)(arc4random() % 100) / 100.0f;
            
            if (middle == CTEmpty) {
                if (r < (_probabilityA * neighborPreyCoef)) {
                    _newGrid[y][x] = CTPrey;
                }
                else {
                    _newGrid[y][x] = middle;
                }
            }
            else if (middle == CTPrey) {
                if (r < (_probabilityB * neighborPreyCoef)) {
                    _newGrid[y][x] = CTPredator;
                }
                else {
                    _newGrid[y][x] = middle;
                }
            }
            else if (middle == CTPredator) {
                if (r < _probabilityC) {
                    _newGrid[y][x] = CTEmpty;
                }
                else {
                    _newGrid[y][x] = middle;
                }
            }
            else {
                _newGrid[y][x] = middle;
            }
        }
    }
    CellType** toSwap = _grid;
    _grid = _newGrid;
    _newGrid = toSwap;
}

-(void)populateGrid
{
    [self freeGrid:_grid];
    [self freeGrid:_newGrid];
    
    _grid = [self allocGrid];
    _newGrid = [self allocGrid];
    
    for (int y = 0; y < _height; y++) {
        for (int x = 0; x < _width; x++) {
            int r = arc4random() % 100;
            CellType newCell = CTEmpty;
            if (r < 1) {
                newCell = CTPredator;
            }
            else if (r >= 1 && r < 2) {
                newCell = CTPrey;
            }
            else {
                newCell = CTEmpty;
            }
            _grid[y][x] = newCell;
        }
    }
}

-(float)calculateCoefOf:(CellType)type inArray:(CellType *)array withLen:(int)len
{
    int count = 0;
    for (int i = 0; i < len; i++) {
        array[i] == type ? count++ : count;
    }
    return (float)count / (float)len;
}

-(CellType**)allocGrid
{
    CellType **grid;
    grid = (CellType**)malloc(_width * sizeof(CellType*));
    for (int i = 0; i < _width; i++) {
        grid[i] = (CellType*) malloc(_height * sizeof(CellType));
        for (int j = 0; j < _height; j++) {
            grid[i][j] = CTEmpty;
        }
    }
    

    return grid;
}

-(void)freeGrid:(CellType**)grid
{
    if (grid != NULL) {
        for (int i = 0; i < _width; i++) {
            if (grid[i] != NULL) {
                free(grid[i]);
            }
        }
        free(grid);
    }
}

-(void)dealloc
{
    [self freeGrid:_grid];
    [self freeGrid:_newGrid];
}


@end
