//
//  ChannelBtn.m
//  draggable_channel_panel
//
//  Created by 马龙 on 15/4/15.
//  Copyright (c) 2015年 马龙. All rights reserved.
//

#import "ChannelBtn.h"

@implementation ChannelBtn

-(id) initWithFrame:(CGRect)frame deleteBtnInnerFrame:(CGRect)deleteFrame
{
    if (self = [super initWithFrame:frame deleteBtnInnerFrame:deleteFrame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"channel_grid_circle"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"channel_grid_circle"] forState:UIControlStateHighlighted];
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"channel_edit_delete"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    return self;
}

@end
