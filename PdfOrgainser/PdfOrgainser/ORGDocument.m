//
//  ORGDocument.m
//  PdfOrgainser
//
//  Created by Adam Sherlaw on 29/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import "ORGDocument.h"
#import "PdfFile.h"

@implementation ORGDocument

@synthesize pdfSet;

- (id)init
{
    NSLog(@"PDF Manager Document init");
    self = [super init];
    if (self) {
        // Create a new set of documents
        pdfSet = [[NSMutableArray alloc] init];
    }
    return self;
}


/* Print all elements in the pdf set array
 */
-(void)printArray
{
    for (id object in pdfSet) {
        NSLog(@"%@", [[[object fileUrl] URLByDeletingPathExtension] lastPathComponent]);
    }
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
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}


- (NSString *)displayName {
    if (![self fileURL])
        return @"PDF Set Viewer";
    
    return [super displayName];
}


- (IBAction)addPdf:(id)sender {
    NSLog(@"addPdf Called");
    // Show the open file window
    // create an open documet panel
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    // display the panel
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            
            // grab a reference to what has been selected
            NSURL *theDocument = [[panel URLs]objectAtIndex:0];
            
            NSLog(@"Document URL: %@", theDocument);
            
            // Create a new pdfFile
            PdfFile *file = [[PdfFile alloc] init];
            
            // Set its URL
            [file setFileWithUrl: theDocument];
            [file setDocumentName: [[theDocument URLByDeletingPathExtension] lastPathComponent]];
            
            // Add the pdf object to the array
            [self insertObject:file inPdfSetAtIndex:0];
        }
    }];
    
    
   }

- (IBAction)viewSet:(id)sender {
    NSLog(@"viewSet Called");
    // If one is selected, display the selected one
    // Else start at the first one
}


-(void)insertObject:(PdfFile *)p inPdfSetAtIndex:(NSUInteger)index
{
    NSLog(@"adding %@ to %@", p, pdfSet);
    // Add the inverse to the undo stack
    /*NSUndoManager *undo = [self undoManager];
     [[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
     
     // If not the undo manager
     if(![undo isUndoing]) {
     [undo setActionName:@"Add Person"];
     }*/
    
    // Add the pdf to the array
    //[self startObservingPerson:p];
    [pdfSet insertObject:p atIndex:index];
}

-(void)removeObjectFromPdfSetAtIndex:(NSUInteger)index
{
    PdfFile *p = [pdfSet objectAtIndex:index];
    NSLog(@"removing %@ from %@", p, pdfSet);
    
    // Add the inverse of the operation to the undo stack
    /*NSUndoManager *undo = [self undoManager];
     [[undo prepareWithInvocationTarget:self] insertObject:p inEmployeesAtIndex:index];
     
     // If not the undo manager
     if (![undo isUndoing]) {
     [undo setActionName:@"Remove Person"];
     }*/
    
    // [self stopObservingPerson:p];
    [pdfSet removeObjectAtIndex:index];
}

-(IBAction)testBtn:(id)sender
{
    NSLog(@"Test Button pressed!");
    
    controllerWindow = [[NSWindowController alloc] initWithWindowNibName:@"PdfViewDocument"];
    [controllerWindow showWindow:self];
}

@end
