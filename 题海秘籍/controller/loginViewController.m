//
//  loginViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/10.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "loginViewController.h"
#import "MBProgressHUD+NJ.h"
#import "userDefault.h"
#import "animationViewController.h"
#import "myTableViewController.h"
#import "UIView+Extension.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

@interface loginViewController ()
@property (weak, nonatomic) UITextField *nameField;
@property (weak, nonatomic) UITextField *keyField;

@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) UIButton *regist;
@property (weak, nonatomic) IBOutlet UISwitch *leftBtn;
@property (weak, nonatomic) IBOutlet UISwitch *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (strong, nonatomic)userDefault *user;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UITextField *regName;
@property (weak, nonatomic) UITextField *regPwd;
@property (weak, nonatomic) UITextField *regPwd2;

@property (nonatomic,assign) bool type;

@end

@implementation loginViewController

//登录和注册的点击功能
- (IBAction)loginBtn:(UIButton*)sender {
    if (!self.regist.selected) {
        [MBProgressHUD showMessage:@"正在拼命加载"];
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"name"]= self.nameField.text;
        NSString *md5 = [self md5:self.keyField.text];
        params[@"password"] = md5;
        [mgr POST:@"http://localhost:8080/myapp/login" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSString *result = responseObject[@"result"] ;
            [MBProgressHUD hideHUD];
            if ([result isEqualToString:@"1"]) {
//                [MBProgressHUD showSuccess:@"登录成功！"];
                [self performSegueWithIdentifier:@"loginTomy" sender:nil];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.nameField.text forKey:self.user.name];
                [defaults setObject:self.keyField.text forKey:self.user.key];
                [defaults setBool:self.leftBtn.on forKey:self.user.leftSwicth];
                [defaults setBool:self.rightBtn.on forKey:self.user.rightSwicth];
            }else{
                [MBProgressHUD showError:@"账号或密码错误！"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"登录失败，网络请求出错!"];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });

    }else{ //注册
        if (self.regName.text.length<3) {
            [MBProgressHUD showError:@"账号名不能小于3个字符！"];
            return ;
        }
        if (self.regPwd.text.length<6) {
            [MBProgressHUD showError:@"密码长度不能小于6个字符！"];
            return ;
        }
        if (![self.regPwd.text isEqualToString:self.regPwd2.text]) {
            [MBProgressHUD showError:@"两次密码不一致"];
            return ;
        }
        [MBProgressHUD showMessage:@"注册中..."];
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"name"]= self.regName.text;
        NSString *md5 = [self md5:self.regPwd.text];
        params[@"password"] = md5;
        [mgr POST:@"http://localhost:8080/myapp/regist" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSString *result = responseObject[@"result"] ;
            if ([result isEqualToString:@"1"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"注册成功！"];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"注册失败，该账号已经被注册！"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"注册失败，网络请求出错!"];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }
    
}

-(void)switchType{
    
    if (self.regist.selected) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        self.regist.selected = NO;
        [self.login setTitle:@"登录" forState:UIControlStateNormal];
        //动画效果
        CGFloat dis = self.leftLabel.x + self.leftLabel.width;
        [UIView animateWithDuration:0.75 animations:^{
            self.leftLabel.transform = CGAffineTransformMakeTranslation(dis, 0);
            self.leftBtn.transform = CGAffineTransformMakeTranslation(dis, 0);
            self.rightLabel.transform = CGAffineTransformMakeTranslation(-dis,0);
            self.rightBtn.transform = CGAffineTransformMakeTranslation(-dis,0);
            [self.leftBtn setAlpha:0.5];
            [self.leftLabel setAlpha:0.5];
            [self.rightBtn setAlpha:0.5];
            [self.rightLabel setAlpha:0.5];
        }];
    

        [CATransaction commit];

    }else{
        [self.scrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
        self.regist.selected = YES;
        [self.login setTitle:@"注册" forState:UIControlStateNormal];
        self.login.enabled = YES;
        //动画效果
        CGFloat dis = self.leftLabel.x + self.leftLabel.width;
        [UIView animateWithDuration:0.75 animations:^{
            
            self.leftLabel.transform = CGAffineTransformMakeTranslation(-dis, 0);
            self.leftBtn.transform = CGAffineTransformMakeTranslation(-dis, 0);
            self.rightLabel.transform = CGAffineTransformMakeTranslation(dis,0);
            self.rightBtn.transform = CGAffineTransformMakeTranslation(dis,0);
            [self.leftBtn setAlpha:0];
            [self.leftLabel setAlpha:0];
            [self.rightBtn setAlpha:0];
            [self.rightLabel setAlpha:0];
        }];
        

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubView];
    // Do any additional setup after loading the view.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameField];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.keyField];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.leftBtn.on = [defaults boolForKey:self.user.leftSwicth];
    self.rightBtn.on = [defaults boolForKey:self.user.rightSwicth];
    self.nameField.text = [defaults objectForKey:self.user.name];
    if (self.leftBtn.on) {
        self.keyField.text = [defaults objectForKey:self.user.key];
    }
    [self textChange];
    if (self.rightBtn.on) {
        [self loginBtn:nil];
        [MBProgressHUD hideHUD];
    }
}

-(void)setSubView{
    
    float W = self.view.width;
    float H = self.view.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0.18*H, W,H*0.3 )];
    scrollView.contentSize = CGSizeMake( W*2 ,scrollView.height );
