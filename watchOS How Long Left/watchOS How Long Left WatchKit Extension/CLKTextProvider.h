//
//  RelativeTextInterpolater.h
//  How Long Left
//
//  Created by Ryan Kontos on 6/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ClockKit/ClockKit.h>


@interface CLKTextProvider (MultiColorPatch)

+ (CLKTextProvider *_Nonnull)textProviderByJoiningTextProviders: (NSArray<CLKTextProvider *> *_Nonnull)textProviders separator:(NSString * _Nullable) separator;

@end
