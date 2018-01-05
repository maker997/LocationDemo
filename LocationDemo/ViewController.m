//
//  ViewController.m
//  LocationDemo
//
//  Created by 刘甲奇 on 2018/1/4.
//  Copyright © 2018年 刘甲奇. All rights reserved.
//

#import "ViewController.h"
#import "BDLocationManager.h"
#import "MALocationManager.h"
#import "GDLocationManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark- Action

- (IBAction)baiduClick
{
    //暂停其他定位,开启百度定位
    [[GDLocationManager shareManager] stopUpdateLocation];
    [[MALocationManager shareManager] stopUpdateLocation];
    
    [[BDLocationManager shareManager] startUpdateLocation];
    [[BDLocationManager shareManager] startReportLocation];
     __weak typeof (self) weakSelf = self;
    [BDLocationManager shareManager].locationBlock = ^(CLLocationCoordinate2D coordinate) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.coordinateLabel.text = [NSString stringWithFormat:@"经度:%f,纬度:%f",coordinate.longitude,coordinate.latitude];
        });
    };
}

- (IBAction)gaodeClick
{
    //暂停百度定位,开启高德定位
    [[BDLocationManager shareManager] stopUpdateLocation];
    [[MALocationManager shareManager] stopUpdateLocation];
    
    [[GDLocationManager shareManager] startUpdateLocation];
    [[GDLocationManager shareManager] startReportLocation];
    __weak typeof (self) weakSelf = self;
    [GDLocationManager shareManager].locationBlock = ^(CLLocationCoordinate2D coordinate) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
           strongSelf.coordinateLabel.text = [NSString stringWithFormat:@"经度:%f,纬度:%f",coordinate.longitude,coordinate.latitude];
        });
    };
}

- (IBAction)phoneClick
{
    //关闭其他定位,开始手机定位
    [[BDLocationManager shareManager] stopUpdateLocation];
    [[GDLocationManager shareManager] stopUpdateLocation];
    
    [[MALocationManager shareManager] startUpdateLocation];
    [[MALocationManager shareManager] startReportLocation];
    __weak typeof (self) weakSelf = self;
    [MALocationManager shareManager].locationBlock = ^(CLLocationCoordinate2D coordinate) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.coordinateLabel.text = [NSString stringWithFormat:@"经度:%f,纬度:%f",coordinate.longitude,coordinate.latitude];
        });
    };
}

@end
