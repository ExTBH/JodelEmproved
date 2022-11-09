#import "JDESettingsManager.h"
#include <Foundation/NSString.h>
#include <Foundation/NSObjCRuntime.h>
#include <UIKit/UIColor.h>

#define suiteName "dev.extbh.jodelemproved"

@interface JDESettingsManager()
@property (strong, nonatomic) NSUserDefaults *tweakSettings;
@property (strong, nonatomic) NSBundle *bundle;
@property (strong, nonatomic, readwrite) NSString *logFile;
@property (nonatomic, readwrite) BOOL logFileExists;
@end

@implementation JDESettingsManager
- (id) init{
    self = [super init];
    if (self != nil){
        _tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:@suiteName];
        //bundle path stuff
        if([[NSBundle mainBundle] pathForResource:@"Jodel EMPROVED" ofType:@"bundle"] != nil){
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Jodel EMPROVED" ofType:@"bundle"];
            _bundle = [NSBundle bundleWithPath:bundlePath];
            }
        else{
            _bundle = [NSBundle bundleWithPath:@"Library/Application Support/Jodel EMPROVED.bundle"];
        }
        //logFile stuff
        NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
        self.logFile = [docsDir stringByAppendingPathComponent:@"JDELogs.log"];
        self.logFileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.logFile];
    }
    return self;
}
+ (JDESettingsManager *)sharedInstance{

    static JDESettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });

    return sharedInstance;

}
- (NSDictionary*)cellInfoForPath:(NSIndexPath*)indexPath{
    NSDictionary *info;
    switch(indexPath.section){
        case 0:
            switch(indexPath.row){
                case 0:
                    info = @{
                        @"title": [self localizedStringForKey:@"save_images"],
                        @"image": [UIImage systemImageNamed:@"square.and.arrow.down"]
                    }; break;
                    
                case 1:
                    info = @{
                        @"title": [self localizedStringForKey:@"upload_images"],
                        @"image": [UIImage systemImageNamed:@"square.and.arrow.up"]
                    }; break;
                case 2:
                    info = @{
                        @"title": [self localizedStringForKey:@"location_spoofer"],
                        @"image": [UIImage systemImageNamed:@"location"]
                    }; break;
                case 3:
                    info = @{
                        @"title": [self localizedStringForKey:@"copy_paste"],
                        @"desc": [self localizedStringForKey:@"copy_paste_desc"],
                        @"image": [UIImage systemImageNamed:@"doc.on.doc"]
                    }; break;
                case 4:
                    info = @{
                        @"title": [self localizedStringForKey:@"confirm_votes"],
                        @"image": [UIImage systemImageNamed:@"checkmark.square"]
                    }; break;
                case 5:
                    info = @{
                        @"title": [self localizedStringForKey:@"confirm_replies"],
                        @"image": [UIImage systemImageNamed:@"checkmark.square"]
                        
                    }; break;
                case 6:
                    info = @{
                        @"title": [self localizedStringForKey:@"screenshot_protection"],
                        @"desc": [self localizedStringForKey:@"screenshot_protection_desc"],
                        @"image": [UIImage systemImageNamed:@"bell.slash"]
                    }; break;
            }
            break;
        case 1:
            switch(indexPath.row){
                case 0:
                    info = @{
                        @"title": [self localizedStringForKey:@"source_code"],
                        @"image":  [[UIImage alloc] initWithContentsOfFile:[self pathForImageWithName:@"github"]]
                    }; break;
                    
                case 1:
                    info = @{
                        @"title": [self localizedStringForKey:@"twitter"],
                        @"image": [[UIImage alloc] initWithContentsOfFile:[self pathForImageWithName:@"twitter"]] 
                    }; break;
                case 2:
                    info = @{
                        @"title": [self localizedStringForKey:@"logs"],
                        @"image": [UIImage systemImageNamed:@"doc.text"]
                    }; break;
            }
    }
    return info;
}
- (void)updateSpoofedLocationWith:(CLLocation*)newLocation { [_tweakSettings setObject:[NSString stringWithFormat:@"%f;%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] forKey:@"spoofed_location"]; }
- (NSString*)spoofedLocation { 
    if([_tweakSettings stringForKey:@"spoofed_location"]){
        return [_tweakSettings stringForKey:@"spoofed_location"];}
    return @"32.61603;44.02488"; }
- (BOOL)featureStateForTag:(NSUInteger)tag {return [_tweakSettings boolForKey:[@(tag) stringValue]]; }
- (void)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag{ [_tweakSettings setBool:newState forKey:[@(tag) stringValue]];
    NSLog(@"JDELogs %d %lu", newState, tag);
}
- (NSString*)localizedStringForKey:(NSString*)key{ return [_bundle localizedStringForKey:key value:@"error" table:nil]; }
- (NSString*)pathForImageWithName:(NSString*)name{
    return [_bundle pathForResource:name ofType:@"png" inDirectory:@"Icons"];
}
- (void)logString:(NSString*)string{
    string = [[NSString stringWithFormat:@"[%@] ", [[NSDate now] description]] stringByAppendingString:string];
    string = [string stringByAppendingString:@"\n"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.logFile];

    if(fileHandle){
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else{
        [string writeToFile:self.logFile atomically:YES  encoding:NSUTF8StringEncoding error:nil];
    }
}
@end