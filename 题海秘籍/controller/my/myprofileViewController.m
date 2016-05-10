//
//  myprofileViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/1.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "myprofileViewController.h"
#import "UIView+Extension.h"
#import "briefViewController.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "YSHYClipViewController.h"
//#import "UIImageView+WebCache.h"

#define upload @"/uploadimage" //服务器响应action


@interface myprofileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ClipViewControllerDelegate>

@property (strong, retain)UIImagePickerController *imagePicker;

@property (weak, nonatomic)UIImageView *imageView;

@end

@implementation myprofileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOnclick:(UIButton*)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"]= self.user.uid;
    param[@"sex"]= self.user.sex;
    param[@"brief"] = self.user.brief;
    NSString *path = [myURL stringByAppendingString:upload];

    [manager POST:path parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *fileName = [NSString stringWithFormat:@"%@.png",self.user.uid];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];

        NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
        if (imageData != NULL) {
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
        }

    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //清除缓存
        [[SDImageCache sharedImageCache] clearDisk];
        //清除内存缓存
        [[SDWebImageManager sharedManager].imageCache clearMemory];
        self.user = [user objectWithKeyValues:responseObject];
        //上传图片成功执行回调
        [self reloadData];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传图片失败");
        //上传图片失败执行回调
    }];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"profileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(2, 43, self.view.width-4, 1)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.2;
    [cell.contentView addSubview:line];
    if (indexPath.row == 0) {
        UIView *headline = [[UIView alloc]initWithFrame:CGRectMake(2, 0, self.view.width-4, 1)];
        headline.backgroundColor = [UIColor grayColor];
        headline.alpha = 0.2;
        [cell.contentView addSubview:headline];
        cell.textLabel.text = @"头像";
        line.y = line.y+44;
        UIImageView *myImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width*0.66, 8, 70, 70)];

        NSURL *url = [NSURL URLWithString:[myURL stringByAppendingString:self.user.image]];
        [myImage sd_setImageWithURL:url];
        
        [cell.contentView addSubview:myImage];
        _imageView = myImage;
        
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"性别";
        cell.detailTextLabel.text =self.user.sex;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"个性签名";
        cell.detailTextLabel.text = self.user.brief;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? 88:44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择照片上传方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"本地上传", nil];
        [actionSheet showInView:self.view];
        actionSheet.tag = 1;
    }
    if (indexPath.row == 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择性别:" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [actionSheet showInView:self.view];
        actionSheet.tag = 2;
    }
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"profileTobrief" sender:nil];
    }
}


#pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.allowsEditing = YES;
//    [self presentModalViewController:_imagePicker animated:YES];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma mark 从摄像头获取活动图片
- (void)pickImageFromCamera
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.allowsEditing = YES;
   [self presentViewController:_imagePicker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    YSHYClipViewController * clipView = [[YSHYClipViewController alloc]initWithImage:image];
    clipView.delegate = self;
    clipView.clipType = CIRCULARCLIP; //支持圆形:CIRCULARCLIP 方形裁剪:SQUARECLIP   默认:圆形裁剪
//    if(![textField.text isEqualToString:@""])
//    {
//        radius =textField.text.intValue;
        clipView.radius = 120;   //设置 裁剪框的半径  默认120
//    }
    //    clipView.scaleRation = 2;// 图片缩放的最大倍数 默认为3
    [picker pushViewController:clipView animated:YES];
    
    
//    UIImage *theImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(88, 88)];

    
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
// Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    //Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
#pragma UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
//            [self pickImageFromCamera];
            NSLog(@"pickImageFromCamera");
        }
        if (buttonIndex == 1) {
            [self pickImageFromAlbum];
        }
    }
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            self.user.sex =@"男";
        }
        if (buttonIndex == 1) {
            self.user.sex = @"女";
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    briefViewController *bv = segue.destinationViewController;
    bv.brief = self.user.brief;
    bv.briefBlock = ^(NSString *text){
        self.user.brief = text;
        [self.tableView reloadData];
    };
}

#pragma mark - ClipViewControllerDelegate
-(void)ClipViewController:(YSHYClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage
{
    [clipViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *newImage=[self imageWithImageSimple:editImage scaledToSize:CGSizeMake(200, 200)];
        [self saveImage:newImage withName:@"currentImage.png"];
        self.imageView.image = newImage;
        
    }];;
}
@end
