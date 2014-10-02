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
#import "Note.h"


@interface ORGDocument : NSDocument {
    IBOutlet NSArrayController *setController;
    PdfFile *currentPdf;
    Note *currentNote;
    NSMutableArray *pdfSet;
    NSInteger indexOfCurrent;
    NSData *note;
    NSUndoManager *navigationManager;
}

@property (strong) IBOutlet PDFView *pdfView;
@property (strong) IBOutlet NSTableView *setView;
@property (weak) IBOutlet NSTextField *fileNameLabel;
@property (weak) IBOutlet NSTextField *currentPageLabel;
@property (strong) IBOutlet NSTextView *noteView;
@property (weak) IBOutlet NSTextField *pageJump;



- (IBAction)addPdf:(id)sender;

-(IBAction)zoomIn:(id)sender;
-(IBAction)zoomOut:(id)sender;
-(IBAction)nextPage:(id)sender;
-(IBAction)previousPage:(id)sender;
-(IBAction)zoomFit:(id)sender;

-(void)labelName: (NSString *) value;


@end
