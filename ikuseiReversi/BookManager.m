//
//  BookManager.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/22.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "BookManager.h"

@implementation Node

- (id)init
{
    if([super init] == self){
        self.child = NULL;
        self.sibling = NULL;
    }
    return self;
}

@end

@implementation BookManager

- (NSMutableArray *)find:(Board*)board
{
    Node *node = Root;
    NSMutableArray *history = [board getHistory];
    if([history count] == 0) return [board getMovablePos];
    
    Disc *first = history[0];
    CoordinatesTransformer *transformer = [[CoordinatesTransformer alloc] initWithFirst:first];
    
    //座標を変換して(6,5)から始まるようにする。
    NSMutableArray *normalized = [[NSMutableArray alloc] init];
    for(int i=0; i<[history count]; i++){
        [normalized addObject:[transformer normalize:history[i]]];
    }
    
    //現在までの棋譜リストと定石の対応を取る
    for(int i=1; i<[normalized count]; i++){
        Disc *p = normalized[i];
        
        node = node.child;
        while(node != NULL){
            if([node.point equals:p]) break;
            node = node.sibling;
        }
        if(node == NULL){
            //定石を外れている
            return [board getMovablePos];
        }
    }
    
    //履歴と定石の終わりが一致していた場合
    if(node.child == NULL) return [board getMovablePos];
    
    NSMutableArray *next_moves = [self getNextMoves:node];
    NSMutableArray *denormalized = [[NSMutableArray alloc] init];
    
    //座標を元の形に変換する
    for(int i=0; i<[next_moves count]; i++){
        [denormalized addObject:[transformer denormalize:[next_moves objectAtIndex:i]]];
    }
    
    return denormalized;
}

- (NSMutableArray*)getNextMoves:(Node*)node
{
    NSMutableArray *candidates = [[NSMutableArray alloc] init];
    for(Node *p = node.child; p != NULL; p=p.sibling){
        [candidates addObject:p.point];
    }
    for(int i=0; i<[candidates count];i++){
        Disc *point = [candidates objectAtIndex:i];
        NSLog(@"(%d,%d)",point.x,point.y);
    }
    return candidates;
}

- (id)init
{
    if([super init] == self){
        
        Root = [[Node alloc] init];
        Root.point = [[Disc alloc] initWithColor:EMPTY x:6 y:5];
        
        NSString* path = [[NSBundle mainBundle]
                          pathForResource:@"reversi" ofType:@"book"];
        NSError* error = nil;
        int enc = NSUTF8StringEncoding;
        NSString* text = [NSString stringWithContentsOfFile:path encoding:enc error:&error];
        NSArray* lines = [text componentsSeparatedByString:@"\n"];
        
        for(int i=0; i<[lines count]; i++){
            NSString *str = lines[i];
            if([str length]>1){
                if([[str substringWithRange:NSMakeRange(0, 1)] isEqual:@"#"]) continue;
                NSArray *book = [str componentsSeparatedByString:@" "];
                [self add:book];
            }
        }
    }
    return self;
}

- (void)add:(NSArray *)book
{
    Node *node = Root;
    
    for (unsigned i=1; i<[book count]; i++){
        int val = [[book objectAtIndex:i] intValue];
        if(val>0){
            if(node.child == NULL){
                node.child = [[Node alloc] init];
                node = node.child;
                node.point = [[Disc alloc] initWithColor:EMPTY x:val/10 y:val%10];
            } else {
                node = node.child;
                while(true){
                    if(node.point.x == val/10 && node.point.y == val%10) break;
                    if(node.sibling == NULL){
                        node.sibling = [[Node alloc] init];
                        node = node.sibling;
                        node.point = [[Disc alloc] initWithColor:EMPTY x:val/10 y:val%10];
                        break;
                    }
                    node = node.sibling;
                }
            }
        }
    }
}

- (void)erase:(Node*)node
{
    
}

@end
