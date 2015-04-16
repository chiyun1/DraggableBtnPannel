//
//  ViewController.m
//  draggable_channel_panel
//
//  Created by 马龙 on 15/4/15.
//  Copyright (c) 2015年 马龙. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@property (strong, nonatomic) ChannelBtn* btn;
@property (strong, nonatomic) UIButton* btnNormal;
@property (strong, nonatomic) DraggablePanel* panel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rc = self.view.bounds;
    self.panel = [[DraggablePanel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(rc), 200)];
    [self.panel setBackgroundColor:[UIColor lightGrayColor]];
    
    NSArray* data = @[@"新闻", @"资讯", @"热点", @"北京", @"科技", @"娱乐", @"游戏", @"财经", @"房产"];
    [self.panel setChannelData:data];
    [self.view addSubview:self.panel];
    
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) btnMoveStart: (CustomDraggableBtn*) btn startPosition: (CGPoint) ptInParent
{
    //NSLog(@"touch began: %@",NSStringFromCGPoint(pt));
}

-(void) btnMoved: (CustomDraggableBtn*) btn newPosition:(CGPoint) ptInParent
{
    //NSLog(@"touch move: %@",NSStringFromCGPoint(pt));
}

-(void) btnMoveEnd: (CustomDraggableBtn*) btn finishPosition:(CGPoint) ptInParent
{
    //NSLog(@"touch end: %@",NSStringFromCGPoint(pt));
}

@end
