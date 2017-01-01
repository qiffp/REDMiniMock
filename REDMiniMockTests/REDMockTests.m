//
//  REDMockTests.m
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <REDMiniMock/REDMiniMock.h>

@interface REDMockTestClass : NSObject
@property (readonly, strong) id property;
- (instancetype)initWithProperty:(id)property;
@end

@implementation REDMockTestClass

- (instancetype)initWithProperty:(id)property
{
	self = [super init];
	if (self) {
		_property = property;
	}
	return self;
}

@end

@protocol REDMockTestProtocol <NSObject>
- (NSString *)doStuff;
@end

@protocol REDMockTestProtocol2 <NSObject>
- (NSString *)doStuff2;
@end

@interface REDMockTests : XCTestCase
@end

@implementation REDMockTests

- (void)testMockClass
{
	NSObject *obj = [REDMock mockClass:[NSObject class]
							 selectors:@{
										 RMMMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; }
										 }];
	XCTAssertTrue([obj isKindOfClass:[NSObject class]]);
	XCTAssertTrue([obj isEqual:@"mock (yeah) ing (yeah) bird (yeah) yeah (yeah)"]);
}

- (void)testMockClassWithInit
{
	REDMockTestClass *obj = [REDMock mockClass:[REDMockTestClass class]
								 initBlock:^id(Class cls) {
									 return [[cls alloc] initWithProperty:@"mocks in 2016 LUL"];
								 } selectors:@{
											   RMMMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; }
											   }];
	XCTAssertTrue([obj isKindOfClass:[REDMockTestClass class]]);
	XCTAssertTrue([obj isEqual:@"mock (yeah) ing (yeah) bird (yeah) yeah (yeah)"]);
	XCTAssertEqualObjects(obj.property, @"mocks in 2016 LUL");
}

- (void)testMockProtocol
{
	id<REDMockTestProtocol> obj = [REDMock mockProtocol:@protocol(REDMockTestProtocol)
										  selectors:@{
													  RMMMethod(doStuff): ^NSString *(id _self) { return @"mock"; }
													  }];
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDMockTestProtocol)]);
	XCTAssertEqualObjects([obj doStuff], @"mock");
}

- (void)testMockMultipleProtocols
{
	id<REDMockTestProtocol, REDMockTestProtocol2> obj = [REDMock mockProtocols:@[@protocol(REDMockTestProtocol), @protocol(REDMockTestProtocol2)]
															 selectors:@{
																		 RMMMethod(doStuff): ^NSString *(id _self) { return @"mock"; },
																		 RMMMethod(doStuff2): ^NSString *(id _self) { return @"yeah"; }
																		 }];
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDMockTestProtocol)]);
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDMockTestProtocol2)]);
	XCTAssertEqualObjects([obj doStuff], @"mock");
	XCTAssertEqualObjects([obj doStuff2], @"yeah");
}

- (void)testMockClassAndProtocolsWithInit
{
	REDMockTestClass<REDMockTestProtocol, REDMockTestProtocol2> *obj = [REDMock mockClass:[REDMockTestClass class]
																	protocols:@[@protocol(REDMockTestProtocol), @protocol(REDMockTestProtocol2)]
																	initBlock:^id(Class cls) {
																		return [[cls alloc] initWithProperty:@"mocks in 2016 LUL"];
																	} selectors:@{
																				  RMMMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; },
																				  RMMMethod(doStuff): ^NSString *(id _self) { return @"mock"; },
																				  RMMMethod(doStuff2): ^NSString *(id _self) { return @"yeah"; }
																				  }];
	XCTAssertTrue([obj isKindOfClass:[REDMockTestClass class]]);
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDMockTestProtocol)]);
	XCTAssertTrue([obj conformsToProtocol:@protocol(REDMockTestProtocol2)]);
	XCTAssertTrue([obj isEqual:@"mock (yeah) ing (yeah) bird (yeah) yeah (yeah)"]);
	XCTAssertEqualObjects([obj doStuff], @"mock");
	XCTAssertEqualObjects([obj doStuff2], @"yeah");
	XCTAssertEqualObjects(obj.property, @"mocks in 2016 LUL");
}

@end
