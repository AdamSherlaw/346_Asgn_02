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
    NSMutableArray *pdfSet;
    
    NSMutableArray *noteSet;
    PdfFile *currentPdf;
    NSInteger indexOfCurrent;
    Note *currentNote;
    NSData *note;
    
    NSUndoManager *navigationManager;
    
    PDFSelection *queryResult;
}

@property (strong) IBOutlet PDFView *pdfView;
@property (strong) IBOutlet NSTableView *setView;
@property (weak) IBOutlet NSTextField *fileNameLabel;
@property (weak) IBOutlet NSTextField *currentPageLabel;
@property (strong) IBOutlet NSTextView *noteView;
@property (weak) IBOutlet NSTextField *pageJump;
@property (weak) IBOutlet NSSearchFieldCell *searchField;




- (IBAction)addPdf:(id)sender;

-(IBAction)zoomIn:(id)sender;
-(IBAction)zoomOut:(id)sender;
-(IBAction)nextPage:(id)sender;
-(IBAction)previousPage:(id)sender;
-(IBAction)zoomFit:(id)sender;

-(void)labelName: (NSString *) value;


@end
