#import <Foundation/Foundation.h>

@interface JDESettingsManager : NSObject
+ (JDESettingsManager *)sharedInstance;
- (NSArray<NSString*>*)features;
- (NSUInteger)numberOfFeatures;
- (NSString*)featureNameForRow:(NSUInteger)row;
- (NSNumber*)featureTagForRow:(NSUInteger)row;
- (BOOL)featureStateForTag:(NSUInteger)row;
- (BOOL)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag;
@end