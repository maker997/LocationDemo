//
//  GDLocationManager.h
//  LocationDemo
//
//  Created by 刘甲奇 on 2018/1/5.
//  Copyright © 2018年 刘甲奇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^GDLocationBlock)(CLLocationCoordinate2D coordinate);

@interface GDLocationManager : NSObject
/**
 * block
 */
@property(nonatomic, strong)GDLocationBlock locationBlock;

+ (instancetype)shareManager;

- (void)startUpdateLocation;

- (void)startReportLocation;

- (void)stopUpdateLocation;

@end
