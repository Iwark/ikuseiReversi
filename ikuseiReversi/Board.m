//
//  Board.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/10.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "Board.h"

@implementation Board

- (id)init
{
    if(self == [super init]){
        [self initGame];
    }
    return self;
}

//  discで指定された座標にdisc.colorの色の石が打てるか。
- (unsigned)checkMobility:(Disc *)disc
{
    if(RawBoard[disc.x][disc.y] != EMPTY) return NONE;
    
    int x, y;
    unsigned dir = NONE;
    
    //上方向
    if(RawBoard[disc.x][disc.y-1] == -disc.color){
        x = disc.x; y = disc.y-2;
        while (RawBoard[x][y] == -disc.color) { y--; }
        if (RawBoard[x][y] == disc.color) dir |= UPPER;
    }
    
    //下方向
    if(RawBoard[disc.x][disc.y+1] == -disc.color){
        x = disc.x; y = disc.y+2;
        while (RawBoard[x][y] == -disc.color) { y++; }
        if (RawBoard[x][y] == disc.color) dir |= LOWER;
    }
    
    //左方向
    if(RawBoard[disc.x-1][disc.y] == -disc.color){
        x = disc.x-2; y = disc.y;
        while (RawBoard[x][y] == -disc.color) { x--; }
        if (RawBoard[x][y] == disc.color) dir |= LEFT;
    }
    
    //右方向
    if(RawBoard[disc.x+1][disc.y] == -disc.color){
        x = disc.x+2; y = disc.y;
        while (RawBoard[x][y] == -disc.color) { x++; }
        if (RawBoard[x][y] == disc.color) dir |= RIGHT;
    }
    
    //右上方向
    if(RawBoard[disc.x+1][disc.y-1] == -disc.color){
        x = disc.x+2; y = disc.y-2;
        while (RawBoard[x][y] == -disc.color) { x++; y--; }
        if (RawBoard[x][y] == disc.color) dir |= UPPER_RIGHT;
    }
    
    //右下方向
    if(RawBoard[disc.x+1][disc.y+1] == -disc.color){
        x = disc.x+2; y = disc.y+2;
        while (RawBoard[x][y] == -disc.color) { x++; y++; }
        if (RawBoard[x][y] == disc.color) dir |= LOWER_RIGHT;
    }
    
    //左上方向
    if(RawBoard[disc.x-1][disc.y-1] == -disc.color){
        x = disc.x-2; y = disc.y-2;
        while (RawBoard[x][y] == -disc.color) { x--; y--; }
        if (RawBoard[x][y] == disc.color) dir |= UPPER_LEFT;
    }
    
    //左下方向
    if(RawBoard[disc.x-1][disc.y+1] == -disc.color){
        x = disc.x-2; y = disc.y+2;
        while (RawBoard[x][y] == -disc.color) { x--; y++; }
        if (RawBoard[x][y] == disc.color) dir |= LOWER_LEFT;
    }
    
    return dir;
}

- (bool)move:(Disc*)disc
{
    //NSLog(@"Trying to move... x:%d y:%d",disc.x,disc.y);
    
    //石が打てるか
    if (disc.x <= 0 || disc.x > BOARD_SIZE) return false;
    if (disc.y <= 0 || disc.y > BOARD_SIZE) return false;
    if (MovableDir[Turns][disc.x][disc.y] == NONE) return false;
    
    [self flipDiscs:disc];
    
    //開放度
    for(int x=-1; x<=1; x++){
        for(int y=-1; y<=1; y++){
            Liberty[disc.x+x][disc.y+y]--;
        }
    }
    Liberty[disc.x][disc.y]++;
    
    Turns++;
    currentColor = -currentColor;
    
    [self initMovable];
    
    return true;
}

