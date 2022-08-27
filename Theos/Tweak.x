#import "Tweak.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) // https://stackoverflow.com/a/5337804

//Add JDEvc & Button
%hook JDLMainFeedNavigationController
-(void)viewDidLoad{
    %orig;
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
        UIButton *btn = [[[JDEButtons alloc] init] buttonWithImageNamed:@"arrow.up.circle.fill"];
        //[btn setTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"upload"] forState:UIControlStateNormal];
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

//Confirm Votes
%hook FeedCellVoteView

- (void)downvoteTap:(id)sender{
    if([[JDESettingsManager sharedInstance] featureStateForTag:4]){
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
        NSLog(@"JDELogs cell %@", cell);
        NSString *cellClass = NSStringFromClass([cell class]);
        //Disabling action for ads and pics and boosted cell
        for(NSString *bannedClass in @[@"Jodel.AdColumnCell", @"Jodel.JDLFeedPostMediaCellV2", @"Jodel.MultiBoostCell",@"Jodel.JDLPostDetailsPostMediaCellV2"]){
            if([cellClass isEqualToString:bannedClass]){ return nil; }
        }

        UIAction *copy = [UIAction actionWithTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"copy"] 
                                                    image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(UIAction *handler) {
                                                        NSLog(@"JDELogs %@", [cell.contentView subviews]);
                                                        //Handle copying for normal and poll main feed cells
                                                        if([cellClass isEqualToString:@"Jodel.JDLFeedPostCellV2"] || [cellClass isEqualToString:@"Jodel.FeedPollCellV2"]){
                                                            UIPasteboard.generalPasteboard.string = [[[cell.contentView subviews][1] contentLabel] text];
                                                        }
                                                        //Copying for sub posts
                                                        if([cellClass isEqualToString:@"Jodel.JDLPostDetailsPostCellV2"]){
                                                            //Change cell type to access methods interfaced methods
                                                            JDLPostDetailsPostCellV2 *cell = [tableView cellForRowAtIndexPath:indexPath];
                                                            UIPasteboard.generalPasteboard.string = [[cell contentLabel] text];
                                                        }
                                                    }];


        UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[copy]];
        UIContextMenuConfiguration *menuConfig = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^(NSArray *suggestedActions) { return menu;}
        ];
        
        return  menuConfig;
    } else { return nil; }
}
%end

//DON'T DELETE WILL BREAK ABOVE METHOD
%hook JDLPostDetailsPostCellV2
%end

%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"),
    PlaceholderTextView=objc_getClass("Jodel.PlaceholderTextView"),
    PictureFeedViewController=objc_getClass("Jodel.PictureFeedViewController"),
    ScreenshotService=objc_getClass("Jodel.ScreenshotService"),
    FeedCellVoteView=objc_getClass("Jodel.JDLFeedCellVoteView"),
    JDLPostDetailsPostCellV2=objc_getClass("Jodel.JDLPostDetailsPostCellV2"),
    ChatboxViewController=objc_getClass("Jodel.ChatboxViewController"),
    LoadingTableView=objc_getClass("Jodel.LoadingTableView"),
    JDLFeedTableViewSource=objc_getClass("Jodel.JDLFeedTableViewSource"));
}

