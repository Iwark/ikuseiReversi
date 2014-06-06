//
//  ColorStorage.h
//  ikuseiReversi
//
//  Created by 岩崎 広平 on 13/04/11.
//  Copyright (c) 2013年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorStorage : NSObject
{
    int data[3];
}

- (int)get:(int)color;
- (void)set:(int)color value:(int)value;

@end
