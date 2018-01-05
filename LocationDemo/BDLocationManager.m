//
//  BDLocationManager.m
//  LocationDemo
//
//  Created by 刘甲奇 on 2018/1/4.
//  Copyright © 2018年 刘甲奇. All rights reserved.
//

#import "BDLocationManager.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationkit/BMKLocationAuth.h>

@interface BDLocationManager()<BMKLocationAuthDelegate,BMKLocationManagerDelegate>
/**
 * 百度定位
 */
@property(nonatomic, strong) BMKLocationManager *BLocationManager;
/**
 * CLLocationManager
 */
@property(nonatomic, strong) CLLocationManager *locationManager;
/**
 * 守护线程
 */
@property(nonatomic, strong) NSThread *daemonThread;
/**
 经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D  coordinate;
/**
 * 计时器
 */
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation BDLocationManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"6hvcIKbar6eCR3NXWAlgQDVGKcputprx" authDelegate:self];
        self.BLocationManager = [self BLocationManager];
    }
    return self;
}

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static BDLocationManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[BDLocationManager alloc]init];
    });
    return manager;
}

#pragma mark- Public
- (void)startUpdateLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.BLocationManager startUpdatingLocation];
    });
}

- (void)startReportLocation
{
    if (_daemonThread)
    {
        return;
    }
    [self.daemonThread start];
}

- (void)stopUpdateLocation
{
    [self.BLocationManager stopUpdatingLocation];
    [self.timer invalidate];
    self.timer = nil;
    self.daemonThread = nil;
}
- (void)run
{
    @autoreleasepool
    {
        self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(reportLocation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)reportLocation
{
    NSLog(@"%s---%d---",__func__,__LINE__);
    if (self.locationBlock)
    {
        self.locationBlock(self.coordinate);
    }
}

#pragma mark- BMKLocationManagerDelegate
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error
{
    self.coordinate = location.location.coordinate;
    NSLog(@"%s---%d---long:%f lat:%f",__func__,__LINE__,self.coordinate.longitude,self.coordinate.latitude);
}

#pragma mark- getter
- (BMKLocationManager *)BLocationManager
{
    if (_BLocationManager == nil)
    {
        //初始化实例
        _BLocationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _BLocationManager.delegate = self;
        //设置返回位置的坐标系类型
        _BLocationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _BLocationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _BLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _BLocationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _BLocationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        _BLocationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _BLocationManager.locationTimeout = 10;
    }
    return _BLocationManager;
}

- (NSThread *)daemonThread
{
    if (_daemonThread == nil)
    {
        _daemonThread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    }
    return _daemonThread;
}

@end

