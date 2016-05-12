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
#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height
#define line 6
#define radius 30

@interface orderViewController ()


@property(weak,nonatomic)UIView *listView;

@property (weak, nonatomic)UIButton *menView;

@property (weak, nonatomic)UIButton *listBtn;

@property (weak, nonatomic) ATshowView *mainView;

@property (weak, nonatomic) ATshowView *nextView;

@property (assign, nonatomic) NSInteger index;

@property (strong,nonatomic)NSMutableArray *wrong;

@property (copy, nonatomic) NSMutableArray *datas;

@property (nonatomic ,strong)UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic ,strong)UISwipeGestureRecognizer *rightSwipe;

@end

@implementation orderViewController

-(void)setSwipe{
    self.leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(loadNext)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(loadLast)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipe];
    [self.view addGestureRecognizer:self.rightSwipe];
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
    self.index += type;
    data *temp = self.datas[self.index];
    NSLog(@"%@",temp.title);
    ATshowView *tpView;
    if (type == 0 && self.mainView ==nil) {
        self.mainView = [self getMainViewInsert:self.menView data:temp];//3
        self.mainView.backgroundColor = [UIColor yellowColor];
        return;
    }
    self.nextView = [self getMainViewInsert:self.mainView data:temp];//2
    [self trsanformAnimationIndex:2 withindex:3 type: type ==1? @"pageCurl":@"pageUnCurl"];
    tpView = self.mainView;
    self.mainView = self.nextView;
    self.nextView = tpView;
    [self.nextView removeFromSuperview];
}

-(void)trsanformAnimationIndex:(NSInteger )indexA withindex:(NSInteger)indexB type:(NSString *)type{
    CATransition* transition = [CATransition animation];
    //动画持续时间
    transition.duration = 1;
    //进出减缓
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    //动画效果
    transition.type = type;
//    transition.subtype = @"fromUp";
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
        [self.wrong addObject:self.tpArray[self.index]];
    };
    return mainView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self changeView:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSwipe];
    
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
    
    for (int i = 0 ; i < self.datas.count;){
        for (int j = 0; j < line; j++,i++) {
            if(i== self.datas.count)
                break;
            CGFloat posX = (mag+radius)*j+mag;
            CGFloat posY = (mag+radius)*(i/line)+mag;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(posX, posY, radius,radius);
            button.backgroundColor = [UIColor greenColor];
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [scrollView addSubview:button];
            button.tag = i;
            [button addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    CGFloat conentHeight = mag + ((self.datas.count+line-1)/line)*(mag+radius);
    scrollView.contentSize = CGSizeMake(screenWidth, conentHeight);
    [self.listView addSubview:scrollView];
    
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
}
-(void)goBack{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未完成全部答题，是否保存错题并退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defauts = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(saveWrongTpic:wrong:)]) {
            [self.delegate saveWrongTpic:self wrong:self.wrong];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:defauts];
    [self presentViewController:alert animated:true completion:nil];
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
-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        for (int i = 0 ; i < self.tpArray.count; i++) {
            data *da = [[data alloc]init];
            [da dataFromArray:self.tpArray[i]];
            [_datas addObject:da];
        }
        self.index = 0;
    }
    return _datas;
}

-(NSMutableArray *)wrong{
    if (_wrong ==nil) {
        _wrong = [NSMutableArray array];
    }
    return _wrong;
}
@end
