//
//  NSURL+NSHash_Additions.m
//  Gibraltar iOS
//
//  Created by Saul Mora on 12/22/13.
//  Copyright (c) 2013 Magical Panda. All rights reserved.
//

#import "NSURL+NSHash.h"
#import "NSString+NSHash.h"
#import <CommonCrypto/CommonCrypto.h>

static NSUInteger NSURLHashFileBufferSize = 4096;

@implementation NSURL (NSHash)

- (NSString *) MD5;
{
    NSError *error = nil;
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingFromURL:self error:&error];
    if (handle == nil)
    {
        NSLog(@"Error opening file at %@: %@", self, error);
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    
    BOOL endOfFileReached = NO;
    
    while (!endOfFileReached) {
        @autoreleasepool {

            NSData *bufferedData = [handle readDataOfLength:NSURLHashFileBufferSize];
            CC_MD5_Update (&md5, [bufferedData bytes], [bufferedData length]);
            
            endOfFileReached = ([bufferedData length] == 0);
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
 
    return nshash_bytes_to_hex_string(digest, CC_MD5_DIGEST_LENGTH);
}

@end
