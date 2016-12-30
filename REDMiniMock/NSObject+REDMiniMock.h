//
//  NSObject+REDMiniMock.h
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (REDMiniMock)

+ (id)mock:(NSDictionary<NSString *, id> *)selectors;
+ (id)mockWithInitBlock:(id(^)(Class))initBlock selectors:(NSDictionary<NSString *, id> *)selectors;
+ (id)mockWithProtocols:(NSArray<Protocol *> *)protocols initBlock:(id(^)(Class))initBlock selectors:(NSDictionary<NSString *, id> *)selectors;

@end
