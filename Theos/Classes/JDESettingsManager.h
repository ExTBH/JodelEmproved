#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import <UIKit/UIKit.h>
#import "../Headers/AppHaptic.h"
#import <objc/runtime.h>

@interface JDESettingsManager : NSObject
@property (strong, nonatomic, readonly) NSString *logFile;
@property (nonatomic, readonly) BOOL logFileExists;

+ (JDESettingsManager *)sharedInstance;
- (NSDictionary*)cellInfoForPath:(NSIndexPath*)indexPath;
- (void)updateSpoofedLocationWith:(CLLocation*)newLocation;
- (NSString*)spoofedLocation;
- (BOOL)featureStateForTag:(NSUInteger)row;
- (void)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag;
- (NSString*)localizedStringForKey:(NSString*)key;
- (void)logString:(NSString*)string;
@end

