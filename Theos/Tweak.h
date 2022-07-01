#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "JDEViewController.h"


@interface JDLMainFeedNavigationController : UINavigationController

-(BOOL)JDEaddSettingsButton;
-(void)presentJDEViewController:(id)sender;
@end


@interface PictureFeedViewController : UIViewController
@end

@interface JDLAVCamCaptureManager : NSObject
//@property (nonatomic, strong, readwrite)AVCapturePhotoOutput *photoOutput;
- (bool)capturePhoto;
@end

@interface JDLImageCaptureViewController : UIViewController <PHPickerViewControllerDelegate>
- (void)JDEuploadImage:(id)sender;
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results;
- (void)captureManagerStillImageCaptured:(id)iDontReallyKnow image:(id)aImage;
- (void)loadImage:(UIImage*)image;

@end

@interface JDLFeedTableViewSource <UITableViewDataSource>
@end

// @interface class_JDLFeedPostCellV2 : UITableViewCell

// @end

@interface FeedCellTextContentViewV2 : UIView
- (id)contentLabel;// returns a Jodel.TappableLabel : UIlabel, hook and get text from it
@end
