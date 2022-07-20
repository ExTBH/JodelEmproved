#import "JDESettingsManager.h"

#define suiteName "dev.extbh.jodelemproved"

@interface JDESettingsManager()
@property (strong, nonatomic) NSUserDefaults *tweakSettings;
@property (strong, nonatomic) NSArray<NSArray*> *features;
@property (strong, nonatomic) NSArray<NSNumber*> *featuresTags;
@property (strong, nonatomic) NSBundle *bundle;
@end

@implementation JDESettingsManager
- (id) init{
    self = [super init];
    if (self != nil){
        _tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:@suiteName];
        _features = @[@[@"Save images", @"nil", @NO], @[@"Upload from gallery", @"nil", @NO], @[@"Location spoofer", @"nil", @NO],
                        @[@"Copy & Paste", @"Require restart to fully change.", @NO], @[@"Confirm votes", @"nil", @YES],
                        @[@"Confirm replies", @"nil", @NO], @[@"Screenshot protection", @"Disable screenshot notification.", @NO], @[@"Tracking protection", @"Stop analytics collection.", @YES],];

        _bundle = [NSBundle bundleWithPath:@"Library/Application Support/Jodel EMPROVED.bundle"];
    }
    return self;
}
+ (JDESettingsManager *)sharedInstance{

    static JDESettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });

    return sharedInstance;

}
- (NSDictionary*)cellInfoForPath:(NSUInteger)indexPath{
    NSDictionary *info;
    switch(indexPath){
        case 0:
            info = @{
                @"title": [self localizedStringForKey:@"save_images"]
            }; break;
            
        case 1:
            info = @{
                @"title": [self localizedStringForKey:@"upload_images"],
            }; break;
        case 2:
            info = @{
                @"title": [self localizedStringForKey:@"location_spoofer"],
            }; break;
        case 3:
            info = @{
                @"title": [self localizedStringForKey:@"copy_paste"],
                @"desc": [self localizedStringForKey:@"copy_paste_desc"]
            }; break;
        case 4:
            info = @{
                @"title": [self localizedStringForKey:@"confirm_votes"],
                @"disabled": @1
            }; break;
        case 5:
            info = @{
                @"title": [self localizedStringForKey:@"confirm_replies"],
                
            }; break;
        case 6:
            info = @{
                @"title": [self localizedStringForKey:@"screenshot_protection"],
                @"desc": [self localizedStringForKey:@"screenshot_protection_desc"]
            }; break;
        case 7:
            info = @{
                @"title": [self localizedStringForKey:@"tracking_protection"],
                @"desc": [self localizedStringForKey:@"tracking_protection_desc"],
                @"disabled": @1
            }; break;
    }
    return info;
}
- (NSUInteger)numberOfFeatures{ return _features.count; }
- (NSString*)featureNameForRow:(NSUInteger)row{ return [_features objectAtIndex:row][0]; }
- (NSString*)featureDescriptionForRow:(NSUInteger)row{ 
    NSString *tmp = [_features objectAtIndex:row][1];
    if([tmp isEqualToString:@"nil"]) {return nil;} return tmp; 
    }
- (NSNumber*)featureDisabledForRow:(NSUInteger)row{ return [_features objectAtIndex:row][2];}
- (NSNumber*)featureTagForRow:(NSUInteger)row{ return @(row); }
- (void)updateSpoofedLocationWith:(CLLocation*)newLocation { [_tweakSettings setObject:[NSString stringWithFormat:@"%f;%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] forKey:@"spoofed_location"]; }
- (NSString*)spoofedLocation { 
    if([_tweakSettings stringForKey:@"spoofed_location"]){
        return [_tweakSettings stringForKey:@"spoofed_location"];}
    return @"32.61603;44.02488"; }
- (BOOL)featureStateForTag:(NSUInteger)tag {return [_tweakSettings boolForKey:[@(tag) stringValue]]; }
- (BOOL)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag{ [_tweakSettings setBool:newState forKey:[@(tag) stringValue]]; return YES;}
- (NSString*)localizedStringForKey:(NSString*)key{ return [_bundle localizedStringForKey:key value:@"error" table:nil]; }

@end