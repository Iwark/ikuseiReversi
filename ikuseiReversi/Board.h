//
//  Board.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/10.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Disc.h"
#import "ColorStorage.h"

//  盤面のサイズ
const static int BOARD_SIZE = 8;

const static int MAX_TURNS = BOARD_SIZE*BOARD_SIZE-4;

@interface Board : NSObject
{
    enum Direction
    {
        NONE = 0,
        UPPER = 1,
        UPPER_LEFT = 2,
        LEFT = 4,
        LOWER_LEFT = 8,
        LOWER = 16,
        LOWER_RIGHT = 32,
        RIGHT = 64,
        UPPER_RIGHT = 128
    };
    
    Color RawBoard[BOARD_SIZE+2][BOARD_SIZE+2];
    unsigned Turns;
    Color currentColor;
    NSMutableArray *updateLog;
    NSMutableArray *MovablePos[MAX_TURNS+1];
    unsigned MovableDir[MAX_TURNS+1][BOARD_SIZE+2][BOARD_SIZE+2];
    ColorStorage *Discs;
    
    int Liberty[BOARD_SIZE+2][BOARD_SIZE+2];
}

@property Color winner;

- (bool)move:(Disc*)disc;
- (bool)pass;
- (bool)undo;
- (void)initGame;
- (bool)isGameOver;
- (Color)getColor:(Disc *)disc;
- (unsigned)countDisc:(Color)color;
- (Color)getCurrentColor;
- (NSMutableArray *)getUpdate;
- (NSMutableArray *)getMovablePos;
- (unsigned)getTurns;
//- (void)setTurns:(unsigned)turn;
- (int)getLiberty:(Disc *)disc;
- (NSMutableArray *)getHistory;

@end