//
//  EFAnimationViewController.m
//  aaatest
//
//  Created by jiang aoteng on 15/9/10.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "animationViewController.h"
#import "sctionSelectTable.h"
#import "userDefault.h"
#import "subject.h"
#import "MBProgressHUD+NJ.h"
#import "ATFileDownloader.h"
#define RADIUS 100.0
#define PHOTONUM 5
#define TAGSTART 1000
#define TIME 0.7
#define SCALENUMBER 1.25
NSInteger array [PHOTONUM][PHOTONUM] = {
    {0,1,2,3,4},
    {4,0,1,2,3},
    {3,4,0,1,2},
    {2,3,4,0,1},
    {1,2,3,4,0}
};

@interface animationViewController ()<EFItemViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *vioceBtn;
@property (weak, nonatomic) IBOutlet UIButton *shakeBtn;

@property (nonatomic, assign) NSInteger currentTag;

@property (nonatomic, strong) NSArray *bookarray;

@property (nonatomic, strong) NSString *selcetedBook;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSMutableArray *bookName;

@property (nonatomic ,strong)UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic ,strong)UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic ,strong)UISwipeGestureRecognizer *upSwipe;
@property (nonatomic ,strong)UISwipeGestureRecognizer *downSwipe;

@property (nonatomic ,strong)userDefault *user;
@property (nonatomic ,strong)subject *sub;

@end

@implementation animationViewController

CATransform3D rotationTransform1[PHOTONUM];


-(void)setSwipe{
    self.leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(commitSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(commitSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(commitSwipe:)];
    self.upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    
    self.downSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(commitSwipe:)];
    self.downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:self.leftSwipe];
    [self.view addGestureRecognizer:self.rightSwipe];
    [self.view addGestureRecognizer:self.upSwipe];
    [self.view addGestureRecognizer:self.downSwipe];
}
-(void)commitSwipe:(UISwipeGestureRecognizer *)swip{
    NSInteger index = self.currentTag;
    if ([swip isEqual:self.leftSwipe]||[swip isEqual:self.downSwipe]) {
        index--;
        if (index == TAGSTART -1) {
            index = TAGSTART +4;
        }
    }
    else if([swip isEqual:self.rightSwipe]||[swip isEqual:self.upSwipe]){
        index++;
        if (index == TAGSTART +5) {
            index = TAGSTART;
        }
    }
    [self didTapped:index];
}
- (void)voiceTouchDown:(UIButton *)sender {
    if (self.vioceBtn.selected) {
        self.vioceBtn.selected = NO;
    }
    else
        self.vioceBtn.selected = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.selected forKey:self.user.voice];
}
- (void)shakeTouchDown:(UIButton *)sender {

    if (self.shakeBtn.selected) {
        self.shakeBtn.selected = NO;
    }else
        self.shakeBtn.selected = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.selected forKey:self.user.shake];
}


-(NSArray *)bookarray{
    if (_bookarray == nil) {
        _bookarray = self.sub.bookarr;
    }
    return _bookarray;
}

-(userDefault *)user{
    if (_user==nil) {
        _user = [[userDefault alloc]init];
    }
    return _user;
}
-(subject *)sub{
    if (_sub == nil) {
        _sub = [[subject alloc]init];
    }
    return _sub;
}

-(NSMutableArray *)bookName{
    if (_bookName == nil) {
        _bookName = self.sub.bookName;
    }
    return _bookName;
}



