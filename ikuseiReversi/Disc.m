//
//  Disc.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/10.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "Disc.h"

@implementation Disc

-(id)initWithColor:(Color)color x:(int)x y:(int)y
{
    if ([super init] == self){
        _x = x;
        _y = y;
        _color = color;
    }
    return self;
}

-(BOOL)equals:(Disc*)p
{
    if(self.x != p.x) return false;
    if(self.y != p.y) return false;
    return true;
}

@end
