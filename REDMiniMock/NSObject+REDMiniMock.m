//
//  NSObject+REDMiniMock.m
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <REDMiniMock/NSObject+REDMiniMock.h>
#import <REDMiniMock/REDMock.h>

@implementation NSObject (REDMiniMock)

+ (id)mock:(NSDictionary<NSString *, id> *)selectors
{
	return [self mockWithInitBlock:nil selectors:selectors];
}

+ (id)mockWithInitBlock:(id(^)(Class))initBlock selectors:(NSDictionary<NSString *, id> *)selectors
{
	return [self mockWithProtocols:nil initBlock:initBlock selectors:selectors];
}

+ (id)mockWithProtocols:(NSArray<Protocol *> *)protocols initBlock:(id(^)(Class))initBlock selectors:(NSDictionary<NSString *, id> *)selectors
{
	return [REDMock mockClass:self protocols:protocols initBlock:initBlock selectors:selectors];
}

@end