-(void)checkNewDB {
    ATFileDownloader *fileDownloader = [[ATFileDownloader alloc]init];
    fileDownloader.url = @"http://www.slotus.cc/tiku.db";
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES)lastObject];
    filePath = [filePath stringByAppendingString:@"/tiku.db"];
    NSLog(@"%@",filePath);
    fileDownloader.destPath = filePath;
    [fileDownloader start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self setSwipe];
    [self.view addSubview:self.label];
    [self.vioceBtn addTarget:self action:@selector(voiceTouchDown:) forControlEvents:(UIControlEventTouchDown)];
    [self.shakeBtn addTarget:self action:@selector(shakeTouchDown:) forControlEvents:(UIControlEventTouchDown)];
    [self.view addSubview:self.vioceBtn];
    [self.view addSubview:self.shakeBtn];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.vioceBtn.selected = [defaults boolForKey:self.user.voice];
    self.shakeBtn.selected = [defaults boolForKey:self.user.shake];
    [self checkNewDB];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    sctionSelectTable *sc = segue.destinationViewController;
//    NSLog(@"%d",self.currentTag);
    sc.bookName = self.selcetedBook;
    sc.index = self.currentTag - TAGSTART;
    sc.title = self.bookName[sc.index];
    sc.voice = self.vioceBtn.selected;
    sc.shake = self.shakeBtn.selected;
    sc.name = self.name;
}
- (IBAction)voiceBtnOnlick:(id)sender {
    if (self.vioceBtn.selected) {
        [MBProgressHUD showError:@"音效关闭"];
    }else
        [MBProgressHUD showSuccess:@"音效开启"];
}
- (IBAction)shakeBtnOnclick:(id)sender {
    if (self.shakeBtn.selected) {
        [MBProgressHUD showError:@"震动关闭"];
    }else
        [MBProgressHUD showSuccess:@"震动开启"];
}

#pragma mark - configViews 

- (void)configViews {
    NSArray *dataArray = self.sub.image;
    
    CGFloat centery = self.view.center.y - 50;
    CGFloat centerx = self.view.center.x;
    
    for (NSInteger i = 0;i < PHOTONUM;i++) {
        CGFloat tmpy =  centery + RADIUS*cos(2.0*M_PI *i/PHOTONUM);
        CGFloat tmpx =	centerx - RADIUS*sin(2.0*M_PI *i/PHOTONUM);
        EFItemView *view = [[EFItemView alloc] initWithNormalImage:dataArray[i] highlightedImage:[dataArray[i] stringByAppendingFormat:@"%@", @"_hover"] tag:TAGSTART+i title:nil];
        view.frame = CGRectMake(0.0, 0.0,118,118);
        view.center = CGPointMake(tmpx,tmpy);
        view.delegate = self;
        rotationTransform1[i] = CATransform3DIdentity;
        
        CGFloat Scalenumber = fabs(i - PHOTONUM/2.0)/(PHOTONUM/2.0);
        if (Scalenumber < 0.3) {
            Scalenumber = 0.4;
        }
        CATransform3D rotationTransform = CATransform3DIdentity;
        rotationTransform = CATransform3DScale (rotationTransform, Scalenumber*SCALENUMBER,Scalenumber*SCALENUMBER, 1);
        view.layer.transform=rotationTransform;
        [self.view addSubview:view];
        
    }
    self.currentTag = TAGSTART;
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.25,self.view.frame.size.height*0.8, self.view.frame.size.width*0.5 ,0.08*self.view.frame.size.height)];
    self.label.text = self.bookName[0];
    self.label.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - EFItemViewDelegate

- (void)didTapped:(NSInteger)index {
    self.label.text = self.bookName[index - TAGSTART];
    if (self.currentTag  == index) {
//        NSLog(@"自定义处理事件");
//        NSLog(@"%d",index);
        self.selcetedBook = self.bookarray[index - TAGSTART];
        [self performSegueWithIdentifier:@"bookToChapter" sender:nil];
        return;
    }
    
    NSInteger t = [self getIemViewTag:index];
    
    for (NSInteger i = 0;i<PHOTONUM;i++ ) {
        
        UIView *view = [self.view viewWithTag:TAGSTART+i];
        [view.layer addAnimation:[self moveanimation:TAGSTART+i number:t] forKey:@"position"];
        [view.layer addAnimation:[self setscale:TAGSTART+i clicktag:index] forKey:@"transform"];
        
        NSInteger j = array[index - TAGSTART][i];
        CGFloat Scalenumber = fabs(j - PHOTONUM/2.0)/(PHOTONUM/2.0);
        if (Scalenumber < 0.3) {
            Scalenumber = 0.4;
        }
    }
    self.currentTag  = index;
}

