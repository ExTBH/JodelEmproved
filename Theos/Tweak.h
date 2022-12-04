#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "JDEViewController.h"
#import "Headers/AppHaptic.h"
#import "Headers/ZSWTappableLabel.h"
#import <SafariServices/SafariServices.h>
#import "Headers/WalkthroughViewController.h"
#import "Headers/ShrinkAnimationButton.h"

@interface PictureFeedViewController : UIViewController
@property (weak, nonatomic, readwrite) UIButton *addReactionButton;
@end

@interface JDLAVCamCaptureManager : NSObject
- (bool)capturePhoto;
@end

@interface ImageCaptureViewController : UIViewController <PHPickerViewControllerDelegate,
                                                            UIImagePickerControllerDelegate,
                                                            UINavigationControllerDelegate>
- (void)JDEuploadImage:(id)sender;
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results;
- (void)captureManagerStillImageCaptured:(id)iDontReallyKnow image:(id)aImage;
- (void)loadImage:(UIImage*)image;

@end

@interface JDLFeedTableViewSource <UITableViewDataSource, UITableViewDelegate> //Its both delegate and dataSource. BLKFlexibleHeightBar forwards calls to it
@end

@interface JDLPostDetailsPostCell : UITableViewCell

- (id)contentLabel;
- (void)setContentLabel:(id)contentLabel;
@end


@interface FeedCellTextContentViewV2 : UIView
- (id)contentLabel;// returns a Jodel.TappableLabel : UIlabel, hook and get text from it
- (void)didTapAction:(id)sender;// shows action sheet for the post
@end

@interface ChatboxViewController : UIViewController
- (void)tappedSend;
@end

@interface FeedCellVoteView : UIView
- (void)downvoteTap:(id)sender;
- (void)upvoteTap:(id)sender;
- (UIViewController *) firstAvailableUIViewController:(UIView*)view; //Getting the VC to show an alert
@end

@interface TappableLabel : UILabel
@end
@interface FeedCellTappableLabelDelegate : NSObject <ZSWTappableLabelTapDelegate>
@end