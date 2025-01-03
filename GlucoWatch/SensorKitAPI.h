//
//  SensorKitAPI.h
//  GlucoWatch
//
//  Created by Genuine on 03.01.2025.
//

#ifndef SensorKitAPI_h
#define SensorKitAPI_h
#import <Foundation/Foundation.h>
#import <SensorKit/SensorKit.h>

@interface SensorKitAPI : NSObject <SRSensorReaderDelegate>

- (void)callPrivateMethod;
- (void)initializeSensorKit;
- (void)initializeSensorReader;
- (void)requestAuthorizationForSensors;
- (void)startRecording;
- (void)stopRecording;
- (void)fetchSensorData;

@end

#endif /* SensorKitAPI_h */
