//
//  Disc.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/10.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Color型と定数の定義
typedef int Color;
const static Color EMPTY = 0;
const static Color WHITE = -1;
const static Color BLACK = 1;
const static Color WALL  = 2;

//  Discクラス
@interface Disc : NSObject

@property int x;
@property int y;
@property Color color;

-(id)initWithColor:(Color)color x:(int)x y:(int)y;
-(BOOL)equals:(Disc*)p;

@end
