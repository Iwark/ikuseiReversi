//
//  ColorStorage.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/11.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "ColorStorage.h"

@implementation ColorStorage

- (int)get:(int)color
{
    return data[color+1];
}

- (void)set:(int)color value:(int)value
{
    data[color+1] = value;
}

@end
