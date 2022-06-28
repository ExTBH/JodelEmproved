#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
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

@interface JDLImageCaptureViewController : UIViewController
@property (nonatomic, strong, readwrite)JDLAVCamCaptureManager *captureManager; // returned by -(id)captureManager
- (void)captureManagerStillImageCaptured:(id)callerSelf image:(id)aImage;
@end
