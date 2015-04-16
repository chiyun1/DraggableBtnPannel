//
//  DraggablePanel.h
//  draggable_channel_panel
//
//  Created by 马龙 on 15/4/15.
//  Copyright (c) 2015年 马龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelBtn.h"

@interface DraggablePanel : UIView<CustomDraggableBtnDelegate>

@property (copy, nonatomic) NSArray* channelData;

@end
