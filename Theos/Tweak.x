#import "Tweak.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) // https://stackoverflow.com/a/5337804

//Add Settings button

@interface MainFeedViewController : UIViewController
@end

%hook MainFeedViewController
- (void)viewDidLoad{
    %orig;
    @try{
        [[JDESettingsManager sharedInstance] logString:@"Adding setting button"];
        MainFeedViewController *usableSelf = self;
        UIBarButtonItem *statsButton = [[UIBarButtonItem alloc] initWithTitle: [[JDESettingsManager sharedInstance] localizedStringForKey:@"emproved"]
                                                                        style:UIBarButtonItemStyleDone target:self 
                                                                        action:@selector(presentJDEViewController:)];
        
        usableSelf.navigationItem.leftBarButtonItem = statsButton;
    }
     @catch(NSException *exception){
        [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"Failed to add settings button: %@", exception]];
    }
}

%new
-(void)presentJDEViewController:(id)sender{
    [[JDESettingsManager sharedInstance] logString:@"Presenting settings VC"];
    JDEViewController *settingsVC = [JDEViewController new];
    settingsVC.title = [[JDESettingsManager sharedInstance] localizedStringForKey:@"emproved"];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

%end

//Enable Paste In New Posts
%hook PlaceholderTextView
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if([[JDESettingsManager sharedInstance] featureStateForTag:3]){
        if (action == @selector(paste:))
            return YES;
        if (action == @selector(copy:))
            return YES;
        if (action == @selector(selectAll:))
            return YES;
            }
    return %orig;
}

%end

//Enable Saving Images
%hook PictureFeedViewController

- (void)viewDidLoad{
    PictureFeedViewController *usuableSelf = self;
    %orig;
    if([[JDESettingsManager sharedInstance] featureStateForTag:0]){
        [[JDESettingsManager sharedInstance] logString:@"Adding image save button"];
        UIView *view = [self viewIfLoaded];
        UIButton *btn = [[[JDEButtons alloc] init] buttonWithImageNamed:@"arrow.down.circle.fill"];
        [btn addTarget:self action:@selector(JDEsaveImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        //Constraints
        [btn.trailingAnchor constraintEqualToAnchor:usuableSelf.addReactionButton.safeAreaLayoutGuide.leadingAnchor constant:-20].active = YES;
        [btn.bottomAnchor constraintEqualToAnchor:usuableSelf.addReactionButton.safeAreaLayoutGuide.bottomAnchor constant:-7].active = YES;
    }
}

%new
- (bool)JDEsaveImage:(id)sender{
    @try{
        [[JDESettingsManager sharedInstance] logString:@"Saving image"];
        UIView *view = [self view];
        view = [[view subviews] firstObject];
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil);
        [[JDESettingsManager sharedInstance] logString:@"Saved image"];
        return YES;
    }
    @catch(NSException *exception){
        [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"Failed to save image: %@", exception]];
        return NO;
    }
}


%end

