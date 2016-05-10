//
//  orderViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/8.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "orderViewController.h"
#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height
#define line 6
#define radius 30

@interface orderViewController ()

@property(weak,nonatomic)UIView *listView;

@property (weak, nonatomic)UIButton *menView;

@property (weak, nonatomic)UIButton *listBtn;

@property (weak, nonatomic) UIScrollView *scrollView;


@end

@implementation orderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *menView = [UIButton buttonWithType:UIButtonTypeCustom];
    menView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    menView.backgroundColor = [UIColor grayColor];
    menView.alpha = 0;
    [menView addTarget:self action:@selector(listShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menView];
    _menView = menView;
    
    UIView *listView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight*0.9, screenWidth, screenHeight*0.8)];
    listView.backgroundColor = [UIColor redColor];
    [self.view addSubview:listView];
    _listView = listView;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.center= CGPointMake( screenWidth*0.1,screenHeight *0.025);
    rightBtn.enabled = NO;
    [rightBtn setImage:[UIImage imageNamed:@"SuccessIcon"] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    rightBtn.size = CGSizeMake(30, 17);
    [rightBtn setTintColor:[UIColor grayColor]];
    [rightBtn setTitle:@"1" forState:UIControlStateNormal];
    [listView addSubview:rightBtn];
    

    
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    listBtn.center = CGPointMake( screenWidth*0.7,screenHeight *0.025);
    listBtn.size = CGSizeMake(50, 30);
    [listBtn setBackgroundColor:[UIColor whiteColor]];
    listBtn.tag = 0;
    [listBtn addTarget:self action:@selector(listShow) forControlEvents:UIControlEventTouchUpInside];
    [listView addSubview:listBtn];
    _listBtn = listBtn;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, screenHeight*0.1, screenHeight, screenHeight*0.7)];
    
    CGFloat mag = (screenWidth - radius*line)/7;
    
    for (int i = 0 ; i < self.tpArray.count;){
        for (int j = 0; j < line; j++,i++) {
            if(i== self.tpArray.count)
                return;
            CGFloat posX = (mag+radius)*j+mag;
            CGFloat posY = (mag+radius)*(i/line)+mag;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(posX, posY, radius,radius);
            button.backgroundColor = [UIColor greenColor];
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [scrollView addSubview:button];
        }
    }
    CGFloat conentHeight = mag + (self.tpArray.count/line)*(mag+radius);
    scrollView.contentSize = CGSizeMake(screenWidth, conentHeight);
    [self.listView addSubview:scrollView];
}

-(void)listShow{
    if (self.listBtn.tag==0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.listView.y -= 0.7*screenHeight;
        }];
        self.listBtn.tag = 1;
        self.menView.alpha = 0.3;
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            self.listView.y += 0.7*screenHeight;
        }];
        self.listBtn.tag = 0;
        self.menView.alpha = 0;
    }
    
}

@end
