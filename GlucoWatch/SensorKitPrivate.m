//
//  SensorKitPrivate.m
//  GlucoWatch
//
//  Created by Genuine on 02.01.2025.
//
// SensorKitAPI.m
//#import "SensorKitAPI.h"
//#import <objc/runtime.h>
//
//
//
//@implementation SensorKitAPI
//
//- (void)callPrivateMethod {
//    // Dynamically get the class reference
//    Class sensorManagerClass = NSClassFromString(@"SRSensorReader");
//    
//    if (sensorManagerClass == nil) {
//        NSLog(@"SRSensorManager class not found.");
//        return;
//    }
//    
//    // Create an instance of the class
//    id sensorManager = [[sensorManagerClass alloc] initWithSensor:SRSensorPhotoplethysmogram];
//    if (!sensorManager) {
//        NSLog(@"Failed to initialize SRSensorReader.");
//        return;
//    }
//    
//    
//    // Create a selector for the private method you want to call
//    SEL selector = NSSelectorFromString(@"initWithSensor:");
//    
//    if (![sensorManager respondsToSelector:selector]) {
//        NSLog(@"Method not found.");
//        return;
//    }
//    
//    // Create a block for the completion handler
//    void (^completionBlock)(BOOL granted, NSError *error) = ^(BOOL granted, NSError *error) {
//        if (error) {
//            NSLog(@"Authorization failed with error: %@", error);
//        } else {
//            NSLog(@"Authorization granted: %d", granted);
//        }
//    };
//    
//    // Convert the block to an Objective-C object (i.e., id type)
//    id blockObject = [completionBlock copy];
//    
//    // Perform the method dynamically
//    NSMethodSignature *methodSignature = [sensorManager methodSignatureForSelector:selector];
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
//    
//    [invocation setTarget:sensorManager];
//    [invocation setSelector:selector];
//    
//    // Set the block as the argument at index 2 (argument index starts from 2)
//    [invocation setArgument:&blockObject atIndex:2];
//    
//    // Invoke the method
//    [invocation invoke];
//}
//
//@end

// SensorKitAPI.h
#import <Foundation/Foundation.h>
#import <SensorKit/SensorKit.h>

//@interface SensorKitAPI : NSObject <SRSensorReaderDelegate>
//- (void)initializeSensorReader;
//- (void)requestAuthorizationForSensors;
//- (void)startRecording;
//- (void)stopRecording;
//- (void)fetchSensorData;
//@end

// SensorKitAPI.m
#import "SensorKitAPI.h"
#import <objc/runtime.h>

@implementation SensorKitAPI {
    SRSensorReader *sensorReader;
}
- (void)initializeSensorKit {
    // Load the SensorKit framework bundle
    NSBundle *sensorKitBundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/SensorKit.framework"];
    if (sensorKitBundle == nil) {
        NSLog(@"SensorKit framework not found.");
        return;
    }
    
    // Attempt to load the bundle
    NSError *error = nil;
    BOOL success = [sensorKitBundle loadAndReturnError:&error];
    if (!success || error) {
        NSLog(@"Failed to load SensorKit framework: %@", error);
        return;
    }
    
    // Get the principal class from the bundle
    Class principalClass = [sensorKitBundle principalClass];
    if (principalClass == nil) {
        NSLog(@"Principal class is nil. SensorKit may not be accessible.");
        return;
    }
    
    NSLog(@"SensorKit principal class loaded: %@", principalClass);
}

