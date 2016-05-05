//
//  myTableViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/4/30.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "myTableViewController.h"
#import "myTableViewCell.h"
#import "user.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD+NJ.h"
#import "myprofileViewController.h"

@interface myTableViewController ()<UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic)user *user;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@end

@implementation myTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self.nameBtn setTitle:self.username forState:UIControlStateNormal];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(IBAction)outLogin:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定要注销?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [sheet showInView:self.view];
}
- (IBAction)btnOnclick:(id)sender {
    [self performSegueWithIdentifier:@"myToprofile" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"username"] = self.username;
    [mgr GET:@"http:localhost:8080/myapp/getuser" parameters:(param) success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        _user = [user objectWithKeyValues:responseObject];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"detailCell";
    myTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"myTableViewCell" owner:nil options:nil]firstObject];
    }
    if (indexPath.row == 0) {//思修
        double average = 0;
        if (self.self.user.sx_timex!=0) {
            average= self.user.sx_sum*1.0/self.user.sx_timex;
        }
        cell.majorLabel.text = @"思修刷题纪录:";
        cell.averageLabel.text = [NSString stringWithFormat:@"平均分：%.1lf",average];
        cell.timesLabel.text = [NSString stringWithFormat:@"章节练习次数：%d",self.user.sx_times];
        cell.timexLabel.text = [NSString stringWithFormat:@"模拟考试次数：%d",self.user.sx_timex];
        cell.errorLabel.text = [NSString stringWithFormat:@"当前错题数：%d",self.user.sx_error];
        cell.maxLabel.text =   [NSString stringWithFormat:@"最高分：%d",self.user.sx_max];
        cell.minLabel.text =   [NSString stringWithFormat:@"最低分：%d",self.user.sx_min];
    }
    else if (indexPath.row == 1){//马克思
        double average = 0;
        if (self.self.user.mks_timex!=0) {
            average= self.user.mks_sum*1.0/self.user.mks_timex;
        }
        cell.majorLabel.text = @"马克思刷题纪录:";
        cell.averageLabel.text = [NSString stringWithFormat:@"平均分：%.1lf",average];
        cell.timesLabel.text = [NSString stringWithFormat:@"章节练习次数：%d",self.user.mks_times];
        cell.timexLabel.text = [NSString stringWithFormat:@"模拟考试次数：%d",self.user.mks_timex];
        cell.errorLabel.text = [NSString stringWithFormat:@"当前错题数：%d",self.user.mks_error];
        cell.maxLabel.text =   [NSString stringWithFormat:@"最高分：%d",self.user.mks_max];
        cell.minLabel.text =   [NSString stringWithFormat:@"最低分：%d",self.user.mks_min];
    }
    else if (indexPath.row == 2){//近代史
        double average = 0;
        if (self.self.user.jds_timex!=0) {
            average= self.user.jds_sum*1.0/self.user.jds_timex;
        }
        cell.majorLabel.text = @"近代史刷题纪录:";
        cell.averageLabel.text = [NSString stringWithFormat:@"平均分：%.1lf",average];
        cell.timesLabel.text = [NSString stringWithFormat:@"章节练习次数：%d",self.user.jds_times];
        cell.timexLabel.text = [NSString stringWithFormat:@"模拟考试次数：%d",self.user.jds_timex];
        cell.errorLabel.text = [NSString stringWithFormat:@"当前错题数：%d",self.user.jds_error];
        cell.maxLabel.text =   [NSString stringWithFormat:@"最高分：%d",self.user.jds_max];
        cell.minLabel.text =   [NSString stringWithFormat:@"最低分：%d",self.user.jds_min];
    }
    else if (indexPath.row == 3){//毛概1
        cell.majorLabel.text = @"毛概上刷题纪录:";
        double average = 0;
        if (self.self.user.mg_timex!=0) {
            average= self.user.mg_sum*1.0/self.user.mg_timex;
        }
        cell.averageLabel.text = [NSString stringWithFormat:@"平均分：%.1lf",average];
        cell.timesLabel.text = [NSString stringWithFormat:@"章节练习次数：%d",self.user.mg_times];
        cell.timexLabel.text = [NSString stringWithFormat:@"模拟考试次数：%d",self.user.mg_timex];
        cell.errorLabel.text = [NSString stringWithFormat:@"当前错题数：%d",self.user.mg_error];
        cell.maxLabel.text =   [NSString stringWithFormat:@"最高分：%d",self.user.mg_max];
        cell.minLabel.text =   [NSString stringWithFormat:@"最低分：%d",self.user.mg_min];
    }
    else if(indexPath.row == 4){//毛概2
        cell.majorLabel.text = @"毛概下刷题纪录:";
        double average = 0;
        if (self.self.user.mg2_timex!=0) {
            average= self.user.mg2_sum*1.0/self.user.mg2_timex;
        }
        cell.averageLabel.text = [NSString stringWithFormat:@"平均分：%.1lf",average];
        cell.timesLabel.text = [NSString stringWithFormat:@"章节练习次数：%d",self.user.mg2_times];
        cell.timexLabel.text = [NSString stringWithFormat:@"模拟考试次数：%d",self.user.mg2_timex];
        cell.errorLabel.text = [NSString stringWithFormat:@"当前错题数：%d",self.user.mg2_error];
        cell.maxLabel.text =   [NSString stringWithFormat:@"最高分：%d",self.user.mg2_max];
        cell.minLabel.text =   [NSString stringWithFormat:@"最低分：%d",self.user.mg2_min];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    myprofileViewController *my = segue.destinationViewController;
    my.user = self.user;
}
#pragma actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 0) return;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
