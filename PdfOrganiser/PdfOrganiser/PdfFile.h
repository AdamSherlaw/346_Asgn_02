//
//  PdfFile.h
//  MyPdfViewer
//
//  Created by Adam Sherlaw on 29/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//
//  This file will be used to reference a PDF document
//
//  On PDF open, a new instance of PdfFile should be created and
//  initailised
//
//  File URL - Where to find the file
//  Associated data that relates to the file
//       Number of pages in document
//       Current / last viewed page
//
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface PdfFile : NSObject {
    NSInteger *numberOfPage;
}

@property (strong) NSURL *fileUrl;
@property (strong) NSString *documentName;
@property (strong) PDFDocument *document;
@property (strong) PDFDestination *point;


-(void)setFileWithUrl:(NSURL *) url;



@end
