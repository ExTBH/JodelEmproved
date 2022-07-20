#import "Tweak.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) // https://stackoverflow.com/a/5337804

//Add JDEvc & Button
%hook JDLMainFeedNavigationController
%property (strong, nonatomic) JDEViewController *JDEvc;

-(void)viewDidLoad{
    %orig;
    JDLMainFeedNavigationController *usuableSelf = self;
    usuableSelf.JDEvc = [[JDEViewController alloc] init];

    [self JDEaddSettingsButton];
}

%new
-(void)JDEaddSettingsButton{
    @try {
        UIView *view = [self viewIfLoaded];
        UIButton *btn = [[[JDEButtons alloc] init] defaultButton];
        [btn addTarget:self action:@selector(presentJDEViewController:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"emproved"] forState:UIControlStateNormal];
        [view addSubview:btn];
        //Constraints
        [btn.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:7].active = YES;
        [btn.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
        [btn.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.25].active = YES;

    }
    @catch(NSException *exception){}
}

%new
-(void)presentJDEViewController:(id)sender{
    JDLMainFeedNavigationController *usuableSelf = self;
    [self presentViewController:usuableSelf.JDEvc animated:YES completion:nil];
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

//Enable Copy In Main Feed
%hook FeedCellTextContentViewV2

- (id)initWithFrame:(struct CGRect)frame{
    if([[JDESettingsManager sharedInstance] featureStateForTag:3]){
        UIView *view = %orig;
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                            initWithTarget:self action:@selector(JDEcopyFeedText:)];
        lpgr.minimumPressDuration = 0.5;
        lpgr.delegate = self;
        [view addGestureRecognizer:lpgr];
        return view;
        }
    return %orig;
}

%new
- (void)JDEcopyFeedText:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIPasteboard.generalPasteboard.string = [[self contentLabel] text];
        [objc_getClass("Jodel.AppHaptic") makeHeavyFeedback];
    }   
}
%end

//Enable Copy In Sub Posts
%hook JDLPostDetailsPostCellV2
- (void)setContentLabel:(id)contentLabel{
    if([[JDESettingsManager sharedInstance] featureStateForTag:3]){
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                            initWithTarget:self action:@selector(JDEcopyReplyText:)];
        lpgr.minimumPressDuration = 0.5;
        lpgr.delegate = self;
        [self addGestureRecognizer:lpgr];
    }
    %orig;
}

%new
- (void)JDEcopyReplyText:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIPasteboard.generalPasteboard.string = [[self contentLabel] text];
        [objc_getClass("Jodel.AppHaptic") makeHeavyFeedback];
    }   
}
%end

//Enable Saving Images
%hook PictureFeedViewController

- (void)viewDidLoad{
    PictureFeedViewController *usuableSelf = self;
    %orig;
    if([[JDESettingsManager sharedInstance] featureStateForTag:0]){

        UIView *view = [self viewIfLoaded];
        UIButton *btn = [[[JDEButtons alloc] init] boldButton];
        [btn setTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"save"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(JDEsaveImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        //Constraints
        [btn.trailingAnchor constraintEqualToAnchor:usuableSelf.addReactionButton.safeAreaLayoutGuide.leadingAnchor constant:-15].active = YES;
        [btn.bottomAnchor constraintEqualToAnchor:usuableSelf.addReactionButton.safeAreaLayoutGuide.bottomAnchor constant:-5].active = YES;

    }
}

%new
- (bool)JDEsaveImage:(id)sender{
    @try{
        UIView *view = [self view];
        view = [[view subviews] firstObject];
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil);
        return YES;
    }
    @catch(NSException *exception){
        return NO;
    }
}


%end

//Enable Uploading From Gallery
%hook JDLImageCaptureViewController
- (void)viewDidLoad{
    %orig;
    if([[JDESettingsManager sharedInstance] featureStateForTag:1]){
        UIView *view = [self viewIfLoaded];
        UIButton *realGalleryBtn = nil;
        for(id temp in view.subviews){
            if([temp isMemberOfClass:objc_getClass("Jodel.ButtonWithBanner")]){ realGalleryBtn = temp; }
        }
        UIButton *btn = [[[JDEButtons alloc] init] boldButton];
        [btn setTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"upload"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(JDEuploadImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        //Constraints
        [btn.trailingAnchor constraintEqualToAnchor:realGalleryBtn.safeAreaLayoutGuide.leadingAnchor constant:-15].active = YES;
        [btn.bottomAnchor constraintEqualToAnchor:realGalleryBtn.safeAreaLayoutGuide.bottomAnchor].active = YES;
    }
}

%new
-(void)JDEuploadImage:(id)sender{
    // IOS 14+ Only!!!!
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14")){
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.selectionLimit = 1;
        config.filter = [PHPickerFilter imagesFilter];
        PHPickerViewController *photoPicker = [[PHPickerViewController alloc] initWithConfiguration:config];
        photoPicker.delegate = self;

        [self presentViewController:photoPicker animated:YES completion:nil];
    }
    else {
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
            NSLog(@"%@", error);
        } else{
            [self loadImage:image];
        }
    }];
}
//iOS13 and below
%new
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^(){
        [self loadImage:info[UIImagePickerControllerOriginalImage]];
    }];
}
%new
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

%new
- (void)loadImage:(UIImage*)image{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self captureManagerStillImageCaptured:self image:image];
    });
}
%end

//Disable Screenshots
%hook ScreenshotService
- (void)madeScreenshot{
    if([[JDESettingsManager sharedInstance] featureStateForTag:6]){ return; }
    return %orig;
}
%end

//Spoof Location
%hook JDLSWGJSONRequestSerializer

- (id)lastStoredUserLocation{
    if([[JDESettingsManager sharedInstance] featureStateForTag:2]){ return [[JDESettingsManager sharedInstance] spoofedLocation];}
    return %orig;
}
%end

//Confirm Replies
%hook ChatboxViewController
- (void)tappedSend{
    if([[JDESettingsManager sharedInstance] featureStateForTag:5]){
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


%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"),
    PlaceholderTextView=objc_getClass("Jodel.PlaceholderTextView"),
    PictureFeedViewController=objc_getClass("Jodel.PictureFeedViewController"),
    ScreenshotService=objc_getClass("Jodel.ScreenshotService"),
    FeedCellTextContentViewV2=objc_getClass("Jodel.FeedCellTextContentViewV2"),
    JDLPostDetailsPostCellV2=objc_getClass("Jodel.JDLPostDetailsPostCellV2"),
    ChatboxViewController=objc_getClass("Jodel.ChatboxViewController"));
}

