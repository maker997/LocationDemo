//
//  BDLocationManager.h
//  LocationDemo
//
//  Created by 刘甲奇 on 2018/1/4.
//  Copyright © 2018年 刘甲奇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^BDLocationBlock)(CLLocationCoordinate2D coordinate);

@interface BDLocationManager : NSObject
/**
 * 定时返回经纬度
 */
@property(nonatomic, strong)BDLocationBlock locationBlock;

+ (instancetype)shareManager;

- (void)startUpdateLocation;

- (void)startReportLocation;

- (void)stopUpdateLocation;

@end
