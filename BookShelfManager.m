//
//  BookShelfManager.m
//  Milestones
//
//  Created by anonymous on 6/23/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import "BookShelfManager.h"


@implementation CCSprite(AliasMethodsFromCocos2d)

+(CCSprite*) spriteWithFile:(NSString*)filename{
	return [UIImage imageNamed:filename];
}


@end

// ------------------------------------------------------------

//REF. iOS4 Programming Cookbook p.51
@implementation BookShelfManager


@synthesize bookNumberOnEachColumn;
@synthesize currentViewingColumn ;
//@synthesize  idToFilePath ;
@synthesize covers;
@synthesize allMaterials;
@synthesize sortedMaterials ;
@synthesize bookCoversDir ;
@synthesize contentRootDir ;
@synthesize currentProcessingImageID;

// ----------   singleton implementation -----------
static BookShelfManager	*sharedInstance = nil;

- (id) init {
	self = [super init]; if (self != nil){
		/* Do NOT allocate/initialize other objects here that might use 
		 the BookShelfManager's sharedInstance as that will create an infinite loop */
	} 
	return(self);
}


- (void) initializeSharedInstance{
	/* Allocate/initialize your values here as we are sure this method gets called 
	 only AFTER the instance of BookShelfManager has been created through the [sharedInstance] class method */
	currentViewingColumn = 0 ;	  // TODO: make read configuration to avoid start from 1st shelf column

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		bookNumberOnEachColumn = 6 ;
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		bookNumberOnEachColumn = 3 ;
	}
	




	[self prepareMaterialCoverFolder ]; // in case of first run, creating resource related
	
	// NOTE: actually we query/save directly on UserDefault preference, the following unfinished implementation will
	//        probably used when our task involving deleting and shelf sorting.
	allMaterials  = [NSMutableArray arrayWithCapacity:6 ]; // 6 is just random number.
	[allMaterials retain ];
	//[self loadExistingMaterials ];   
	//[self reloadAllMaterial ] ;  // to be used in 
	
	// TEMP, I feelt it's not correct way to preload every images in the an array, 
	//      because we ought to sort the array based on attributes.
	// [self loadMaterialCoversForBookShelf]  ; 
}



-(void) loadInventory {
	NSString *ids_key = @"inventory" ;
	
	// retrieve first to avoid overwrite
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	NSMutableArray *mats = [prefs objectForKey:ids_key] ;


	if ( mats) { 
//		NSLog(@"---------------------");
//		NSLog(@"all existing art works from book keeping:   %@", mats);
//		NSLog(@"---------------------");
		// already exists, just set the manager's instance variable 'allMaterials' for further use.
		// NSMutableArray *materials = [[NSMutableArray alloc]init] ;
		for ( NSUInteger i = 0; i< [mats count ]; i++) {
			Material *mat = [ [Material alloc] initWithDictionaryInfo:[mats objectAtIndex:i ]];
			[allMaterials addObject: mat ] ;
		}
					
	}else {
		// first run of app, glob all artwork from a directory and persist to 
		NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
		NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundleRoot error:nil];
		NSArray *onlyJPGAndPNG = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self like 'PG*.jpg'" ]];
		
		NSLog(@"Total jpg and png  %d found!", [onlyJPGAndPNG count] ); 
		
		NSLog(@"1st element is   %@ found!", [onlyJPGAndPNG objectAtIndex:0] ); 
		
		// NOTE: copied from 'updateMaterialFromJSONString:(NSString *)jsonString'. TODO: refactor
		//  create instance  and 
		NSMutableArray *mats = [NSMutableArray arrayWithCapacity:[onlyJPGAndPNG count]];
		
		for ( int i = 0 ; i < [onlyJPGAndPNG count];i++) {
			Material *mat =  [[Material alloc] initWithName:[onlyJPGAndPNG objectAtIndex:i] andPath:bundleRoot]; // ESP. if use raw data from "info" , use "identifier" as the key!

			if (mat) {
								// created new one 
				
				//setup device based information.  // TODO: week point
				mat.downloaded = NO;
				mat.purchased = NO;
				mat.purchaseVerified = NO ;
				
				// NOTE: since parsed json dictionary will contain just server side info, it shall not overwrite existing info.
				//BOOL isOK = [mat save];  //TODO: some exception handling
				[mats addObject:mat];
				[allMaterials addObject:mat];
			}			
		}
		// TODO: what this persistence process is interrupted? How to handle that situation? 
		[self saveAllMaterialsToConfig:mats];
				
	}
	
	NSLog(@"[DEBUG]Art Gallary - loadInventory loaded .   total:  [ %d]", [allMaterials count ]) ;
}


