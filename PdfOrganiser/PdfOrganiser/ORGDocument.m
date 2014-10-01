//
//  ORGDocument.m
//  PdfOrganiser
//
//  Created by Adam Sherlaw on 30/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import "ORGDocument.h"

@implementation ORGDocument

- (id)init
{
    
    self = [super init];
    if (self) {
        pdfSet = [[NSMutableArray alloc] init];
    }
    NSLog(@"PDF Manager Document init");
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"ORGDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
}

+ (BOOL)autosavesInPlace
{
    return NO;
}


-(void)awakeFromNib
{
    [_setView setTarget:self];
    [_setView setDoubleAction:@selector(doubleClick:)];
}



- (void)doubleClick:(SEL)aSelector
{
    NSInteger rowNumber = [_setView clickedRow];
    current = [pdfSet objectAtIndex: rowNumber];
    
    [_pdfView setDocument: [current document]];
    [_pdfView goToDestination:[current point]];
    
    [self labelName:[current documentName]];
    indexOfCurrent = rowNumber;
    
}


-(void)labelName: (NSString *) value
{
    NSLog(@"HERE:    %@", value);
    [_fileNameLabel setStringValue:value];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    /*NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;*/
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    /*NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;*/
    return YES;
}

# pragma pdf tools

- (IBAction)addPdf:(id)sender {
    NSLog(@"addPdf Called");
    // Show the open file window
    // create an open documet panel
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:NO];
    
    // display the panel
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            for (NSURL *temp in [panel URLs]) {
                
            // A reference to what has been selected
                NSURL *theDocument = temp;
                
                NSLog(@"Document URL: %@", theDocument);
            
            // Create a new pdfFile
                PdfFile *file = [[PdfFile alloc] init];
            
            // Set its URL
            [file setFileWithUrl: theDocument];
            [file setDocumentName: [[theDocument URLByDeletingPathExtension] lastPathComponent]];
            
            // Add the pdf object to the array
            [self insertObject:file inPdfSetAtIndex:[pdfSet count]];
            }
        }
    }];
    
    
}


-(void)insertObject:(PdfFile *)p inPdfSetAtIndex:(NSUInteger)index
{
    NSLog(@"adding %@ to %@", p, pdfSet);
    // Add the inverse to the undo stack
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromPdfSetAtIndex:index];
     
     // If not the undo manager
     if(![undo isUndoing]) {
     [undo setActionName:@"Add PDF"];
     }
    
    // Add the pdf to the array
    //[self startObservingPerson:p];
    [pdfSet insertObject:p atIndex:index];
}

-(void)removeObjectFromPdfSetAtIndex:(NSUInteger)index
{
    PdfFile *p = [pdfSet objectAtIndex:index];
    NSLog(@"removing %@ from %@", p, pdfSet);
    
    // Add the inverse of the operation to the undo stack
    NSUndoManager *undo = [self undoManager];
     [[undo prepareWithInvocationTarget:self] insertObject:p inPdfSetAtIndex:index];
     
     // If not the undo manager
     if (![undo isUndoing]) {
     [undo setActionName:@"Remove PDF"];
     }
    
    //[self stopObservingPerson:p];
    [pdfSet removeObjectAtIndex:index];
}


- (NSString *)displayName {
    if (![self fileURL]) {
        if ([current documentName]) {
            NSLog(@"In if %@", [current documentName]);
            return @"here";
        } else {
            return @"PDF Set Viewer";
        }
    }
    NSLog(@"Out if");
    return [super displayName];
}


-(IBAction)zoomIn:(id)sender
{
    [_pdfView zoomIn:sender];
}
-(IBAction)zoomOut:(id)sender
{
    [_pdfView zoomOut:sender];
}

-(IBAction)nextPage:(id)sender
{
    [_pdfView goToNextPage:sender];
    [current setPoint: [_pdfView currentDestination]];
}

-(IBAction)previousPage:(id)sender
{
    [_pdfView goToPreviousPage:sender];
    [current setPoint: [_pdfView currentDestination]];
}

-(IBAction)zoomFit:(id)sender
{
    [_pdfView setAutoScales:YES];
}

-(IBAction)goToPage:(NSInteger)page
{
    //[_pdfView goToPage:<#(PDFPage *)#>];
}

// Check for the end of the array....
-(IBAction)nextDocument:(id)sender
{
    if (indexOfCurrent +1 < [pdfSet count]) {
        //NSLog(@"%ld", ++indexOfCurrent);
        current = [pdfSet objectAtIndex: ++indexOfCurrent];
    
        [_pdfView setDocument: [current document]];
        [self labelName:[current documentName]];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexOfCurrent];
        [_setView selectRowIndexes:indexSet byExtendingSelection:NO];
    }
}

// Check for the beginning of the array
-(IBAction)previousDocument:(id)sender
{
    if (indexOfCurrent - 1 >= 0) {
        //NSLog(@"%ld", --indexOfCurrent);
        
        current = [pdfSet objectAtIndex: --indexOfCurrent];
    
        [_pdfView setDocument: [current document]];
        [self labelName:[current documentName]];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexOfCurrent];
        [_setView selectRowIndexes:indexSet byExtendingSelection:NO];
    }
}


@end