//Enable Uploading From Gallery
%hook ImageCaptureViewController
- (void)viewDidLoad{
    %orig;
    if([[JDESettingsManager sharedInstance] featureStateForTag:1]){
        [[JDESettingsManager sharedInstance] logString:@"Adding image upload button"];
        UIView *view = [self viewIfLoaded];
        UIButton *realGalleryBtn = nil;
        for(id temp in view.subviews){
            if([temp isMemberOfClass:objc_getClass("Jodel.ButtonWithBanner")]){ realGalleryBtn = temp; }
        }
        UIButton *btn = [[[JDEButtons alloc] init] buttonWithImageNamed:@"arrow.up.circle.fill"];
        [btn addTarget:self action:@selector(JDEuploadImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        //Constraints
        [btn.trailingAnchor constraintEqualToAnchor:realGalleryBtn.safeAreaLayoutGuide.leadingAnchor constant:-20].active = YES;
        [btn.bottomAnchor constraintEqualToAnchor:realGalleryBtn.safeAreaLayoutGuide.bottomAnchor constant:-7].active = YES;
    }
}

%new
-(void)JDEuploadImage:(id)sender{
    // IOS 14+ Only!!!!
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14")){
        [[JDESettingsManager sharedInstance] logString:@"Selecting image to upload iOS 14+"];
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.selectionLimit = 1;
        config.filter = [PHPickerFilter imagesFilter];
        PHPickerViewController *photoPicker = [[PHPickerViewController alloc] initWithConfiguration:config];
        photoPicker.delegate = self;

        [self presentViewController:photoPicker animated:YES completion:nil];
    }
    // IOS 13
    else {
        [[JDESettingsManager sharedInstance] logString:@"Selecting image to upload iOS 13-"];
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
//iOS14 and up
%new
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{

    [picker dismissViewControllerAnimated:YES completion:nil];
    PHPickerResult *result = [results firstObject];

    [result.itemProvider loadObjectOfClass:UIImage.self
                            completionHandler:^(UIImage* image, NSError *error){
        if(error){
            [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"Failed to select image iOS 14+: %@", error.description]];
        } else{
            [[JDESettingsManager sharedInstance] logString:@"Selected image to upload iOS 14+"];
            [self loadImage:image];
        }
    }];
}
//iOS13 and below
%new
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^(){
        [[JDESettingsManager sharedInstance] logString:@"Selected image to upload iOS 13-"];
        [self loadImage:info[UIImagePickerControllerOriginalImage]];
    }];
}
%new
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


%new
- (void)loadImage:(UIImage*)image{
    [[JDESettingsManager sharedInstance] logString:@"Loading selected image"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self captureManagerStillImageCaptured:self image:image];
    });
}

// Required as of 7.59 because the app checks the method from protocol [JDLAVCamCaptureManager isFrontCamera], delegate is self
// Improve the hook later
// Side effects, Captured photos wont get flipped 
%new
- (BOOL)isFrontCamera{
    return NO;
}
%end

//Disable Screenshots
%hook ScreenshotService
- (void)madeScreenshot{
    if([[JDESettingsManager sharedInstance] featureStateForTag:6]){
        [[JDESettingsManager sharedInstance] logString:@"Bypassed Screenshot"];
        return;
        }
    return %orig;
}
%end

//Spoof Location
%hook JDLSWGJSONRequestSerializer

- (id)lastStoredUserLocation{
    if([[JDESettingsManager sharedInstance] featureStateForTag:2]){ 
        NSString *spoofedLoc = [[JDESettingsManager sharedInstance] spoofedLocation];
        [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"Spoofed location to %@", spoofedLoc]];
        return spoofedLoc;
        }
    return %orig;
}
%end

//Confirm Replies
%hook ChatboxViewController
- (void)tappedSend{
    
    if([[JDESettingsManager sharedInstance] featureStateForTag:5]){
        [[JDESettingsManager sharedInstance] logString:@"Confirm reply called"];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_reply_title"] 
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* reply = [UIAlertAction actionWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_reply_ok"] style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) { %orig; }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_reply_no"] style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {}];
        [alert addAction:reply];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else { %orig; }
}
%end

//Confirm Votes
%hook FeedCellVoteView

