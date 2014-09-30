//
//  PdfSet.h
//  MyPdfViewer
//
//  Created by Adam Sherlaw on 29/09/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//
//  Holds an array of PdfFile objects that represent each of the files in the
//  set of pdfs
//
//  Create new set
//  Insert into set
//  Remove from set
//

#import <Foundation/Foundation.h>
#import "PdfFile.h"

@class PdfFile;

@interface PdfSet : NSObject {
    NSMutableArray *pdfSet;
}

@property (strong) NSMutableArray * pdfSet;

-(void)insertObject:(PdfFile *)p inPdfSetAtIndex:(NSUInteger)index;
-(void)removeObjectFromPdfSetAtIndex:(NSUInteger)index;

-(void)printArray;

@end