/**
 * Temp use for persisting materilas to a dictionary
 */
-(void)saveAllMaterialsToConfig:(NSArray *) materialObjects {
	
	NSMutableArray *alldicts = [[NSMutableArray alloc]init]; ; // wtf, that's a big surprise!
	
	for (int i =0; i< [materialObjects count]; i++) {
		Material *tmp = [materialObjects objectAtIndex:i];
		
		NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithCapacity:6] ;
		
		if ( tmp.idServerSide == NULL) {
			tmp.idServerSide = tmp.name;
		}
		[newData setValue:tmp.idServerSide			forKey:@"product_server_id"] ;
		
		[newData setValue:tmp.name					forKey:@"product_name"] ;
		
		if (tmp.productIdentifier == NULL) {
			tmp.productIdentifier = tmp.name;
		}		
		[newData setValue:tmp.productIdentifier		forKey:@"product_identifier"] ;
		
		
		if ( (NSNull *)tmp.coverFullPathAtDevice == [NSNull null]) {
			tmp.coverFullPathAtDevice =  @"" ;
		}
		
		if ( (NSNull *)tmp.coverURLString == [NSNull null]) {
			tmp.coverURLString =  @"" ;
		}
		
		if ( (NSNull *)tmp.contentFullPathAtDevice == [NSNull null]) {
			tmp.contentFullPathAtDevice =  @"" ;
		}
		
		if ( (NSNull *)tmp.contentURLString == [NSNull null]) {
			tmp.contentURLString =  @"" ;
		}
		
		
		[newData setValue:tmp.coverFullPathAtDevice	forKey:@"cover_full_path_at_device"] ;
		[newData setValue:tmp.coverURLString		forKey:@"cover_url_string"] ;
		
		[newData setValue:tmp.contentFullPathAtDevice	forKey:@"content_full_path_at_device"] ;
		[newData setValue:tmp.contentURLString		forKey:@"content_url_string"] ;
		
		if ( tmp.isDownloaded != YES) {
			tmp.downloaded = NO;
		}
		
		if ( tmp.isFreeAvailable != YES) {
			tmp.freeAvailable = NO ;
		}
		
		if (tmp.isPurchased  != YES) {
			tmp.purchased  = NO;
		}
		
		if ( tmp.isPurchaseVerified != YES) {
			tmp.purchaseVerified = NO;
		}
		
		[newData setValue:[NSNumber numberWithBool: tmp.isDownloaded ]			forKey:@"product_is_downloaded"] ;		
		[newData setValue:[NSNumber numberWithBool: tmp.isFreeAvailable ]		forKey:@"product_is_free_available"] ;
		[newData setValue:[NSNumber numberWithBool: tmp.isPurchased ]			forKey:@"product_is_purchased"] ;
		[newData setValue:[NSNumber numberWithBool: tmp.isPurchaseVerified ]	forKey:@"product_is_purchase_verified"] ;
		NSLog(@"In adding  new data is ..... %@ ", newData);
		
		
		[alldicts addObject:newData];
	}
	
	NSString *ids_key = @"inventory" ;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[NSMutableArray arrayWithArray:alldicts ] forKey:ids_key ] ;
	NSLog(@"pref .... %@", prefs) ;
	
	[alldicts release]; alldicts = nil;
}


