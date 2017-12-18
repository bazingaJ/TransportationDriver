//
//  JXRegPhotoVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXRegPhotoVC.h"
#import "JXCollectCell.h"
#import "JXReadVC.h"

@interface JXRegPhotoVC ()< UICollectionViewDelegate,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate>


@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableDictionary *infoDic;

@property (nonatomic, strong) NSString *imgUrl1;
@property (nonatomic, strong) NSString *imgUrl2;
@property (nonatomic, strong) NSString *imgUrl3;
@property (nonatomic, strong) NSString *imgUrl4;

@end

@implementation JXRegPhotoVC

- (instancetype)initWithDict:(NSMutableDictionary *)dict
{
    if (self = [super init])
    {
        self.infoDic = [NSMutableDictionary dictionary];
        self.infoDic = dict;
        JXLog(@"-----%@",dict);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self overrideBackButton];
    [self initialized];
    [self setupUI];
}
- (void)initialized
{
    self.titleArr = [[NSArray alloc] initWithObjects:@"身份证照片",@"行驶证照片",@"驾驶证照片",@"车辆45° 侧照", nil];
}
- (void)setupUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(Main_Screen_Width/2, 140);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    //154
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 140, Main_Screen_Width, Main_Screen_Height-100) collectionViewLayout:layout];
    _collectionView.backgroundColor = RGBCOLOR(240, 240, 240);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"JXCollectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"JXCollectCell"];
    [self.view addSubview:_collectionView];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, Main_Screen_Height-145, Main_Screen_Width-40, 45);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtn) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setBackgroundColor:RGBCOLOR(252, 85, 31)];
    commitBtn.titleLabel.font = F18;
    ViewRadius(commitBtn, 5);
    [self.view addSubview:commitBtn];
}

#pragma mark - UICollection view Data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     JXCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JXCollectCell" forIndexPath:indexPath];
    cell.titleLab.text = _titleArr[indexPath.row];
    cell.imgBtn.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;
    [self choicePhotos];
}
- (void)choicePhotos
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addPhoto];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:photoAction];
    [alertVC addAction:cameraAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)addPhoto
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.tintColor = [UIColor blackColor];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//UIImagePickerControllerSourceTypePhotoLibrary--从相簿选择，UIImagePickerControllerSourceTypeSavedPhotosAlbum--从相册选
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}
- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备不支持拍照功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:^{
            //[[UIApplication sharedApplication] setStatusBarHidden:NO];
            
        }];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    NSIndexPath *path = [NSIndexPath indexPathForItem:_index inSection:0];
    
    JXCollectCell *cell  =(JXCollectCell *)[_collectionView cellForItemAtIndexPath:path];
    if (_index == 0)
    {
        self.image1 = image;
    }
    else if (_index == 1)
    {
        self.image2 = image;
    }
    else if (_index == 2)
    {
        self.image3 = image;
    }
    else
    {
        self.image4 = image;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [cell.imgBtn setImage:image forState:UIControlStateNormal];
    }];
}

- (void)commitBtn
{
    if ([self isNullImageJudge])
    {
        [self requestuploadImg];

    }
    
}
- (BOOL)isNullImageJudge
{
    if (_image1 == nil)
    {
        SVINFO(@"请上传身份证照片", 2)
        return NO;
    }
    else if (_image2 == nil)
    {
        SVINFO(@"请上传行驶证照片", 2)
        return NO;
    }
    else if (_image3 == nil)
    {
        SVINFO(@"请上传驾驶证照片", 2)
        return NO;
    }
    else if (_image4 == nil)
    {
        SVINFO(@"请上传车辆45°侧照", 2)
        return NO;
    }
    else
    {
        return YES;
    }
    
}
- (void)requestuploadImg
{
    NSString *imgName1 = @"idCardImage";
    NSString *imgName2 = @"drivingCardImage";
    NSString *imgName3 = @"driverCardImage";
    NSString *imgName4 = @"car45Image";
    
    SVSTATUS(@"正在上传信息")
    dispatch_async(dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL), ^{
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            [JXRequestTool postUploadImgNeedimgBelong:imgName1 Image:_image1 complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    self.imgUrl1 = respose[@"res"];
                    dispatch_group_leave(group);
                    dispatch_semaphore_signal(semaphore);
                }
            }];
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            [JXRequestTool postUploadImgNeedimgBelong:imgName2 Image:_image2 complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    self.imgUrl2 = respose[@"res"];
                    dispatch_group_leave(group);
                    dispatch_semaphore_signal(semaphore);
                }
            }];
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            [JXRequestTool postUploadImgNeedimgBelong:imgName3 Image:_image3 complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    self.imgUrl3 = respose[@"res"];
                    dispatch_group_leave(group);
                    dispatch_semaphore_signal(semaphore);
                }
            }];
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            [JXRequestTool postUploadImgNeedimgBelong:imgName4 Image:_image4 complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    self.imgUrl4 = respose[@"res"];
                    dispatch_group_leave(group);
                    dispatch_semaphore_signal(semaphore);
                }
            }];
        });
        dispatch_group_notify(group, queue, ^{
    [JXRequestTool postImproveDriverInfoNeedTrueName:_infoDic[@"realName"]
                                              cardNo:_infoDic[@"idNumber"]
                                              cityId:_infoDic[@"cityId"]
                                            cityName:_infoDic[@"cityName"]
                                              areaId:_infoDic[@"areaId"]
                                            areaName:_infoDic[@"areaName"]
                                                 lon:_infoDic[@"longi"]
                                                 lat:_infoDic[@"lati"]
                                         contactName:_infoDic[@"emergencyName"]
                                          contactTel:_infoDic[@"emergencyPhone"]
                                             autoNum:_infoDic[@"plateNo"]
                                            autoType:_infoDic[@"carType"]
                                             special:_infoDic[@"special"]
                                             cardImg:_imgUrl1
                                       travelCardImg:_imgUrl2
                                    driverLicenseImg:_imgUrl3
                                             autoImg:_imgUrl4
                                            complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    SVSUCCESS(@"提交成功", 2)
                    
                    [kUserDefaults setObject:@"已登录" forKey:@"loginStatus"];
                    [kUserDefaults synchronize];
                    
                    static NSString *identifier =@"JXMainTabBarC";
                    JXMainTabBarC *hvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
                    kWindow.rootViewController=hvc;
                    
                    
                    
                }
            }];
        });
    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
