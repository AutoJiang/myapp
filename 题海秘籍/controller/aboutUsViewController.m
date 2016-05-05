//
//  aboutUsViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/10/10.
//  Copyright © 2015年 Auto. All rights reserved.
//

#import "aboutUsViewController.h"

@interface aboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *T1;
@property (weak, nonatomic) IBOutlet UILabel *T2;
@property (weak, nonatomic) IBOutlet UILabel *T3;
@property (weak, nonatomic) IBOutlet UILabel *T4;
@property (weak, nonatomic) IBOutlet UILabel *T5;
@property (weak, nonatomic) IBOutlet UILabel *T6;
@property (weak, nonatomic) IBOutlet UILabel *T7;
@property (strong, nonatomic)NSArray *arr;
@property (weak, nonatomic) IBOutlet UILabel *T8;


@end

@implementation aboutUsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    for (int i =0; i<self.arr.count; i++) {
        UILabel *label = self.arr[i];
        label.alpha = 0;
    }
    // Do any additional setup after loading the view.

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (int i = 0; i<self.arr.count; i++) {
        UILabel *label = self.arr[i];
        label.alpha = 1;
        //        label.alpha = 0;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        //    animation.keyPath = @"position";
        //    NSValue *a = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
        //        label.layer.anchorPoint = CGPointMake(0.5, 0.5);
        CGFloat X = label.layer.position.x;
        CGFloat Y = label.layer.position.y;
        NSLog(@"%f",X);
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(X,Y+400)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(X,Y)];
        animation.duration = 2;
        //        animation.removedOnCompletion = YES;
        //        animation.repeatCount = MAXFLOAT;
        //        animation.autoreverses = YES;
        animation.delegate =self;
        animation.fillMode = kCAFillModeBoth;
        
        //    self.T1.layer.position;
        [label.layer addAnimation:animation forKey:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 1;
    animation.removedOnCompletion =YES;
    animation.autoreverses = YES;
    animation.repeatCount =3;
    [self.T8.layer addAnimation:animation forKey:nil];
    self.T8.alpha =1;
}
-(NSArray *)arr{
    if (_arr == nil) {
        _arr = [[NSArray alloc]initWithObjects:_T1,_T2,_T3,_T4,_T5,_T6,_T7,nil];
    }
    return _arr;
}


@end
