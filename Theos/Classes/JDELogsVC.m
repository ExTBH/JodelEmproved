#import "JDELogsVC.h"
#import "JDESettingsManager.h"


@interface JDELogsVC()
@property (strong, nonatomic) UITextView *logView;
@end

@implementation JDELogsVC
- (void)viewDidLoad
{
    self.title = [[JDESettingsManager sharedInstance] localizedStringForKey:@"logs"];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self configureLogView];
    [self loadLogs];
}

- (void)configureLogView
{
    self.logView = [UITextView new];
    self.logView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logView.editable = NO;
    self.logView.textColor = UIColor.secondaryLabelColor;
    self.logView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.logView];

    [NSLayoutConstraint activateConstraints:@[
        [self.logView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.logView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor constant:10],
        [self.logView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor constant:-10],
        [self.logView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}
- (void)loadLogs{
    JDESettingsManager *manager = [JDESettingsManager sharedInstance];
    if([[NSFileManager defaultManager] fileExistsAtPath:manager.logFile]){
        self.logView.text = [NSString stringWithContentsOfFile:manager.logFile encoding:NSUTF8StringEncoding error:nil];
    }
    else{
        self.logView.text = @"No Log File Found";
    }
}

@end