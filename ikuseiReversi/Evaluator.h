//
//  Evaluator.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/12.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"

@interface Evaluator : NSObject

- (int)evaluate:(Board *)board;

@end
