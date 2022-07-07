#import <Foundation/Foundation.h>

@interface JDESettingsManager : NSObject
+ (JDESettingsManager *)sharedInstance;
- (NSUInteger)numberOfFeatures;
- (NSString*)featureNameForRow:(NSUInteger)row;
- (NSString*)featureDescriptionForRow:(NSUInteger)row;
- (NSNumber*)featureDisabledForRow:(NSUInteger)row;
- (NSNumber*)featureTagForRow:(NSUInteger)row;
- (BOOL)featureStateForTag:(NSUInteger)row;
- (BOOL)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag;
@end