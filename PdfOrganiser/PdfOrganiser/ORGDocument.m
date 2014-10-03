//
//  ORGDocument.m
//  PdfOrganiser
//
//  COSC346 Assignment 02
//  Adam Sherlaw 1935911
//

#import "ORGDocument.h"

@implementation ORGDocument

- (id)init
{
    self = [super init];
    if (self) {
        pdfSet = [[NSMutableArray alloc] init];
        noteSet = [[NSMutableArray alloc] init];
        
        navigationManager = [[NSUndoManager alloc]init];
        indexOfCurrent = -1;
        
        /* Notification center for the current page label */
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(currentPageLabel:)
                   name:PDFViewPageChangedNotification
                 object:nil];
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


/* 
 * Action invoked on table item double click
 * Changes the pdf view to the item selected.
 */
- (void)doubleClick:(SEL)aSelector
{
    [self changeDocument:[_setView clickedRow]];
}


/* 
 * Changes the current PDF document being viewed to the document
 * that is stored at the given index. The index of the table view
 * correspond to the indexes of the relating pdf document.
 */
-(void)changeDocument:(NSInteger)rowNumber
{
    currentPdf = [pdfSet objectAtIndex: rowNumber];
    
    [_pdfView setDocument: [currentPdf document]];
    
    // Reset the page that was last being viewed
    [_pdfView goToPage: [[currentPdf document] pageAtIndex:(NSUInteger)[currentPdf currentPage]]];
    
    [self labelName:[currentPdf documentName]];
    indexOfCurrent = rowNumber;
    
    // Change the higlighted row to match the document being displayed
    [_setView selectRowIndexes:[NSIndexSet indexSetWithIndex:indexOfCurrent] byExtendingSelection:NO];
    
    [_currentPageLabel setStringValue:[NSString stringWithFormat:@"%lu", [[currentPdf document] indexForPage:[_pdfView currentPage]]]];
    
    // Display the corresponding note
    [self displayNote:rowNumber];
}


/*
 * Load in a PDF or multiple PDF document(s) from the file manager.
 * The last, or only PDF will be displayed on load.
 */
-(IBAction)addPdf:(id)sender {
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
    
    [panel beginSheetModalForWindow: [self windowForSheet] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            for (NSURL *url in [panel URLs]) {
                
                PdfFile *file = [[PdfFile alloc] init];
                
                [file setFileWithUrl: url];
                [file setDocumentName: [[url URLByDeletingPathExtension] lastPathComponent]];
                
                [setController addObject: file];
                [noteSet insertObject:[NSString stringWithFormat:@"This is a new note!"] atIndex:[pdfSet count] - 1];
                
                currentPdf = file;
                
                [_pdfView setDocument:[file document]];
                [self displayNote:[pdfSet count] - 1];
                
                [self labelName:[file documentName]];
                [_currentPageLabel setStringValue:[NSString stringWithFormat:@"%d", 0]];
                
                indexOfCurrent = [pdfSet count] - 1;
            }
        }
    }];
}


/*
 *  Load and display the note that corresponds to the current document
 */
-(void)displayNote:(NSInteger)index
{
    [_noteView setStringValue: [noteSet objectAtIndex:index]];
}


/*
 *  Save the current note's contents to the index of the current pdf document
 */
-(IBAction)saveNote:(id)sender
{
    if (indexOfCurrent < 0) return;
    
    [noteSet replaceObjectAtIndex:indexOfCurrent withObject:[_noteView stringValue]];
}


/*
 *  Sets the window's name
 */
- (NSString *)displayName
{
    if (![self fileURL]) return @"PDF Set Viewer";
    return [super displayName];
}


/* Zoom Actions */


/*
 *  Zoom the PDF view in by one increment
 */
-(IBAction)zoomIn:(id)sender
{
    [_pdfView zoomIn:sender];
}


/*
 *  Zoom the PDF view out by one increment
 */
