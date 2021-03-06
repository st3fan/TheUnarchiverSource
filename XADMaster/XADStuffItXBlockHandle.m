#import "XADStuffItXBlockHandle.h"
#import "StuffItXUtilities.h"

@implementation XADStuffItXBlockHandle

-(id)initWithHandle:(CSHandle *)handle
{
	if((self=[super initWithParentHandle:handle]))
	{
		startoffs=[parent offsetInFile];
		buffer=NULL;
		currsize=0;
	}
	return self;
}

-(void)dealloc
{
	free(buffer);
	[super dealloc];
}

-(void)resetBlockStream
{
	[parent seekToFileOffset:startoffs];
}

-(int)produceBlockAtOffset:(off_t)pos
{
	int size=(int)ReadSitxP2(parent);
	if(!size) return -1;

	if(size>currsize)
	{
		free(buffer);
		buffer=malloc(size);
		currsize=size;
		[self setBlockPointer:buffer];
	}

	return [parent readAtMost:size toBuffer:buffer];
}

@end
