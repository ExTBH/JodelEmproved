#import "JELog.h"


static NSString *logFilePath(void){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"JDELogs.log"];
} 

static void writeString(__kindof NSString *string){
    NSString * const logFile = logFilePath();
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFile];

    if(fileHandle == nil){
        [string writeToFile:logFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return;
    }

    NSNumber *fileSize = [NSFileManager.defaultManager attributesOfItemAtPath:logFile error:nil][NSFileSize];
    unsigned long long unsignedFileSize = [fileSize unsignedLongLongValue];
    if(unsignedFileSize > 102400){
        [fileHandle closeFile];
        // TODO: delete file
    }

    [fileHandle seekToEndReturningOffset:&unsignedFileSize error:nil];
    [fileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    [fileHandle closeFile];
}

// https://codereview.stackexchange.com/a/48207
void JELog(NSString *format, ...){
    static NSDateFormatter* timeStampFormat;
    if (!timeStampFormat) {
        timeStampFormat = [[NSDateFormatter alloc] init];
        [timeStampFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [timeStampFormat setTimeZone:[NSTimeZone systemTimeZone]];
    }

    NSString* timestamp = [timeStampFormat stringFromDate:[NSDate date]];

    va_list vargs;
    va_start(vargs, format);
    NSString* formattedMessage = [[NSString alloc] initWithFormat:format arguments:vargs];
    va_end(vargs);
    // TODO: make time stamp colored
    NSString* message = [NSString stringWithFormat:@"[%@] %@", timestamp, formattedMessage];

    writeString(message);
}