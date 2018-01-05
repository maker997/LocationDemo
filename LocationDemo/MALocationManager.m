//
//  MALocationMananger.m
//  LocationDemo
//
//  Created by maker  on 2017/11/28.
//  Copyright © 2017年 maker . All rights reserved.
//

#import "MALocationManager.h"

@interface MALocationManager()
/**
 * locationManager
 */
@property(nonatomic, strong)CLLocationManager *locationManager;
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

@implementation MALocationManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static MALocationManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[MALocationManager alloc]init];
    });
    return manager;
}

#pragma mark- Public
- (void)startUpdateLocation
{
    [self.locationManager requestAlwaysAuthorization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.locationManager startUpdatingLocation];
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
    [self.locationManager stopUpdatingLocation];
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
#pragma mark- CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *lastLocation = locations[0];
    _coordinate = lastLocation.coordinate;
    NSLog(@"%s---%d---long:%f lat:%f",__func__,__LINE__,_coordinate.longitude,_coordinate.latitude);
}

#pragma mark- getter
- (CLLocationManager *)locationManager
{
    if (_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _locationManager;
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







