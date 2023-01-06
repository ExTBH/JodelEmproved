#import "JELog.h"
#import <UIKit/UIKit.h>

NSString *logFilePath(void){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"JDELogs.log"];
} 

static void writeString(__kindof NSAttributedString *string){
    
    NSError *error;
    NSRange stringRange = NSMakeRange(0, string.length);
    NSData *stringData = [string dataFromRange:stringRange
        documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType}
        error:&error];
    if(stringData == nil){
        return;
    }
    NSURL * const logFile = [NSURL fileURLWithPath:logFilePath()];
    NSData *logsDictData = [NSData dataWithContentsOfURL:logFile];
    

    if (logsDictData == nil){
        NSDictionary *logsDict = @{@"logs": @[stringData]};
        [logsDict writeToURL:logFile atomically:YES];
        return;
    }
    NSMutableDictionary *logsDict = [NSPropertyListSerialization propertyListWithData:logsDictData
        options:NSPropertyListMutableContainersAndLeaves
        format:nil
        error:&error];

    if (error != nil){
        return;
    }
    [logsDict[@"logs"] addObject:stringData];

    [logsDict writeToURL:logFile atomically:YES];

}

// https://codereview.stackexchange.com/a/48207
void JELog(NSString *format, ...){
    static NSDateFormatter* timeStampFormat;
    if (!timeStampFormat) {
        timeStampFormat = [[NSDateFormatter alloc] init];
        [timeStampFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [timeStampFormat setTimeZone:[NSTimeZone systemTimeZone]];
    }

    NSDictionary<NSAttributedStringKey, id> *attrs = @{
        NSForegroundColorAttributeName: UIColor.systemYellowColor
    };

    NSString *dateString = [NSString stringWithFormat:@"[%@]", [NSDate date]];
    NSAttributedString *timestamp = [[NSAttributedString alloc]
        initWithString:dateString attributes:attrs];

    va_list vargs;
    va_start(vargs, format);
    NSString* formattedMessage = [[NSString alloc] initWithFormat:format arguments:vargs];
    va_end(vargs);
    formattedMessage = [NSString stringWithFormat:@" %@", formattedMessage];
    NSAttributedString *attrFormattedMessage = [[NSAttributedString alloc] initWithString:formattedMessage
        attributes:@{NSForegroundColorAttributeName: UIColor.labelColor}];


    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithAttributedString:timestamp];
    [message appendAttributedString:attrFormattedMessage];

    writeString(message);
}