//
//  orderViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/8.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "orderViewController.h"
#import "ATshowView.h"
#import "data.h"
#import "ATbutton.h"
#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height
#define line 6
#define radius 35

@interface orderViewController ()

@property(weak,nonatomic)UIView *listView;

@property (weak, nonatomic)UIButton *menView;

@property (weak, nonatomic)ATbutton *listBtn;

@property (weak, nonatomic) ATshowView *mainView;

@property (weak, nonatomic) ATshowView *nextView;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (nonatomic ,strong)UISwipeGestureRecognizer *leftSwipe;

@property (nonatomic ,strong)UISwipeGestureRecognizer *rightSwipe;

@property (strong, nonatomic) NSMutableArray *btnArray;

@property (nonatomic ,weak) UIButton *lastBtn;

@property (nonatomic ,assign)NSInteger lastIndex;

@property (nonatomic ,assign)NSInteger rightCount;

@property (nonatomic ,assign)NSInteger wrongCount;

@property (nonatomic ,assign)NSInteger upAllCount;

@property (nonatomic ,weak) ATbutton *rBtn;

@property (weak, nonatomic) ATbutton *wBtn;



@end

@implementation orderViewController

-(void)setSwipe{
    self.leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(loadNext)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(loadLast)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.mainView addGestureRecognizer:self.leftSwipe];
    [self.mainView addGestureRecognizer:self.rightSwipe];
}

-(void)loadNext{
    if (self.index == self.datas.count-1) {
        return;
    }
    [self changeView:1];
}

-(void)loadLast{
    if (self.index == 0) {
        return;
    }
    [self changeView:-1];
}

