//
//  ORGDocument.h
//  PdfOrganiser
//
//  COSC346 Assignment 02
//  Adam Sherlaw 1935911
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "PdfFile.h"

@interface ORGDocument : NSDocument {
    IBOutlet NSArrayController *setController;
    NSMutableArray *pdfSet;
    NSMutableArray *noteSet;
    
    NSInteger indexOfCurrent;
    
    PdfFile *currentPdf;
    PDFSelection *queryResult;
    
    NSUndoManager *navigationManager;
}

@property (weak) IBOutlet PDFView *pdfView;
@property (weak) IBOutlet NSTableView *setView;
@property (weak) IBOutlet NSTextField *noteView;

@property (weak) IBOutlet NSTextField *fileNameLabel;
@property (weak) IBOutlet NSTextField *currentPageLabel;
@property (weak) IBOutlet NSTextField *pageJump;
@property (weak) IBOutlet NSSearchFieldCell *searchField;


- (void)doubleClick:(SEL)aSelector;

-(IBAction)addPdf:(id)sender;
-(IBAction)saveNote:(id)sender;

-(IBAction)zoomIn:(id)sender;
-(IBAction)zoomOut:(id)sender;
-(IBAction)zoomFit:(id)sender;

-(IBAction)nextPage:(id)sender;
-(IBAction)previousPage:(id)sender;
-(void)moveToPage:(NSInteger)page;

-(IBAction)nextDocument:(id)sender;
-(IBAction)previousDocument:(id)sender;
-(void)changeDocument:(NSInteger)rowNumber;

-(IBAction)back:(id)sender;
-(IBAction)forward:(id)sender;

-(IBAction)changePage:(id)sender;
-(IBAction)searchField:(id)sender;

-(void)labelName: (NSString *) value;
-(void)currentPageLabel:(NSNotification *)notification;

-(void)displayNote:(NSInteger)index;
- (NSString *)displayName;

@end
