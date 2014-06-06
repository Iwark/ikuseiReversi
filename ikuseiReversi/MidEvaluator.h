//
//  MidEvaluator.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/13.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Evaluator.h"
#import "EdgeParam.h"

static const unsigned TABLE_SIZE = 6561;
static const int MIN_VALUE = -999999;

@interface MidEvaluator : Evaluator
{
    struct Weight EvalWeight;
}

- (int)evaluate:(Board *)board;

@end