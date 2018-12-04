//
//  ViewController.m
//  FetchRecentPhotoDemo
//
//  Created by admin on 2018/12/4.
//  Copyright © 2018 zlbased. All rights reserved.
//

#import "ViewController.h"
#import "AJUserPhotoFetchManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [AJUserPhotoFetchManager requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (status == PHAuthorizationStatusAuthorized) {
            [AJUserPhotoFetchManager.sharedUserPhotoFetchManager fetchLatestPhotoInTimeIntervalWithCompletion:^(UIImage * _Nonnull result, NSDictionary * _Nonnull info) {// 
                // 根据创建的时间节点来判读是不是同一个图片
                NSLog(@"AJUserPhotoFetchManager: result=%@, info=%@", result, info);
            }];
        }
    }];
}
@end
