//
//  REDMiniMockFunctions.m
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <REDMiniMock/REDMiniMockFunctions.h>
#import <REDMiniMock/MABlockForwarding.h>

#import <objc/message.h>

typedef NS_ENUM(NSInteger, REDMockArgType) {
	REDMockArgTypeOther,
	REDMockArgTypeClass,
	REDMockArgTypeId
};

static void *REDMockMockedSelectorsKey;
static void *REDMockJanitorKey;

static const char *block_sanitizedTypes(id block) {
	const char *types = BlockSig(block);
	char *sanitizedTypes;
	
	NSUInteger j = 0;
	for (NSUInteger i = 0; types[i]; i++) {
		char ch = types[i];
		if (!isdigit(ch)) {
			sanitizedTypes[j++] = ch;
		}
	}
	sanitizedTypes[j] = '\0';
	
	return sanitizedTypes;
}

static REDMockArgType block_firstArgType(id block) {
	NSUInteger firstArgIndex = 0;
	NSUInteger angleBracketDepth = 0;
	const char *sanitizedTypes = block_sanitizedTypes(block);
	
	for (NSUInteger i = 0; sanitizedTypes[i]; i++) {
		char ch = sanitizedTypes[i];
		if (ch == '?') {
			if (sanitizedTypes[i + 1] == '<') {
				continue;
			} else if (angleBracketDepth == 0) {
				firstArgIndex = i + 1;
				break;
			}
		} else if (ch == '<') {
			angleBracketDepth++;
		} else if (ch == '>') {
			angleBracketDepth--;
		}
	}
	
	char firstArg = sanitizedTypes[firstArgIndex];
	if (firstArg == '#') {
		return REDMockArgTypeClass;
	} else if (firstArg == '@' && sanitizedTypes[firstArgIndex + 1] != '"') {
		return REDMockArgTypeId;
	} else {
		return REDMockArgTypeOther;
	}
}

static BOOL REDMiniMock_shouldCreateClassMethod(Class cls, SEL sel, id block) {
	/*
	 * If block's first arg is a class, it's assumed to be a class method.
	 * If block's first arg is an id, but there's no instance method and there is a class method, it's assumed to be a class method.
	 * Otherwise, it's assumed to be an instance method.
	 */

	REDMockArgType firstArgType = block_firstArgType(block);
	return firstArgType == REDMockArgTypeClass || (firstArgType == REDMockArgTypeId && !class_getInstanceMethod(cls, sel) && class_getClassMethod(cls, sel));
}

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
	[selectors enumerateKeysAndObjectsUsingBlock:^(NSString *selName, id block, BOOL *stop) {
		IMP imp = imp_implementationWithBlock(block);
		imps[selName] = [NSValue valueWithPointer:imp];
		
		SEL sel = NSSelectorFromString(selName);
		Class impClass = REDMiniMock_shouldCreateClassMethod(mockClass, sel, block) ? object_getClass(mockClass) : mockClass;
		class_replaceMethod(impClass, sel, imp, BlockSig(block));
	}];
	REDMiniMock_setMockedSelectors(mockClass, imps);
	
	return mockClass;
}
