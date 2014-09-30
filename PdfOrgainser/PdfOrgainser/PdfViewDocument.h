//
//  MYPDFDocument.h
//  MyPdfViewer
//
//  Created by Adam Sherlaw on 26/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface MYPDFDocument : NSDocument

@property (weak) IBOutlet PDFView *pdfView;

//-(IBAction)changeDoc:(id)sender;

@end
