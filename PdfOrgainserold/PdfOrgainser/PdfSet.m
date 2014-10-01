//
//  PdfSet.m
//  MyPdfViewer
//
//  Created by Adam Sherlaw on 29/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import "PdfSet.h"

@implementation PdfSet

@synthesize pdfSet;

-(id) init
{
    NSLog(@"PDF Set init");
    self = [super init];
    if (self) {
        // Initailise the Pdf Set array
        pdfSet = [[NSMutableArray alloc] init];
    }
    return self;
}


/*
 */
-(void)printArray
{
    for (id object in pdfSet) {
        NSLog(@"%@", [[[object fileUrl] URLByDeletingPathExtension] lastPathComponent]);
    }
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

@end
