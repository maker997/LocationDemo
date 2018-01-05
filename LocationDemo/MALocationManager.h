//
//  MALocationMananger.h
//  LocationDemo
//
//  Created by maker  on 2017/11/28.
//  Copyright © 2017年 maker . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^MALocationBlock)(CLLocationCoordinate2D coordinate);

@interface MALocationManager : NSObject<CLLocationManagerDelegate>
/**
 * block
 */
@property(nonatomic, strong) MALocationBlock locationBlock;

+ (instancetype)shareManager;

- (void)startUpdateLocation;

- (void)startReportLocation;

- (void)stopUpdateLocation;

@end
