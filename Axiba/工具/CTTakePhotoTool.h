//
//  CTTakePhotoTool.h
//  TP
//
//  Created by Peter on 15/12/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CTPhotoChooseBlock)(NSString* _Nonnull picName, UIImage* _Nonnull image);
typedef void (^CTPhotoUploadCompleteBlock)(NSString* _Nonnull picUrl, UIImage* _Nonnull image);
typedef void (^CTPhotoUploadErrorBlock)(NSError* _Nonnull error);

@interface CTTakePhotoTool : NSObject

+ (nonnull id)sharedInstance;

/**
 *  选择图片, convenient method, autoUpload=YES, chooseBlock=NULL, errorBlock=NULL
 *
 *  @param root                show出Sheet的root控制器
 *  @param placeholder         placeholder
 *  @param completeUploadBlock 上传完图片后，回传Url
 */

- (void)takePhoto:(UIViewController* _Nonnull)root placeholder:(NSString* _Nonnull)placeholder completeUploadBlock:(CTPhotoUploadCompleteBlock _Nonnull)completeUploadBlock;

/**
 *  选择图片，可以选择是否自动上传
 *
 *  @param root                show出Sheet的root控制器
 *  @param placeholder         placeholder
 *  @param autoUpload          是否自动上传
 *  @param block               block，选择完图片后先回传一个UIImage
 *  @param completeUploadBlock 上传完图片后，回传Url
 *  @param errorBlock          上传完图片错误回调（error会在本类抛出）
 */
- (void)takePhoto:(UIViewController* _Nonnull)root placeholder:(NSString* _Nonnull)placeholder autoUpload:(BOOL)autoUpload chooseBlock:(CTPhotoChooseBlock _Nullable)block errorBlock:(CTPhotoUploadErrorBlock _Nullable)errorBlock completeUploadBlock:(CTPhotoUploadCompleteBlock _Nonnull)completeUploadBlock;
@end
