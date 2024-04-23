//
//  AI.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/12.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "AI.h"

@implementation AI

- (id)init{
    if([super init] == self){
        _presearch_depth = 5;
        _normal_depth = 7;
        _wld_depth = 16;
        _perfect_depth = 14;
        _thoughtDate = [NSDate date];
    }
    return self;
}

@end
