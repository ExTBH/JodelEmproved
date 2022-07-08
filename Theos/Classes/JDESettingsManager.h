#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import "../Headers/AppHaptic.h"
#import <objc/runtime.h>

@interface JDESettingsManager : NSObject
+ (JDESettingsManager *)sharedInstance;
- (NSUInteger)numberOfFeatures;
- (NSString*)featureNameForRow:(NSUInteger)row;
- (NSString*)featureDescriptionForRow:(NSUInteger)row;
- (NSNumber*)featureDisabledForRow:(NSUInteger)row;
- (NSNumber*)featureTagForRow:(NSUInteger)row;
- (void)updateSpoofedLocationWith:(CLLocation*)newLocation;
- (NSString*)spoofedLocation;
- (BOOL)featureStateForTag:(NSUInteger)row;
- (BOOL)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag;
@end