// TODO: also reload the sortedMaterial array accordingly.
// Update the material instances in the all materials array
-(void) reloadAllMaterials {
	NSString *ids_key = @"inventory" ;
	
	// retrieve first to avoid overwrite
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *mats = [prefs objectForKey:ids_key] ;
	
	NSMutableArray *materials = [NSMutableArray arrayWithCapacity:5 ];	
	
	for ( NSUInteger i = 0; i< [mats count ]; i++) {
		[materials addObject: [[ Material alloc ] initWithDictionaryInfo:[mats objectAtIndex:i ]  ] ] ;
	}
	
	NSLog(@"reloaded.   Materials total:  [ %d]", [materials count ]) ;
	
	[allMaterials removeAllObjects ];
	[allMaterials addObjectsFromArray:materials ];
}

// TODO: method in probation, not really needed.
-(void) loadMaterialCoversForBookShelf {
	if (allMaterials != NULL &&  [allMaterials count] >0 ) {  // covers prepare based on book indexing 
		covers = [NSMutableArray arrayWithCapacity:[allMaterials count] ];
		
		for (int i=0; i < [allMaterials count] ; i++) {
			NSString *coverFullPath = [[allMaterials objectAtIndex:i ] objectForKey:@"cover_full_path_at_device" ];
			
			CCSprite *bookCover = [CCSprite spriteWithFile:coverFullPath ];
			[covers addObject:bookCover];		
		}	
		
		// ESP. TODO: is it a nice place to retain those object?
		[allMaterials retain];
		[covers retain ];
	}else {
		NSLog(@"[WARN] No materials found in plist, thus cover pages can't be loaded.");
	}
}


-(void) createFolderIfNotExists:(NSString *)folderPath {
	NSError *error;

	//NSLog(@"testing or creating folderPath ,  %@", folderPath );
	if ( folderPath != NULL) {
		// create directory if not exists, Q: what's the difference with different location, USER DEFAULT.
		NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
		if (! [fileManager fileExistsAtPath:folderPath ]) {
			[ fileManager createDirectoryAtPath:folderPath 
					withIntermediateDirectories:YES
									 attributes:nil
										  error:&error] ;
		}
	}
}

-(void) prepareMaterialCoverFolder {
	if ( self.bookCoversDir == NULL) {
		// INFO: it looks like "UIImage imageNamed:" load resource from application main bundle, may changed to main bundle if other ways unfeasible. 
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		//NSLog(@"rootPath is %@", rootPath ); 		
		NSArray *bookCoversDirComponents = [NSArray arrayWithObjects:rootPath, @"covers", nil] ;
		self.bookCoversDir = [NSString pathWithComponents:bookCoversDirComponents ] ;
		
		[self createFolderIfNotExists:self.bookCoversDir ];
	}
	
	// root directory holds all the books and other content.
	if ( self.contentRootDir == NULL) {
		// INFO: it looks like "UIImage imageNamed:" load resource from application main bundle, may changed to main bundle if other ways unfeasible. 
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
		//NSLog(@"rootPath is %@", rootPath ); 
		
		NSArray *bookCoversDirComponents = [NSArray arrayWithObjects:rootPath, @"contents", nil] ;
		self.contentRootDir = [NSString pathWithComponents:bookCoversDirComponents ] ;
		
		// create directory if not exists, Q: what's the difference with different location, USER DEFAULT.
		[self createFolderIfNotExists:contentRootDir ];
	}
	
	
}


+ (BookShelfManager *)	sharedInstance{
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
	
	[covers release ];
	//[idToFilePath release] ;
	[allMaterials release]; allMaterials = nil;
	[super dealloc];
}

//  -----------    helper methods   ---------

// Logical control of book distributed on the shelf column
// ESP: should handle a columns number that may not exist.
-(NSArray *) getBookCoversForShelfColumn:(int)number{
	if ( number < 0 || number  > ceil( [allMaterials count ] / bookNumberOnEachColumn )) {
		return NULL ; 	
	}else {
		NSMutableArray *targetCovers = [NSMutableArray arrayWithCapacity:bookNumberOnEachColumn];
		int startIndex = number * bookNumberOnEachColumn ;
		int maxIndex = MIN( number * bookNumberOnEachColumn + bookNumberOnEachColumn , [allMaterials count ] ) ; // in case the shelf is not full
		
		for ( int i = startIndex ; i < maxIndex ; i++) {
			Material *mat = [allMaterials objectAtIndex:i ]  ;
			NSString *filename = mat.coverFullPathAtDevice ;  // Actually the thumbnail files
			filename = [filename lastPathComponent];
			//NSLog(@"file name is %z@", filename);
			if (filename != nil  ) {  // && [[NSFileManager defaultManager] fileExistsAtPath:filename ]
				[targetCovers addObject:[CCSprite spriteWithFile:filename] ];
			}
		}
		return targetCovers ;
	}	
}




