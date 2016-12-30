//
//  REDMock.h
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REDMock : NSObject

+ (id)mockClass:(Class)cls selectors:(NSDictionary<NSString *, id> *)selectors;
+ (id)mockClass:(Class)cls initBlock:(id(^)(Class))initBlock selectors:(NSDictionary<NSString *, id> *)selectors;
+ (id)mockProtocol:(Protocol *)protocol selectors:(NSDictionary<NSString *, id> *)selectors;
+ (id)mockProtocols:(NSArray<Protocol *> *)protocols selectors:(NSDictionary<NSString *, id> *)selectors;
+ (id)mockClass:(Class)cls protocols:(NSArray<Protocol *> *)protocols initBlock:(id(^)(Class))initBlock selectors:(NSDictionary<NSString *, id> *)selectors;

@end
