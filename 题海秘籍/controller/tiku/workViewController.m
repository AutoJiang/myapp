//  workViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/22.
//  Copyright (c) 2015年 Auto. All rights reserved.
//
#import "workViewController.h"
#import "MBProgressHUD+NJ.h"
#import <AudioToolbox/AudioToolbox.h>
#define vCount 6               //音频数
static SystemSoundID V[vCount];
static SystemSoundID W;
@interface workViewController ()
@property (weak, nonatomic) IBOutlet UITextView *topicTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;
@property (weak, nonatomic) IBOutlet UIButton *btnD;
@property (strong, nonatomic) NSMutableArray *temp;
@property (assign, nonatomic) NSInteger right;
@property (weak, nonatomic) IBOutlet UIButton *item;

//@property (weak, nonatomic) IBOutlet UILabel *awr;
@property (assign, nonatomic) NSInteger num;
@property (assign,nonatomic)NSInteger time;
@property (strong,nonatomic)NSMutableArray *wrong;
@property (assign,nonatomic)NSInteger flag;
@property (weak, nonatomic) IBOutlet UIView *optionalView;

@end

@implementation workViewController


- (IBAction)getBackBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未完成全部答题，是否保存错题并退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defauts = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveWrongTpic];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:defauts];
    [self presentViewController:alert animated:true completion:nil];
}

-(void)didVoice{
    for (int i = 0 ; i< vCount; i++) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"V_%d.wav",i]withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &V[i]);
    }
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"w.mp3" withExtension:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &W);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = self.tpArray.count;
    self.flag = 0;
    [self didVoice];
    [self setBtnMode];
    [self setBtnTitle];
}
-(void)setBtnTitle{
    if (!self.tpArray.count) {
        [self doneTipic];
        return;
    }
    self.time++;
    NSInteger n = arc4random() % self.tpArray.count;
    self.temp = self.tpArray[n];
    [self.tpArray removeObjectAtIndex:n];
    [self.item setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.time,(long)self.num] forState:UIControlStateNormal];
    CATransition *ca = [CATransition animation];
    ca.type =@"cube";
    ca.subtype =@"fromTop";
    [self.topicTextField.layer addAnimation:ca forKey:nil];
    
    NSString *tp = [NSString stringWithString:self.temp[0]];
    NSMutableString *title = [NSMutableString stringWithString:tp];
    int m = 4-(int)tp.length/20;
    if (m>0) {
        for (int i =0; i < m ; i++) {
            [title insertString:@"\n" atIndex:0];
        }
    }
    [self.topicTextField setText:title];
    
    CGSize sizeToFit = [self.topicTextField sizeThatFits:CGSizeMake(self.topicTextField.frame.size.width, self.myfont+1)];
    if(self.topicTextField.frame.size.height<sizeToFit.height){
        self.topicTextField.contentSize = sizeToFit;
    }else{
        self.topicTextField.contentSize = self.topicTextField.frame.size;
    }
    self.topicTextField.font = [UIFont systemFontOfSize:self.myfont+1];
    
    [self.btnA setTitle:self.temp[1] forState:UIControlStateNormal];
    [self.btnB setTitle:self.temp[2] forState:UIControlStateNormal];
    [self.btnA.layer addAnimation:ca forKey:nil];
    [self.btnB.layer addAnimation:ca forKey:nil];
    if (self.temp.count == 4) {
        self.btnC.alpha = 0;
        self.btnD.alpha = 0;
        [self.btnC setTitle:@"" forState:UIControlStateNormal];
        [self.btnD setTitle:@"" forState:UIControlStateNormal];
    }else{
        self.btnC.alpha = 1;
        self.btnD.alpha = 1;
        [self.btnC.layer addAnimation:ca forKey:nil];
        [self.btnD.layer addAnimation:ca forKey:nil];
        [self.btnC setTitle:self.temp[3] forState:UIControlStateNormal];
        [self.btnD setTitle:self.temp[4] forState:UIControlStateNormal];
    }
    //    [self.awr setText:self.temp[5]];
}
-(void)setBtnMode{
    for (UIButton *btn in self.optionalView.subviews) {
        btn.titleLabel.lineBreakMode = 0;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:self.myfont];
        UIImage *originalImage = [UIImage imageNamed:@"btn_0"];
        CGFloat imageW = originalImage.size.width * 0.5;
        CGFloat imageH = originalImage.size.height * 0.5;
        UIEdgeInsets insets = UIEdgeInsetsMake(imageH, imageW,imageH, imageW);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [btn setBackgroundImage:stretchableImage forState:UIControlStateNormal];
        UIImage *originaleImage_1 = [UIImage imageNamed:@"btn_1"];
        stretchableImage = [originaleImage_1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [btn setBackgroundImage:stretchableImage forState:UIControlStateHighlighted];
    }
}
-(NSMutableArray *)wrong{
    if (_wrong ==nil) {
        _wrong =[[NSMutableArray alloc]initWithCapacity:self.num];
    }
    return _wrong;
}