//TODO: at the server side, the json should not include those materials those are not 'visible'(deprecated, closed due to other affairs.)

//TODO: require a more general key-value setting when setting attribute for a material.
//-(void) updateMaterialFromJSONString:(NSString *)jsonString {
//	// parse the response
//	SBJsonParser *parser = [SBJsonParser new];   //Q: what's the use of new? GC things?
//
//	NSArray *responses = [parser objectWithString:jsonString];
//	
//	if ([responses count] > 0) {
//		for (int i=0; i< [responses count]; i++) {
//			NSMutableDictionary *localMaterial = [NSMutableDictionary dictionaryWithCapacity:10 ] ;
//			
//			NSDictionary *item = [responses objectAtIndex:i] ;
//			NSDictionary *info = [item valueForKey:@"products_info"];
//			NSLog(@"parsing json data .....   %@", info);
//			if ([info valueForKey:@"name"]  != NULL && [info valueForKey:@"identifier"]  != NULL 
//													&& [info valueForKey:@"cover_small_file_name"] != NULL 
//													&& [info valueForKey:@"id"] != NULL ) {
//				
//				// setup up basic info for later local referenceing
//				[localMaterial setObject:[info valueForKey:@"name"]			forKey:@"product_name"		];
//				[localMaterial setObject:[info valueForKey:@"identifier"]	forKey:@"product_identifier"];
//				[localMaterial setObject:[info valueForKey:@"id"]			forKey:@"product_server_id"	];
//				
//				
//				[localMaterial setObject:[info valueForKey:@"is_free"] forKey:@"product_is_free_available"];
// 				// A Ateb
//				//if ([info valueForKey:@"is_free"] == nil ) {
//					[localMaterial setValue:(id)1 	forKey:@"product_is_free_available"];
//				}else {
//					[localMaterial setObject:[info valueForKey:@"is_free"]		forKey:@"product_is_free_available"];
//				}
//
//				
//				
//				// get URL string and download destination info	, TODO, this is very weak!							
//				[localMaterial setObject:[self getCoverDownloadURLFromMaterialInfo:info]			forKey:@"cover_url_string" ];
//				[localMaterial setObject:[self getCoverDownloadDestinationFromMaterialInfo:info] forKey:@"cover_full_path_at_device" ];
//				
//				NSLog(@"in updateMaterialFromJSONString,  info is %@", info) ;
//				
//				NSString *contentURL = [self getContentDownloadURLFromMaterialInfo:info];
//				if ( contentURL != nil ) {
//					[localMaterial setObject:contentURL		forKey:@"content_url_string" ];					
//				}else {
//					[localMaterial setObject:[NSNull null]	forKey:@"content_url_string" ];
//				}
//
//				NSString *contentDest = [self getContentDownloadDestinationFromMaterialInfo:info] ;
//				if (contentDest != nil ) {
//					[localMaterial setObject:contentDest		forKey:@"content_full_path_at_device" ];					
//				}else {
//					[localMaterial setObject:[NSNull null]	forKey:@"content_full_path_at_device" ];
//				}
//				
//				NSLog(@"in updateMaterialFromJSONString,  localMaterial is %@", localMaterial) ;
//	
//				
//				// ESP.NOTE: because the dictionary parsed from JSON is structured for the ease of server setup, only has part of info. needed by device. 
//				//       so there are some difference between the Material#initWithDictionaryInfo's targeted key which has more clear names.
//				Material *mat =  [ Material findByIdentifier:[localMaterial valueForKey:@"product_identifier"] ]; // ESP. if use raw data from "info" , use "identifier" as the key!
// 				
//				if (mat == NULL) 
//					{NSLog(@"Adding new material to local repository, %@ ", localMaterial )	;	
//					// created new one 
//					Material *mat = [[Material alloc] initWithDictionaryInfo:localMaterial ] ;
//					
//					//setup device based information.  // TODO: week point
//					mat.downloaded = NO;
//					mat.purchased = NO;
//					mat.purchaseVerified = NO ;
//						
//					// NOTE: since parsed json dictionary will contain just server side info, it shall not overwrite existing info.
//					BOOL isOK = [mat save];  //TODO: some exception handling
//						
//						if (! [[NSFileManager defaultManager] fileExistsAtPath: mat.coverFullPathAtDevice ] ) {
//							//TODO: should also allow forced download in case cover image is corrupt.
//							[self downloadBookCoverForMaterial:mat];
//						}	
//					
//				}else {
//					// update the corresponding info, TODO: since the url/path and partial product info 
//					NSLog(@"Updating material info from ")	;
//					
//					[ mat updateWithNewInfo:localMaterial ];
//					BOOL isOK = [mat save];  //TODO: some exception handling
//					
//					if (! [[NSFileManager defaultManager] fileExistsAtPath: mat.coverFullPathAtDevice ] ) {
//						//TODO: should also allow forced download in case cover image is corrupt.
//						[self downloadBookCoverForMaterial:mat];
//					}
//				}
//				
//				
//				
//				// if doesn't exist, add 
//				NSArray *allIndentifier = [self allValuesFromArrayOfDictionary:allMaterials forKey:@"product_identifier" ];
//				
//				if (! [allIndentifier containsObject: [localMaterial valueForKey:@"product_identifier" ]] ) {  
//					[allMaterials addObject:localMaterial ];
//					[self downloadBookCoverFor:localMaterial];   //TODO: should also allow forced download in case cover image is corrupt.					
//					NSLog(@"[INFO] Adding one product into the inventory, %@ ", localMaterial);
//				}else {
//					NSLog(@"[WARN] Product already exists, %@ ", localMaterial);
//				}				
//			}else {
//				NSLog(@"[WARN] info doesn't pass the validation, check all the information from parsed string\n%@\n ",info);
//			}
//		}
//		//[self persistAllMaterialsToPlist] ;
//	}	
//	
//	
//	[parser release ];
//}

