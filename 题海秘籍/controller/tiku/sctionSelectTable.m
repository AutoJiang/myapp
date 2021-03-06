//
//  sctionSelectTable.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/17.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "sctionSelectTable.h"
#import "examinationViewController.h"
#import "readViewController.h"
#import "searchViewController.h"
#import "ATTableViewCell.h"
#import "orderViewController.h"
#import "randomViewController.h"
#import "errorViewController.h"
#define ImageCount 5  //图片轮播个数
#define  M  @3

static NSString *kheader = @"menuSectionHeader";
static NSString *ksubSection = @"menuSubSection";

@interface sctionSelectTable ()<orderViewControllerDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *Singletopic;
@property (nonatomic,strong) NSMutableArray *Doubletopic;
@property (nonatomic,strong) NSMutableSet *SingleWrong;
@property (nonatomic,strong) NSMutableSet *DoubleWrong;
@property (nonatomic,strong) NSMutableArray *currentTpic;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *sd;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic,strong)  NSArray *sections;
@property (strong, nonatomic) NSMutableArray *sectionsArray;
@property (strong, nonatomic) NSMutableArray *showingArray;

@property (strong, nonatomic) NSMutableArray *Sindex;
@property (strong, nonatomic) NSMutableArray *Dindex;

@end

@implementation sctionSelectTable

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = width / 2.0;
    self.headView.frame= CGRectMake(0, 0, width, height);
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    for (int i = 0; i < ImageCount; i++) {
        CGFloat imageX = i * width;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, 0,width, height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d",i]];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(ImageCount*width, height);
    self.scrollView.pagingEnabled =YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControl.numberOfPages =ImageCount;
    [self.headView addSubview:self.scrollView];
    [self.headView addSubview:self.pageControl];
    [self addScrollTimer];
    
    [self openDb];
    
    [self readFromFile];
    
    self.sectionsArray = [NSMutableArray new];
    self.showingArray = [NSMutableArray new];
    [self setMenuSections:self.sections];
}
-(void)readFromFile{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.ctj",self.bookName]];
    self.SingleWrong =[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSString *pathd = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/D%@.ctj",self.bookName]];
    self.DoubleWrong =[NSKeyedUnarchiver unarchiveObjectWithFile:pathd];
    
    path = [path stringByAppendingString:@"x"];
    self.Sindex = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    pathd = [pathd stringByAppendingString:@"x"];
    self.Dindex = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}
-(void)writeToFileS{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.ctj",self.bookName]];
    NSLog(@"%@",path);
    [NSKeyedArchiver archiveRootObject:self.SingleWrong toFile:path];
    path = [path stringByAppendingString:@"x"];
    [NSKeyedArchiver archiveRootObject:self.Sindex toFile:path];
}
-(void)writetoFileD{
    NSString *pathd = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/D%@.ctj",self.bookName]];
    [NSKeyedArchiver archiveRootObject:self.DoubleWrong toFile:pathd];
    pathd = [pathd stringByAppendingString:@"x"];
    [NSKeyedArchiver archiveRootObject:self.Dindex toFile:pathd];
}
//打开数据库
-(void)openDb{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"tiku.db"];
//    NSString *database_path = [[NSBundle mainBundle]pathForResource:@"tiku.db" ofType:nil];
//    NSLog(@"%@",database_path);
    if (sqlite3_open([database_path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
    }else{
        NSString *quary =[NSString stringWithFormat:@"SELECT * FROM %@",self.bookName];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, [quary UTF8String], -1, &stmt, nil)==SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                NSMutableArray *temp,*arr = [NSMutableArray array],*chapter;
                int pid = sqlite3_column_int(stmt, 1);
                int type= sqlite3_column_int(stmt, 3);
                if (!sqlite3_column_int(stmt, 0)) {
                    for (int i =0 ; i < pid; i++) {
                        NSMutableArray *sArr = [NSMutableArray array];
                        NSMutableArray *dArr = [NSMutableArray array];
                        [self.Singletopic addObject:sArr];
                        [self.Doubletopic addObject:dArr];
                    }
                    continue;
                }
                if (type == 1 ||type ==3) {
                    temp =self.Singletopic;
                }else if(type == 2){
                    temp =self.Doubletopic;
                }
                if([self.bookName isEqual:@"mao2"]&&pid>=7)
                    pid -=6;
                if([self.bookName isEqual:@"history"])
                    pid --;
                chapter = temp[pid];
                
                char *title = (char *)sqlite3_column_text(stmt, 4);
                NSString *titleString =[[NSString alloc]initWithUTF8String:title];
                [arr addObject:titleString];
                
                char *op = (char *)sqlite3_column_text(stmt, 5);
                NSString *opString =[[NSString alloc]initWithUTF8String:op];
                for (int i = 0,j = 0;i < opString.length; i++) {
                    unichar c=[opString characterAtIndex:i];
                    if ( c=='B'||c=='C'||c=='D'||c=='E'||c=='F'||i==opString.length-1) {
                        if (i == opString.length-1)
                            i++;
                        if (i!=j) {
                            NSRange range;
                            range.location = j;
                            range.length = i -j;
                            [arr addObject:[opString substringWithRange:range]];
                            j = i;
                        }
                    }
                }
                char *answer = (char *)sqlite3_column_text(stmt, 6);
                NSString *answerString = [[NSString alloc]initWithUTF8String:answer];
                if (type ==3) {
                    [arr addObject:@"A.对"];
                    [arr addObject:@"B.错"];
                    if ([answerString isEqualToString:@"对"])
                        answerString = @"A";
                    if ([answerString isEqualToString:@"错"])
                        answerString = @"B";
                }
                [arr addObject:answerString];
                [chapter addObject:arr];
            }
        }else{
            NSLog(@"no");
        }
    }
}



