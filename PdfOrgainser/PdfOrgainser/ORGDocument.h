//
//  ORGDocument.h
//  PdfOrgainser
//
//  Created by Adam Sherlaw on 29/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PdfFile;

@interface ORGDocument : NSDocument <NSOutlineViewDataSource> {
    IBOutlet NSArrayController *setController;
    IBOutlet NSWindowController *controllerWindow;
}
@property (strong) NSMutableArray *pdfSet;

- (IBAction)addPdf:(id)sender;
- (IBAction)viewSet:(id)sender;

-(void)insertObject:(PdfFile *)p inPdfSetAtIndex:(NSUInteger)index;
-(void)removeObjectFromPdfSetAtIndex:(NSUInteger)index;

-(void)printArray;

- (IBAction)testBtn:(id)sender;

@end
