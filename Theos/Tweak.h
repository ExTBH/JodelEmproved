#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "JDEViewController.h"
#import "Headers/AppHaptic.h"


@interface JDLMainFeedNavigationController : UINavigationController
@property (strong, nonatomic) NSUserDefaults *JDEsettings;
@property (strong, nonatomic) JDEViewController *JDEvc;
-(BOOL)JDEaddSettingsButton;
-(void)presentJDEViewController:(id)sender;
@end


@interface PictureFeedViewController : UIViewController
@property (weak, nonatomic, readwrite) UIButton *addReactionButton;
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
- (id)tableView:(id)tableView cellForRowAtIndexPath:(id)indexPath;
@end

@interface JDLPostDetailsPostCellV2 : UITableViewCell
- (id)contentLabel;
- (void)setContentLabel:(id)contentLabel;
@end


@interface FeedCellTextContentViewV2 : UIView
- (id)contentLabel;// returns a Jodel.TappableLabel : UIlabel, hook and get text from it
- (void)didTapAction:(id)sender;// shows action sheet for the post
@end

