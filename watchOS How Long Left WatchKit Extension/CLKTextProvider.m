//
//  RelativeTextInterpolater.m
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 6/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

#import <Foundation/Foundation.h>

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
