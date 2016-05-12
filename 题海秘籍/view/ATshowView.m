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

@end

@implementation ATshowView


-(ATshowView*)initWithFrame:(CGRect)frame withFont:(UIFont*)font data:(data*)data{
    self = [super initWithFrame:frame];
    if (self) {
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
        if (_data.done) {
            box.userInteractionEnabled = NO;
        }
    }
    if (self.showType == showTypeDouble) {
        H += 10;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.x = self.width * 0.1;
        btn.y = H;
        btn.width = self.width *0.8;
        btn.height = 44;
        [btn setTitle:@"确认答案" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor greenColor];
        [btn addTarget:self action:@selector(btnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        H +=  btn.height +10;
    }
    self.contentSize = CGSizeMake(self.width , H);
    _data = data;
}
-(void)updateHeight{
    CGSize contentSize = [_topicTextField.text sizeWithFont:_font constrainedToSize:CGSizeMake(_topicTextField.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    _topicTextField.height = contentSize.height+10;
}

-(void)btnOnclick:(UIButton *)btn{
    btn.selected = YES;
    [btn setTitle:[self comfirm]? @"您答对了":@"您答错了" forState:UIControlStateSelected];
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
    if ([answer isEqualToString:self.data.answer]){
        self.data.isRight = YES;
        NSLog(@"right");
        
    }else{
        self.data.isRight = NO;
        self.addWrong();
    }
    for (ATCheckBox *box  in self.subviews) {
        if ([box isKindOfClass:[ATCheckBox class]]) {
            status s = [self.data.statusArray[box.tag]integerValue];
            [box setSelected:NO];
            if (s == statusRight) {
                [box setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateNormal];
            }else if (s == statusError){
                [box setImage:[UIImage imageNamed:@"ErrorIcon"] forState:UIControlStateNormal];
            }
        }
        box.userInteractionEnabled = NO;
    }
    self.data.done = YES;
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
