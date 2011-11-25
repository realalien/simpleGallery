//
//  StaticBookReader.h
//  Milestones
//
//  Created by anonymous on 6/24/11.
//  Copyright 2011 companyName. All rights reserved.
//
//
// Devnote: similar to the BookShelfManager, control each lifecyle of page instance.



// Served as a book page MVC, the controller part.
// Functionality,
// * manage the instance of StaticBook and download material.
// * keep a lifecyle of static book instance with book keeping, like finishing reading or not, etc.
// * page navigation, e.g. previous or next, last read page,
// Note,
// * this is not long live object, to actuall present a book, page objects 
// * open one book at a time!
// * Q: to avoid the dulplication of functionalities of class Static Book, 
//      REMEMBER that this class should appear to the controller, not the model

#import <Foundation/Foundation.h>
#import "StaticBook.h"
#import "cocos2d.h"
#import "StaticBookPage.h"
#import "Material.h"


@interface StaticBookReader : NSObject {
	StaticBook	*currentReadingBook ;		// a concept description of a book, nothing related to the resource, 
											// all resource loading/unloadingshould manage by this class.
	
	Material *currentUsingMaterial ;
}

@property(retain) StaticBook *currentReadingBook ;


+(StaticBookReader*) sharedInstance ;

-(void)setCurrentReadingBook:(StaticBook*)book ;
-(void)loadBook:(StaticBook*)book ;

-(void) setCurrentUsingMaterial:(Material *)mat ;
-(StaticBookReader *) loadMaterial:(Material *)mat ;


-(CCScene*)getPage:(int)targetPageNumber ;

-(NSString *) getPageArtForPage:(int) targetPageNumber  inDirectory:(NSString*)directory ;


-(CCScene *) present ;
@end
