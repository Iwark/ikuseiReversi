//
//  Move.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/12.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "Move.h"

@implementation Move

-(id)initWithEval:(int)eval x:(int)x y:(int)y
{
    if ([super init] == self){
        _x = x;
        _y = y;
        _eval = eval;
    }
    return self;
}

@end
