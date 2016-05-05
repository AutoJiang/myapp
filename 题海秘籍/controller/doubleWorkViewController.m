//
//  doubleWorkViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/26.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "doubleWorkViewController.h"
#import "QCheckBox.h"
#import "MBProgressHUD+NJ.h"
#import <AudioToolbox/AudioToolbox.h>
int check[5];
#define vCount 6
static SystemSoundID V[vCount];
static SystemSoundID W;
@interface doubleWorkViewController ()
@property(nonatomic,strong)NSMutableArray *temp;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIScrollView *optionalView;
@property (assign, nonatomic) NSInteger right;
@property (assign, nonatomic) NSInteger num;
@property (weak, nonatomic) IBOutlet UIButton *item;
@property (assign,nonatomic) NSInteger time;
@property (strong,nonatomic) NSMutableArray *wrong;
@property (assign,nonatomic) NSInteger flag;
@property (weak, nonatomic) IBOutlet UIButton *awr;
@property (nonatomic ,strong)NSMutableArray *btnArr;
@end


@implementation doubleWorkViewController

- (IBAction)getBackBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您未完成全部答题，是否保存错题并退出？" preferredStyle:UIAlertControllerStyleAlert];
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [self didbtn];
    [self setTitle];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self didVoice];
    self.num = self.tpArray.count;    
}
-(NSMutableArray *)wrong{
    if (_wrong ==nil) {
        _wrong = [[NSMutableArray alloc]initWithCapacity:self.num];
    }
    return _wrong;
}
-(void)initCheck{
    for (int i=0 ;i<5 ; i++) {
        check[i]=0;
    }
}
-(void)setTitle{
    if (!self.tpArray.count) {
        [self doneTipic];
        return;
    }
    NSInteger n = arc4random()%self.tpArray.count;
    self.temp = self.tpArray[n];
    [self.tpArray removeObjectAtIndex:n];
    CATransition *ca = [CATransition animation];
    ca.type =@"cube";
    ca.subtype =@"fromTop";
    [self.textField.layer addAnimation:ca forKey:nil];
    
    NSString *tp = [NSString stringWithString:self.temp[0]];
    NSMutableString *title = [NSMutableString stringWithString:tp];
    int m = 4-(int)tp.length/20;
    if (m>0) {
        for (int i =0; i < m ; i++) {
            [title insertString:@"\n" atIndex:0];
        }
    }
    self.textField.text = title;
    
    CGSize sizeToFit = [self.textField sizeThatFits:CGSizeMake(self.textField.frame.size.width, self.myfont+1)];
    if(self.textField.frame.size.height<sizeToFit.height){
        self.textField.contentSize = sizeToFit;
    }else{
        self.textField.contentSize = self.textField.frame.size;
    }
    self.textField.font = [UIFont systemFontOfSize:self.myfont+1];
    
    self.time++;
    [self.item setTitle:[NSString stringWithFormat:@"%zi/%zi",self.time,self.num] forState:UIControlStateNormal];
    if (self.temp.count == 6) {
        UIButton *btn =self.btnArr[4];
        btn.alpha = 0;
    }else{
        UIButton *btn =self.btnArr[4];
        btn.alpha = 1;
    }
    
    float x = 0,y = 0,w = self.optionalView.frame.size.width;
    for (int i = 0 ; i< self.temp.count -2; i++) {
        UIButton *btn = self.btnArr[i];
        [btn setTitle:self.temp[i+1] forState:UIControlStateNormal];
        CATransition *ca = [CATransition animation];
        ca.type = @"cube";
        ca.subtype =@"fromTop";
        [btn.layer addAnimation:ca forKey:nil];
        CGRect rect = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(w, MAXFLOAT)  options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        btn.titleLabel.frame = CGRectMake(x, y, w, rect.size.height);
        y = y + btn.frame.size.height+5;
    }
    self.optionalView.contentOffset = CGPointMake(0, 0);
    self.optionalView.contentSize = CGSizeMake(w, y);
    self.awr.enabled = NO;
    NSLog(@"%@",[self.temp lastObject]);
    [self initCheck];
    [self clearSelect];
}
-(void)didbtn{
    for (int i = 0; i < 5; i++) {
        CGFloat y = i * self.interval;
        QCheckBox  *check = [[QCheckBox alloc]initWithDelegate:self];
        check.frame = CGRectMake(0, y, self.optionalView.frame.size.width, self.interval);
        check.tag = i;
        check.titleLabel.font = [UIFont systemFontOfSize:self.myfont];
        check.titleLabel.lineBreakMode = 0;
        [check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [check setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        [check setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [check.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [check setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
        [check setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
        [self.btnArr addObject:check];
        [self.optionalView addSubview:check];
    }
    self.awr.alpha = 1;
}
-(NSMutableArray *)btnArr{
    if (_btnArr ==nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (IBAction)btnOnClick:(id)sender {
    NSString *answer = @"" ;
    for (int i= 0; i < 5; i++) {
        if (check[i]){
            answer = [answer stringByAppendingString:[NSString stringWithFormat:@"%c",'A'+i]];
        }
    }
//    NSLog(@"%@",answer);
    //    NSLog(@"%@",[self.temp lastObject]);
    if ([answer isEqualToString:[self.temp lastObject]]) {
        self.right++;
        if (self.right ==1 &&self.flag == 0 && [self.name containsString:@"Dota"] && !self.voice) {
            AudioServicesPlaySystemSound(V[0]);
        }else{
            if (!self.voice && self.time!=self.num) {
                NSInteger i = arc4random() % 3 +1;
                AudioServicesPlaySystemSound(V[i]);
            }
        }
        if (self.record) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您答对了" message:[NSString stringWithFormat:@"是否将该题移出错题集？"]preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate deleteDWrongTpic:self wrong:self.temp];
                [self setTitle];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self setTitle];
            }];
            [alert addAction:defaults];
            [alert addAction:cancel];
            [self presentViewController:alert animated:true completion:nil];
        }else{
            if (self.time!=self.num) {
                [MBProgressHUD showSuccess:@"正确"];
            }
            [self setTitle];
        }
    }else{
        if (!self.voice) {
            AudioServicesPlaySystemSound(W);
        }
        if (!self.shake) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); //震动
        }
        //        AudioServicesPlayAlertSound(V[4]);
        [self.wrong addObject:self.temp];
        NSString *mge = [NSString string];
        NSString *s = [self.temp lastObject];
        for (int i = 0; i<s.length; i++) {
            int j= [s characterAtIndex:i]-'A';
            NSString *tp = [NSString stringWithString:self.temp[j+1]];
            NSLog(@"%@",tp);
            int  m = 30 -tp.length%18;
            while (m--) {
                tp = [tp stringByAppendingString:@" \t"];
            }
            mge = [mge stringByAppendingString:tp];
            if (i<s.length-1) {
//                mge = [mge stringByAppendingString:@"\n"];
            }
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您答错了,正确答案是：%@",s] message:mge preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self setTitle];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)doneTipic{
    if (!self.tpArray.count) {
        float rate = self.right * 1.0 /self.num;
        if (!self.voice && !self.flag && !self.record) {
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
                [self setTitle];
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
        if ([self.delegate respondsToSelector:@selector(saveDwrongTpic:wrong:)]) {
            [self.delegate saveDwrongTpic:self wrong:self.wrong];
        }
        self.flag++;
    }
}
-(NSMutableArray *)tpArray{
    if (_tpArray == nil) {
        _tpArray = [[NSMutableArray alloc]init];
    }
    return _tpArray;
}
-(void)clearSelect{
    for (int i = 0; i<5; i++) {
        QCheckBox *btn = self.btnArr[i];
        btn.checked = NO;
    }
}
#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    check[checkbox.tag] = checkbox.checked;
    BOOL flag = NO;
    for (int i =0; i <self.btnArr.count ; i++) {
        QCheckBox *box = self.btnArr[i];
        if (box.selected)
            flag =YES;
    }
    self.awr.enabled = flag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
