//
//  CustomDraggableBtn.m
//  draggable_channel_panel
//
//  Created by 马龙 on 15/4/15.
//  Copyright (c) 2015年 马龙. All rights reserved.
//

#import "CustomDraggableBtn.h"

@interface CustomDraggableBtn ()
@property (assign, nonatomic) CGRect originContentFrame;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGRect startRect;

@end


@implementation CustomDraggableBtn

-(id) initWithFrame:(CGRect)frame deleteBtnInnerFrame: (CGRect)deleteFrame
{
    if (self = [super initWithFrame:frame]) {
        _originContentFrame = frame;
        _deleteBtn = [[UIButton alloc] initWithFrame:deleteFrame];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_deleteBtn];
    }
    
    return  self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    //
    UITouch* touch = [touches anyObject];
    self.startPoint = [touch locationInView:self.superview];
    
    //scale frame
    CGRect frame = self.frame;
    CGRect newFrame = CGRectInset(frame, -2, -2);
    
    [self.superview bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = newFrame;
        self.startRect = self.frame;
    }];
    
    if ([self.delegate respondsToSelector:@selector(btnMoveStart:startPosition:)]) {
        [self.delegate btnMoveStart:self startPosition:self.startPoint];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.superview];
    CGRect rcNew = CGRectOffset(self.startRect, pt.x - self.startPoint.x, pt.y - self.startPoint.y);
    self.frame = rcNew;
    
    if ([self.delegate respondsToSelector:@selector(btnMoved:newPosition:)]) {
        [self.delegate btnMoved:self newPosition:pt];
    }

}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.superview];
    
    //restore frame
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rcNew = CGRectOffset(self.startRect, pt.x - self.startPoint.x, pt.y - self.startPoint.y);
        rcNew = CGRectInset(rcNew, 2, 2);
        
        self.frame = rcNew;
    }completion:^(BOOL b){}];
    
    if ([self.delegate respondsToSelector:@selector(btnMoveEnd:finishPosition:)]) {
        [self.delegate btnMoveEnd:self finishPosition:pt];
    }
}

-(void) deleteBtnClicked
{
    if ([self.delegate respondsToSelector:@selector(deleteBtnClicked:)]) {
        [self.delegate deleteBtnClicked:self];
    }
}

-(void) btnClicked
{
    if ([self.delegate respondsToSelector:@selector(btnClicked:)]) {
        [self.delegate btnClicked:self];
    }
}

@end
