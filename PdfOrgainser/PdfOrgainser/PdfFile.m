//
//  PdfFile.m
//  MyPdfViewer
//
//  Created by Adam Sherlaw on 29/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import "PdfFile.h"

@implementation PdfFile
@synthesize fileUrl, documentName;

- (id)init
{
    NSLog(@"PDF File init");
    self = [super init];
    if (self) {
        // Set the default url to nil
        fileUrl = nil;
        // Set the current page to 0
        //currentPage = 0;
        // Set the Number of pages to 0
        //numberOfPage = 0;
        documentName = @"Adam";
    }
    return self;
}


/* Set the file url */
-(void)setFileWithUrl:(NSURL *) url
{
    fileUrl = url;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Hello %@", [[fileUrl URLByDeletingPathExtension] lastPathComponent]];
}

@end
