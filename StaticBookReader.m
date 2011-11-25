//
//  StaticBookReader.m
//  Milestones
//
//  Created by anonymous on 6/24/11.
//  Copyright 2011 companyName. All rights reserved.
//

#import "StaticBookReader.h"



@implementation StaticBookReader


@synthesize currentReadingBook ;

// RA: how I which the simplicity of ruby singleton, 'just include singleton!'! Can I achieve this here? 
static StaticBookReader	*sharedInstance = nil;

- (id) init {
	self = [super init]; 
	
	if (self != nil){
		/* Do NOT allocate/initialize other objects here that might use 
		 the StaticBookReader's sharedInstance as that will create an infinite loop */		
		
		// TEMP, FIXME: UNZIP RESOURCE ONE TIME
//		NSString *path = @"Rowdyruff_Boy.zip" ;		// TODO: should have a directory structure, not to mingle with other app resources for easy mgmt.
//		NSString *fullpath = [CCFileUtils fullPathFromRelativePath: path ];
//		NSString *zipfileFullPath = [CCFileUtils fullPathFromRelativePath:@"Rowdyruff_Boy.zip"  ];  // self.currentReadingBook.resourceName
//		// For the moment, pages are unzipped into folder with the same name as resource file name(.zip).
//		
//		BOOL ifExists = [ [NSFileManager defaultManager ] fileExistsAtPath:fullpath ] ;
//		
//		NSLog(@" the fullpath of the resource path is %@", fullpath ) ;
//		NSLog(@" ifExists  is  %@", ifExists ? @"YES" :@"NO" );
//		
//		NSLog(@" -----------------------------   unzipping  -------------------");
//		// OK!  test unzip with ssunzip, since we don't know what format will the dlable be!
//		NSArray *unzip_path_components1_temp = [ NSArray arrayWithObjects: [fullpath stringByDeletingLastPathComponent ], nil ];   // Q: with '__MACOSX' cause problems?
//		NSString *destination = [NSString pathWithComponents:unzip_path_components1_temp  ];
//		//[SSZipArchive unzipFileAtPath:fullpath toDestination:destination];
//		NSLog(@"unzip_path_components1_temp  ...... %@", unzip_path_components1_temp) ;
//		NSLog(@"destination  ...... %@", destination) ;
//		NSLog(@"---------------------");
//
//		
//		// ---test unzippied folder 
//		NSArray *unzip_path_components = [ NSArray arrayWithObjects: [zipfileFullPath stringByDeletingLastPathComponent ], @"Rowdyruff_Boy", nil ]; // self.currentReadingBook.resourceName
//		NSString *unzip_path = [NSString pathWithComponents:unzip_path_components];
//		ifExists = [ [NSFileManager defaultManager ] fileExistsAtPath:unzip_path ] ;
//		
//		NSLog(@" the fullpath of the resource path is %@", unzip_path ) ;
//		NSLog(@" if  unzip_path  Exists  is  %@", ifExists ? @"YES" :@"NO" );		
		
	} 
	return(self);
}


- (void) initializeSharedInstance{
	/* Allocate/initialize your values here as we are sure this method gets called 
	 only AFTER the instance of StaticBookReader has been created through the [sharedInstance] class method */
		
	
	// TODO: self configuration.
	
}

+ (StaticBookReader *)	sharedInstance{
	@synchronized(self){ 
		if (sharedInstance == nil){
			sharedInstance = [[self alloc] init]; 
			/* Now initialize the shared instance */ 
			[sharedInstance initializeSharedInstance];
		} 
		return(sharedInstance);
	} 
}	

- (NSUInteger) retainCount{
	return(NSUIntegerMax);
}

- (void)release{ 
	/* Don't call super here. The shared instance should
	 not be deallocated */
}	

- (id) autorelease{
	return(self);
}

- (id) retain{
	return(self);
}


- (void) dealloc {
	[currentReadingBook release ];
	
	[super dealloc];
}



///   -----------------------------------------------------------------


-(void)setCurrentReadingBook:(StaticBook*)book {
	[book retain ] ;
	currentReadingBook = book;
	[book release ] ;
}


