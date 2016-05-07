//
//  briefViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/2.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "briefViewController.h"

@interface briefViewController ()<UITextViewDelegate>

@property (nonatomic,weak)UILabel *countLabel;

@property (weak, nonatomic)UITextView *textView;

@end

@implementation briefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height*0.2;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 84, width-40, height)];
    textView.font = [UIFont systemFontOfSize:16];
    textView.text = self.brief;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [textView.layer setCornerRadius:10];
    textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:textView];
    _textView = textView;
    _textView.delegate = self;
    
    UILabel *label = [[UILabel alloc]init];
    label.layer.anchorPoint = CGPointMake(1.0, 1.0);
    label.bounds = CGRectMake(0, 0, height*0.3, height*0.3);
    label.layer.position = CGPointMake(width-20 , height+84);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%lu",30-(unsigned long)textView.text.length];
    [self.view addSubview:label];
    _countLabel = label;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:textView];
}
-(void)textChange{
    self.countLabel.text = [NSString stringWithFormat:@"%lu",30-(unsigned long)self.textView.text.length];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return range.location==30 ? NO : YES;
}
- (IBAction)btnOnclick:(id)sender {
    _briefBlock(self.textView.text);
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
