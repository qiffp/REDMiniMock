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
#import <objc/message.h>

#define RMMMethod(sel) NSStringFromSelector(@selector(sel))

#define RMMSuper(self, returntype, sel, args...) ({	\
	/* Go two levels up since `self` is the dynamically created mock class */	\
	Class superclass = [[self performSelector:@selector(superclass)] performSelector:@selector(superclass)];	\
	struct objc_super s;	\
	if (object_isClass(self)) {	\
		s = (struct objc_super){ object_getClass(self), object_getClass(superclass) };	\
	} else {	\
		s = (struct objc_super){ self, superclass };	\
	}	\
	((returntype(*)(struct objc_super *, SEL, ...))objc_msgSendSuper)(&s, sel, args);	\
})
