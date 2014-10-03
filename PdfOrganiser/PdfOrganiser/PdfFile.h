//
//  PdfFile.h
//  PdfOrganiser
//
//  COSC346 Assignment 02
//  Adam Sherlaw 1935911
//
//  PDF File contains a URL to a pdf document along with the document's name,
//  documents current page and the document object itself.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface PdfFile : NSObject {
    NSInteger currentPage;
}

@property (strong) NSURL *fileUrl;
@property (strong) NSString *documentName;
@property (strong) PDFDocument *document;
@property NSInteger currentPage;


-(void)setFileWithUrl:(NSURL *) url;



@end
