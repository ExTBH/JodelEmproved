#include <Foundation/Foundation.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSFileManager.h>
#include <Foundation/NSUserDefaults.h>
#import <UIKit/UIKit.h>
#include <objc/objc.h>

@interface UIImage (Scale)
+ (UIImage *)resizeImageFromImage:(UIImage *)image withSize:(CGSize)size;
@end

@interface NSUserDefaults (Colors)
- (void)setColor:(UIColor*)color forKey:(NSString*)key;
- (UIColor*)colorForKey:(NSString*)key;
@end

@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController;
@end

@interface NSDataDetector (Shared)
+ (NSDataDetector*)sharedInstance;
@end

@interface NSFileManager (Batch)
- (NSError*)removeItemsAtPaths:(NSArray<NSString*>*)paths withBlacklist:(NSSet<NSString*>*)blacklist;
@end

@interface NSArray (Paths)
-(NSArray<NSString*>*)arrayByPrePendingPathComponent:(NSString*)component;
@end

@interface NSString (Paths)
- (BOOL)pathPartOfPaths:(NSSet<NSString*>*)paths;
@end