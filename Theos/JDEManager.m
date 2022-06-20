#import "JDEManager.h"


@implementation JDEManager

- (instancetype)init{
    if ((self = [super init])) {
        _JDEViewController = [[JDEViewController alloc] init]; 
        _JDEButtons = [[JDEButtons alloc] init];
    }
    return self;
    }

-(void)addSettingsButton{

}

@end