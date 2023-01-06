#import <Foundation/Foundation.h>
#import "JDELogsVC.h"
#import "JDESettingsManager.h"
#import "../Utils/Logging/JELog.h"

@interface JDELogsVC()
@property (strong, nonatomic) UITextView *logView;
@property (strong, nonatomic) JDESettingsManager *manager;
@end

@implementation JDELogsVC
- (void)viewDidLoad{
    self.manager = [JDESettingsManager sharedInstance];
    self.title = [self.manager localizedStringForKey:@"logs"];
    self.view.backgroundColor = UIColor.systemBackgroundColor;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
        initWithImage:[UIImage systemImageNamed:@"ellipsis"]
        style:UIBarButtonItemStylePlain
        target:self
        action:@selector(didTapMore:)];
    
    [self configureLogView];
    [self loadLogs];
}

- (void)configureLogView{
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
    if([[NSFileManager defaultManager] fileExistsAtPath:logFilePath()]){
        NSError *err;
        
        NSDictionary *logsDict = [NSDictionary 
            dictionaryWithContentsOfURL:[NSURL fileURLWithPath:logFilePath()]
            error:&err];

        if  (err.code == NSFileReadCorruptFileError){
            [self clearLogs];
        }
        else if (err != nil){
            self.logView.text = err.debugDescription;
            return;
        }
        NSMutableArray<NSAttributedString*> *logs = [NSMutableArray new];
        for(NSData *log in logsDict[@"logs"]){
            [logs addObject:[[NSAttributedString alloc] initWithData:log
                options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType}
                documentAttributes:nil
                error:nil]];
        }
        NSMutableAttributedString *finalLog = [NSMutableAttributedString new];
        static NSString * const newLineRaw = @"\n";
        NSAttributedString * const newLineAttr = [[NSAttributedString alloc] initWithString:newLineRaw];
        for (NSAttributedString *log in logs){
            [finalLog appendAttributedString:log];
            [finalLog appendAttributedString:newLineAttr];
        }
        self.logView.attributedText = finalLog;
    }
    else{
        self.logView.text = @"No Log File Found";
    }
}

- (void)clearLogs{
    NSError *err;
    [[NSFileManager defaultManager] removeItemAtPath:logFilePath() error:&err];
    if(err){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"An error happened while deleting log file"
            message:err.description
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"Dismiss" 
            style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {}];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        }
    else{
        [self loadLogs];
    }
}
- (void)didTapMore:(id)sender{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* copyAction = [UIAlertAction actionWithTitle:@"Copy Logs" 
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [UIPasteboard generalPasteboard].string = self.logView.text;
                                }];

    UIAlertAction* clearAction = [UIAlertAction actionWithTitle:@"Clear Logs" 
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    dispatch_async(dispatch_get_main_queue(), ^{ [self clearLogs]; });
                                }
                                ];

    [alert addAction:cancelAction];
    [alert addAction:clearAction];
    [alert addAction:copyAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end