-(IBAction)zoomOut:(id)sender
{
    [_pdfView zoomOut:sender];
}

/*
 *  Zoom the PDF view to a scale that allows one entire pdf page to fit onto
 *  the screen
 */
-(IBAction)zoomFit:(id)sender
{
    [_pdfView setAutoScales:YES];
}




/* Page Actions */


/*
 *  Changes pdf view do the next page in the document
 */
-(IBAction)nextPage:(id)sender
{
    [_pdfView goToNextPage:sender];
    
    [currentPdf setCurrentPage:[[currentPdf document] indexForPage:[_pdfView currentPage]]];
    
    [[navigationManager prepareWithInvocationTarget:self] previousPage:sender];
}


/*
 *  Changes the PDF view to the previous page in the document
 */
-(IBAction)previousPage:(id)sender
{
    [_pdfView goToPreviousPage:sender];
    
    [currentPdf setCurrentPage:[[currentPdf document] indexForPage:[_pdfView currentPage]]];
    
    [[navigationManager prepareWithInvocationTarget:self] nextPage:sender];
}


/* Document Actions */


/*
 *  Changes the PDF view to the next document in the set
 */
-(IBAction)nextDocument:(id)sender
{
    if (indexOfCurrent + 1 < [pdfSet count]) {
        currentPdf = [pdfSet objectAtIndex: ++indexOfCurrent];
        
        [self changeDocument:indexOfCurrent];
        [[navigationManager prepareWithInvocationTarget:self] previousDocument:sender];
    }
}

/*
 *  Changes the PDF view to the previous document in the set
 */
-(IBAction)previousDocument:(id)sender
{
    if (indexOfCurrent - 1 >= 0) {
        currentPdf = [pdfSet objectAtIndex: --indexOfCurrent];
        
        [self changeDocument:indexOfCurrent];
        [[navigationManager prepareWithInvocationTarget:self] nextDocument:sender];
    }
}


/* Navigation controls */


/*
 *  Moves the user back to the previous command done if they are not at
 *  the end of the undo command stack.
 */
-(IBAction)back:(id)sender
{
    [navigationManager undo];
}


/*
 *  Moves the user forward to the next command done if they are not at the 
 *  end of the redo command stack.
 */
-(IBAction)forward:(id)sender
{
    [navigationManager redo];
}


/*
 *  Sets the current file label to display the given string value
 */
-(void)labelName: (NSString *) value
{
    [_fileNameLabel setStringValue:value];
}


/*
 *  Sets the current page label to display the current page being displayed
 */
-(void)currentPageLabel:(NSNotification *)notification
{
    NSUInteger current = [[currentPdf document] indexForPage:[_pdfView currentPage]];
    [_currentPageLabel setStringValue:[NSString stringWithFormat:@"%lu", current]];
}


/*
 *  Moves the pdf view to the page specified in the text box.
 *  Moves to the first page of the document if the value is invalid
 */
-(IBAction)changePage:(id)sender
{
    [self moveToPage:[_pageJump integerValue]];
}


/*
 * Moves the pdf view to the page given in number.
 */
-(void)moveToPage:(NSInteger)page
{
    [[navigationManager prepareWithInvocationTarget:self] moveToPage:[[currentPdf document] indexForPage:[_pdfView currentPage]]];
    
    [_pdfView goToPage: [[currentPdf document] pageAtIndex:(NSUInteger)page]];
}


/*
 *  Searches the current document for the given string from the search field
 *  Displays the results as higlighted text.
 *  Use enter key to cycle through the results
 */
- (IBAction)searchField:(id)sender
{
    NSString *searchQuery = [[self searchField] stringValue];
    queryResult = [[currentPdf document] findString:searchQuery fromSelection: queryResult withOptions: NSCaseInsensitiveSearch];
    
    [_pdfView setCurrentSelection:queryResult];
    [_pdfView scrollSelectionToVisible:sender];
}

@end