- (void)flipDiscs:(Disc*)disc
{
    int x, y;
    
    int dir = MovableDir[Turns][disc.x][disc.y];
    
    NSMutableArray *update = [[NSMutableArray alloc] init];
    
    RawBoard[disc.x][disc.y] = currentColor;
    
    Disc *operation = [[Disc alloc] initWithColor:currentColor x:disc.x y:disc.y];
    [update addObject:operation];
    
    //上に置ける
    if (dir & UPPER){
        y = disc.y;
        while(RawBoard[disc.x][--y] == -currentColor){
            RawBoard[disc.x][y] = currentColor;
            operation = [[Disc alloc] initWithColor:currentColor x:disc.x y:y];
            [update addObject:operation];
        }
    }
    
    //下に置ける
    if (dir & LOWER){
        y = disc.y;
        while(RawBoard[disc.x][++y] == -currentColor){
            RawBoard[disc.x][y] = currentColor;
            operation = [[Disc alloc] initWithColor:currentColor x:disc.x y:y];
            [update addObject:operation];
        }
    }
    
    //右に置ける
    if (dir & RIGHT){
        x = disc.x;
        while(RawBoard[++x][disc.y] == -currentColor){
            RawBoard[x][disc.y] = currentColor;
            operation = [[Disc alloc] initWithColor:currentColor x:x y:disc.y];
            [update addObject:operation];
        }
    }
    
    //左に置ける
    if (dir & LEFT){
        x = disc.x;
        while(RawBoard[--x][disc.y] == -currentColor){
            RawBoard[x][disc.y] = currentColor;
            operation = [[Disc alloc] initWithColor:currentColor x:x y:disc.y];
            [update addObject:operation];
        }
    }
    
    //左上に置ける
    if (dir & UPPER_LEFT){
        x = disc.x;
        y = disc.y;
        while(RawBoard[--x][--y] == -currentColor){
            RawBoard[x][y] = currentColor;
            operation = [[Disc alloc] initWithColor:currentColor x:x y:y];
            [update addObject:operation];
        }
    }
    
    //右上に置ける
    if (dir & UPPER_RIGHT){
        x = disc.x;
        y = disc.y;
        while(RawBoard[++x][--y] == -currentColor){
            RawBoard[x][y] = currentColor;
            operation = [[Disc alloc] initWithColor:currentColor x:x y:y];
            [update addObject:operation];
        }
    }
    
    //左下に置ける
    if (dir & LOWER_LEFT){
        x = disc.x;
        y = disc.y;
        while(RawBoard[--x][++y] == -currentColor){
            RawBoard[x][y] = currentColor;
            operation = [[Disc alloc] initWithColor:currentColor x:x y:y];
            [update addObject:operation];
        }
    }
    
    //右下に置ける
    if (dir & LOWER_RIGHT){
        x = disc.x;
        y = disc.y;
        while(RawBoard[++x][++y] == -currentColor){
            RawBoard[x][y] = currentColor;
            operation = [[Disc alloc] initWithColor:currentColor x:x y:y];
            [update addObject:operation];
        }
    }
    
    //石数の更新
    int discdiff = [update count];
    [Discs set:currentColor value:[Discs get:currentColor] + discdiff];
    [Discs set:-currentColor value:[Discs get:-currentColor] - discdiff + 1];
    [Discs set:EMPTY value:[Discs get:EMPTY] - 1];
    
    [updateLog addObject:update];
}

//置ける場所
- (void)initMovable
{
    int dir;
    
    MovablePos[Turns] = nil;
    MovablePos[Turns] = [[NSMutableArray alloc] init];
    for(int x=1; x<=BOARD_SIZE; x++){
        for(int y=1; y<=BOARD_SIZE; y++){
            Disc *disc = [[Disc alloc] initWithColor:currentColor x:x y:y];
            dir = [self checkMobility:disc];
            if(dir != NONE){
                [MovablePos[Turns] addObject:disc];
            }
            MovableDir[Turns][x][y] = dir;
        }
    }
}

//ゲーム終了の判定
- (bool)isGameOver
{
    if(Turns == MAX_TURNS) return true;
    
    if([MovablePos[Turns] count] != 0) return false;
    
    Disc *disc = [[Disc alloc] initWithColor:-currentColor x:0 y:0];
    for(int x=1;x<=BOARD_SIZE;x++){
        disc.x = x;
        for(int y=1;y<=BOARD_SIZE;y++){
            disc.y = y;
            if([self checkMobility:disc] != NONE) return false;
        }
    }
    
    return true;
}

//パス
- (bool)pass
{
    //if([MovablePos[Turns] count] != 0) return false;
    
    if([self isGameOver]) return false;
    
    currentColor = -currentColor;
    
    [updateLog addObject:[[NSMutableArray alloc] init]];
    
    [self initMovable];
    
    return true;
}