- (void)addScrollTimer
{
    self.timer = [NSTimer timerWithTimeInterval:1.5f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeScrollTimer
{
    [self.timer invalidate];
    self.timer = nil;
    
}
- (void)nextPage
{
    long currentPage = self.pageControl.currentPage;
    currentPage ++;
    if (currentPage == ImageCount) {
        currentPage = 0;
    }
    
    CGFloat width = self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(currentPage * width, 0.f);
    [UIView animateWithDuration:.2f animations:^{
        self.scrollView.contentOffset = offset;
    }];
    
}
#pragma mark - UIScrollViewDelegate实现方法-
// scrollView滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"scrollViewDidScroll");
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat offsetX = offset.x;
    CGFloat width = self.scrollView.frame.size.width;
    int pageNum = (offsetX + .5f *  width) / width;
    
    self.pageControl.currentPage = pageNum;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeScrollTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"scrollViewDidEndDragging");
    [self addScrollTimer];
}

-(NSArray *)Singletopic{
    if (_Singletopic == nil) {
//        NSString *path = [[NSBundle mainBundle]pathForResource:self.bookName ofType:@"plist"];
        _Singletopic = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return _Singletopic;
}
-(NSMutableArray *)Doubletopic{
    if (_Doubletopic == nil) {
//        NSString *name = [NSString stringWithFormat:@"D%@",self.bookName];
//        NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"plist"];
        _Doubletopic = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return _Doubletopic;
}
-(NSMutableSet *)SingleWrong{
    if (_SingleWrong ==nil) {
        _SingleWrong = [[NSMutableSet alloc]init];
    }
    return _SingleWrong;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMenuSections:(NSArray *)menuSections{
    
    for (NSDictionary *sec in menuSections) {
        
        NSString *header = [sec objectForKey:kheader];
        NSArray *subSection = [sec objectForKey:ksubSection];
        
        NSMutableArray *section = [NSMutableArray new];
        [section addObject:header];
        
        for (NSString *sub in subSection) {
            [section addObject:sub];
        }
        [self.sectionsArray addObject:section];
        [self.showingArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row ==0){
        if([[self.showingArray objectAtIndex:indexPath.section]boolValue]){
//            [cell setBackgroundColor:[UIColor redColor]];
        }else{
//            [cell setBackgroundColor:[UIColor clearColor]];
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.sectionsArray count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (![[self.showingArray objectAtIndex:section]boolValue]) {
        return 1;
    }
    else{
        return [[self.sectionsArray objectAtIndex:section]count];;
    }
}

-(NSArray *)sections{
    if (_sections == nil) {
        NSMutableArray *sucSectionsA = [NSMutableArray array];
        NSMutableArray *sucSectionsB = [NSMutableArray array];
        NSMutableArray *sucSectionsC = [NSMutableArray array];
        NSMutableArray *sucSectionsD = [NSMutableArray array];
        NSMutableArray *sucSectionsE = [NSMutableArray array];
        for (int i = 0 ; i < self.Singletopic.count; i++) {
            NSString *str =[NSString stringWithFormat:@"第%d章",i+1];
            [sucSectionsA addObject :str];
            [sucSectionsE addObject :str];
            [sucSectionsC addObject :str];

        }
        NSDictionary *sectionA = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"题库浏览", kheader,
                                  sucSectionsA, ksubSection,
                                  nil];
        NSDictionary *sectionB = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"错题集", kheader,
                                  sucSectionsB, ksubSection,
                                  nil];
        NSDictionary *sectionE = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"章节练习(顺序)", kheader,
                                  sucSectionsC, ksubSection,
                                  nil];
        NSDictionary *sectionC = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"章节练习(随机)", kheader,
                                  sucSectionsC, ksubSection,
                                  nil];
        NSDictionary *sectionD = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"模拟考场", kheader,
                                  sucSectionsD, ksubSection,
                                  nil];
        _sections = [NSArray arrayWithObjects:sectionA,sectionB,sectionE,sectionC,sectionD,nil];
    }
    return _sections;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"identifier";
    ATTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ATTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.lable.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"cell_%ld",indexPath.section]];
