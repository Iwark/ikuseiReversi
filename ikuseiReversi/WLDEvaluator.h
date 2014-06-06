//
//  WLDEvaluator.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/13.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Evaluator.h"

static const int WIN  =  999998;
static const int DRAW =  0;
static const int LOSE = -999998;

@interface WLDEvaluator : Evaluator
{
    bool win_flag;
}
- (int)evaluate:(Board *)board;

@end
