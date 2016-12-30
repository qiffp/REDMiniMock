//
//  REDMiniMockFunctions.m
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <REDMiniMock/REDMiniMockFunctions.h>
#import <REDMiniMock/MABlockForwarding.h>

#import <objc/runtime.h>
#import <objc/message.h>

static void *REDMockMockedSelectorsKey;
static void *REDMockJanitorKey;

void REDMiniMock_setMockedSelectors(Class cls, NSDictionary<NSString *, NSValue *> *mockedSelectors) {
	objc_setAssociatedObject(cls, REDMockMockedSelectorsKey, mockedSelectors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

NSDictionary<NSString *, NSValue *> *REDMiniMock_mockedSelectors(Class cls) {
	return objc_getAssociatedObject(cls, REDMockMockedSelectorsKey);
}

void REDMiniMock_setMockJanitor(id obj, REDMockJanitor *janitor) {
	objc_setAssociatedObject(obj, &REDMockJanitorKey, janitor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

Class REDMiniMock_setupMockClass(Class cls, NSArray<Protocol *> *protocols, NSDictionary<NSString *, id> *selectors) {
	NSMutableString *className = [NSMutableString stringWithFormat:@"REDConcreteMock_%@_", cls];
	for (Protocol *protocol in protocols) {
		[className appendString:[NSString stringWithFormat:@"%@_", NSStringFromProtocol(protocol)]];
	}
	[className appendString:[NSString stringWithFormat:@"%@", [NSUUID UUID].UUIDString]];
	
	Class mockClass = objc_allocateClassPair(cls, className.UTF8String, 0);
	objc_registerClassPair(mockClass);
	
	for (Protocol *protocol in protocols) {
		class_addProtocol(mockClass, protocol);
	}
	
	NSMutableDictionary<NSString *, NSValue *> *imps = [NSMutableDictionary new];
	[selectors enumerateKeysAndObjectsUsingBlock:^(NSString *selectorName, id block, BOOL *stop) {
		IMP imp = imp_implementationWithBlock(block);
		imps[selectorName] = [NSValue valueWithPointer:imp];
		class_replaceMethod(mockClass, NSSelectorFromString(selectorName), imp, BlockSig(block));
	}];
	REDMiniMock_setMockedSelectors(mockClass, imps);
	
	return mockClass;
}

