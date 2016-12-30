//
//  REDMiniMockFunctions.h
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REDMockJanitor;

void REDMiniMock_setMockedSelectors(Class cls, NSDictionary<NSString *, NSValue *> *mockedSelectors);
NSDictionary<NSString *, NSValue *> *REDMiniMock_mockedSelectors(Class cls);

void REDMiniMock_setMockJanitor(id obj, REDMockJanitor *janitor);

Class REDMiniMock_setupMockClass(Class cls, NSArray<Protocol *> *protocols, NSDictionary<NSString *, id> *selectors);
