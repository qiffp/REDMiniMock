//
//  REDMiniMock.h
//  REDMiniMock
//
//  Created by Sam Dye on 2016-12-30.
//  Copyright © 2016 Sam Dye. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for REDMiniMock.
FOUNDATION_EXPORT double REDMiniMockVersionNumber;

//! Project version string for REDMiniMock.
FOUNDATION_EXPORT const unsigned char REDMiniMockVersionString[];

#import <REDMiniMock/REDMock.h>
#import <REDMiniMock/NSObject+REDMiniMock.h>

#define REDMockMethod(sel) NSStringFromSelector(@selector(sel))
