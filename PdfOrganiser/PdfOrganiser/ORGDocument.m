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
        note = [[NSData alloc] init];
        navigationManager = [[NSUndoManager alloc]init];
    }
    return self;
}

- (NSString *)windowNibName
{
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


// Set the undo manager
- (void)doubleClick:(SEL)aSelector
{
    NSInteger rowNumber = [_setView clickedRow];
    currentPdf = [pdfSet objectAtIndex: rowNumber];
    
    [_pdfView setDocument: [currentPdf document]];
    [_pdfView goToPage: [[currentPdf document] pageAtIndex:(NSUInteger)[currentPdf currentPage]]];
    
    [self labelName:[currentPdf documentName]];
    [self currentPageLabel:[NSString stringWithFormat:@"%ld", [[currentPdf document] indexForPage:[_pdfView currentPage]]]];
    indexOfCurrent = rowNumber;
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
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            for (NSURL *temp in [panel URLs]) {
                
                NSURL *theDocument = temp;
                
                PdfFile *file = [[PdfFile alloc] init];
                [file setFileWithUrl: theDocument];
                [file setDocumentName: [[theDocument URLByDeletingPathExtension] lastPathComponent]];
                
                [setController addObject: file];
                
                currentPdf = file;
                [_pdfView setDocument:[file document]];
                indexOfCurrent = [pdfSet count] - 1;
                
                [self labelName:[file documentName]];
                [self currentPageLabel:[NSString stringWithFormat:@"%ld", [[currentPdf document] indexForPage:[_pdfView currentPage]]]];
            }
        }
    }];
    
    
}


- (NSString *)displayName {
    if (![self fileURL]) return @"PDF Set Viewer";
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


-(IBAction)zoomFit:(id)sender
{
    [_pdfView setAutoScales:YES];
}


-(IBAction)nextPage:(id)sender
{
    [_pdfView goToNextPage:sender];
    
    [currentPdf setCurrentPage:[[currentPdf document] indexForPage:[_pdfView currentPage]]];
    
    [self currentPageLabel:[NSString stringWithFormat:@"%ld", [[currentPdf document] indexForPage:[_pdfView currentPage]]]];
    
    [[navigationManager prepareWithInvocationTarget:self] previousPage:sender];
}


-(IBAction)previousPage:(id)sender
{
    [_pdfView goToPreviousPage:sender];
    
    [currentPdf setCurrentPage:[[currentPdf document] indexForPage:[_pdfView currentPage]]];
    
    [self currentPageLabel:[NSString stringWithFormat:@"%ld", [[currentPdf document] indexForPage:[_pdfView currentPage]]]];
    
    [[navigationManager prepareWithInvocationTarget:self] nextPage:sender];
}



-(IBAction)nextDocument:(id)sender
{
    if (indexOfCurrent + 1 < [pdfSet count]) {
        currentPdf = [pdfSet objectAtIndex: ++indexOfCurrent];
    
        [_pdfView setDocument: [currentPdf document]];
        [self labelName:[currentPdf documentName]];
        
        [_pdfView goToPage: [[currentPdf document] pageAtIndex:(NSUInteger)[currentPdf currentPage]]];
        
        [self currentPageLabel:[NSString stringWithFormat:@"%lu", (NSUInteger)[currentPdf currentPage]]];
        
        [_setView selectRowIndexes:[NSIndexSet indexSetWithIndex:indexOfCurrent] byExtendingSelection:NO];
        
        [[navigationManager prepareWithInvocationTarget:self] previousDocument:sender];
    }
}


-(IBAction)previousDocument:(id)sender
{
    if (indexOfCurrent - 1 >= 0) {
        currentPdf = [pdfSet objectAtIndex: --indexOfCurrent];
    
        [_pdfView setDocument: [currentPdf document]];
        [self labelName:[currentPdf documentName]];
        
        [_pdfView goToPage: [[currentPdf document] pageAtIndex:(NSUInteger)[currentPdf currentPage]]];
        [self currentPageLabel:[NSString stringWithFormat:@"%lu", (NSUInteger)[currentPdf currentPage]]];
    
        [_setView selectRowIndexes:[NSIndexSet indexSetWithIndex:indexOfCurrent] byExtendingSelection:NO];
        
        [[navigationManager prepareWithInvocationTarget:self] nextDocument:sender];
    }
}


-(IBAction)back:(id)sender
{
    [navigationManager undo];
}


-(IBAction)forward:(id)sender
{
    [navigationManager redo];
}


-(void)labelName: (NSString *) value
{
    [_fileNameLabel setStringValue:value];
}


-(void)currentPageLabel:(NSString *)value
{
    [_currentPageLabel setStringValue:value];
}



-(IBAction)loadNote:(id)sender
{
    // Menu to open an application specific file that corresponds to a note
    // object. - Using the application extension.
    
    
}


-(IBAction)newNote:(id)sender
{
    // Show a new note window
    
    // Create a new note object
    currentNote = [[Note alloc] init];
}


-(IBAction)saveNote:(id)sender
{
    // Set the text into the data buffer
    // Archive the object?
    
    [currentNote setNoteData:[[_noteView string] dataUsingEncoding:NSUTF8StringEncoding]];
    [currentNote saveNote];
    
    // Hide the note window
}


-(IBAction)changePage:(id)sender
{
     [self moveToPage:[_pageJump integerValue]];
}


-(void)moveToPage:(NSInteger)page
{
    [[navigationManager prepareWithInvocationTarget:self] moveToPage:[[currentPdf document] indexForPage:[_pdfView currentPage]]];
    if (![navigationManager isUndoing]) [navigationManager setActionName:@"Previous Jump"];
    
    [_pdfView goToPage: [[currentPdf document] pageAtIndex:(NSUInteger)page]];
    [self currentPageLabel:[NSString stringWithFormat:@"%ld", page]];
}



@end