// method alias
-(void)loadBook:(StaticBook*)book {
	[self setCurrentReadingBook:book];
	
	
//	if ( [self canLoadBook:book ] ) {
//		[self checkBookReadHistoryAndPref] ;
//		[self present] ;  // actually a page instance.
//	}	
	
//	[self present] ;
}


-(void)setCurrentUsingMaterial:(Material *)mat {
	[mat retain ] ;
	currentUsingMaterial = mat;
	[mat release ] ;
}

-(StaticBookReader *) loadMaterial:(Material *)mat {
	[self setCurrentUsingMaterial:mat];
	return self ;
}


-(CCScene *) present {
	if ( currentUsingMaterial != nil) {
		return [self getPage:0];
	} else {
		return NULL;
	}
}

// --------------  helper method ---------------


// TODO: load resouce here!
-(CCScene*)getPage:(int)targetPageNumber {
	// OK! Q: how to read file from memory?
	//  TODO: FIXME: one time unzipping, shall be inside intializers not this function.	
	
	//TODO: temp code 
	NSString *temp = [ currentUsingMaterial.contentFullPathAtDevice stringByDeletingLastPathComponent];
	NSLog(@"temp  is %@", temp) ;
	NSString *temp2 = [ temp stringByAppendingPathComponent:@"Rowdyruff_Boy" ];   /// TODO: should follow the naming rule.
	NSLog(@"temp2  is %@", temp2) ;
	BOOL temp2Exist = [[NSFileManager defaultManager] fileExistsAtPath:temp2 ] ;
	NSString *jud = temp2Exist ? @"YES" : @"NO" ;
	NSLog(@"temp2Exist  is %@", jud) ;
	
	
	if (temp2Exist) {
		NSString *nthPageFileName = [self getPageArtForPage:targetPageNumber inDirectory:temp2 ] ;
		
		//NSLog(@"loading ..... %@", nthPageFileName) ;
		if (nthPageFileName != NULL) {
			
			NSArray *pageArtFilePathComponent = [NSArray arrayWithObjects:temp2 , nthPageFileName, nil ] ; 
			NSString *pageArtFilePath = [NSString pathWithComponents:pageArtFilePathComponent ];
			//NSLog(@"..................loading page art for page  %d,  with resource %@", targetPageNumber, pageArtFilePath );
			
			StaticBookPage  *page  = [StaticBookPage node] ;
			[page addPageArt: [CCSprite spriteWithFile:pageArtFilePath  ]];
			// ESP, increment or decrement the pagenumber
			page.pageNumber = targetPageNumber ;			
			
			CCScene *scene = [CCScene node];
			[scene addChild:page];		
			return scene ; 
		}else {   
			NSLog(@"[INFO] Can't get page art or no more previous page is the end of the book.") ;
			return NULL ;
		}
	}else {
		NSLog(@"[WARN] Going to redownload and unzip!") ;
		return NULL ;
	}	
}

// TEMP: retrieve corresponding page art for target page, 
// FIXME: 
// REF, http://stackoverflow.com/questions/499673/getting-a-list-of-files-in-a-directory-with-a-glob
-(NSString *) getPageArtForPage:(int) targetPageNumber  inDirectory:(NSString*)directory{
	// handling of boundary
	//NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
	NSAssert( [[NSFileManager defaultManager] fileExistsAtPath:directory ] , @"Directory must be exists");
	NSLog(@"page art in diretory .... %@ ", directory );
	
	NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
	NSArray *selectedFiles = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
	
	NSLog(@"selectedFiles   count ....  %d", [selectedFiles count ] );
	
	if (targetPageNumber >= 0 || targetPageNumber < [selectedFiles count ]) {
		return	[selectedFiles objectAtIndex:targetPageNumber ];
	}else {
		NSLog(@"[ERROR] targetPageNumber %d is invalid." , targetPageNumber );
		return NULL;
	}

}

+(BOOL)canLoadBook:(StaticBook*)book{
	// check if resource is valid and organized correctly.
	// EXT: is it possible that we read a manifest file?
	//TODO:  handle  new version of the books or dulplicated download.
	//FIXME:  code template
	return YES; 
}

+(BOOL)checkBookReadHistoryAndPref {	
	// FIXME: code template	
	return YES;
}

@end
