//
//  ELGzipUtil.h
//  ELFeedback
//
//  Created by Yuriy Buyanov on 25/02/14.
//  Copyright (c) 2014 e-legion. All rights reserved.
//

// Helper from
// http://www.clintharris.net/2009/how-to-gzip-data-in-memory-using-objective-c/


#import <Foundation/Foundation.h>
#import <zlib.h>

@interface ELGzipUtil : NSObject

+(NSData*) gzipData: (NSData*)pUncompressedData;

@end