- (void)downvoteTap:(id)sender{
    if([[JDESettingsManager sharedInstance] featureStateForTag:4]){
        [[JDESettingsManager sharedInstance] logString:@"Confirm downvote called"];
        UIViewController *topVC = [self firstAvailableUIViewController:self];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_vote_title"] 
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* reply = [UIAlertAction actionWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_vote_ok"] style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) { %orig; }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_vote_no"] style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {}];
        [alert addAction:reply];
        [alert addAction:cancel];
        [topVC presentViewController:alert animated:YES completion:nil];
        }
    else { %orig; }
}
- (void)upvoteTap:(id)sender{
    if([[JDESettingsManager sharedInstance] featureStateForTag:4]){
        [[JDESettingsManager sharedInstance] logString:@"Confirm upvote called"];
        UIViewController *topVC = [self firstAvailableUIViewController:self];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_vote_title"] 
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* reply = [UIAlertAction actionWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_vote_ok"] style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) { %orig; }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"confirm_vote_no"] style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {}];
        [alert addAction:reply];
        [alert addAction:cancel];
        [topVC presentViewController:alert animated:YES completion:nil];
        }
    else { %orig; }
}

%new
- (UIViewController *) firstAvailableUIViewController:(UIView*)view {
    UIResponder *responder = [view nextResponder];
    while (responder != nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}
%end

//Copying posts through Context Menus
%hook JDLFeedTableViewSource

%new
- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    
    if([[JDESettingsManager sharedInstance] featureStateForTag:3]){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *cellClass = NSStringFromClass([cell class]);
        //Disabling action for ads and pics and boosted cell
        NSArray *bannedClasses = @[@"Jodel.AdColumnCell",
                                    @"Jodel.JDLFeedPostMediaCell",
                                    @"Jodel.MultiBoostCell",
                                    @"Jodel.JDLPostDetailsPostMediaCell"];
        for(NSString *bannedClass in bannedClasses){
            if([cellClass isEqualToString:bannedClass]){ 
                [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"don't show context menu for post (%@)", cellClass]];
                return nil;
                }
        }

        UIAction *copy = [UIAction actionWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"copy"] 
                                                    image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(UIAction *handler) {
                                                        //Handle copying for normal and poll main feed cells
                                                        if([cellClass isEqualToString:@"Jodel.JDLFeedPostCell"] 
                                                            || [cellClass isEqualToString:@"Jodel.FeedPollCell"]){
                                                                UIPasteboard.generalPasteboard.string = [[[cell.contentView subviews][1] contentLabel] text];
                                                                [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"Successfully copied for (%@)", cellClass]];
                                                        }
                                                        //Copying for sub posts
                                                        else if([cellClass isEqualToString:@"Jodel.JDLPostDetailsPostCell"]){
                                                            //Change cell type to access methods interfaced methods
                                                            JDLPostDetailsPostCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                                            UIPasteboard.generalPasteboard.string = [[cell contentLabel] text];
                                                            [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"Successfully copied for (%@)", cellClass]];
                                                        }
                                                        else{
                                                            [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"Failed to copy for (%@)", cellClass]];
                                                        }
                                                    }];

        [[JDESettingsManager sharedInstance] logString:[NSString stringWithFormat:@"show context menu for post (%@)", cellClass]];
        UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[copy]];
        UIContextMenuConfiguration *menuConfig = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^(NSArray *suggestedActions) { return menu;}
        ];
        
        return  menuConfig;
    } else { return nil; }
}
%end

%hook TappableLabel
-(void)setAttributedText:(NSAttributedString *)arg1{
    NSMutableAttributedString *newAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:arg1];
    if([[JDESettingsManager sharedInstance] featureStateForTag:7]){
        
        [[NSDataDetector sharedInstance] enumerateMatchesInString:arg1.string options:0 range:NSMakeRange(0, arg1.string.length) 
            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
                attributes[ZSWTappableLabelTappableRegionAttributeName] = @YES;
                attributes[ZSWTappableLabelHighlightedBackgroundAttributeName] = UIColor.lightGrayColor;
                attributes[ZSWTappableLabelHighlightedForegroundAttributeName] = UIColor.whiteColor;
                attributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
                attributes[@"NSTextCheckingResult"] = result;
                [newAttributedString addAttributes:attributes range:result.range];
            }];
    }

    %orig(newAttributedString);

}
%end

%hook FeedCellTappableLabelDelegate
- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel tappedAtIndex:(NSInteger)idx withAttributes:(NSDictionary<NSAttributedStringKey, id> *)attributes{
    if([[JDESettingsManager sharedInstance] featureStateForTag:7]){
        NSTextCheckingResult *result = attributes[@"NSTextCheckingResult"];
        UIViewController *presentationController = [tappableLabel firstAvailableUIViewController];
        if (result){
            switch(result.resultType){
                case NSTextCheckingTypeLink:{
                        SFSafariViewController *inApp = [[SFSafariViewController alloc] initWithURL:result.URL];
                        [presentationController presentViewController:inApp animated:YES completion:nil];
                    }
                    break;
                case NSTextCheckingTypePhoneNumber:{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Open with" 
                        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

                    UIAlertAction *whatsappAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Whatsapp: %@", result.phoneNumber] 
                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://wa.me/%@", result.phoneNumber]];
                            [UIApplication.sharedApplication openURL:whatsappURL options:@{} completionHandler:nil];
                        }];

                    [alert addAction:cancelAlert];
                    [alert addAction:whatsappAlert];
                    [presentationController presentViewController:alert animated:YES completion:nil];
                }
                    break;
                default:
                    break;
            }
        }
    }
    %orig;
}
%end

