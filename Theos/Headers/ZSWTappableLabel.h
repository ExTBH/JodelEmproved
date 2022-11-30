//
//  ZSWTappableLabel.h
//  ZSWTappableLabel
//
//  Copyright (c) 2019 Zachary West. All rights reserved.
//
//  MIT License
//  https://github.com/zacwest/ZSWTappableLabel
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN
@interface ZSWTappableLabel : UILabel
@end
#pragma mark - Attributes you include in strings

NSAttributedStringKey const ZSWTappableLabelHighlightedBackgroundAttributeName
    NS_SWIFT_NAME(tappableHighlightedBackgroundColor) = @"ZSWTappableLabelHighlightedBackgroundAttributeName";

NSAttributedStringKey const ZSWTappableLabelHighlightedForegroundAttributeName
    NS_SWIFT_NAME(tappableHighlightedForegroundColor) = @"ZSWTappableLabelHighlightedForegroundAttributeName";

NSAttributedStringKey const ZSWTappableLabelTappableRegionAttributeName
    NS_SWIFT_NAME(tappableRegion) = @"ZSWTappableLabelTappableRegionAttributeName";

@protocol ZSWTappableLabelTapDelegate

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel
        tappedAtIndex:(NSInteger)idx
       withAttributes:(NSDictionary<NSAttributedStringKey, id> *)attributes;
@end

NS_ASSUME_NONNULL_END
