//
//  CoordinatesTransformer.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/17.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "CoordinatesTransformer.h"

@implementation CoordinatesTransformer

- (id)initWithFirst:(Disc *)first
{
    if([super init] == self){
        Rotate = 0;
        Mirror = false;
        
        if(first.x == 4 && first.y == 3){
            Rotate = 1;
            Mirror = true;
        }else if(first.x == 3 && first.y == 4){
            Rotate = 2;
        }else if(first.x == 5 && first.y == 6){
            Rotate = -1;
            Mirror = true;
        }
        
    }
    return self;
}

- (Disc *)normalize:(Disc *)point
{
    Disc *new_point = [self rotatePoint:point rotate:Rotate];
    if(Mirror) new_point = [self mirrorPoint:new_point];
    
    return new_point;
}

- (Disc *)denormalize:(Disc *)point
{
    Disc *new_point = [[Disc alloc] initWithColor:EMPTY x:point.x y:point.y];
    if(Mirror) new_point = [self mirrorPoint:new_point];
    
    new_point = [self rotatePoint:new_point rotate:-Rotate];
    
    return new_point;
}

- (Disc *)rotatePoint:(Disc *)old_point rotate:(int)rotate
{
    if(rotate < 0) rotate += 4;
    rotate %= 4;
    
    Disc *new_point = [[Disc alloc] initWithColor:EMPTY x:0 y:0];
    
    switch (rotate){
        case 1:
            new_point.x = old_point.y;
            new_point.y = BOARD_SIZE - old_point.x + 1;
            break;
        case 2:
            new_point.x = BOARD_SIZE - old_point.x + 1;
            new_point.y = BOARD_SIZE - old_point.y + 1;
            break;
        case 3:
            new_point.x = BOARD_SIZE - old_point.y + 1;
            new_point.y = old_point.x;
            break;
        default:
            new_point.x = old_point.x;
            new_point.y = old_point.y;
            break;
    }
    
    return new_point;
}

- (Disc *)mirrorPoint:(Disc *)point
{
    Disc *new_point = [[Disc alloc] initWithColor:EMPTY x:0 y:0];
    new_point.x = BOARD_SIZE - point.x + 1;
    new_point.y = point.y;
    
    return new_point;
}

@end
