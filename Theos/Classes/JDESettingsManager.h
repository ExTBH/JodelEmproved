#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import <UIKit/UIKit.h>
#import "../Headers/AppHaptic.h"

@interface JDESettingsManager : NSObject
@property (strong, nonatomic) NSUserDefaults *tweakSettings;


+ (JDESettingsManager *)sharedInstance;
- (NSDictionary*)cellInfoForPath:(NSIndexPath*)indexPath;
- (void)updateSpoofedLocationWith:(CLLocation*)newLocation;
- (NSString*)spoofedLocation;
- (BOOL)featureStateForTag:(NSUInteger)row;
- (void)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag;
- (NSString*)localizedStringForKey:(NSString*)key;
@end

