//
//  AI.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/12.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"

@interface AI : NSObject
{
}
@property NSDate *thoughtDate; //考え終わった時間
@property unsigned presearch_depth; //事前に探索順序を決める先読み手数
@property unsigned normal_depth;    //序盤・中盤の先読み手数
@property unsigned wld_depth;       //必勝読みを始める残り手数
@property unsigned perfect_depth;   //完全読みを始める残り手数

- (id)init;
//- (void)move:(Board *)board;

@end
