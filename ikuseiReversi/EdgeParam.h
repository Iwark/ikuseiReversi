//
//  EdgeParam.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/13.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EdgeParam : NSObject

@property short stable;     //確定石の個数
@property short wing;       //ウイングの個数
@property short mountain;   //山の個数
@property short Cmove;      //危険なC打ちの個数

- (id)add:(EdgeParam *)src;
- (void)undo:(EdgeParam *)e;
- (void)set:(EdgeParam *)e;

@end


//重み係数
struct Weight{
    int mobility_w;
    int liberty_w;
    int stable_w;
    int wing_w;
    int Xmove_w;
    int Cmove_w;
};


@interface EdgeStat : NSObject
{
    EdgeParam *data[3];
}

- (EdgeParam *)get:(int)color;
- (void)add:(EdgeStat *)e;
- (void)undo:(EdgeStat *)e;
- (id)initWithObject:(EdgeStat *)e;

@end


@interface CornerParam : NSObject

@property short corner;   //隅にある石の数
@property short Xmove;    //危険なX打ちの数

@end


@interface CornerStat : NSObject
{
    CornerParam *data[3];
}

- (CornerParam *)get:(int)color;

@end