//DON'T DELETE WILL BREAK ABOVE METHOD
%hook JDLPostDetailsPostCell
%end

%hook UIColor
+ (UIColor *)colorNamed:(NSString *)name{

    UIColor *color = [[JDESettingsManager sharedInstance].tweakSettings colorForKey:name];
    if (!color){
        return %orig;
    }
    return color;

}
%end

%hook WalkthroughViewController
- (void)viewDidLayoutSubviews{
    %orig;

    ShrinkAnimationButton *targetButton = nil;
    Class trgtClass = objc_getClass("Jodel.ShrinkAnimationButton");

    for(id view in [self view].subviews){
        if([view isKindOfClass:[trgtClass class]]){
            targetButton = view;
            break;
        }
    }
}

-(void)didTapNext{
    UIAlertController *accAlert = [UIAlertController alertControllerWithTitle:nil 
        message:nil 
        preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
        style:UIAlertActionStyleCancel 
        handler:nil];

    UIAlertAction *withToken = [UIAlertAction actionWithTitle:@"Use Token" 
        style:UIAlertActionStyleDefault 
        handler:^(UIAlertAction  *action){
            [self showTokenAlertWithCompletion:^(){
                %orig;
            }];
        }];

    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Use Default" 
        style:UIAlertActionStyleDefault 
        handler:^(UIAlertAction  *action){
            %orig;
        }];

    [accAlert addAction:cancelAction];
    [accAlert addAction:withToken];
    [accAlert addAction:defaultAction];
    [self presentViewController:accAlert animated:YES completion:nil];
}
%new
- (void)showTokenAlertWithCompletion:(void (^)())completion{
    UIAlertController *tokenAlert = [UIAlertController alertControllerWithTitle:nil 
        message:@"Use Token"
        preferredStyle:UIAlertControllerStyleAlert];

    [tokenAlert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"UUID key here";
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
        style:UIAlertActionStyleCancel 
        handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" 
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction *alertAction){
            [[NSUserDefaults standardUserDefaults] setObject:[tokenAlert.textFields firstObject].text forKey:@"fc_uuidForDevice"];
            completion();
        }];
    [tokenAlert addAction:cancelAction];
    [tokenAlert addAction:okAction];
    
    [self presentViewController:tokenAlert animated:YES completion:nil];

}

%end

%hook ShrinkAnimationButton
%end
%ctor {
    %init(PlaceholderTextView=objc_getClass("Jodel.PlaceholderTextView"),
    PictureFeedViewController=objc_getClass("Jodel.PictureFeedViewController"),
    ScreenshotService=objc_getClass("Jodel.ScreenshotService"),
    FeedCellVoteView=objc_getClass("Jodel.JDLFeedCellVoteView"),
    JDLPostDetailsPostCell=objc_getClass("Jodel.JDLPostDetailsPostCell"),
    ChatboxViewController=objc_getClass("Jodel.ChatboxViewController"),
    JDLFeedTableViewSource=objc_getClass("Jodel.JDLFeedTableViewSource"),
    MainFeedViewController=objc_getClass("Jodel.MainFeedViewController"),
    ImageCaptureViewController=objc_getClass("Jodel.ImageCaptureViewController"),
    TappableLabel=objc_getClass("Jodel.TappableLabel"),
    FeedCellTappableLabelDelegate=objc_getClass("Jodel.FeedCellTappableLabelDelegate"),
    WalkthroughViewController=objc_getClass("Jodel.WalkthroughViewController"),
    ShrinkAnimationButton=objc_getClass("Jodel.ShrinkAnimationButton"));
}

