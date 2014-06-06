//
//  CoordinatesTransformer.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/17.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"

@interface CoordinatesTransformer : NSObject
{
    int Rotate;
    bool Mirror;
}

- (id)initWithFirst:(Disc *)first;
- (Disc *)normalize:(Disc *)point;
- (Disc *)denormalize:(Disc *)point;

@end
