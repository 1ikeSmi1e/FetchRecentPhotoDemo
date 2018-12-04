//
//  AJUserPhotoFetchManager.h
//  首页滑动DEMO
//
//  Created by admin on 2018/11/20.
//  Copyright © 2018 ysepay. All rights reserved.
// 获取用户图片的工具类
// 尽量将获取用户图片的具体操作放在本类中，在使用时直接调用对应方法即可

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJUserPhotoFetchManager : NSObject

+ (AJUserPhotoFetchManager *)sharedUserPhotoFetchManager;

/** 点击“＋”号的时候获取相册列表，获取最新保存的一张图片。
 * 根据图片保存时间，与当前时间戳进行计算，获得间隔时间。从而判断是否是需求的时间间隔。（时间间隔自定义）
 */
- (void)fetchLatestPhotoInTimeIntervalWithCompletion:(void (^)(UIImage *result, NSDictionary *info))completion;


+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;
@end

NS_ASSUME_NONNULL_END
