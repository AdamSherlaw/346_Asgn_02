//
//  Note.h
//  PdfOrganiser
//
//  Created by Adam Sherlaw on 2/10/14.
//  Copyright (c) 2014 Adam Sherlaw. All rights reserved.
//

// Notes are stored in plain text to allow ease of email to student etc
#import <Foundation/Foundation.h>

@interface Note : NSObject {
    NSURL *pdfLocation;      // Associated pdf file location
    NSURL *noteLocation;     // Location of stored note plain text.
    NSData *noteData;        // Note Data
}

@property (strong) NSData *noteData;

-(void) saveNote;

@end
