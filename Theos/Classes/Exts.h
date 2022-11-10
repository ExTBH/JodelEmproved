#include <Foundation/NSUserDefaults.h>
#import <UIKit/UIKit.h>

@interface UIImage (Scale)
+ (UIImage *)resizeImageFromImage:(UIImage *)image withSize:(CGSize)size;
@end

@interface NSUserDefaults (Colors)
- (void)setColor:(UIColor*)color forKey:(NSString*)key;
- (UIColor*)colorForKey:(NSString*)key;
@end