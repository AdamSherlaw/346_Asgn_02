//
//  ORGDocument.h
//  PdfOrganiser
//
//  Created by Adam Sherlaw on 30/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "PdfFile.h"


@interface ORGDocument : NSDocument {
    IBOutlet NSArrayController *setController;
    PdfFile *current;
    NSMutableArray *pdfSet;
    NSInteger indexOfCurrent;
}

@property (strong) IBOutlet PDFView *pdfView;
@property (strong) IBOutlet NSTableView *setView;
@property (weak) IBOutlet NSTextField *fileNameLabel;


- (IBAction)addPdf:(id)sender;

-(IBAction)zoomIn:(id)sender;
-(IBAction)zoomOut:(id)sender;
-(IBAction)nextPage:(id)sender;
-(IBAction)previousPage:(id)sender;
-(IBAction)zoomFit:(id)sender;

-(void)insertObject:(PdfFile *)p inPdfSetAtIndex:(NSUInteger)index;
-(void)removeObjectFromPdfSetAtIndex:(NSUInteger)index;

-(void)labelName: (NSString *) value;


@end
