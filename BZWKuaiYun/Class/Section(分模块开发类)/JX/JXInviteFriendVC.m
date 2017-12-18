//
//  JXInviteFriendVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXInviteFriendVC.h"
#import "JXShareTool.h"

@interface JXInviteFriendVC ()

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDetail;
@property (nonatomic, strong) NSString *linkStr;

@end

@implementation JXInviteFriendVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self requestShareUrl];
}

- (void)setupUI
{
    [self saveQRCode];
}

- (void)requestShareUrl
{
    [JXRequestTool postQuerySysDictNeedType:@"shareUrl" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSArray *arr = respose[@"res"];
            NSDictionary *dic = arr[0];
            
            self.linkStr = dic[@"value"];
            self.shareTitle = dic[@"label"];
            self.shareDetail = dic[@"description"];
            
            [self makeQRCode];
        }
    }];
}

- (void)makeQRCode
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [_linkStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    self.codeImage.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:127];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
- (IBAction)shareBtnClick:(UIButton *)sender
{
    NSInteger i = sender.tag;
    if (i == 6)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _linkStr;
        SVSUCCESS(@"复制成功", 1.5)
    }
    else
    {
        [JXShareTool UMShareInViewController:self shareType:i needTitle:_shareTitle detail:_shareDetail url:_linkStr imgUrl:@""];
    }
    
}

- (void)saveQRCode
{
    UILongPressGestureRecognizer*longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    self.codeImage.userInteractionEnabled = YES;
    [self.codeImage addGestureRecognizer:longTap];
}
- (void)imglongTapClick:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        UIAlertController *alert=[UIAlertController  alertControllerWithTitle:@"保存到相册" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(self.codeImage.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(void*)contextInfo
{
    if(error)
    {
        
        SVERROR(@"保存失败，请重新尝试", 1);
        
    }
    else
    {
        SVSUCCESS(@"保存成功", 1);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