//-(void)downloadBookCoverFor:(NSMutableDictionary *)oneMaterial {
//	// TODO: image may be corrupt, test ok or delete!
//	NSLog(@"[INFO] Download material cover page, From: %@\tTo: %@", [oneMaterial objectForKey:@"cover_url_string"], [oneMaterial objectForKey:@"cover_full_path_at_device"] ) ;
//	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[oneMaterial objectForKey:@"cover_url_string"] ];
//	[request setDownloadDestinationPath:[oneMaterial objectForKey:@"cover_full_path_at_device"] ];
//	[request setDelegate:self];
//	[request setDidFinishSelector:@selector(requestDone:)];
//	[request setDidFailSelector:@selector(requestWentWrong:)];
//	//[[self queue] addOperation:request]; 
//	[request startAsynchronous];	
//}
//
//
//-(void)downloadBookCoverForMaterial:(Material *)mat {
//	// TODO: image may be corrupt, test ok or delete!
//	NSLog(@"[INFO] Download material cover page, From: %@\tTo: %@", mat.coverURLString, mat.coverFullPathAtDevice ) ;
//	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: [NSURL URLWithString:mat.coverURLString ]];
//	
//	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: mat, @"material", nil ] ;  // TODO: userinfo.
//	[request setUserInfo:userInfo ];
//	
//	[request setDownloadDestinationPath:mat.coverFullPathAtDevice ];
//	[request setDelegate:self];
//	[request setDidFinishSelector:@selector(requestDone:)];
//	[request setDidFailSelector:@selector(requestWentWrong:)];
//	//[[self queue] addOperation:request]; 
//	[request startAsynchronous];	
//}


