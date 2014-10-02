//
//  Note.m
//  PdfOrganiser
//
//  Created by Adam Sherlaw on 2/10/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

#import "Note.h"

@implementation Note

@synthesize noteData;

- (id)init
{
    self = [super init];
    if (self) {
        pdfLocation = nil;
        noteLocation = nil;
        noteData = @"Adam is cool";
    }
    return self;
}


- (id)initWithPdfUrl:(NSURL *)pdfUrl andNoteUrl:(NSURL *)noteUrl
{
    self = [super init];
    if (self) {
        pdfLocation = pdfUrl;
        noteLocation = noteUrl;
    }
    return self;
}

-(void)saveNote
{
    // Save the note
    // Save the object or save the data??? Both maybe???
    //[noteData writeToFile:@"/Users/Adam/Desktop/test" atomically:YES];
}
@end
