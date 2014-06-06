//
//  MidEvaluator.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/13.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "MidEvaluator.h"

static bool TableInit = false;
static EdgeStat *EdgeTable[TABLE_SIZE];

@implementation MidEvaluator

- (id)init
{
    if([super init] == self){
        //初回起動時にテーブルを生成
        if(!TableInit){
            Color line[BOARD_SIZE];
            [self generateEdge:line index:0];
            
            TableInit = true;
        }
        
        //重み係数の設定
        EvalWeight.mobility_w = 67;
        EvalWeight.liberty_w  = -13;
        EvalWeight.stable_w   = 101;
        EvalWeight.wing_w     = -308;
        EvalWeight.Xmove_w    = -449;
        EvalWeight.Cmove_w    = -552;
    }
    return self;
}

- (int)evaluate:(Board *)board
{
    
    if([board countDisc:[board getCurrentColor]] == 0) return MIN_VALUE;
    
    int result;
    
    //辺の評価
    EdgeStat *edgestat = [[EdgeStat alloc] initWithObject:EdgeTable[[self idxTop:board]]];
    [edgestat add:EdgeTable[[self idxBottom:board]]];
    [edgestat add:EdgeTable[[self idxRight:board]]];
    [edgestat add:EdgeTable[[self idxLeft:board]]];
    
    //隅の評価
    CornerStat *cornerstat = [self evalCorner:board];
    
    
    //確定石に関して、隅の石を２回数えてしまっているので補正
    [edgestat get:BLACK].stable -= [cornerstat get:BLACK].corner;
    [edgestat get:WHITE].stable -= [cornerstat get:WHITE].corner;
    
    //パラメータの線形結合
    //NSLog(@"STABLE: %d vs %d * %d",[edgestat get:BLACK].stable,[edgestat get:WHITE].stable,EvalWeight.stable_w);
    //NSLog(@"WING: %d vs %d * %d",[edgestat get:BLACK].wing,[edgestat get:WHITE].wing,EvalWeight.wing_w);
    //NSLog(@"CMOVE: %d vs %d * %d",[edgestat get:BLACK].Cmove,[edgestat get:WHITE].Cmove,EvalWeight.Cmove_w);
    //NSLog(@"XMOVE: %d vs %d * %d",[cornerstat get:BLACK].Xmove,[cornerstat get:WHITE].Xmove,EvalWeight.Xmove_w);
    result = ([edgestat get:BLACK].stable - [edgestat get:WHITE].stable) * EvalWeight.stable_w
           + ([edgestat get:BLACK].wing - [edgestat get:WHITE].wing) * EvalWeight.wing_w
           + ([edgestat get:BLACK].Cmove - [edgestat get:WHITE].Cmove) * EvalWeight.Cmove_w
           + ([cornerstat get:BLACK].Xmove - [cornerstat get:WHITE].Xmove) * EvalWeight.Xmove_w;
    //NSLog(@"result[1]：%d",result);
    //開放度・着手可能手数の評価
    if(EvalWeight.liberty_w != 0){
        ColorStorage *liberty = [self countLiberty:board];
        result += ([liberty get:BLACK] - [liberty get:WHITE]) * EvalWeight.liberty_w;
    //    NSLog(@"LIBERTY: %d vs %d * %d",[liberty get:BLACK],[liberty get:WHITE],EvalWeight.liberty_w);
    }
    //NSLog(@"result[2]：%d",result);
    //現在の手番について、着手可能手数を調べる
    result += [board getCurrentColor] * [[board getMovablePos] count] * EvalWeight.mobility_w;
    //NSLog(@"CC:%d, gMP:%d * %d",[board getCurrentColor],[[board getMovablePos] count],EvalWeight.mobility_w);
    //NSLog(@"result[3]:%d",result);
    return [board getCurrentColor] * result;
}

- (void)generateEdge:(Color[])edge index:(unsigned)count
{
    if (count == BOARD_SIZE){
        //このパターンは完成したので、局面のカウント
        EdgeStat *stat = [[EdgeStat alloc] init];
        
        [[stat get:BLACK] set:[self evalEdge:edge color:BLACK]];
        [[stat get:WHITE] set:[self evalEdge:edge color:WHITE]];
        
        EdgeTable[[self idxLine:edge]] = stat;
        
        return;
        
    }
    
    //再帰的に全てのパターンを網羅
    edge[count] = EMPTY;
    [self generateEdge:edge index:count+1];
    
    edge[count] = BLACK;
    [self generateEdge:edge index:count+1];

    edge[count] = WHITE;
    [self generateEdge:edge index:count+1];

    return;
}