// Deprecated: allMaterials is supposed to have instances of Material, rather than dictionary of info.
//  maintain the existing materials by r/w plist and related directories.
-(void) loadExistingMaterials {
	
	NSString *ids_key = @"inventory" ;
	
	// retrieve first to avoid overwrite
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	if (allMaterials == NULL || [allMaterials count  ] < 1 ) {
		allMaterials = [ [NSMutableArray alloc ] initWithCapacity:1]; // create a empty array to allow later adding materials.
	}
	allMaterials = [NSMutableArray arrayWithArray:[prefs arrayForKey:ids_key]];
	
	
	// TODO: see if we can use Core Data to manipulate the data. Use dictionary is less intuitive.
	//	NSMutableArray *arrayOfMaterial = [NSMutableArray arrayWithArray:[prefs arrayForKey:ids_key]];
	//	
	//	if (arrayOfMaterial == NULL || [arrayOfMaterial count  ] < 1 ) {
	//		arrayOfMaterial = [ NSMutableArray arrayWithCapacity:1];
	//		[prefs setObject:arrayOfMaterial forKey:ids_key ] ;
	//	}else {
	//		//for (NSUInteger i = 0; i< [arrayOfMaterial count]; i++) {
	//			//Material *mat = [[[ Material alloc ] initWithDictionaryInfo:[arrayOfMaterial objectAtIndex:i] ] autorelease ] ;
	//			//[ allMaterials addObject: mat];
	//		//}
	//	}
	
	// DEBUG: retrieve to show them all
	NSLog(@"[INFO] allMaterials are %@", allMaterials );
}


-(void) persistAllMaterialsToPlist {
	NSString *ids_key = @"inventory" ;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[NSArray arrayWithArray:allMaterials] forKey:ids_key ] ;
}

-(NSString *) getCoverDownloadDestinationFromMaterialInfo:(NSDictionary *)jsonInfo {
	//NSArray *downloadFilePathComponents = [NSArray arrayWithObjects:bookCoversDir, imageFileName, nil ];  
	NSString *productIdentifier = [jsonInfo valueForKey:@"identifier"] ;
	NSString *imageNameOnDeviceDotAdded =  [productIdentifier stringByAppendingString:@"."] ;
	NSString *imageFileName = [jsonInfo valueForKey:@"cover_small_file_name"] ;
	NSString *imageNameOnDeviceFullPath = [imageNameOnDeviceDotAdded stringByAppendingString: [[imageFileName pathExtension] lowercaseString] ] ;  // append extension name, lower case
	NSArray *downloadFilePathComponents = [NSArray arrayWithObjects:self.bookCoversDir, imageNameOnDeviceFullPath , nil ]; 
	NSString *downloadDest = [NSString pathWithComponents:downloadFilePathComponents ];
	
	return downloadDest ;
}


//-(NSString *) getCoverDownloadURLFromMaterialInfo:(NSDictionary *)jsonInfo {
//	// create URL and download file， TODO: not nice URL setup!
//	//NSArray *imagesServerLocationComponents =[ NSArray URLByAppendingPathComponent:@"http://localhost:3000/system/cover_smalls", [NSString stringWithFormat:@"%@",[info valueForKey:@"id"]] ,@"original", nil ] ;
//	//NSString *imagesServerLocation  = [NSString pathWithComponents:imagesServerLocationComponents ];
//	NSURL *url = [NSURL URLWithString: [[ DownloadManager sharedInstance] productsCoversURL] ];
//	url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@",[jsonInfo valueForKey:@"id"]]  ];  // append id
//	url = [url URLByAppendingPathComponent:@"original" ]; // TODO: may change according to new spec.
//	url = [url URLByAppendingPathComponent: [jsonInfo valueForKey:@"cover_small_file_name"] ] ;    // append image file name
//	
//	NSLog(@"url to request cover image is .......%@", [url absoluteString ]);
//	// INFO, to easier file manipulation on user device, cover page name will be the same with identifier.
//	
//	return [url absoluteString] ;
//}


