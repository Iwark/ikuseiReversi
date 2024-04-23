//
//  GameViewController.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/10.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "AlphaBetaAI.h"
#import "MidEvaluator.h"

@interface GameViewController : UIViewController
{
    Board *board;
    UIImage *nullImg;
    UIImage *blackImg;
    UIImage *whiteImg;
    UIButton *buttons[8][8];
    
    AlphaBetaAI *com;
    MidEvaluator *eval;
    
    IBOutlet UILabel *score;
    IBOutlet UILabel *turnLabel;
    IBOutlet UIView *chatView;
    IBOutlet UILabel *chatLabel;
    
    NSString *chat_contents;
    bool chat_flag;
    bool winner_flag;
    bool computerMode;
    bool processing;
    Color comColor;
}

- (void)showChat:(NSTimer *)timer;

@end
