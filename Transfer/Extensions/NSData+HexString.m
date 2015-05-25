//
//  NSData+HexString.m
//  Transfer
//
//  Created by Juhan Hion on 16.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "NSData+HexString.h"

@implementation NSData (HexString)

static inline char initialChars(int i)
{
	if (i > 9) return 'A' + (i - 10);
	return '0' + i;
}

- (NSString *)hexString
{
	NSUInteger i, len;
	unsigned char *buf, *bytes;
	
	len = self.length;
	bytes = (unsigned char*)self.bytes;
	buf = malloc(len*2);
	
	for (i=0; i<len; i++)
	{
		buf[i*2] = initialChars((bytes[i] >> 4) & 0xF);
		buf[i*2+1] = initialChars(bytes[i] & 0xF);
	}
	
	return [[NSString alloc] initWithBytesNoCopy:buf
										  length:len * 2
										encoding:NSASCIIStringEncoding
									freeWhenDone:YES];
}

@end
