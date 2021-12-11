//
//  RelativeTextInterpolater.m
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 21/3/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

#import "RelativeTextInterpolater.h"

@implementation CLKTextProvider (MultiColorPatch)

+ (CLKTextProvider *)textProviderByJoiningTextProviders: (NSArray<CLKTextProvider *> *)textProviders separator:(NSString * _Nullable) separator {
    
    NSString *formatString = @"%@%@";
    
    if (separator.length > 0) {
        formatString = [NSString stringWithFormat:@"%@%@%@", @"%@", separator, @"%@"];
    }
    
    CLKTextProvider *firstItem = textProviders.firstObject;
    
    for (int index = 1; index < textProviders.count; index++) {
        CLKTextProvider *secondItem = [textProviders objectAtIndex: index];
        firstItem = [CLKTextProvider textProviderWithFormat:formatString, firstItem, secondItem];
    }
    
    return firstItem;
}

@end
