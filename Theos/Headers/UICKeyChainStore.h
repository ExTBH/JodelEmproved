#include <Foundation/Foundation.h>

@interface UICKeyChainStore : NSObject
+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service;
+ (BOOL)removeAllItems;
- (BOOL)removeAllItems;
- (NSArray *)allItems;
- (instancetype)initWithService:(NSString *)service;
@end