//    cell.imageview.backgroundColor = [UIColor redColor];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"题库浏览";
    }
    if (section == 2||section ==3) {
        return @"章节练习";
    }
    return nil;
}

-(void)didSelectAction:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && indexPath.row==0 )|| (indexPath.section == 2 && indexPath.row == 0)||(indexPath.section == 3 && indexPath.row == 0)) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    if (indexPath.section == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择题库的类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"单选" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.currentTpic = self.Singletopic;
            self.sd = @"S";
            [self performSegueWithIdentifier:@"selectToRead" sender:nil];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"多选" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.currentTpic = self.Doubletopic;
            self.sd = @"D";
            [self performSegueWithIdentifier:@"selectToRead" sender:nil];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
    }
    if (indexPath.section == 1||indexPath.section == 2||indexPath.section == 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择答题的类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"单选" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.type = 0;
            if (indexPath.section == 1) {
                if (!self.SingleWrong.count) {
                    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"单选错题集暂无错题！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alert2 addAction:action];
                    [self presentViewController:alert2 animated:true completion:nil];
                }else{
                    [self performSegueWithIdentifier:@"selectToError" sender:@1];
                }

            }
            else if (indexPath.section == 2) {
                [self performSegueWithIdentifier:@"selectToOrder" sender:@2];
            }else if(indexPath.section ==3){
                [self performSegueWithIdentifier:@"selectToRandom" sender:@3];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"多选" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.type = 1;
            if (indexPath.section == 1) {
                if (!self.DoubleWrong.count) {
                    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"多选错题集暂无错题！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alert2 addAction:action];
                    [self presentViewController:alert2 animated:true completion:nil];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                }else{
                    [self performSegueWithIdentifier:@"selectToError" sender:@1];
                }
                
            }
            else if (indexPath.section == 2) {
                [self performSegueWithIdentifier:@"selectToOrder" sender:@2];
            }else if(indexPath.section == 3){
                [self performSegueWithIdentifier:@"selectToRandom" sender:@3];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
    }
    else if(indexPath.section == 4){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您将在30分钟内完成60道单选和20道多选，是否要进入？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self performSegueWithIdentifier:@"selectToExam" sender:@4];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
        [alert addAction:defaults];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld,%ld",indexPath.section,indexPath.row);
    if (indexPath.section == 1||indexPath.section == 4) {
        [self didSelectAction:indexPath];
        return;
    }
    
    if([[self.showingArray objectAtIndex:indexPath.section]boolValue]){
        [self.showingArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPath.section];
    }else{
        [self.showingArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.section];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self didSelectAction:indexPath];
}



//-(void)deleteDWrongTpic:(doubleWorkViewController *)dworkView wrong:(NSMutableArray *)WrongArray{
//    if (WrongArray !=nil) {
//        [self.DoubleWrong removeObject:WrongArray];
//    }
//}
#pragma orderViewControllerDelegate
-(void)saveWrongTpic:(orderViewController *)workView wrong:(NSMutableArray *)WrongArray{
    if (workView.type == 0) {
        if (self.SingleWrong ==nil) {
            self.SingleWrong =[[NSMutableSet alloc]initWithObjects:WrongArray,nil];
        }else{
            [self.SingleWrong addObject:WrongArray];
        }
        if (self.Sindex == nil) {
            self.Sindex =[NSMutableArray array];
        }
        if (self.SingleWrong.count>self.Sindex.count) {
            [self.Sindex addObject:M];
        }
        [self writeToFileS];
    }else if (workView.type == 1){
        if (self.DoubleWrong ==nil) {
            self.DoubleWrong =[[NSMutableSet alloc]initWithObjects:WrongArray,nil];
        }else{
            [self.DoubleWrong addObject: WrongArray];
        }
        if (self.Dindex == nil) {
            self.Dindex =[NSMutableArray array];
        }
        [self writetoFileD];
    }

}
-(void)deleteRightTpic:(orderViewController *)workView right:(NSMutableArray *)RightArray pos:(NSInteger)pos{
    if (workView.type == 0) {
        NSNumber *num =  self.Sindex[pos];
        NSInteger ingter =[num integerValue]-1;
        if (ingter == 0) {
            [self.SingleWrong removeObject:RightArray];
            [self.Sindex removeObjectAtIndex:pos];
        }else{
            self.Sindex[pos] = [NSNumber numberWithInteger:ingter];
        }
        [self writeToFileS];
    }else if (workView.type == 1){
        NSNumber *num = self.Dindex[pos];
        NSInteger ingter = [num integerValue]-1;
        if (ingter == 0) {
            [self.DoubleWrong removeObject:RightArray];
            [self.Dindex removeObjectAtIndex:pos];
        }else{
            self.Dindex[pos] = [NSNumber numberWithInteger:ingter];
        }
        [self writetoFileD];
    }
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath * indexpath = [self.tableView indexPathForSelectedRow];
    if([segue.destinationViewController isKindOfClass:[searchViewController class]]){
        searchViewController *sv =segue.destinationViewController;
        for (int i = 0; i<self.Singletopic.count; i++) {
            NSMutableArray *temp = self.Singletopic[i];
            if (sv.allArray ==nil) {
                sv.allArray = [NSMutableArray arrayWithArray:temp];
            }else{
                [sv.allArray addObjectsFromArray:temp];
            }
        }
        for (int i = 0; i<self.Doubletopic.count; i++) {
            NSMutableArray *temp = self.Doubletopic[i];
            [sv.allArray addObjectsFromArray:temp];
        }
        return;
    }
    NSInteger section  = [sender integerValue];
    if(section == 0){
        readViewController *rd =segue.destinationViewController;
        rd.tpic = [NSMutableArray arrayWithArray:self.currentTpic[indexpath.row-1]];
        rd.record = [self.bookName stringByAppendingString:[NSString stringWithFormat:@"_%@_%ld",self.sd,(long)indexpath.row]];
        NSLog(@"%@",rd.record);
    }
    else if(section == 1) {//进入错题集
        errorViewController *ev = segue.destinationViewController;
        ev.voice = self.voice;
        ev.shake = self.shake;
        ev.name = self.name;
        ev.record = [NSString stringWithFormat:@"%@_%ld,%ld_%ld_",self.bookName,indexpath.section,indexpath.row,ev.type];
        ev.tpArray = [NSMutableArray array];
        if (_type == 0) {
            for (NSMutableArray *oj in self.SingleWrong) {
                [ev.tpArray addObject:oj];
            }
        }else if (_type == 1){
            for (NSMutableArray *oj in self.DoubleWrong) {
                [ev.tpArray addObject:oj];
            }
        }
        ev.delegate = self;
    }
    else if (section == 2){
        orderViewController *oc = segue.destinationViewController;
        oc.voice = self.voice;
        oc.shake = self.shake;
        oc.type = _type ;
        if (oc.type == 0) {
            oc.tpArray = [[NSMutableArray alloc]initWithArray:self.Singletopic[indexpath.row-1]];
        }else{
            oc.tpArray = [[NSMutableArray alloc]initWithArray:self.Doubletopic[indexpath.row-1]];
        }
        oc.record = [NSString stringWithFormat:@"%@_%ld,%ld_%ld_",self.bookName,indexpath.section,indexpath.row,oc.type];
        NSLog(@"%@",oc.record);
        oc.delegate = self;
    }
    else if (section == 3){
        randomViewController *rv = segue.destinationViewController;
        rv.voice = self.voice;
        rv.shake = self.shake;
        rv.type = _type ;
        if (rv.type == 0) {
            rv.tpArray = [[NSMutableArray alloc]initWithArray:self.Singletopic[indexpath.row-1]];
        }else{
            rv.tpArray = [[NSMutableArray alloc]initWithArray:self.Doubletopic[indexpath.row-1]];
        }
        rv.record = [NSString stringWithFormat:@"%@_%ld,%ld_%ld",self.bookName,indexpath.section,indexpath.row,rv.type];
        NSLog(@"%@",rv.record);
        rv.delegate = self;
    }else if (section == 4){
        examinationViewController *ev = segue.destinationViewController;
        ev.voice = self.voice;
        ev.delegate = self;
        for (NSMutableArray *ar in self.Singletopic) {
            [ev.singleTpic addObjectsFromArray:ar];
        }
        for (NSMutableArray *ar in self.Doubletopic) {
            [ev.doubleTpic addObjectsFromArray:ar];
        }
        ev.name = self.name;
    }
}
@end
