//
//  commentViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/7.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "commentViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"
#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height
#define Powder [UIColor colorWithRed:254/255.0 green:124/255.0 blue:148/255.0 alpha:1]
#define addcomment @"/addcomment"
#define lastcomment @"/lastcomment"
#define earlycomment @"/earlycomment"
@interface commentViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *critiqueView;
@property (nonatomic, strong) UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy,nonatomic) NSMutableArray *arrayData;

@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downLoadLast];
    
    self.critiqueView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    self.critiqueView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"所有背景.png"]];
    [self.view addSubview:self.critiqueView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 70, 30)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"输入评论...";
    self.textField.font = [UIFont fontWithName:@"Arial" size:13.0f];
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.returnKeyType = UIReturnKeyGo;
    self.textField.delegate = self;
    //    self.search.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"所有背景.png"]];
    [self.critiqueView addSubview:self.textField];
    
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = CGRectMake(ScreenWidth - 50, 5, 40, 30);
    [button setTitle:@"发送" forState:0];
    [button setTitleColor:Powder forState:0];
    [self.critiqueView  addSubview:button];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(sendMess) forControlEvents:UIControlEventTouchUpInside];
    
    
    //键盘通知
    
    //键盘的frame发生改变时发出的通知（位置和尺寸）
    
    //UIKeyboardWillChangeFrameNotification
    
    //UIKeyboardDidChangeFrameNotification
    
    //键盘显示时发出的通知
    
    //UIKeyboardWillShowNotification
    
    //UIKeyboardDidShowNotification
    
    //键盘隐藏时发出的通知
    
    //UIKeyboardWillHideNotification
    
    //UIKeyboardDidHideNotification
    
    
    
    [[NSNotificationCenter
      defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:)
     name:UIKeyboardWillChangeFrameNotification object:nil];//在这里注册通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 监听方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    //    if (self.picking) return;
    /**
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.critiqueView.y = self.view.height - self.critiqueView.height;//这里的<span style="background-color: rgb(240, 240, 240);">self.toolbar就是我的输入框。</span>
            
        } else {
            self.critiqueView.y = keyboardF.origin.y - self.critiqueView.height;
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.critiqueView.frame = CGRectMake(0, ScreenHeight - 294, ScreenWidth, 40);
        
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMess];
    return YES;
}
- (void)sendMess
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    
    NSString* uid =[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (uid == NULL) {
        NSLog(@"您还未登录!");
        return;
    }
    pram[@"uid"] = [NSString stringWithFormat:@"%@",uid];
    pram[@"comment"]= self.textField.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    pram[@"sendtime"] =date;
    
    NSString *path = [NSString stringWithFormat:@"%@%@",myURL,addcomment];
    [mgr POST:path parameters:pram success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"发送成功!");
        [self downLoadLast];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"服务器出错!");
    }];
}
-(NSMutableArray *)arrayData{
    if (_arrayData==NULL) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
-(void)downLoadLast{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *path = [NSString stringWithFormat:@"%@%@",myURL,lastcomment];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"pos"] = [NSString stringWithFormat:@"%ld",self.arrayData.count];
    [mgr GET:path parameters:param success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSMutableArray *apendArray = responseObject[@"commentArray"];
        [self.arrayData addObjectsFromArray:apendArray];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取数据失败");
    }];
}

#pragma UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"comment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSArray *com = self.arrayData[indexPath.row];
    
    cell.textLabel.text = com[1];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",myURL,com[2]]];
    [cell.imageView sd_setImageWithURL:url];
    cell.detailTextLabel.text = com[3];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


@end
