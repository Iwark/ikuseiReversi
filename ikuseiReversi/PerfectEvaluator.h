//
//  PerfectEvaluator.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/13.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Evaluator.h"

@interface PerfectEvaluator : Evaluator

- (int)evaluate:(Board *)board;

@end
