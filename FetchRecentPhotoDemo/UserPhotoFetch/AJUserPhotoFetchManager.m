//
//  AJUserPhotoFetchManager.m
//  首页滑动DEMO
//
//  Created by admin on 2018/11/20.
//  Copyright © 2018 ysepay. All rights reserved.
//

#import "AJUserPhotoFetchManager.h"

@interface AJUserPhotoFetchManager ()

@property (nonatomic, strong, nullable) NSDate *lastAssetcreationDate;
@end

static NSTimeInterval const latestAssetFetchInterval = 10;
static NSString * const kLastAssetcreationDateKey = @"kLastAssetcreationDateKey";
@implementation AJUserPhotoFetchManager

#pragma mark - 单例方法
static AJUserPhotoFetchManager *sharedInstance;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
        sharedInstance.lastAssetcreationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastAssetcreationDateKey];
    });
    
    return sharedInstance;
}

+ (AJUserPhotoFetchManager *)sharedUserPhotoFetchManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AJUserPhotoFetchManager alloc]init];
        sharedInstance.lastAssetcreationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastAssetcreationDateKey];
    });
    return sharedInstance;
}


/** 点击“＋”号的时候获取相册列表，获取最新保存的一张图片。
  * 根据图片保存时间，与当前时间戳进行计算，获得间隔时间。从而判断是否是需求的时间间隔。（时间间隔自定义）
 */
- (void)fetchLatestPhotoInTimeIntervalWithCompletion:(void (^)(UIImage *result, NSDictionary *info))completion{
    // 此处不能主动获取权限，在用户同意的情况下可以去获取
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
//        AJUserPhotoFetchManager *sharedUserPhotoFetchManager = [AJUserPhotoFetchManager sharedUserPhotoFetchManager];
        PHAsset *latestAsset = [self fetchLatestPhotoAsset];
        NSDate *nowDate = [NSDate date];
        NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:latestAsset.creationDate];// 创建时间距离的时间间隔
        if (timeInterval > latestAssetFetchInterval) { // 超出时间了
            completion(nil, nil);
            return;
        }
        
        if (self.lastAssetcreationDate && [self.lastAssetcreationDate compare:latestAsset.creationDate] != NSOrderedAscending) { // 上次已经获取过了
            completion(nil, nil);
            return;
        }
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        [[PHImageManager defaultManager] requestImageForAsset:latestAsset targetSize:UIScreen.mainScreen.bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            self.lastAssetcreationDate = latestAsset.creationDate;
            [[NSUserDefaults standardUserDefaults] setObject:latestAsset.creationDate forKey:kLastAssetcreationDateKey];
            completion(result, info);
        }];
    }
}

- (PHAsset *)fetchLatestPhotoAsset{

    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    if (@available(iOS 9.0, *)) {
        options.fetchLimit = 1;
    }
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return assetsFetchResults.firstObject;
}

+ (void)requestAuthorization:(void (^)(PHAuthorizationStatus))handler{
    [PHPhotoLibrary requestAuthorization:handler];
}
@end
