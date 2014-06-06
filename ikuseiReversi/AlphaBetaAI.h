//
//  AlphaBetaAI.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/12.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move.h"
#import "AI.h"
#import "PerfectEvaluator.h"
#import "WLDEvaluator.h"
#import "MidEvaluator.h"
#import "BookManager.h"

#define MAX_VALUE 999999   //十分大きな数
#define MIN_VALUE -999999   //十分小さな数

@interface AlphaBetaAI : AI
{
    Evaluator *Eval;
    NSDate *startDate;
}

- (void)move:(Board*)board;

@end
