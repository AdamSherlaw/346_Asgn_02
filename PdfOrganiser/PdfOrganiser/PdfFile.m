//
//  PdfFile.m
//  PdfOrganiser
//
//  COSC346 Assignment 02
//  Adam Sherlaw 1935911
//

#import "PdfFile.h"

@implementation PdfFile
@synthesize fileUrl, documentName, document, currentPage;

- (id)init
{
    self = [super init];
    if (self) {
        fileUrl = nil;
        documentName = @"unnamed";
        document = nil;
        currentPage = 0;
    }
    return self;
}

/* 
 *  Set the file url to the URL given
 */
-(void)setFileWithUrl:(NSURL *) url
{
    fileUrl = url;
    document = [[PDFDocument alloc] initWithURL:url];
}

@end
