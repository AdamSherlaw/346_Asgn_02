//
//  PdfFile.m
//  MyPdfViewer
//
//  Created by Adam Sherlaw on 29/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import "PdfFile.h"

@implementation PdfFile
@synthesize fileUrl, documentName, document, currentPage;

- (id)init
{
    self = [super init];
    if (self) {
        fileUrl = nil;
        numberOfPage = 0;
        documentName = @"No name";
        document = nil;
        currentPage = 0;
    }
    return self;
}

/*-(void)setCurrentPage:(NSUInteger *)current
{
    currentPage = current;
}

-(NSInteger)getCurrentPage
{
    return currentPage;
}*/

/* Set the file url */
-(void)setFileWithUrl:(NSURL *) url
{
    fileUrl = url;
    document = [[PDFDocument alloc] initWithURL:url];
}

- (NSString *)description {
    return [NSString stringWithFormat: @"%@", [[fileUrl URLByDeletingPathExtension] lastPathComponent]];
}

@end
