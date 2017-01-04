//
//  REDMiniMockTests.m
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-31.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <REDMiniMock/REDMiniMock.h>

typedef BOOL(^REDTestBlock)(void);

@interface REDPositiveClass : NSObject
- (BOOL)instanceMethodArg1:(id)obj1 arg2:(id)obj2;
- (BOOL)noArgMethod;
- (REDTestBlock)blockMethod;
+ (BOOL)classMethodArg1:(id)obj1 arg2:(id)obj2;
@end

@implementation REDPositiveClass
- (BOOL)instanceMethodArg1:(id)obj1 arg2:(id)obj2 { return YES; }
- (BOOL)noArgMethod { return YES; }
- (REDTestBlock)blockMethod { return ^{ return YES; }; }
+ (BOOL)classMethodArg1:(id)obj1 arg2:(id)obj2 { return YES; }
@end

@interface REDNegativeClass : REDPositiveClass
@end

@implementation REDNegativeClass
- (BOOL)instanceMethodArg1:(id)obj1 arg2:(id)obj2 { return NO; }
- (BOOL)noArgMethod { return NO; }
- (REDTestBlock)blockMethod { return ^{ return NO; }; }
+ (BOOL)classMethodArg1:(id)obj1 arg2:(id)obj2 { return NO; }
@end

@interface REDMiniMockTests : XCTestCase
@end

@implementation REDMiniMockTests

- (void)testSuperWithInstanceMethod
{
	REDNegativeClass *obj = [REDNegativeClass mock:@{
											   RMMMethod(instanceMethodArg1:arg2:): ^BOOL(id _self, id obj1, id obj2) { return RMMSuper(_self, BOOL, @selector(instanceMethodArg1:arg2:), obj1, obj2); }
											   }];
	
	XCTAssertTrue([obj instanceMethodArg1:@"mock" arg2:@"yeah"]);
}

- (void)testSuperWithClassMethod
{
	REDNegativeClass *obj = [REDNegativeClass mock:@{
											   RMMMethod(classMethodArg1:arg2:): ^BOOL(Class _self, id obj1, id obj2) { return RMMSuper(_self, BOOL, @selector(classMethodArg1:arg2:), obj1, obj2); }
											   }];
	
	XCTAssertTrue([[obj class] classMethodArg1:@"mock" arg2:@"yeah"]);
}

- (void)testSuperWithMethodWithNoArgs
{
	REDNegativeClass *obj = [REDNegativeClass mock:@{
													 RMMMethod(noArgMethod): ^BOOL(id _self) { return RMMSuper(_self, BOOL, @selector(noArgMethod)); }
													 }];
	
	XCTAssertTrue([obj noArgMethod]);
}

- (void)testSuperWithBlockMethod
{
	REDNegativeClass *obj = [REDNegativeClass mock:@{
													 RMMMethod(blockMethod): ^REDTestBlock(id _self) { return RMMSuper(_self, REDTestBlock, @selector(blockMethod)); }
													 }];
	
	XCTAssertTrue([obj blockMethod]());
}

@end
