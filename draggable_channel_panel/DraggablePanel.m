//
//  DraggablePanel.m
//  draggable_channel_panel
//
//  Created by 马龙 on 15/4/15.
//  Copyright (c) 2015年 马龙. All rights reserved.
//

#import "DraggablePanel.h"

@interface NSMutableArray (logWithLocale)
- (NSString *)descriptionWithLocale:(id)locale;
@end

@implementation NSMutableArray (logWithLocale)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    return strM;
}

@end

const NSInteger kChannelHorEdge = 5;
const NSInteger kChannelVecEdge = 5;
const NSInteger kChannelCountPerLine = 4;
const NSInteger kChannelVecGapBetweenLine = 5;

const NSInteger kChannelBtnWidth = 70;
const NSInteger kChannelBtnHeight = 30;

const NSInteger kDeleteBtnWidth = 13;
const NSInteger kDeleteBtnHeight = 13;

const NSInteger kSwapTriggerAreaWidth = 20;
const NSInteger kSwapTriggerAreaHeight = 10;

@interface DraggablePanel ()

@property (strong, nonatomic) NSMutableArray* channelAreaList;
@property (strong, nonatomic) NSMutableArray* channelBtnList;
@property (assign, nonatomic) BOOL needLayoutBtns;

@property (assign, nonatomic) NSInteger startIndex;
@property (assign, nonatomic) NSInteger destIndex;

@end

@implementation DraggablePanel

-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _channelAreaList = [[NSMutableArray alloc] init];
        _channelBtnList = [[NSMutableArray alloc] init];
        _needLayoutBtns = TRUE;
    }
    
    return  self;
}

-(void) setChannelData:(NSArray *)channelData
{
    _channelData = [channelData copy];
    
    [self.channelBtnList removeAllObjects];
    
    for (NSInteger i = 0; i < self.channelData.count; i++) {
        ChannelBtn* btn = [[ChannelBtn alloc] initWithFrame:CGRectMake(0, 0, kChannelBtnWidth, kChannelBtnHeight) deleteBtnInnerFrame:CGRectMake(0, 0, kDeleteBtnWidth, kDeleteBtnHeight)];
        [btn setTitle:[channelData objectAtIndex:i] forState:UIControlStateNormal];
        [btn setIndex:i];
        btn.delegate = self;

        [self addSubview:btn];
        [self.channelBtnList addObject:btn];
    }
    
    
}

-(void) layoutSubviews
{
    if (self.needLayoutBtns != FALSE) {
        
        [self.channelAreaList removeAllObjects];
        
        CGRect rect = self.bounds;
        
        NSInteger middleGap = (CGRectGetWidth(rect) - kChannelHorEdge*2 - (kChannelCountPerLine*kChannelBtnWidth)) / (kChannelCountPerLine - 1);
        
        //create all channel area
        NSInteger horIndex = 0;
        NSInteger vecIndex = 0;
        for (NSInteger i = 0;  i < self.channelData.count;  i++) {
            horIndex = i % kChannelCountPerLine;
            vecIndex = i / kChannelCountPerLine;
            
            CGRect rcFrame = CGRectMake(kChannelHorEdge + horIndex*kChannelBtnWidth + horIndex*middleGap, kChannelVecEdge + vecIndex*kChannelBtnHeight + vecIndex*kChannelVecGapBetweenLine, kChannelBtnWidth, kChannelBtnHeight);
            
            [self.channelAreaList addObject:[NSValue valueWithCGRect:rcFrame]];
            
            [[self.channelBtnList objectAtIndex:i] setFrame:rcFrame];
        }
        
        self.needLayoutBtns = FALSE;
    }
    
}

-(void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIImage* image = [UIImage imageNamed:@"channel_compact_placeholder_inactive"];
    
    //CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSValue* value in self.channelAreaList) {
        CGRect rc = [value CGRectValue];
        if (CGRectIntersectsRect(rc, rect)) {
            [image drawInRect:rc];
        }
    }
}

-(void) btnMoveStart: (CustomDraggableBtn*) btn startPosition: (CGPoint) ptInParent
{
    self.startIndex = btn.index;
    self.destIndex = self.startIndex;
}

-(void) logBtnArray
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    for (ChannelBtn* btn in self.channelBtnList) {
        NSString* title = btn.currentTitle;
        [arr addObject:title];
    }
}

