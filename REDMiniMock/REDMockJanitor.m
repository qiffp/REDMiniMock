//
//  REDMockJanitor.m
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <REDMiniMock/REDMockJanitor.h>
#import <REDMiniMock/REDMiniMockFunctions.h>

#import <objc/runtime.h>

@implementation REDMockJanitor {
	Class _mockClass;
}

- (instancetype)initWithMockClass:(Class)mockClass
{
	self = [super init];
	if (self) {
		_mockClass = mockClass;
	}
	return self;
}

- (void)dealloc
{
	for (NSValue *mockedIMPValue in REDMiniMock_mockedSelectors(_mockClass).allValues) {
		imp_removeBlock(mockedIMPValue.pointerValue);
	}
	REDMiniMock_setMockedSelectors(_mockClass, nil);
	objc_disposeClassPair(_mockClass);
}

@end
