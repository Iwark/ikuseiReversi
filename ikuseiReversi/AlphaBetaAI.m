//
//  AlphaBetaAI.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/12.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "AlphaBetaAI.h"

@implementation AlphaBetaAI

- (void)move:(Board*)board
{
    BookManager *book = [[BookManager alloc] init];
    NSMutableArray *movables = [book find:board];
    //打てる場所が無ければパス
    if([movables count]==0){
        [board pass];
        return;
    }
    //一カ所だけなら、そこへ打つ
    if([movables count]==1){
        Disc *disc = [movables objectAtIndex:0];
        [board move:disc];
        return;
    }
    Eval = [[MidEvaluator alloc] init];
    
    //手を良さそうな順番にソート
    [self sort:board movables:movables limit:self.presearch_depth];
    
    //探索する手数
    int limit;
    if(MAX_TURNS - [board getTurns] <= self.wld_depth){
        //NSLog(@"WLD");
        limit = MAX_VALUE;
        if(MAX_TURNS - [board getTurns] <= self.perfect_depth){ Eval = [[PerfectEvaluator alloc] init]; }
        else Eval = [[WLDEvaluator alloc] init];
    }
    else{
        limit = self.normal_depth;
        if([board getTurns] < 10) self.normal_depth = 6;
        else self.normal_depth = 5;
    }
    
    int eval, alpha = MIN_VALUE;
    int beta = MAX_VALUE;
    Disc *disc;
    
    //探索開始
    startDate = [NSDate date];
    for (unsigned i=0; i<[movables count]; i++){
        [board move:(Disc *)[movables objectAtIndex:i]];
        eval = -[self alphabeta:board limit:limit-1 alpha:-beta beta:-alpha];
        [board undo];
        
        if(eval > alpha){
            alpha = eval;
            disc = movables[i];
        }
        NSLog(@"candidates:%d",eval);
        if(alpha == 999998){ NSLog(@"勝ち決まり"); break; }
    }
    NSLog(@"%d",alpha);
    //探索終了
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
    NSLog(@"time is %lf (sec)", interval);
    
    Eval = nil;
    if(alpha==999998) board.winner = [board getCurrentColor];
    [board move:disc];
    self.thoughtDate = [NSDate date];
    NSLog(@"Trying to move... x:%d y:%d",disc.x-1,disc.y-1);
}

- (void)sort:(Board *)board movables:(NSMutableArray *)movables limit:(int)limit
{
    NSMutableArray *moves = [[NSMutableArray alloc] init];
    int eval;
    
    for (unsigned i=0; i<[movables count]; i++){
        Disc *disc = [movables objectAtIndex:i];
        //NSLog(@"sort movables[%d]:%d,%d",i,disc.x,disc.y);
        [board move:disc];
        eval = -[self alphabeta:board limit:limit-1 alpha:MIN_VALUE beta:MAX_VALUE];
        [board undo];
        
        Move *move = [[Move alloc] initWithEval:eval x:disc.x y:disc.y];
        [moves addObject:move];
    }
    //評価値の大きい順にソート
    NSSortDescriptor *sortDispNo = [[NSSortDescriptor alloc] initWithKey:@"eval" ascending:NO];
    NSArray *sortDescArray = [NSArray arrayWithObjects:sortDispNo, nil];
    [moves sortedArrayUsingDescriptors:sortDescArray];
    
    //結果の書き戻し
    movables = [[NSMutableArray alloc] init];
    for (unsigned i=0; i<[moves count]; i++){
        [movables addObject:[moves objectAtIndex:i]];
    }
    
    return;
    
}

- (int)alphabeta:(Board *)board limit:(int)limit alpha:(int)alpha beta:(int)beta
{
    //NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
    if([board isGameOver] || limit==0/* || interval>15*/) return [Eval evaluate:board];
    
    int score;
    NSMutableArray *movables = [board getMovablePos];
    if ([movables count]==0){
        [board pass];
        score = -[self alphabeta:board limit:limit alpha:-beta beta:-alpha];
        [board undo];
        return score;
    }
    for (unsigned i=0; i<[movables count]; i++){
        [board move:[movables objectAtIndex:i]];
        score = -[self alphabeta:board limit:limit-1 alpha:-beta beta:-alpha];
        [board undo];
        
        if (score >= beta) return score;
        
        alpha = MAX(alpha, score);
    }
    return alpha;
}

@end
