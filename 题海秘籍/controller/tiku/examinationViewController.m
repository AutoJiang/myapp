//
//  examinationViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/30.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "examinationViewController.h"
#import "QCheckBox.h"
#import "MBProgressHUD+NJ.h"
#import "readViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define vCount 6               //音频数
static SystemSoundID V[vCount];
static SystemSoundID W;
#define S 2
#define M 2
#define timeLimit 1800

@interface examinationViewController ()
@property (nonatomic ,assign) NSInteger time;
@property (nonatomic ,strong)UIButton *btn;
@property (nonatomic ,strong)NSMutableArray *btnArray;
@property (nonatomic ,strong)NSMutableArray *btnArrayD;

@property (weak, nonatomic) IBOutlet UIButton *item;

@property (nonatomic ,strong)NSMutableArray *temp;
@property (nonatomic ,assign)NSInteger right;
@property (strong ,nonatomic) NSMutableArray *wrong;
@property (nonatomic ,strong)NSMutableArray *check;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic ,assign)NSInteger secondsCountDown;
@property (nonatomic ,strong)NSTimer *countDownTimer;

@property (nonatomic ,assign)NSInteger grade;

@property( nonatomic ,strong) NSMutableArray *array;

@end
@implementation examinationViewController

@synthesize isExam =_isExam;

@synthesize datas =_datas;

-(void)didVoice{
    for (int i = 0 ; i< vCount; i++) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"V_%d.wav",i]withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &V[i]);
    }
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"w.mp3" withExtension:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &W);
}

- (IBAction)getBack:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未完成全部答题，是否确定退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defauts = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:defauts];
    [self presentViewController:alert animated:true completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
}


- (void)viewDidLoad {
    _isExam = YES;
    [super viewDidLoad];
    [self didVoice];
//    [self didBtn];
//    [self setBtnTitle];
    //    self.navigationController.navigationBar.translucent =YES;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.secondsCountDown = timeLimit;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:%02ld",self.secondsCountDown/60,self.secondsCountDown%60];
    self.timeLabel.font= [UIFont systemFontOfSize:self.myfont];
    //    self.timeLabel.style = UIBarButtonItemStyleDone;
    [self setBtnUnable];
    self.resetYes = ^(){
        _secondsCountDown = timeLimit;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        _isExam = YES;
    };
    self.resetNo = ^(){
        _isExam = NO;
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    };
}

-(void)setSwipe{
    if (self.isExam && self.upAllCount < S+M) {
        return;
    }
    [super setSwipe];
}


-(void)autoChange{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNext];
    });
    if (self.upAllCount == S) {
        self.type = 1;
    }
    if (self.upAllCount == S+M) {
        [self setBtnEnable];
        self.isExam = NO;  //开启浏览模式
    }
}

-(void)timeFireMethod{
    self.secondsCountDown--;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:%02ld",self.secondsCountDown/60,self.secondsCountDown%60];
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        [self complete];
    }
}

-(NSMutableArray *)btnArray{
    if (_btnArray ==nil) {
        _btnArray =[[NSMutableArray alloc]init];
    }
    return _btnArray;
}
-(NSMutableArray *)btnArrayD{
    if (_btnArrayD ==nil) {
        _btnArrayD =[NSMutableArray array];
    }
    return _btnArrayD;
}

-(void)complete{
    if (!self.voice) {
        AudioServicesPlaySystemSound(V[5]);
    }
    if (!self.wrong.count) {
        NSString *mge = [NSString stringWithFormat:@"恭喜%@同学,本次考试您获得了%d分的优异成绩。",self.name,(int)self.grade];
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"答题结束。" message:mge preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    NSString *mge = [NSString stringWithFormat:@"%@同学,本次考试您获得了%d分。是否进入错题浏览？",self.name,(int)self.grade];
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"答题结束。" message:mge preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        [self performSegueWithIdentifier:@"examToRead" sender:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    [alert addAction:cancel];
    [alert addAction:defaults];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    readViewController *rv = segue.destinationViewController;
    rv.tpic = [NSMutableArray arrayWithArray:self.wrong];
    rv.record = @"wrong";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)singleTpic{
    if (_singleTpic ==nil) {
        _singleTpic = [[NSMutableArray alloc]init];
    }
    return _singleTpic;
}
-(NSMutableArray *)doubleTpic{
    if (_doubleTpic ==nil) {
        _doubleTpic = [[NSMutableArray alloc]init];
    }
    return _doubleTpic;
}
-(NSMutableArray *)wrong{
    if (_wrong == nil) {
        _wrong = [NSMutableArray array];
    }
    return _wrong;
}
-(NSMutableArray *)datas{
    if ( _datas == nil) {
        _datas = [NSMutableArray array];
        self.array = [self.singleTpic mutableCopy];
        self.tpArray = [NSMutableArray array];
        for(int i = 0 ; i < S ;i++){
            NSInteger n = arc4random()%self.array.count;
            data *da = [[data alloc]init];
            [da dataFromArray:self.array[n]];
            [self.tpArray addObject:self.array[n]];
            [_datas addObject:da];
            [self.array removeObjectAtIndex:n];
        }
        self.array = [self.doubleTpic mutableCopy];
        for(int i = 0 ; i < M ;i++){
            NSInteger n = arc4random() % self.array.count;
            data *da = [[data alloc]init];
            [da dataFromArray:self.array[n]];
            [self.tpArray addObject:self.array[n]];
            [_datas addObject:da];
            [self.array removeObjectAtIndex:n];
        }
    }
    return _datas;
}

-(void)saveToFile{
    return;
}

@end
