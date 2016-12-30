
#import <objc/message.h>
#import "MABlockForwarding.h"

struct BlockDescriptor
{
	unsigned long reserved;
	unsigned long size;
	void *rest[1];
};

struct Block
{
	void *isa;
	int flags;
	int reserved;
	void *invoke;
	struct BlockDescriptor *descriptor;
};

enum {
	BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
	BLOCK_HAS_CTOR =          (1 << 26), // helpers have C++ code
	BLOCK_IS_GLOBAL =         (1 << 28),
	BLOCK_HAS_STRET =         (1 << 29), // IFF BLOCK_HAS_SIGNATURE
	BLOCK_HAS_SIGNATURE =     (1 << 30),
};

const char *BlockSig(id blockObj)
{
	struct Block *block = (__bridge void *)blockObj;
	struct BlockDescriptor *descriptor = block->descriptor;
	
	assert(block->flags & BLOCK_HAS_SIGNATURE);
	
	int index = 0;
	if(block->flags & BLOCK_HAS_COPY_DISPOSE)
		index += 2;
	
	return descriptor->rest[index];
}
