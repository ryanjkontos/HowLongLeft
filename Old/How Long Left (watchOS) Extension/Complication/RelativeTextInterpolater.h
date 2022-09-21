//
//  RelativeTextInterpolater.h
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 21/3/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ClockKit/ClockKit.h>


@interface CLKTextProvider (MultiColorPatch)

+ (CLKTextProvider *_Nonnull)textProviderByJoiningTextProviders: (NSArray<CLKTextProvider *> *_Nonnull)textProviders separator:(NSString * _Nullable) separator;

@end


