//
//  ATshowView.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/10.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATshowView.h"
#import "ATCheckBox.h"

@interface ATshowView ()<ATCheckBoxDelegate>

@property (weak, nonatomic)data *data;

@property (weak, nonatomic)UIButton *btn;

@end

@implementation ATshowView


-(ATshowView*)initWithFrame:(CGRect)frame withFont:(UIFont*)font data:(data*)data exam:(BOOL)isExam{
    self = [super initWithFrame:frame];
    if (self) {
        self.isExam =isExam;
        [self reloadData:data];
        _font= font;
    }
    return self;
}

-(void)reloadData:(data*)data{
    UITextView *topicTextField = [[UITextView alloc]init];
    topicTextField.x = self.frame.size.width*0.05;
    topicTextField.y = self.frame.size.height*0.1;
    topicTextField.width = self.frame.size.width*0.9;
    topicTextField.userInteractionEnabled = NO;
    topicTextField.backgroundColor = [UIColor whiteColor];
    topicTextField.font = _font;
    [self addSubview:topicTextField];
    _topicTextField = topicTextField;
    for (ATCheckBox *box in self.subviews) {
        if ([box isKindOfClass:[ATCheckBox class]]) {
            [box removeFromSuperview];
        }
    }
    self.topicTextField.text = data.title;
    [self updateHeight];
    
    CGFloat H = self.topicTextField.y+self.topicTextField.height+10;
    for (int i = 0; i<data.opArray.count; i++) {
        ATCheckBox *box = [[ATCheckBox alloc]initWithDelegate:self];
        box.tag = i;
        box.frame = CGRectMake(0, H, self.width, 44);
        box.titleLabel.font = self.font;
        [box setTitle:data.opArray[i] forState:UIControlStateNormal];
        H += box.height;
        [self addSubview:box];
        status s = [data.statusArray[i] integerValue];
        [box setSelected:NO];
        if (!self.isExam) {
            switch (s) {
                case statusRight:
                    [box setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateNormal];
                    break;
                case statusError:
                    [box setImage:[UIImage imageNamed:@"ErrorIcon"] forState:UIControlStateNormal];
                    break;
                case statusSelect:
                    [box setSelected:YES];
                    break;
                case statusNomal:
                    break;
                default:
                    break;
            }
        }
        if (_data.done) {
            box.userInteractionEnabled = NO;
        }
    }
    if (self.showType == showTypeDouble || _data.answer.length >1) {
        H += 20;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.x = self.width * 0.1;
        btn.y = H;
        btn.width = self.width *0.8;
        btn.height = 44;
        btn.layer.cornerRadius = 10;
        [self didBtn:btn da:data];
        
        [btn addTarget:self action:@selector(btnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _btn = btn;
        H +=  btn.height +10;
        btn.enabled = !data.done;
    }
    self.contentSize = CGSizeMake(self.width , H);
    _data = data;
}

-(void)didBtn:(UIButton*)btn da:(data*)data{
    NSString *title;
    btn.titleLabel.backgroundColor = [UIColor clearColor];
    if (!data.done) {
        title = @"确认答案";
        btn.backgroundColor = [UIColor orangeColor];
    }else{
        if (data.isRight) {
            title = @"您答对了!";
            btn.backgroundColor = [UIColor greenColor];
        }else{
            title = @"您答错了!";
            btn.backgroundColor = [UIColor redColor];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}

-(void)updateHeight{
    CGSize contentSize = [_topicTextField.text sizeWithFont:_font constrainedToSize:CGSizeMake(_topicTextField.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    _topicTextField.height = contentSize.height+10;
}

-(void)btnOnclick:(UIButton *)btn{
    btn.selected = YES;
    [self comfirm];
    btn.userInteractionEnabled = NO;
}

-(BOOL)comfirm{
    data *data = self.data;
    NSString *answer = @"" ;
    for (int i= 0,j=0; i < data.opArray.count; i++) {
        char c = 'A'+i;
        if (data.statusArray[i]==[NSNumber numberWithInteger:statusSelect]){

            answer = [answer stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
            if ([data.answer characterAtIndex:j] == [answer characterAtIndex:j]) {
                j++;
                data.statusArray[i] = [NSNumber numberWithInteger:statusRight];
            }else{
                data.statusArray[i] = [NSNumber numberWithInteger:statusError];
            }
        }
        if ([data.answer containsString:[NSString stringWithFormat:@"%c",c]]) {
            data.statusArray[i] = [NSNumber numberWithInteger:statusRight];
        }
    }
    self.data.done = YES;
    if ([answer isEqualToString:self.data.answer]){
        self.data.isRight = YES;
        NSLog(@"right");
        self.deleteRight();
    }else{
        self.data.isRight = NO;
        self.addWrong();
    }
    for (ATCheckBox *box  in self.subviews) {
        if ([box isKindOfClass:[ATCheckBox class]]) {
            status s = [self.data.statusArray[box.tag]integerValue];
            if (!self.isExam) {
                [box setSelected:NO];
            }
            if (s == statusRight && !self.isExam) {
                    [box setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateNormal];
                }else if (s == statusError && !self.isExam){
                    [box setImage:[UIImage imageNamed:@"ErrorIcon"] forState:UIControlStateNormal];
            }
        }
        box.userInteractionEnabled = NO;
    }
    self.data.done = YES;
    
    [self didBtn:self.btn da:data];
    
    return self.data.isRight;
}
#pragma ATCheckBoxDelegate
- (void)didSelectedCheckBox:(ATCheckBox *)checkbox checked:(BOOL)checked{
    if (checked) {
        _data.statusArray[checkbox.tag] = [NSNumber numberWithInteger:statusSelect];
    }else{
        _data.statusArray[checkbox.tag] = [NSNumber numberWithInteger:statusNomal];
    }
    if (_data.answer.length == 1) {
        [self comfirm];
    }
}

@end