- (CAAnimation*)setscale:(NSInteger)tag clicktag:(NSInteger)clicktag {
    
    NSInteger i = array[clicktag - TAGSTART][tag - TAGSTART];
    NSInteger i1 = array[self.currentTag  - TAGSTART][tag - TAGSTART];
    CGFloat Scalenumber = fabs(i - PHOTONUM/2.0)/(PHOTONUM/2.0);
    CGFloat Scalenumber1 = fabs(i1 - PHOTONUM/2.0)/(PHOTONUM/2.0);
    if (Scalenumber < 0.3) {
        Scalenumber = 0.4;
    }
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = TIME;
    animation.repeatCount =1;
    
    CATransform3D dtmp = CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber*SCALENUMBER, Scalenumber*SCALENUMBER, 1.0);
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber1*SCALENUMBER,Scalenumber1*SCALENUMBER, 1.0)];
    animation.toValue = [NSValue valueWithCATransform3D:dtmp ];
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

- (CAAnimation*)moveanimation:(NSInteger)tag number:(NSInteger)num {
    // CALayer
    UIView *view = [self.view viewWithTag:tag];
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animation];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,view.layer.position.x,view.layer.position.y);
    
    NSInteger p =  [self getIemViewTag:tag];
    CGFloat f = 2.0*M_PI  - 2.0*M_PI *p/PHOTONUM;
    CGFloat h = f + 2.0*M_PI *num/PHOTONUM;
    CGFloat centery = self.view.center.y - 50;
    CGFloat centerx = self.view.center.x;
    CGFloat tmpy =  centery + RADIUS*cos(h);
    CGFloat tmpx =	centerx - RADIUS*sin(h);
    view.center = CGPointMake(tmpx,tmpy);
    
    BOOL clockwise = num<3 ?0:1;
    
    CGPathAddArc(path,nil,self.view.center.x, self.view.center.y - 50,RADIUS,f+ M_PI/2,f+ M_PI/2 + 2.0*M_PI *num/PHOTONUM,clockwise);
    animation.path = path;
    CGPathRelease(path);
    animation.duration = TIME;
    animation.repeatCount = 1;
    animation.calculationMode = @"paced"; 	
    return animation;
}

- (NSInteger)getIemViewTag:(NSInteger)tag {
    
    if (self.currentTag >tag){
        return self.currentTag  - tag;
    } else {
        return PHOTONUM  - tag + self.currentTag ;
    }
}

@end




@interface EFItemView ()

@property (nonatomic, strong) NSString *normal;
@property (nonatomic, strong) NSString *highlighted_;
@property (nonatomic, assign) NSInteger tag_;
@property (nonatomic, strong) NSString *title;

@end

@implementation EFItemView

- (instancetype)initWithNormalImage:(NSString *)normal highlightedImage:(NSString *)highlighted tag:(NSInteger)tag title:(NSString *)title {
    
    self = [super init];
    if (self) {
        _normal = normal;
        _highlighted_ = highlighted;
        _tag_ = tag;
        _title = title;
        [self configViews];
    }
    return self;
}

#pragma mark - configViews

- (void)configViews {
    
    self.tag = _tag_;
    [self setBackgroundImage:[UIImage imageNamed:_normal] forState:UIControlStateNormal];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setBackgroundImage:[UIImage imageNamed:_highlighted_] forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self setTitle:_title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:30.0]];
}

- (void)btnTapped:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapped:)]) {
        [self.delegate didTapped:sender.tag];
    }
}
@end