- (void)initializeSensorReader {
    // Dynamically get the class reference
    Class sensorManagerClass = NSClassFromString(@"SRSensorReader");
    
    if (sensorManagerClass == nil) {
        NSLog(@"SRSensorReader class not found.");
        return;
    }

    // Create a selector for the private method you want to call
    SEL selector = NSSelectorFromString(@"initWithSensor:SRSensorPhotoplethysmogram");
    
    if (![sensorManagerClass instancesRespondToSelector:selector]) {
        NSLog(@"Method not found.");
        return;
    }
    
    // Perform the method dynamically using NSInvocation
    NSMethodSignature *methodSignature = [sensorManagerClass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    // Create the sensor type argument
    SRSensor sensorType = SRSensorPhotoplethysmogram;
    
    [invocation setTarget:sensorManagerClass];
    [invocation setSelector:selector];
    [invocation setArgument:&sensorType atIndex:2]; // index 2 (index 0 is reserved for self and index 1 for _cmd)
    
    // Invoke the method
    [invocation invoke];
    
    // Get the return value
    __unsafe_unretained id returnValue;
    [invocation getReturnValue:&returnValue];
    sensorReader = returnValue;
    
    if (!sensorReader) {
        NSLog(@"Failed to initialize SRSensorReader.");
        return;
    }
    
    sensorReader.delegate = self;
}

- (void)requestAuthorizationForSensors {
    // Request authorization for the specific sensor using NSInvocation
    Class sensorManagerClass = NSClassFromString(@"SRSensorReader");

    SEL selector = NSSelectorFromString(@"requestAuthorizationForSensors:completion:");
    
    if (![sensorManagerClass respondsToSelector:selector]) {
        NSLog(@"Method not found.");
        return;
    }
    
    // Create the completion block
    void (^completionBlock)(BOOL granted, NSError * _Nullable error) = ^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Authorization failed with error: %@", error);
        } else {
            NSLog(@"Authorization granted: %d", granted);
            if (granted) {
                [self startRecording];
            }
        }
    };
    
    // Convert the block to an Objective-C object
    id blockObject = [completionBlock copy];
    
    // Perform the method dynamically using NSInvocation
    NSMethodSignature *methodSignature = [sensorManagerClass methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
   // NSArray *sensors = @[ @(SRSensorTypeHeartRate) ];
    
    [invocation setTarget:sensorManagerClass];
    [invocation setSelector:selector];
  //  [invocation setArgument:&sensors atIndex:2]; // index 2
    [invocation setArgument:&blockObject atIndex:3]; // index 3
    
    // Invoke the method
    [invocation invoke];
}
//
//- (void)startRecording {
//    // Start recording sensor data
//    if ([sensorReader authorizationStatusForSensor:SRSensorTypeHeartRate] == SRAuthorizationStatusAuthorized) {
//        [sensorReader startRecording];
//        NSLog(@"Started recording sensor data.");
//    } else {
//        NSLog(@"Authorization not granted.");
//    }
//}
//
//- (void)stopRecording {
//    // Stop recording sensor data
//    [sensorReader stopRecording];
//    NSLog(@"Stopped recording sensor data.");
//}
//
//- (void)fetchSensorData {
//    // Create a fetch request for the sensor data
//    SRFetchRequest *fetchRequest = [[SRFetchRequest alloc] initWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-604800] // 7 days ago
//                                                                     endDate:[NSDate date]];
//    [sensorReader fetch:fetchRequest];
//}
//
//#pragma mark - SRSensorReaderDelegate methods
//
//- (void)sensorReader:(SRSensorReader *)reader didChangeAuthorizationStatus:(SRAuthorizationStatus)authorizationStatus forSensor:(SRSensorType)sensor {
//    if (authorizationStatus == SRAuthorizationStatusAuthorized) {
//        NSLog(@"Authorization status changed to authorized for sensor: %ld", (long)sensor);
//    } else {
//        NSLog(@"Authorization status changed to unauthorized for sensor: %ld", (long)sensor);
//    }
//}
//
//- (void)sensorReader:(SRSensorReader *)reader didCompleteFetch:(NSError * _Nullable)error {
//    if (error) {
//        NSLog(@"Fetch completed with error: %@", error);
//    } else {
//        NSLog(@"Fetch completed successfully.");
//    }
//}
//
//- (void)sensorReader:(SRSensorReader *)reader fetchingRequest:(SRFetchRequest *)request didFetchResult:(id)result {
//    NSLog(@"Fetched sensor data: %@", result);
//}

@end