- (IBAction)btnOnclick:(UIButton *)sender {
    NSString *s = [self.temp lastObject];
    if ([s isEqualToString:@"对"])
        s = @"A";
    if ([s isEqualToString:@"错"])
        s = @"B";
    if ((char)(sender.tag +'A')== [s characterAtIndex:0]) {
        self.right++;
        if (self.right ==1 &&self.flag == 0&&[self.name containsString:@"Dota"]&&!self.voice) {          //first boold!
                AudioServicesPlaySystemSound(V[0]);
        }else{
            NSInteger i = arc4random() % 3 +1;
            if (!self.voice && self.time!=self.num) {
                AudioServicesPlaySystemSound(V[i]);
            }
        }
        if (self.record) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您答对了" message:[NSString stringWithFormat:@"是否将该题移出错题集？"]preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate deleteWrongTpic:self wrong:self.temp];
                [self setBtnTitle];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self setBtnTitle];
            }];
            [alert addAction:defaults];
            [alert addAction:cancel];
            [self presentViewController:alert animated:true completion:nil];
        }else{
            if (self.time!=self.num) {
                [MBProgressHUD showSuccess:@"正确"];
            }
            [self setBtnTitle];
        }
    }else{
        if (!self.voice) {
            AudioServicesPlaySystemSound(W);
        }
        //        AudioServicesPlayAlertSound(V[4]);
        if (!self.shake) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); //震动
        }
        [self.wrong addObject:self.temp];
        NSString *mge = [NSString string];
        for (int i = 0; i<s.length; i++) {
            int j= [s characterAtIndex:i]-'A';
            NSString *tp = [NSString stringWithString:self.temp[j+1]];
            int  m = 30-tp.length%18;
            while (m--) {
                tp = [tp stringByAppendingString:@" \t"];
            }
            mge = [mge stringByAppendingString:tp];
            if (i<s.length-1) {
                mge = [mge stringByAppendingString:@"\n"];
            }
        }        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您答错了,正确答案是：%@",s] message:mge preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self setBtnTitle];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)doneTipic{
    if (!self.tpArray.count) {
        float rate = self.right * 1.0 /self.num;
        if (!self.voice &&!self.flag&&!self.record) {
            AudioServicesPlaySystemSound(V[5]);
        }
        if (!self.wrong.count) {
            NSString *mge = [NSString stringWithFormat:@"恭喜%@同学，本轮答题正确率为%.2f%%",self.name,rate * 100];
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"您已完成答题。" message:mge preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self saveWrongTpic];
                [self.navigationController popViewControllerAnimated:true];
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            NSString *mge = [NSString stringWithFormat:@"%@同学，本轮答题正确率为%.2f%%。是否进入错题回顾？",self.name,rate * 100];
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"您已完成答题。" message:mge preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self.tpArray = [self.wrong mutableCopy];
                [self saveWrongTpic];
                self.num = self.wrong.count;
                self.wrong = nil;
                self.time = 0;
                self.right = 0;
                [self setBtnTitle];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self saveWrongTpic];
                [self.navigationController popViewControllerAnimated:true];
            }];
            [alert addAction:cancel];
            [alert addAction:defaults];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return ;
    }
}

-(void)saveWrongTpic{
    if (!self.flag) {
        if ([self.delegate respondsToSelector:@selector(saveWrongTpic:wrong:)]) {
            [self.delegate saveWrongTpic:self wrong:self.wrong];
        }
        self.flag = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSMutableArray *)tpArray{
    if (_tpArray ==nil) {
        _tpArray = [[NSMutableArray alloc]init];
    }
    return _tpArray;
}

@end
