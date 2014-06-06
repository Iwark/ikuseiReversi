//
//  PerfectEvaluator.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/13.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "PerfectEvaluator.h"

@implementation PerfectEvaluator

- (int)evaluate:(Board *)board
{
    int discdiff = [board getCurrentColor] * ( [board countDisc:BLACK] - [board countDisc:WHITE]);
    
    return discdiff;
}

@end