-(void) btnMoved: (CustomDraggableBtn*) btn newPosition:(CGPoint) ptInParent
{
    for (NSInteger i = 0;  i < self.channelAreaList.count;  i++) {
        CGRect rcArea = [[self.channelAreaList objectAtIndex:i] CGRectValue];
        
        //交换位置触发区域
        CGRect rcTrigger = CGRectMake(CGRectGetMidX(rcArea)- kSwapTriggerAreaWidth, CGRectGetMidY(rcArea) - kSwapTriggerAreaHeight, kSwapTriggerAreaWidth*2, kSwapTriggerAreaHeight*2);
        
        if (CGRectContainsPoint(rcTrigger, ptInParent)) {
            //进入到了触发区域
            self.destIndex = i;
            break;
        }
    }
    
    if (self.destIndex != self.startIndex) {
        //进入到了别人的触发区域,进行交换动画
        if (self.destIndex > self.startIndex) {
            //向前移动
            NSInteger numberToMove = self.destIndex - self.startIndex;
            
            [UIView animateWithDuration:0.3 animations:^{
                for (NSInteger k = 0; k != numberToMove; k++) {
                    ChannelBtn* btn = [self.channelBtnList objectAtIndex:(k + self.startIndex + 1)];
                    CGRect rcNewFrame = [[self.channelAreaList objectAtIndex:(k + self.startIndex)] CGRectValue];
                    
                    btn.index = k + self.startIndex;
                    //把后一个按钮移动到前一个按钮的位置上
                    btn.frame = rcNewFrame;
                }
            }completion:^(BOOL b){
                //调整按钮交换后的存储顺序
                ChannelBtn* btn = [self.channelBtnList objectAtIndex:self.startIndex];
                [self.channelBtnList removeObjectAtIndex:self.startIndex];
                [self.channelBtnList insertObject:btn atIndex:self.destIndex];
                btn.index = self.destIndex;
                
                [self logBtnArray];
                
                self.startIndex = self.destIndex;
            }];
            
        }else{
            //向后移动
            NSInteger numberToMove = self.startIndex - self.destIndex;
            
            [UIView animateWithDuration:0.3 animations:^{
                for (NSInteger k = 0; k != numberToMove; k++) {
                    ChannelBtn* btn = [self.channelBtnList objectAtIndex:(self.startIndex - k -1)];
                    CGRect rcNewFrame = [[self.channelAreaList objectAtIndex:(self.startIndex - k)] CGRectValue];
                    
                    btn.index = self.startIndex - k;
                    //把前一个按钮移动到后一个按钮的位置上
                    btn.frame = rcNewFrame;
                }
            }completion:^(BOOL b){
                //调整按钮交换后的存储顺序
                ChannelBtn* btn = [self.channelBtnList objectAtIndex:self.startIndex];
                [self.channelBtnList removeObjectAtIndex:self.startIndex];
                [self.channelBtnList insertObject:btn atIndex:self.destIndex];
                btn.index = self.destIndex;
                
                self.startIndex = self.destIndex;
            }];
        }
    }
}

-(void) btnMoveEnd: (CustomDraggableBtn*) btn finishPosition:(CGPoint) ptInParent
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rcFrame = [[self.channelAreaList objectAtIndex:self.destIndex] CGRectValue];
        btn.frame = rcFrame;
    }];
}

-(void) deleteBtnClicked: (CustomDraggableBtn*) btn
{
    NSInteger index = btn.index;
    self.startIndex = index;
    
    //删掉最后一个按钮区域
    [self setNeedsDisplayInRect:[[self.channelAreaList lastObject] CGRectValue]];
    [self.channelAreaList removeLastObject];

    //移动后面的按钮
    NSInteger numberToMove = self.channelBtnList.count - index - 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        for (NSInteger k = 0; k != numberToMove; k++) {
            ChannelBtn* btn = [self.channelBtnList objectAtIndex:(k + self.startIndex + 1)];
            CGRect rcNewFrame = [[self.channelAreaList objectAtIndex:(k + self.startIndex)] CGRectValue];
            
            btn.index = k + self.startIndex;
            //把后一个按钮移动到前一个按钮的位置上
            btn.frame = rcNewFrame;
        }
    }completion:^(BOOL b){
        //调整按钮交换后的存储顺序
        ChannelBtn* btn = [self.channelBtnList objectAtIndex:self.startIndex];
        [self.channelBtnList removeObjectAtIndex:self.startIndex];
        [btn removeFromSuperview];
    }];

}

-(void) btnClicked:(CustomDraggableBtn *)btn
{
    NSLog(@"btn %@ is clicked", btn.currentTitle);
}

@end
