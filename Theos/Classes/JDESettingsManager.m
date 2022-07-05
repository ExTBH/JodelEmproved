#import "JDESettingsManager.h"

#define suiteName "dev.extbh.jodelemproved"

@interface JDESettingsManager()
@property (strong, nonatomic) NSUserDefaults *tweakSettings;
@property (strong, nonatomic) NSArray<NSString*> *features;
@property (strong, nonatomic) NSArray<NSNumber*> *featuresTags;
@end

@implementation JDESettingsManager
- (id) init{
    self = [super init];
    if (self != nil){
        _tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:@suiteName];
        //_features = @[@"save_images", @"upload_images", @"spoof_gps", @"copy_paste", @"confirm_vote", @"confirm_reply", @"anti_ss", @"anti_telemtry"];
        _features = @[@"Save images", @"Upload from gallery", @"Location spoofer", @"Copy & Paste", @"Confirm votes", @"confirm replies", @"Screenshot protection", @"Tracking protection"];
        _featuresTags = @[@0, @1, @2, @3, @4, @5, @6, @7];
        if(_features.count != _featuresTags.count){NSLog(@"JDELogs %s Features Length does not match %lu %lu", __PRETTY_FUNCTION__, _features.count, _featuresTags.count); return nil;}
    }
    return self;
}
- (NSArray<NSString*>*)features{ return _features; }
- (NSUInteger)numberOfFeatures{ return _features.count; }
- (NSString*)featureNameForRow:(NSUInteger)row{ return _features[row]; }
- (NSNumber*)featureTagForRow:(NSUInteger)row{ return _featuresTags[row]; }
- (BOOL)featureStateForTag:(NSUInteger)row {return [_tweakSettings boolForKey:[@(row) stringValue]]; }
- (BOOL)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag{ [_tweakSettings setBool:newState forKey:[@(tag) stringValue]]; return YES;}
@end