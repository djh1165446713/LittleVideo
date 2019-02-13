//
//  TPLocationManager.m
//  TP
//
//  Created by moxin on 15/6/18.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "TPLocationManager.h"
#import <JZLocationConverter.h>
#import "INTULocationManager.h"
#import "ABUpdateUserDataModel.h"

@interface TPLocationManager()
@property(nonatomic,assign)BOOL      bAlreadyShowServiceAlert;
@property(nonatomic,strong)NSString* city;
@property(nonatomic,strong)NSString* province;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSString* countryCode;
@property(nonatomic,assign)INTULocationRequestID requestId;
@property(nonatomic,assign)CLLocationCoordinate2D currentLocation;

@end

@implementation TPLocationManager

+ (instancetype)sharedInstance
{
    static TPLocationManager* manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TPLocationManager new];
    });
    return manager;
}

+ (CLLocationCoordinate2D)currentLocation
{
    return [TPLocationManager sharedInstance].currentLocation;
}

+ (NSString* )locationCity
{
    return [TPLocationManager sharedInstance].city;
}

+ (NSString* )locationProvince {
    return [TPLocationManager sharedInstance].province;
}

+ (NSString* )locationCountry
{
    return [TPLocationManager sharedInstance].country;
}

+ (NSString* )locationCountryCode
{
    return [TPLocationManager sharedInstance].countryCode;
}

+ (void)startLocation
{
    [self startLocationWithCompletion:nil];
}

+ (void)startLocationWithCompletion:(void (^)(CLLocation *))callback
{
    INTULocationRequestID requestId = [[INTULocationManager sharedInstance]requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:5.0 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusServicesDisabled || status == INTULocationStatusServicesDenied) {
            return ;
        }
        
        CLLocationCoordinate2D newCoor = [JZLocationConverter wgs84ToGcj02:currentLocation.coordinate];//当输入坐标为中国大陆以外时，仍旧返回WGS-84坐标
        [TPLocationManager sharedInstance].currentLocation = newCoor;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newCoor.latitude longitude:newCoor.longitude];
        
        //geocoding
        CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
        [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
            
             if (error){
                 return;
             }
            
             CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
             NSString *countryCode = myPlacemark.ISOcountryCode;
             NSString *countryName = myPlacemark.country;
             NSString *province = myPlacemark.administrativeArea;
             NSString* city = myPlacemark.locality;
             NSLog(@"{My country code: %@\n countryName: %@\n province:%@ city:%@\n", countryCode, countryName,province,city);
            [TPLocationManager sharedInstance].country = countryName;
            [TPLocationManager sharedInstance].countryCode = countryCode;
            [TPLocationManager sharedInstance].province = province;
            [TPLocationManager sharedInstance].city = city;
            
         }];
        
        if (callback) {
            callback(currentLocation);
        }
    }];
    [TPLocationManager sharedInstance].requestId = requestId;
}

+ (void)stopLocation
{
    INTULocationRequestID requestId = [TPLocationManager sharedInstance].requestId;
    [[INTULocationManager sharedInstance] cancelLocationRequest:requestId];
}

@end