//undo
- (bool)undo
{
    if(Turns == 0) return false;
    
    currentColor = -currentColor;
    NSMutableArray *update = [updateLog lastObject];
    
    //前回がパスだった場合
    if([update count] == 0){
        //NSLog(@"前回はパス");
        MovablePos[Turns] = [[NSMutableArray alloc] init];
        for(unsigned x=1; x<=BOARD_SIZE; x++){
            for(unsigned y=1; y<=BOARD_SIZE; y++){
                MovableDir[Turns][x][y] = NONE;
            }
        }
    }else{
        
        Turns--;
        
        Disc *disc = [update objectAtIndex:0];
        RawBoard[disc.x][disc.y] = EMPTY;
        for(unsigned i=1; i<[update count]; i++){
            Disc *disc = [update objectAtIndex:i];
            RawBoard[disc.x][disc.y] = -currentColor;
        }
        
        //開放度
        for(int x=-1; x<=1; x++){
            for(int y=-1; y<=1; y++){
                Liberty[disc.x+x][disc.y+y]++;
            }
        }
        Liberty[disc.x][disc.y]--;
        
        //石数の更新
        unsigned discdiff = [update count];
        [Discs set:currentColor value:[Discs get:currentColor] - discdiff];
        [Discs set:-currentColor value:[Discs get:-currentColor] + discdiff - 1];
        [Discs set:EMPTY value:[Discs get:EMPTY] + 1];
    }
    
    [updateLog removeLastObject];
    
    return true;
}

- (void)initGame
{
    //全てのマスを空きマスに
    for(int x=1;x<=BOARD_SIZE;x++){
        for(int y=1;y<=BOARD_SIZE;y++){
            RawBoard[x][y] = EMPTY;
        }
    }
    
    //壁の設定
    for(int y=0;y<BOARD_SIZE+2;y++){
        RawBoard[0][y] = WALL;
        RawBoard[BOARD_SIZE+1][y] = WALL;
    }
    for(int x=0;x<BOARD_SIZE+2;x++){
        RawBoard[x][0] = WALL;
        RawBoard[x][BOARD_SIZE+1] = WALL;
    }
    
    //初期配置
    RawBoard[4][4] = WHITE;
    RawBoard[5][5] = WHITE;
    RawBoard[4][5] = BLACK;
    RawBoard[5][4] = BLACK;
    
    //石数の設定
    Discs = [[ColorStorage alloc] init];
    [Discs set:BLACK value:2];
    [Discs set:WHITE value:2];
    [Discs set:EMPTY value:BOARD_SIZE*BOARD_SIZE-4];

    Turns = 0;              //手数
    currentColor = BLACK;   //先手

    self.winner = EMPTY;
    
    //開放度
    for(int x=1; x<=BOARD_SIZE; x++){
        for(int y=1; y<=BOARD_SIZE; y++){
            Liberty[x][y]=8;
        }
    }
    for(int x=-1; x<=1; x++){
        for(int y=-1; y<=1; y++){
            Liberty[4+x][4+y]--;
            Liberty[5+x][5+y]--;
            Liberty[4+x][5+y]--;
            Liberty[5+x][4+y]--;
        }
    }
    Liberty[4][4]++;
    Liberty[5][5]++;
    Liberty[4][5]++;
    Liberty[5][4]++;
    
    //ログの初期化・配置可能位置の更新
    updateLog = [[NSMutableArray alloc] init];
    [self initMovable];
    
}

- (unsigned)countDisc:(Color)color
{
    return [Discs get:color];
}

- (Color)getColor:(Disc *)disc
{
    return RawBoard[disc.x][disc.y];
}

- (NSMutableArray *)getMovablePos
{
    return MovablePos[Turns];
}

- (NSMutableArray *)getUpdate
{
    if([updateLog count] == 0) return [[NSMutableArray alloc] init];
    else return [updateLog lastObject];
}

- (int)getCurrentColor
{
    return currentColor;
}

- (unsigned)getTurns
{
    return Turns;
}

/*- (void)setTurns:(unsigned)turn
{
    Turns = turn;
}*/

- (int)getLiberty:(Disc *)disc
{
    return Liberty[disc.x][disc.y];
}

// これまでに打たれてきた手を並べた配列を返す
- (NSMutableArray *)getHistory
{
    NSMutableArray *history = [[NSMutableArray alloc] init];
    
    for(unsigned i=0; i<[updateLog count]; i++){
        NSMutableArray *update = updateLog[i];
        if([update count]==0) continue;
        [history addObject:update[0]];
    }
    return history;
}

@end