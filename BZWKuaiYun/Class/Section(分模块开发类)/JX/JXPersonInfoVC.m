//
//  JXPersonInfoVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXPersonInfoVC.h"
#import "JXChangePhoneVC.h"
#import "JXChangeNameVC.h"

@interface JXPersonInfoVC ()< UITableViewDelegate,
                              UITableViewDataSource,
                              UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate >

@end

@implementation JXPersonInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self setupUI];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)setupUI
{
    self.navigationController.navigationBar.barTintColor = white_color;
    [self.navigationController.navigationBar setTranslucent:YES];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 40);
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    [leftBtn setImage:JX_IMAGE(@"fanhuijiantou") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    UserInfo *info = [UserInfo defaultUserInfo];
    if (![JXTool verifyIsNullString:info.photo])
    {
        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:info.photo] forState:UIControlStateNormal placeholderImage:JX_IMAGE(@"head2")];
    }
    self.nameLab.text = info.trueName;
    self.telLab.text = info.tel;
    self.confirmLab.text = [info.carCheckStatus isEqualToString:@"1"] ? @"已认证" : @"未认证";
    
}

- (void)requestUploadingMyHeadImage:(UIImage *)img completeWithBlock:(void(^)(BOOL isOK, NSDictionary *respose))block;
{
    SVSTATUS(@"上传中")
    [JXRequestTool postUploadImgNeedimgBelong:@"headImage" Image:img complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSString *imgUrl = respose[@"res"];
            block(YES,respose);
            [JXRequestTool postUpdateMyInfoNeedPhoto:imgUrl mobile:@"" checkCode:@"" trueName:@"" uploadType:UploadTypePhoto complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    SVMISS
                }
            }];
        }
    }];
}


- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            
            [self performSegueWithIdentifier:@"JXChangeNameVC" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"JXChangePhoneVC" sender:nil];
            
        }
        
    }
    else if (indexPath.section == 2)
    {
        if ([self.confirmLab.text isEqualToString:@"已认证"])
        {
            [self performSegueWithIdentifier:@"JXCarInfoVC" sender:self];
        }
        else
        {
            SVINFO(@"车辆未认证", 2)
        }
    }
   
}

- (IBAction)headBtnClick:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoAlbum];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 去相册选择图片
- (void)photoAlbum
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.tintColor = [UIColor blackColor];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self requestUploadingMyHeadImage:[self cutImage:image] completeWithBlock:^(BOOL isOK, NSDictionary *respose) {
            if (isOK)
            {
                [self.headBtn setImage:[self cutImage:image] forState:UIControlStateNormal];
                [JXTool saveImage:[self cutImage:image] WithName:@"headImage.jpg"];
                [kNotificationCenter postNotificationName:@"changeHeadImage" object:nil userInfo:@{@"headImg":[self cutImage:image]}];
            }
        }];
        
    }];
}
- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < 1)
    {
        newSize.width = image.size.width;
        newSize.height = image.size.width * 1;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    }
    else
    {
        newSize.height = image.size.height;
        newSize.width = image.size.height * 1;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备不支持拍照功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"JXChangeNameVC"])
    {
        JXChangeNameVC *receive = segue.destinationViewController;
        receive.textName =_nameLab.text;
        receive.name = ^(NSString *name) {
            self.nameLab.text = name;
        };
    }
 }
 


@end
