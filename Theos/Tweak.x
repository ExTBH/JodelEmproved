#import "Tweak.h"


%hook JDLMainFeedNavigationController

JDEViewController *JDEvc;


-(void)viewDidLoad{
    %orig;
    UIViewController *JDLmainFeedViewController = [[self childViewControllers] firstObject];
    JDEvc = [[JDEViewController alloc] init];

    bool didAddSettingsButton = [self JDEaddSettingsButton];
    if(!didAddSettingsButton){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Restart the APP!" message:@"Failed to load the Settings Button" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:dismissAlert];
        [JDLmainFeedViewController presentViewController:alert animated:YES completion:nil];
    }
}

%new
-(BOOL)JDEaddSettingsButton{
    @try {
        UIView *view = [self viewIfLoaded];
        UIButton *btn = [[[JDEButtons alloc] init] defaultButton];
        [btn addTarget:self action:@selector(presentJDEViewController:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        //Constraints
        [btn.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:10].active = YES;
        [btn.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
        [btn.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.25].active = YES;

        
        return YES;
    }
    @catch(NSException *exception){
        return NO;
    }
}

%new
-(void)presentJDEViewController:(id)sender{
    NSBundle *mainBundle = [NSBundle bundleWithPath:@PATH];
    NSString *configPath = [mainBundle pathForResource:@"config" ofType:@"json"];
    // present UIAlert later
    if (configPath == nil){
        return;
    }
    [self presentViewController:JDEvc animated:YES completion:nil];
}
%end


//Enable Paste In New Posts
%hook PlaceholderTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (action == @selector(paste:))
        return YES;
    if (action == @selector(copy:))
        return YES;
    if (action == @selector(selectAll:))
        return YES;
    return %orig;
}

%end



//Enable Saving Images
%hook PictureFeedViewController

- (void)viewDidLoad{
    %orig;
    @try {
        UIView *view = [self viewIfLoaded];
        UIButton *btn = [[[JDEButtons alloc] init] boldButton];
        [btn setTitle:@"Save" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(JDEsaveImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        //Constraints
        [btn.trailingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.trailingAnchor constant:-77].active = YES;
        [btn.bottomAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.bottomAnchor constant:-45].active = YES;

    }
    @catch(NSException *exception){
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




@interface JDLImageCaptureViewController() <PHPickerViewControllerDelegate>
- (void)JDEuploadImage:(id)sender;
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results;
- (void)captureManagerStillImageCaptured:(id)iDontReallyKnow image:(id)aImage;
- (void)loadImage:(UIImage*)image;
@end

%hook JDLImageCaptureViewController
- (void)viewDidLoad{
    %orig;
    UIView *view = [self viewIfLoaded];
    UIButton *btn = [[[JDEButtons alloc] init] boldButton];
    [btn setTitle:@"Upload" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(JDEuploadImage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    //Constraints
    [btn.centerYAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.centerYAnchor].active = YES;
    [btn.centerXAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.centerXAnchor].active = YES;
}

%new
-(void)JDEuploadImage:(id)sender{
    // IOS 14+ Only!!!!
    PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
    config.selectionLimit = 1;
    config.filter = [PHPickerFilter imagesFilter];
    PHPickerViewController *photoPicker = [[PHPickerViewController alloc] initWithConfiguration:config];
    photoPicker.delegate = self;

    [self presentViewController:photoPicker animated:YES completion:nil];

}
%new
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
    NSLog(@"JDELogs didFinishPicking called %@", results);
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

}

%end

%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"),
    PlaceholderTextView=objc_getClass("Jodel.PlaceholderTextView"),
    PictureFeedViewController=objc_getClass("Jodel.PictureFeedViewController"),
    ScreenshotService=objc_getClass("Jodel.ScreenshotService"));
}