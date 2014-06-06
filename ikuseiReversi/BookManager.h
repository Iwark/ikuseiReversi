//
//  BookManager.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/22.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "CoordinatesTransformer.h"

@interface Node : NSObject

@property Node* child;
@property Node* sibling;
@property Disc* point;

@end

@interface BookManager : NSObject
{
    Node* Root;
}

- (NSMutableArray *)find:(Board*)board;

@end