// TODO:  refactor code to avoid code copying
-(NSString *) getContentDownloadDestinationFromMaterialInfo:(NSDictionary *)jsonInfo {
	//NSArray *downloadFilePathComponents = [NSArray arrayWithObjects:bookCoversDir, imageFileName, nil ];  
	NSString *productIdentifier = [jsonInfo valueForKey:@"identifier"] ;
	NSString *imageNameOnDeviceDotAdded =  [productIdentifier stringByAppendingString:@"."] ;

	NSString *imageFileName = [jsonInfo valueForKey:@"zipcontent_file_name"] ;
	if ( (NSNull *)imageFileName == [NSNull null]  ) {  // TODO: FIXME: temp solution, user shouldn't be paid for nothing.
		return NULL ;
	}else {
		NSString *imageNameOnDeviceFullPath = [imageNameOnDeviceDotAdded stringByAppendingString: [[imageFileName pathExtension] lowercaseString] ] ;  // append extension name, lower case
		//TODO: decide how to organize content.
		//NSArray *downloadFilePathComponents = [NSArray arrayWithObjects:contentRootDir, productIdentifier, nil ];   //imageNameOnDeviceFullPath
		NSArray *downloadFilePathComponents = [NSArray arrayWithObjects:self.contentRootDir, imageNameOnDeviceFullPath, nil ];
		NSString *downloadDest = [NSString pathWithComponents:downloadFilePathComponents ];
		
		return downloadDest ;	
	}
}
//
// ESP, those published content shouldn't 
//-(NSString *) getContentDownloadURLFromMaterialInfo:(NSDictionary *)jsonInfo {
//	
//	// create URL and download file， TODO: not nice URL setup!
//	//NSArray *imagesServerLocationComponents =[ NSArray URLByAppendingPathComponent:@"http://localhost:3000/system/cover_smalls", [NSString stringWithFormat:@"%@",[info valueForKey:@"id"]] ,@"original", nil ] ;
//	//NSString *imagesServerLocation  = [NSString pathWithComponents:imagesServerLocationComponents ];
//	NSURL *url = [NSURL URLWithString:[[ DownloadManager sharedInstance] productsContentURL]  ];
//	url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@",[jsonInfo valueForKey:@"id"]]  ];  // append id
//	url = [url URLByAppendingPathComponent:@"original" ]; // TODO: may change according to new spec.
//	NSString *filename = [jsonInfo valueForKey:@"zipcontent_file_name"] ;
//	
//	NSLog(@"filename  is %@", filename) ;
//	if ( (NSNull *)filename == [NSNull null] ) {  // TODO: FIXME: temp solution, user shouldn't be paid for nothing.
//		return NULL ;
//	}else {
//		url = [url URLByAppendingPathComponent:filename  ] ;    // append image file name	
//	}
//	
//	NSLog(@"url to request content   is   .......%@", url);
//	// INFO, to easier file manipulation on user device, cover page name will be the same with identifier.
//	
//	return [url absoluteString] ;
//}

-(NSArray *)allValuesFromArrayOfDictionary:(NSArray*)arrayOfDictionary forKey:(NSString*)key {
	if ( arrayOfDictionary != NULL && key != NULL) {
		NSMutableArray *values = [NSMutableArray arrayWithCapacity:[arrayOfDictionary count ]];
		
		for ( NSUInteger i=0 ; i < [arrayOfDictionary count ] ; i++) {
			NSString *value =  [[arrayOfDictionary objectAtIndex:i ] valueForKey:key ] ;
			if ( value != NULL ) {
				[values addObject:value ];				
			}
		}
		return [NSArray arrayWithArray:values];
	}
	return NULL ;	
}


//- (void) requestDone:(ASIHTTPRequest *)request {
//	NSString *response = [request responseString];
//	NSLog(@"requestDone .in downloading files ... response is %@", response) ;
//	NSDictionary *userinfo = request.userInfo;
//	Material *temp = [userinfo valueForKey:@"material" ];
//	if (  temp != nil) {
//		Material *mat = [Material findByIdentifier:temp.productIdentifier ];
//		if (mat != nil) {
//			mat.downloaded = YES; 
//			[mat save ];
//		}	
//	}	
//}
//
//- (void)requestWentWrong:(ASIHTTPRequest *)request
//{
//	NSError *error = [request error];
//	NSLog(@"requestWentWrong when downloading files,  error: %@", error) ;
//	NSLog(@"request info,  %@", request) ;
//}
@end
