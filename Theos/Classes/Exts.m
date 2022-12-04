#import "Exts.h"
#include <UIKit/UIColor.h>
@implementation UIImage (Scale)
// Resize images by luki120 @ Theos discord
+ (UIImage *)resizeImageFromImage:(UIImage *)image withSize:(CGSize)size {

    CGSize newSize = size;

    CGFloat scale = MAX(newSize.width/image.size.width, newSize.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake(
        (newSize.width - width)/2.0,
        (newSize.height - height)/2.0,
        width,
        height
    );

    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect: imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

}
@end

@implementation NSUserDefaults (Colors)
- (void)setColor:(UIColor*)color forKey:(NSString*)key{
    NSData *archivedColor = [NSKeyedArchiver archivedDataWithRootObject:color
        requiringSecureCoding:NO
        error:nil];
    [self setObject:archivedColor forKey:key];
}
- (UIColor*)colorForKey:(NSString*)key{
    NSData *archivedColor = [self objectForKey:key];
    if (archivedColor){
        UIColor *color = [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:archivedColor error:nil];
        return color;
    }
    return nil;
}
@end

@implementation UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController {
    UIResponder *responder = [self nextResponder];
    while (responder != nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end

@implementation NSDataDetector (Shared)
+ (NSDataDetector *)sharedInstance {
    static NSDataDetector *shared = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        shared = [self dataDetectorWithTypes:NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber error:nil];
        });
    return shared;

}

@end