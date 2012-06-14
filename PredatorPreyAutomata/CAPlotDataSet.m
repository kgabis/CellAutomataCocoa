//
//  CAPlotDataSet.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 14.06.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CAPlotDataSet.h"

enum {
    CABufferSize = 1024
};

@interface CAPlotDataSet ()

@end

@implementation CAPlotDataSet
{
    int *_buffer;
    int *_values;
    int _bufferOffset;
    int _length;
    NSColor *_color;
    int _max;
    int _min;
}
@synthesize values = _values;
@synthesize length = _length;
@synthesize color = _color;
@synthesize max;
@synthesize min;

-(id)init
{
    self = [super init];
    if (self) {
        _buffer = (int*)calloc(sizeof(int), CABufferSize);
        _values = _buffer;
    }
    return self;
}

-(void)addValue:(int)value
{
    if (_length == (CABufferSize / 2 )) {
        _values[_length] = value;
        _values++;
        _bufferOffset++;
        if (_bufferOffset == (CABufferSize / 2)) {
            memmove(_buffer, _values, _length * sizeof(int));
            _values = _buffer;
            _bufferOffset = 0;
        }
    }
    else {

        _values[_length] = value;
        _length++;
    }
    
}

-(void)clear
{
    free(_buffer);
    _buffer = (int*)calloc(sizeof(int), CABufferSize);
    _values = _buffer;
    _bufferOffset = 0;
    _length = 0;
}

-(int)max
{
    int tempMax = 0;
    for (int i = 0; i < _length; i++) {
        tempMax = MAX(tempMax, _values[i]);
    }
    return tempMax;
}

-(int)min
{
    int tempMin = 0;
    for (int i = 0; i < _length; i++) {
        tempMin = MIN(tempMin, _values[i]);
    }
    return tempMin;
}

-(void)dealloc
{
    free(_buffer);
}

@end
