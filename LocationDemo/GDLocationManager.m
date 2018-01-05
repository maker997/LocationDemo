//
//  GDLocationManager.m
//  LocationDemo
//
//  Created by 刘甲奇 on 2018/1/5.
//  Copyright © 2018年 刘甲奇. All rights reserved.
//

#import "GDLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface GDLocationManager()<AMapLocationManagerDelegate>
/**
 * 高德定位管理者
 */
@property(nonatomic, strong) AMapLocationManager *GLocationManager;
/**
 * CLLocationManager
 */
@property(nonatomic, strong) CLLocationManager *locationManager;
/**
 经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D  coordinate;
/**
 * 守护线程
 */
@property(nonatomic, strong) NSThread *daemonThread;
/**
 * 计时器
 */
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation GDLocationManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
       [AMapServices sharedServices].apiKey =@"0c76cf2adee66de8445493a7b5a1ce04";
    }
    return self;
}

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static GDLocationManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[GDLocationManager alloc]init];
    });
    return manager;
}

#pragma mark- Public
- (void)startUpdateLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.GLocationManager startUpdatingLocation];
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
    [self.GLocationManager stopUpdatingLocation];
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

#pragma mark- AMapLocationDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    _coordinate = location.coordinate;
    NSLog(@"%s---%d---long:%f lat:%f",__func__,__LINE__,_coordinate.longitude,_coordinate.latitude);
}

#pragma mark- getter
- (AMapLocationManager *)GLocationManager
{
    if (_GLocationManager == nil)
    {
        _GLocationManager = [[AMapLocationManager alloc] init];
        _GLocationManager.distanceFilter = kCLDistanceFilterNone;
        _GLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _GLocationManager.pausesLocationUpdatesAutomatically = NO;
        _GLocationManager.allowsBackgroundLocationUpdates = YES;
        _GLocationManager.delegate = self;
    }
    return _GLocationManager;
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



