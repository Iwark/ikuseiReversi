//
//  GameViewController.m
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/10.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    board = [[Board alloc] init];
    nullImg = [UIImage imageNamed:@"nullButton.png"];
    blackImg = [UIImage imageNamed:@"blackButton.png"];
    whiteImg = [UIImage imageNamed:@"whiteButton.png"];
    computerMode = YES;
    comColor = WHITE;
    [self initGame];
}

- (void)initGame
{
    for(int x=0;x<8;x++){
        for(int y=0;y<8;y++){
            if(buttons[x][y]) [buttons[x][y] removeFromSuperview];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x*34+25,y*34+73,32,32)];
            buttons[x][y] = button;
            button.tag = x*10+y;
            if((x==3 && y==3) || (x==4 && y==4)){
                [button setBackgroundImage:whiteImg forState:UIControlStateDisabled];
                button.enabled = false;
            }else if((x==4 && y==3) || (x==3 && y==4)){
                [button setBackgroundImage:blackImg forState:UIControlStateDisabled];
                button.enabled = false;
            }else{
                [button setBackgroundImage:nullImg forState:UIControlStateNormal];
                [button addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchDown];
            }
            [self.view addSubview:button];
        }
    }
    [board initGame];
    com = [[AlphaBetaAI alloc] init];
    eval = [[MidEvaluator alloc] init];
    winner_flag = false;
    chat_flag = false;
    chat_contents = @"勝負や！！";
    [NSTimer
     scheduledTimerWithTimeInterval:0.5f
     target:self
     selector:@selector(showChat:)
     userInfo:nil
     repeats:NO
     ];
    
}

- (void)showChat:(NSTimer *)timer
{
    if(chat_flag==false){
        chatLabel.text = chat_contents;
        chatView.hidden = false;
        [NSTimer
         scheduledTimerWithTimeInterval:2.0f
         target:self
         selector:@selector(showChat:)
         userInfo:nil
         repeats:NO
         ];
        chat_flag=true;
    }else{
        chatView.hidden = true;
        chat_flag=false;
        if(computerMode==YES && [board getCurrentColor] == comColor){
            [self computerMove];
        }
    }
}

- (void)pushButton:(UIButton*)button
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:com.thoughtDate];
    if(interval > 0.1){
        int x = button.tag/10+1;
        int y = button.tag%10+1;
        Disc *disc = [[Disc alloc] initWithColor:NONE x:x y:y];
        if([board move:disc]) [self updateStatus];
    }
}

- (IBAction)changeMode:(UIButton*)button
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:com.thoughtDate];
    if(interval > 0.1){
        if(computerMode == YES && comColor == WHITE){
            computerMode = NO;
            [button setTitle:@"人間(黒) vs 人間(白)" forState:UIControlStateNormal];
        }
        else if(computerMode == YES && comColor == BLACK){
            computerMode = YES;
            comColor = WHITE;
            [button setTitle:@"人間(黒) vs COM(白)" forState:UIControlStateNormal];
        }
        else{
            computerMode = YES;
            comColor = BLACK;
            [button setTitle:@"人間(白) vs COM(黒)" forState:UIControlStateNormal];
        }
        if(computerMode == YES){
            [self computerMove];
        }
        
    }
}

- (IBAction)passButton:(UIButton*)button
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:com.thoughtDate];
    if(interval > 0.1){
        [board pass];
        [self updateStatus];
    }
}

- (IBAction)restartButton:(UIButton*)button
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:com.thoughtDate];
    if(interval > 0.1){
        [self initGame];
    }
}