//辺のパラメータを数える
- (EdgeParam *)evalEdge:(Color[])line color:(Color)color
{
    EdgeParam *edgeparam = [[EdgeParam alloc] init];
    
    unsigned x;
    
    //ウイング等のカウント
    if (line[0] == EMPTY && line[7] == EMPTY){
        x = 2;
        while ( x <= 5 ){
            if (line[x] != color) break;
            x++;
        }
        //少なくともブロックが出来ている
        if(x == 6){
            if( line[1] == color && line[6] == EMPTY ) edgeparam.wing = 1;
            else if( line[1] == EMPTY && line[6] == color ) edgeparam.wing = 1;
            else if( line[1] == color && line[6] == color ) edgeparam.mountain = 1;
        }
        //それ以外の場合、隅に隣接する位置に置いていたら
        else{
            if(line[1] == color) edgeparam.Cmove++;
            if(line[6] == color) edgeparam.Cmove++;
        }
    }
    
    //確定石のカウント
    for(x = 0; x < 8; x++){
        if(line[x] != color) break;
        edgeparam.stable++;
    }
    if(edgeparam.stable < 8){
        for(x = 7; x > 0; x--){
            if(line[x] != color) break;
            edgeparam.stable++;
        }
    }
    
    return edgeparam;
}

- (CornerStat *)evalCorner:(Board *)board
{
    CornerStat *cornerstat = [[CornerStat alloc] init];
    [cornerstat get:BLACK].corner = 0;
    [cornerstat get:BLACK].Xmove = 0;
    [cornerstat get:WHITE].corner = 0;
    [cornerstat get:WHITE].Xmove = 0;
    
    Disc *disc = [[Disc alloc] initWithColor:EMPTY x:0 y:0];
    
    //左上
    disc.x = 1; disc.y = 1;
    [cornerstat get:[board getColor:disc]].corner++;
    if([board getColor:disc] == EMPTY){
        disc.x++; disc.y++;
        [cornerstat get:[board getColor:disc]].Xmove++;
    }
    
    //左下
    disc.x = 1; disc.y = 8;
    [cornerstat get:[board getColor:disc]].corner++;
    if([board getColor:disc] == EMPTY){
        disc.x++; disc.y--;
        [cornerstat get:[board getColor:disc]].Xmove++;
    }
    
    //右上
    disc.x = 8; disc.y = 1;
    [cornerstat get:[board getColor:disc]].corner++;
    if([board getColor:disc] == EMPTY){
        disc.x--; disc.y++;
        [cornerstat get:[board getColor:disc]].Xmove++;
    }
    
    //右下
    disc.x = 8; disc.y = 8;
    [cornerstat get:[board getColor:disc]].corner++;
    if([board getColor:disc] == EMPTY){
        disc.x--; disc.y--;
        [cornerstat get:[board getColor:disc]].Xmove++;
    }
    
    return cornerstat;
}

- (unsigned)idxTop:(Board *)board
{
    unsigned index = 0;
    unsigned val = 2187;
    
    for(int x=1;x<=BOARD_SIZE;x++){
        Disc *disc = [[Disc alloc] initWithColor:EMPTY x:x y:1];
        index += val * ([board getColor:disc]+1);
        val = val / 3;
    }

    return index;
}

- (unsigned)idxBottom:(Board *)board
{
    unsigned index = 0;
    unsigned val = 2187;
    
    for(int x=1;x<=BOARD_SIZE;x++){
        Disc *disc = [[Disc alloc] initWithColor:EMPTY x:x y:BOARD_SIZE];
        index += val * ([board getColor:disc]+1);
        val = val / 3;
    }
    
    return index;
}

- (unsigned)idxRight:(Board *)board
{
    unsigned index = 0;
    unsigned val = 2187;
    
    for(int y=1;y<=BOARD_SIZE;y++){
        Disc *disc = [[Disc alloc] initWithColor:EMPTY x:BOARD_SIZE y:y];
        index += val * ([board getColor:disc]+1);
        val = val / 3;
    }
    
    return index;
}

- (unsigned)idxLeft:(Board *)board
{
    unsigned index = 0;
    unsigned val = 2187;
    
    for(int y=1;y<=BOARD_SIZE;y++){
        Disc *disc = [[Disc alloc] initWithColor:EMPTY x:1 y:y];
        index += val * ([board getColor:disc]+1);
        val = val / 3;
    }
    
    return index;
}

- (ColorStorage *)countLiberty:(Board *)board
{
    ColorStorage *liberty = [[ColorStorage alloc] init];
    [liberty set:BLACK value:0];
    [liberty set:WHITE value:0];
    [liberty set:EMPTY value:0];
    
    for(unsigned int x=1; x<=BOARD_SIZE; x++){
        for(unsigned int y=1; y<=BOARD_SIZE; y++){
            Disc *disc = [[Disc alloc] initWithColor:EMPTY x:x y:y];
            Color color = [board getColor:disc];
            [liberty set:color value:[liberty get:color]+[board getLiberty:disc]];
        }
    }
    
    return liberty;
}

- (unsigned)idxLine:(Color[])l
{
    return 3*(3*(3*(3*(3*(3*(3*(l[0]+1)+l[1]+1)+l[2]+1)+l[3]+1)+l[4]+1)+l[5]+1)+l[6]+1)+l[7]+1;
}
@end
