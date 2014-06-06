//
//  WLDEvaluator.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/13.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "WLDEvaluator.h"

@implementation WLDEvaluator

- (int)evaluate:(Board *)board
{
    int discdiff = [board getCurrentColor] * ( [board countDisc:BLACK] - [board countDisc:WHITE]);
    if(discdiff > 0) return WIN;
    else if(discdiff < 0) return LOSE;
    else return DRAW;
}

@end