- (IBAction)undoButton:(UIButton*)button
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:com.thoughtDate];
    if(interval > 0.1){
        [board undo];
        Disc *disc = [[Disc alloc] init];
        for(int x=1; x<=BOARD_SIZE; x++){
            disc.x=x;
            for(int y=1; y<=BOARD_SIZE; y++){
                disc.y=y;
                switch ([board getColor:disc])
                {
                    case BLACK:
                        [buttons[x-1][y-1] setBackgroundImage:blackImg forState:UIControlStateDisabled];
                        buttons[x-1][y-1].enabled = false;
                        break;
                    case WHITE:
                        [buttons[x-1][y-1] setBackgroundImage:whiteImg forState:UIControlStateDisabled];
                        buttons[x-1][y-1].enabled = false;
                        break;
                    default:
                        [buttons[x-1][y-1] setBackgroundImage:nullImg forState:UIControlStateDisabled];
                        buttons[x-1][y-1].enabled = true;
                        break;
                }
            }
            
        }
        if([board getCurrentColor] == BLACK) turnLabel.text = @"黒のターン";
        else turnLabel.text = @"白のターン";
    }
}

- (void)updateStatus
{
    NSMutableArray *update = [board getUpdate];
    
    if([update count]>0){
        Disc *operation = [update objectAtIndex:0];
        if(operation.color==BLACK){
            [buttons[operation.x-1][operation.y-1] setBackgroundImage:blackImg forState:UIControlStateHighlighted];
        }else{
            [buttons[operation.x-1][operation.y-1] setBackgroundImage:whiteImg forState:UIControlStateHighlighted];
        }
        
        for(int i=0; i<[update count]; i++){
            operation = [update objectAtIndex:i];
            switch (operation.color)
            {
                case BLACK:
                    [buttons[operation.x-1][operation.y-1] setBackgroundImage:blackImg forState:UIControlStateDisabled];
                    buttons[operation.x-1][operation.y-1].enabled = false;
                    break;
                case WHITE:
                    [buttons[operation.x-1][operation.y-1] setBackgroundImage:whiteImg forState:UIControlStateDisabled];
                    buttons[operation.x-1][operation.y-1].enabled = false;
                    break;
                default:
                    [buttons[operation.x-1][operation.y-1] setBackgroundImage:nullImg forState:UIControlStateDisabled];
                    buttons[operation.x-1][operation.y-1].enabled = true;
                    break;
            }
        }
    }
    /*
    NSMutableArray *array = [board getMovablePos];
    for(int i=0;i<[array count];i++){
        Disc *disc = [array objectAtIndex:i];
        NSLog(@"%d,%d,%d",disc.x,disc.y,disc.color);
    }*/
    
    score.text = [NSString stringWithFormat:@"%d - %d",[board countDisc:BLACK],[board countDisc:WHITE]];
    //NSLog(@"%d:%d",[board getCurrentColor],[eval evaluate:board]);
    
    if([board getCurrentColor] == BLACK) turnLabel.text = @"黒のターン";
    else turnLabel.text = @"白のターン";
    //NSLog(turnLabel.text);
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
    
    if([board isGameOver]){
        if(winner_flag == true){
            chat_contents = @"げへへ…やっぱりな…わいの勝ちや";
            [NSTimer
             scheduledTimerWithTimeInterval:0.5f
             target:self
             selector:@selector(showChat:)
             userInfo:nil
             repeats:NO
             ];
        }
        return;
    }
    [self computerMove];
}

- (void)computerMove{
    if(computerMode==YES && [board getCurrentColor] == comColor){
        //dispatch_queue_t main = dispatch_get_main_queue();
        //dispatch_queue_t sub = dispatch_queue_create("example.com", NULL);
        //dispatch_async(sub, ^{
            //何か重たい処理
            [com move:board];
        //    dispatch_async(main, ^{
                //重たい処理が終わったとき
                NSLog(@"%@", @"finish");
                if(board.winner == WHITE && winner_flag == false){
                    chatLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
                    chatLabel.shadowOffset = CGSizeMake(1.0,-1.0);
                    chat_contents = @"終局まで読み切ったで…わいの勝ちや";
                    [NSTimer
                     scheduledTimerWithTimeInterval:0.5f
                     target:self
                     selector:@selector(showChat:)
                     userInfo:nil
                     repeats:NO
                     ];
                    winner_flag = true;
                }
                [self updateStatus];
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
        //    });
        //});
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"メモリおわこん");
}

@end
