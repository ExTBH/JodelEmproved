#import "Exts.h"

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