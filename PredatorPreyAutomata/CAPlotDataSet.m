//
//  CAPlotDataSet.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 14.06.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CAPlotDataSet.h"

enum {
    CABufferStartingSize = 1024,
    CAVisibleValuesRange = 256
};

@interface CAPlotDataSet ()

@end

@implementation CAPlotDataSet
{
    int *_buffer;
    int _bufferSize;
    int *_visibleValues;
    int _visibleLength;
    int _length;
    NSColor *_color;
    int _max;
    int _min;
}
@synthesize visibleValues = _visibleValues;
@synthesize visibleLength = _visibleLength;
@synthesize values = _buffer;
@synthesize length = _length;
@synthesize color = _color;
@synthesize max;
@synthesize min;

-(id)init
{
    self = [super init];
    if (self) {
        _buffer = (int*)calloc(sizeof(int), CABufferStartingSize);
        _visibleValues = _buffer;
        _bufferSize = CABufferStartingSize;
    }
    return self;
}

-(void)addValue:(int)value
{
    if (_length == _bufferSize) {
        int valuesOffset = _visibleValues - _buffer;
        _bufferSize = 2 * _bufferSize;        
        _buffer = (int*) realloc(_buffer, _bufferSize * sizeof(int));
        assert(_buffer != NULL);
        _visibleValues = _buffer + valuesOffset;        
    }
            
    if (_visibleLength == CAVisibleValuesRange) {
        _visibleValues[_visibleLength] = value;
        _visibleValues++;
    }
    else {
        _visibleValues[_visibleLength] = value;
        _visibleLength++;
    }
    _length++;   
}

-(void)clear
{
    free(_buffer);
    _buffer = (int*)calloc(sizeof(int), CABufferStartingSize);
    _visibleValues = _buffer;
    _visibleLength = 0;
}

-(int)max
{
    int tempMax = 0;
    for (int i = 0; i < _visibleLength; i++) {
        tempMax = MAX(tempMax, _visibleValues[i]);
    }
    return tempMax;
}

-(int)min
{
    int tempMin = 0;
    for (int i = 0; i < _visibleLength; i++) {
        tempMin = MIN(tempMin, _visibleValues[i]);
    }
    return tempMin;
}

-(void)dealloc
{
    free(_buffer);
}

@end
