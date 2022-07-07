#import "JDESettingsManager.h"

#define suiteName "dev.extbh.jodelemproved"

@interface JDESettingsManager()
@property (strong, nonatomic) NSUserDefaults *tweakSettings;
@property (strong, nonatomic) NSArray<NSArray*> *features;
@property (strong, nonatomic) NSArray<NSNumber*> *featuresTags;
@end

@implementation JDESettingsManager
- (id) init{
    self = [super init];
    if (self != nil){
        _tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:@suiteName];
        _features = @[@[@"Save images", @"nil", @NO], @[@"Upload from gallery", @"nil", @NO], @[@"Location spoofer", @"nil", @YES],
                        @[@"Copy & Paste", @"Require restart to fully change.", @NO], @[@"Confirm votes", @"nil", @YES],
                        @[@"Confirm replies", @"nil", @YES], @[@"Screenshot protection", @"nil", @NO], @[@"Tracking protection", @"Stop analytics collection.", @YES],];
    }
    return self;
}
+ (JDESettingsManager *)sharedInstance{

    static JDESettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });

    return sharedInstance;

}
- (NSUInteger)numberOfFeatures{ return _features.count; }
- (NSString*)featureNameForRow:(NSUInteger)row{ return [_features objectAtIndex:row][0]; }
- (NSString*)featureDescriptionForRow:(NSUInteger)row{ 
    NSString *tmp = [_features objectAtIndex:row][1];
    if([tmp isEqualToString:@"nil"]) {return nil;} return tmp; 
    }
- (NSNumber*)featureDisabledForRow:(NSUInteger)row{ return [_features objectAtIndex:row][2];}
- (NSNumber*)featureTagForRow:(NSUInteger)row{ return @(row); }
- (BOOL)featureStateForTag:(NSUInteger)tag {return [_tweakSettings boolForKey:[@(tag) stringValue]]; }
- (BOOL)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag{ [_tweakSettings setBool:newState forKey:[@(tag) stringValue]]; return YES;}

@end