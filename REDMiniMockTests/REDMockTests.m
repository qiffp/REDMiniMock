//
//  REDMockTests.m
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <REDMiniMock/REDMiniMock.h>

@interface REDTestClass : NSObject
@property (readonly, strong) id property;
- (instancetype)initWithProperty:(id)property;
@end

@implementation REDTestClass

- (instancetype)initWithProperty:(id)property
{
	self = [super init];
	if (self) {
		_property = property;
	}
	return self;
}

@end

@protocol REDTestProtocol <NSObject>
- (NSString *)doStuff;
@end

@protocol REDTestProtocol2 <NSObject>
- (NSString *)doStuff2;
@end

@interface REDMockTests : XCTestCase
@end

@implementation REDMockTests

- (void)testMockClass
{
	NSObject *obj = [REDMock mockClass:[NSObject class]
							 selectors:@{
										 REDMockMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; }
										 }];
	XCTAssertTrue([obj isKindOfClass:[NSObject class]]);
	XCTAssertTrue([obj isEqual:@"mock (yeah) ing (yeah) bird (yeah) yeah (yeah)"]);
}

- (void)testMockClassWithInit
{
	REDTestClass *obj = [REDMock mockClass:[REDTestClass class]
								 initBlock:^id(Class cls) {
									 return [[cls alloc] initWithProperty:@"mocks in 2016 LUL"];
								 } selectors:@{
											   REDMockMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; }
											   }];
	XCTAssertTrue([obj isKindOfClass:[REDTestClass class]]);
	XCTAssertTrue([obj isEqual:@"mock (yeah) ing (yeah) bird (yeah) yeah (yeah)"]);
	XCTAssertEqualObjects(obj.property, @"mocks in 2016 LUL");
}

- (void)testMockProtocol
{
	id<REDTestProtocol> obj = [REDMock mockProtocol:@protocol(REDTestProtocol)
										  selectors:@{
													  REDMockMethod(doStuff): ^NSString *(id _self) { return @"mock"; }
													  }];
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDTestProtocol)]);
	XCTAssertEqualObjects([obj doStuff], @"mock");
}

- (void)testMockMultipleProtocols
{
	id<REDTestProtocol, REDTestProtocol2> obj = [REDMock mockProtocols:@[@protocol(REDTestProtocol), @protocol(REDTestProtocol2)]
															 selectors:@{
																		 REDMockMethod(doStuff): ^NSString *(id _self) { return @"mock"; },
																		 REDMockMethod(doStuff2): ^NSString *(id _self) { return @"yeah"; }
																		 }];
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDTestProtocol)]);
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDTestProtocol2)]);
	XCTAssertEqualObjects([obj doStuff], @"mock");
	XCTAssertEqualObjects([obj doStuff2], @"yeah");
}

- (void)testMockClassAndProtocolsWithInit
{
	REDTestClass<REDTestProtocol, REDTestProtocol2> *obj = [REDMock mockClass:[REDTestClass class]
																	protocols:@[@protocol(REDTestProtocol), @protocol(REDTestProtocol2)]
																	initBlock:^id(Class cls) {
																		return [[cls alloc] initWithProperty:@"mocks in 2016 LUL"];
																	} selectors:@{
																				  REDMockMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; },
																				  REDMockMethod(doStuff): ^NSString *(id _self) { return @"mock"; },
																				  REDMockMethod(doStuff2): ^NSString *(id _self) { return @"yeah"; }
																				  }];
	XCTAssertTrue([obj isKindOfClass:[REDTestClass class]]);
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDTestProtocol)]);
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDTestProtocol2)]);
	XCTAssertTrue([obj isEqual:@"mock (yeah) ing (yeah) bird (yeah) yeah (yeah)"]);
	XCTAssertEqualObjects([obj doStuff], @"mock");
	XCTAssertEqualObjects([obj doStuff2], @"yeah");
	XCTAssertEqualObjects(obj.property, @"mocks in 2016 LUL");
}

@end
