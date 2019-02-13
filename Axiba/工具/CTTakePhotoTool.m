//
//  CTTakePhotoTool.m
//  TP
//
//  Created by Peter on 15/12/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "CTTakePhotoTool.h"
#import "ABProfileModel.h"


@interface CTTakePhotoTool()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, copy  ) CTPhotoChooseBlock            chooseBlock;
@property (nonatomic, copy  ) CTPhotoUploadCompleteBlock    uploadCompleteBlock;
@property (nonatomic, copy  ) CTPhotoUploadErrorBlock       uploaderrorBlock;
@property (nonatomic, assign) BOOL                          autoUpload;
@end

@implementation CTTakePhotoTool

+ (id)sharedInstance {
    static CTTakePhotoTool* tool = nil;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        tool = [[CTTakePhotoTool alloc] init];
    });
    return tool;
}

#pragma mark - take photo
- (void)takePhoto:(UIViewController* _Nonnull)root placeholder:(NSString* _Nonnull)placeholder completeUploadBlock:(CTPhotoUploadCompleteBlock _Nonnull)completeUploadBlock {
    [self takePhoto:root placeholder:placeholder autoUpload:YES chooseBlock:NULL errorBlock:NULL completeUploadBlock:completeUploadBlock];
}
- (void)takePhoto:(UIViewController* _Nonnull)root placeholder:(NSString* _Nonnull)placeholder autoUpload:(BOOL)autoUpload chooseBlock:(CTPhotoChooseBlock _Nullable)block errorBlock:(CTPhotoUploadErrorBlock _Nullable)errorBlock completeUploadBlock:(CTPhotoUploadCompleteBlock _Nonnull)completeUploadBlock {
    self.chooseBlock = block;
    self.autoUpload = autoUpload;
    self.uploadCompleteBlock = completeUploadBlock;
    self.uploaderrorBlock = errorBlock;
    
    [self showImagePicker:root placeholder:placeholder];
}

#pragma mark - upload image
- (void)p_startUpload:(UIImage*)image {
    if (self.autoUpload) {
        ______WS();
        TOAST_Process;
        [[CTHttpApi sharedInstance] uploadFile:urlUpload image:image progressBlock:^(NSProgress *uploadProgress) {
            NSLog(@"图片上传：%.0f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount * 100);
        } success:^(NSDictionary *responseObject) {
            ABAvatorModel* model = [[ABAvatorModel alloc] initWithDictionary:responseObject error:nil];
            TOAST_Hide;
            if (model.rspCode.integerValue == 200) {
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:model.rspObject.avator]];
                wSelf.uploadCompleteBlock(model.rspObject.avator,image);
            }
        } failure:^(NSError *error) {
            TOAST_ERROR([CTTools rootViewController], error);
        }];
    }
}

#pragma mark - image picker
- (void)showImagePicker:(UIViewController*)vc placeholder:(NSString*)placeholder {
    UIActionSheet *sheet;
    NSString* title = placeholder;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    }else
    {
        sheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:nil, nil];
    }
    [sheet showInView:vc.view];
    
    ______WS();
    [[sheet rac_buttonClickedSignal] subscribeNext:^(NSNumber* x) {
        [wSelf actionSheetChoose:vc clickedButtonAtIndex:x.integerValue];
    }];
}

-(void)actionSheetChoose:(UIViewController *)vc clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = 0;
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 2:
                //取消
                return;
                break;
            case 0:
                //相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                break;
        }
    }
    else {
        if (buttonIndex == 1)
        {
            return;
        }
        else
        {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    //跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [vc presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    ______WS();
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString* picName = @"asset.JPG";
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.chooseBlock != NULL) {
        self.chooseBlock(picName, image);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf p_startUpload:image];
    });

}
@end
