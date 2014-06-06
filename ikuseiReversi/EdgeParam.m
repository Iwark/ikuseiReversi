//
//  EdgeParam.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/13.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "EdgeParam.h"

@implementation EdgeParam

- (id)init
{
    if([super init] == self){
        self.stable = 0;
        self.wing = 0;
        self.mountain = 0;
        self.Cmove = 0;
    }
    return self;
}

- (id)add:(EdgeParam *)src
{
    self.stable += src.stable;
    self.wing += src.wing;
    self.mountain += src.mountain;
    self.Cmove += src.Cmove;
    return self;
}

- (void)undo:(EdgeParam *)src
{
    self.stable -= src.stable;
    self.wing -= src.wing;
    self.mountain -= src.mountain;
    self.Cmove -= src.Cmove;
}

- (void)set:(EdgeParam *)e
{
    self.stable = e.stable;
    self.wing = e.wing;
    self.mountain = e.mountain;
    self.Cmove = e.Cmove;
}

@end


@implementation EdgeStat

- (EdgeParam *)get:(int)color
{
    return data[color+1];
}

- (void)add:(EdgeStat *)e
{
    for(int i=0; i<3; i++) [data[i] add:[e get:i-1]];
}

- (void)undo:(EdgeStat *)e
{
    for(int i=0; i<3; i++) [data[i] undo:[e get:i-1]];
}

- (id)init
{
    if([super init]==self){
        for(int i=0; i<3; i++) data[i] = [[EdgeParam alloc] init];
    }
    return self;
}

- (id)initWithObject:(EdgeStat *)e
{
    if([super init]==self){
        for(int i=0; i<3; i++){
            EdgeParam *edgeparam = [e get:i-1];
            EdgeParam *new_edgeparam = [[EdgeParam alloc] init];
            [new_edgeparam set:edgeparam];
            data[i] = new_edgeparam;
        }
    }
    return self;
}

@end


@implementation CornerParam

@end


@implementation CornerStat

- (CornerParam *)get:(int)color
{
    return data[color+1];
}

- (id)init
{
    if([super init]==self){
        for(int i=0; i<3; i++){
            data[i] = [[CornerParam alloc] init];
        }
    }
    return self;
}

@end