//    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.pagingEnabled =YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    UILabel *lableA = [[UILabel alloc]initWithFrame:CGRectMake(W*1.02, _scrollView.height*0.1, W*0.15, _scrollView.height*0.2)];
    lableA.textAlignment = NSTextAlignmentRight;
    lableA.alpha = 0.5;
    lableA.textColor = [UIColor whiteColor];
    lableA.text = @"账号:";
    [self.scrollView addSubview:lableA];
    
    UILabel *lableB = [[UILabel alloc]initWithFrame:CGRectMake(W*1.02, _scrollView.height*0.4, W*0.15, _scrollView.height*0.2)];
    lableB.textAlignment = NSTextAlignmentRight;
    lableB.alpha = 0.5;
    lableB.textColor = [UIColor whiteColor];
    lableB.text = @"密码:";
    [self.scrollView addSubview:lableB];
    
    UILabel *lableC = [[UILabel alloc]initWithFrame:CGRectMake(W*1.02, _scrollView.height*0.7, W*0.15, _scrollView.height*0.2)];
    lableC.textAlignment = NSTextAlignmentRight;
    lableC.alpha = 0.5;
    lableC.textColor = [UIColor whiteColor];
    lableC.text = @"确认:";
    [self.scrollView addSubview:lableC];
    
    UITextField *textA = [[UITextField alloc]initWithFrame:CGRectMake(W*1.2, _scrollView.height*0.1, W*0.75, _scrollView.height*0.2)];
    textA.placeholder = @"请输入账号/昵称";
    textA.borderStyle = UITextBorderStyleRoundedRect;
    textA.alpha = 0.5;
    textA.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:textA];
    _regName = textA;
    
    UITextField *textB = [[UITextField alloc]initWithFrame:CGRectMake(W*1.2, _scrollView.height*0.4, W*0.75, _scrollView.height*0.2)];
    textB.placeholder = @"请输入密码";
    textB.borderStyle = UITextBorderStyleRoundedRect;
    textB.alpha = 0.5;
    textB.backgroundColor = [UIColor whiteColor];
    textB.secureTextEntry = YES;
    [self.scrollView addSubview:textB];
    _regPwd = textB;
    
    UITextField *textC = [[UITextField alloc]initWithFrame:CGRectMake(W*1.2, _scrollView.height*0.7, W*0.75, _scrollView.height*0.2)];
    textC.placeholder = @"请确认密码";
    textC.borderStyle = UITextBorderStyleRoundedRect;
    textC.alpha = 0.5;
    textC.backgroundColor = [UIColor whiteColor];
    textC.secureTextEntry = YES;
    [self.scrollView addSubview:textC];
    _regPwd2 = textC;
    
    UILabel *lableD = [[UILabel alloc]initWithFrame:CGRectMake(W*0.02, _scrollView.height*0.1, W*0.15, _scrollView.height*0.2)];
    lableD.textAlignment = NSTextAlignmentRight;
    lableD.alpha = 0.5;
    lableD.textColor = [UIColor whiteColor];
    lableD.text = @"账号:";
    [self.scrollView addSubview:lableD];
    
    UILabel *lableE = [[UILabel alloc]initWithFrame:CGRectMake(W*0.02, _scrollView.height*0.4, W*0.15, _scrollView.height*0.2)];
    lableE.textAlignment = NSTextAlignmentRight;
    lableE.alpha = 0.5;
    lableE.textColor = [UIColor whiteColor];
    lableE.text = @"密码:";
    [self.scrollView addSubview:lableE];
    
    UITextField *textD = [[UITextField alloc]initWithFrame:CGRectMake(W*0.2, _scrollView.height*0.1, W*0.75, _scrollView.height*0.2)];
    textD.placeholder = @"请输入账号/昵称";
    textD.borderStyle = UITextBorderStyleRoundedRect;
    textD.alpha = 0.5;
    textD.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:textD];
    _nameField =textD;
    
    UITextField *textE = [[UITextField alloc]initWithFrame:CGRectMake(W*0.2, _scrollView.height*0.4, W*0.75, _scrollView.height*0.2)];
    textE.placeholder = @"请输入密码";
    textE.borderStyle = UITextBorderStyleRoundedRect;
    textE.alpha = 0.5;
    textE.backgroundColor = [UIColor whiteColor];
    textE.secureTextEntry = YES;
    [self.scrollView addSubview:textE];
    _keyField = textE;
    
    UIButton *regist = [UIButton buttonWithType:UIButtonTypeCustom];
    regist.frame = CGRectMake(0.1*W, 0.73*H, 0.8*W, 0.1*H);
    [regist setTitle:@"没有学霸账号？去注册！" forState:UIControlStateNormal];
    [regist setTitle:@"已有学霸账号？去登录！" forState:UIControlStateSelected];
    regist.alpha = 0.5;
    regist.titleLabel.textAlignment = NSTextAlignmentCenter;
    [regist addTarget:self action:@selector(switchType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regist];
    _regist = regist;
}

-(userDefault *)user{
    if (_user==nil) {
        _user = [[userDefault alloc]init];
    }
    return _user;
}

-(void)textChange{
    self.login.enabled =(self.nameField.text.length && self.keyField.text.length);
}
- (IBAction)resignKeyborad:(id)sender {
    [self.nameField resignFirstResponder];
    [self.keyField resignFirstResponder];
    [self.regName resignFirstResponder];
    [self.regPwd resignFirstResponder];
    [self.regPwd2 resignFirstResponder];
}

- (IBAction)leftSwitchOnclick:(id)sender {
    if (!self.leftBtn.on) {
        [self.rightBtn setOn:NO animated:true];
    }
}
- (IBAction)rightSwitchOnlick:(id)sender {
    if (self.rightBtn) {
        [self.leftBtn setOn:YES animated:true];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[animationViewController class]]) {
        animationViewController *vc = segue.destinationViewController;
        vc.name = self.nameField.text;
    }
    if ([segue.destinationViewController isKindOfClass:[myTableViewController class]]) {
        myTableViewController *mc = segue.destinationViewController;
        mc.username = self.nameField.text;
    }
}

@end
