//
//  Move.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/12.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Move : NSObject

@property int x;
@property int y;
@property int eval;

-(id)initWithEval:(int)eval x:(int)x y:(int)y;


@end