-(void)changeView:(int)type{
    if (self.lastBtn !=nil) {
         data *da = self.datas[self.lastIndex];
        if (!da.done) {
            [self.lastBtn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    self.index += type;
    data *temp = self.datas[self.index];
    NSLog(@"%@",temp.title);
    UIButton *btn = self.btnArray[self.index];
    if (!temp.done) {
        [btn setBackgroundColor:[UIColor grayColor]];
    }
    self.lastBtn = btn;
    self.lastIndex = self.index;
    
    ATshowView *tpView;
    if (type == 0 && self.mainView ==nil) {
        self.mainView = [self getMainViewInsert:self.menView data:temp];//3
        [self setSwipe];
        return;
    }
    self.nextView = [self getMainViewInsert:self.mainView data:temp];//2
    [self trsanformAnimationIndex:2 withindex:3 type: type ==1? @"pageCurl":@"pageUnCurl"];
    tpView = self.mainView;
    self.mainView = self.nextView;
    [self setSwipe];
    self.nextView = tpView;
    [self.nextView removeFromSuperview];
}

-(void)trsanformAnimationIndex:(NSInteger )indexA withindex:(NSInteger)indexB type:(NSString *)type{
    CATransition* transition = [CATransition animation];
    //动画持续时间
    transition.duration = 0.75;
    //进出减缓
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //动画效果
    transition.type = type;
    transition.delegate = self;

    [self.view.layer addAnimation:transition forKey:nil];
    //view之间的切换
    [self.view exchangeSubviewAtIndex:indexA withSubviewAtIndex:indexB];
}

-(ATshowView *)getMainViewInsert:(UIView *)belowSubview data:(data *)temp{
    ATshowView *mainView=[[ATshowView alloc]initWithFrame:CGRectMake(0,44, screenWidth, screenHeight*0.9-44) withFont:self.font data:temp];
    mainView.showType = self.type;
    [self.view insertSubview:mainView belowSubview:belowSubview];
    [mainView reloadData:temp];
    mainView.addWrong = ^(){
        if([self.delegate respondsToSelector:@selector(saveWrongTpic:wrong:)]){
            [self.delegate saveWrongTpic:self wrong:self.tpArray[self.index]];
        }
        [self changeBtnStatus];
        _wrongCount++;
        _upAllCount++;
        [self reflashToolBtn];
    };
    mainView.deleteRight = ^(){
        [self delRight];
        [self changeBtnStatus];
        _rightCount++;
        _upAllCount++;
        [self reflashToolBtn];
    };
    return mainView;
}
-(void)delRight{
    return;
}

-(void)changeBtnStatus{
    UIButton *btn = self.btnArray[self.index];
    data *da = self.datas[self.index];
    if (da.isRight) {
        [btn setBackgroundColor:[UIColor greenColor]];
    }else{
        [btn setBackgroundColor:[UIColor redColor]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self changeView:0];
}

-(void)reflashToolBtn{
    [self.rBtn setTitle:[NSString stringWithFormat:@"%ld",_rightCount] forState:UIControlStateNormal];
    [self.wBtn setTitle:[NSString stringWithFormat:@"%ld",_wrongCount] forState:UIControlStateNormal];
    [self.listBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",_upAllCount,self.datas.count] forState:UIControlStateNormal];
}

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
    listView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:listView];
    _listView = listView;
    
    ATbutton *rBtn = [ATbutton buttonWithType:UIButtonTypeCustom];
    rBtn.center= CGPointMake( screenWidth*0.1,22);
    rBtn.size = CGSizeMake(45, 15);
    rBtn.userInteractionEnabled = NO;
    [rBtn setImage:[UIImage imageNamed:@"SuccessIcon"] forState:UIControlStateNormal];
    [rBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [listView addSubview:rBtn];
    _rBtn = rBtn;
    
    ATbutton *wBtn = [ATbutton buttonWithType:UIButtonTypeCustom];
    wBtn.center= CGPointMake( screenWidth*0.35,22);
    wBtn.size = CGSizeMake(45, 15);
    wBtn.userInteractionEnabled = NO;
    [wBtn setImage:[UIImage imageNamed:@"ErrorIcon"] forState:UIControlStateNormal];
    [wBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [listView addSubview:wBtn];
    _wBtn = wBtn;
    
    ATbutton *listBtn = [ATbutton buttonWithType:UIButtonTypeCustom];
    listBtn.center = CGPointMake( screenWidth*0.6,10);
    listBtn.size = CGSizeMake(100, 40);
    [listBtn setImage:[UIImage imageNamed:@"tool_3"] forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(listShow) forControlEvents:UIControlEventTouchUpInside];
    [listView addSubview:listBtn];
    _listBtn = listBtn;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, screenHeight*0.1, screenHeight, screenHeight*0.7)];

    CGFloat mag = (screenWidth - radius*line)/7;
    
    for (int i = 0 ; i < self.datas.count;){
        for (int j = 0; j < line; j++,i++) {
            if(i== self.datas.count)
                break;
            CGFloat posX = (mag+radius)*j+mag;
            CGFloat posY = (mag+radius)*(i/line)+mag;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame=CGRectMake(posX, posY, radius,radius);
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.tag = i;
            button.layer.cornerRadius = 8.f;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor grayColor].CGColor;
            button.layer.borderWidth = 1;
            button.alpha = 0.5;
            [button addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
            [self.btnArray addObject:button];
        }
    }
    CGFloat conentHeight = mag + ((self.datas.count+line-1)/line)*(mag+radius);
    scrollView.contentSize = CGSizeMake(screenWidth, conentHeight);
    scrollView.showsHorizontalScrollIndicator= YES;
    scrollView.showsVerticalScrollIndicator = YES;

    [self.listView addSubview:scrollView];
    _scrollView = scrollView;
    
    [self redoneBtn];//加载按钮状态.
    [self load];
    [self reflashToolBtn];
    
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setImage:[UIImage imageNamed:@"header_icon_back"] forState:UIControlStateNormal];
    lButton.frame = CGRectMake(0, 0, 30, 50);
    [lButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:lButton];;
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame = CGRectMake(0, 0, 90, 30);
    [rButton setTitle:@"提交/重置" forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(resetData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)resetData{
    self.datas = nil;
    _index = 0;
    NSString *path = [self filePath];
    [NSKeyedArchiver archiveRootObject:_datas toFile:path];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger :_index forKey:self.record];
    _index = -1;
    [self changeView:1];
    [self redoneBtn];
}

-(void)goBack{
    NSString *path = [self filePath];
    [NSKeyedArchiver archiveRootObject:self.datas toFile:path];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger :self.index forKey:self.record];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)chooseBtn:(UIButton *)btn{
    self.index = btn.tag-1;
    [self listShow];
    [self changeView:1];
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
-(void)redoneBtn{
    for (UIButton *btn in self.scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            long i = btn.tag;
            data *da = self.datas[i];
            if (da.done) {
                if (da.isRight) {
                    [btn setBackgroundColor:[UIColor greenColor]];
                }else{
                    [btn setBackgroundColor:[UIColor redColor]];
                }
            }else{
                [btn setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }
}

-(NSMutableArray *)datas{
    if (_datas == nil) {
        NSString *path = [self filePath];
        _datas = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (_datas ==nil||_datas.count==0) {
            _datas = [NSMutableArray array];
            for(int i = 0 ; i < self.tpArray.count; i++) {
                data *da = [[data alloc]init];
                [da dataFromArray:self.tpArray[i]];
                [_datas addObject:da];
            }
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:self.record]!=nil) {
            self.index = [defaults integerForKey:self.record];
        }
    }
    return _datas;
}

-(void)load{
    for (int i = 0; i < self.datas.count; i++) {
        data *da = self.datas[i];
        if (da.done) {
            if (da.isRight) {
                _rightCount++;
            }else{
                _wrongCount++;
            }
            _upAllCount++;
        }
    }
}

-(NSMutableArray *)btnArray{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

-(NSString *)filePath{
    NSString *pa = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return [pa stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",self.record]];
}
@end
