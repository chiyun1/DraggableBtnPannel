//
//  CustomDraggableBtn.h
//  draggable_channel_panel
//
//  Created by 马龙 on 15/4/15.
//  Copyright (c) 2015年 马龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomDraggableBtn;
@protocol CustomDraggableBtnDelegate <NSObject>

@optional
-(void) btnMoveStart: (CustomDraggableBtn*) btn startPosition: (CGPoint) ptInParent;
-(void) btnMoved: (CustomDraggableBtn*) btn newPosition:(CGPoint) ptInParent;
-(void) btnMoveEnd: (CustomDraggableBtn*) btn finishPosition:(CGPoint) ptInParent;
-(void) deleteBtnClicked: (CustomDraggableBtn*) btn;
-(void) btnClicked: (CustomDraggableBtn*) btn;

@end

@interface CustomDraggableBtn : UIButton

@property(strong, nonatomic) UIButton* deleteBtn; //delete btn at left top. fixed frame
@property(weak, nonatomic) id<CustomDraggableBtnDelegate> delegate;
@property(assign, nonatomic) NSInteger index;

-(id) initWithFrame:(CGRect)frame deleteBtnInnerFrame: (CGRect)deleteFrame;

@end
