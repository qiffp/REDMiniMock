//
//  REDMock.m
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <REDMiniMock/REDMock.h>
#import <REDMiniMock/REDMiniMockFunctions.h>
#import <REDMiniMock/REDMockJanitor.h>

@implementation REDMock

+ (id)mockClass:(Class)cls selectors:(NSDictionary<NSString *,id> *)selectors
{
	return [self mockClass:cls initBlock:nil selectors:selectors];
}

+ (id)mockClass:(Class)cls initBlock:(id (^)(Class))initBlock selectors:(NSDictionary<NSString *,id> *)selectors
{
	return [self mockClass:cls protocols:nil initBlock:initBlock selectors:selectors];
}

+ (id)mockProtocol:(Protocol *)protocol selectors:(NSDictionary<NSString *,id> *)selectors
{
	return [self mockProtocols:@[protocol] selectors:selectors];
}

+ (id)mockProtocols:(NSArray<Protocol *> *)protocols selectors:(NSDictionary<NSString *,id> *)selectors
{
	return [self mockClass:[NSObject class] protocols:protocols initBlock:nil selectors:selectors];
}

+ (id)mockClass:(Class)cls protocols:(NSArray<Protocol *> *)protocols initBlock:(id (^)(Class))initBlock selectors:(NSDictionary<NSString *,id> *)selectors
{
	Class mockClass = REDMiniMock_setupMockClass(cls, protocols, selectors);
	id mock = initBlock ? initBlock(mockClass) : [mockClass new];
	REDMiniMock_setMockJanitor(mock, [[REDMockJanitor alloc] initWithMockClass:mockClass]);
	return mock;
}

@end
