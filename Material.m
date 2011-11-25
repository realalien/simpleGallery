//
//  Material.m
//  Milestones
//
//  Created by anonymous on 7/6/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import "Material.h"

#define PRODUCT_IDENTIFIER @"product_identifier"

@implementation Material

@synthesize idServerSide ;
@synthesize name ;
@synthesize productIdentifier;

//
@synthesize coverFullPathAtDevice  ;
@synthesize coverURLString ;
@synthesize contentURLString  ;
@synthesize contentFullPathAtDevice  ;

-(BOOL)isFreeAvailable{
	return freeAvailable;
}

-(void) setFreeAvailable:(BOOL)val {
	freeAvailable = val ;
}

-(BOOL)isPurchased {
	return purchased ;
}
-(void) setPurchased:(BOOL) val {
	purchased = val ;
}

-(BOOL)isPurchaseVerified {
	return purchaseVerified ;
}

-(void) setPurchaseVerified:(BOOL)val{
	purchaseVerified = val ;
}

-(BOOL)isDownloaded{
	return downloaded;
}

-(void) setDownloaded:(BOOL)val {
	downloaded = val ;
}

/**
 * Temp code, just init with basic device location and filename.
 */
-(id) initWithName:(NSString *)aName andPath:(NSString *)filefullPath {
	self.name = aName ;
	self.coverFullPathAtDevice =  [filefullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@", aName]]  ; // the variable means to be each art work name, nothing related to the cover
	self.contentFullPathAtDevice = [filefullPath stringByAppendingPathComponent:aName ] ;	
	return self;
}

// TODO: the potential problem is that if scheme at the server side changes, the class failes, FIXME: more robust data handling.
// REF, http://stackoverflow.com/questions/3822601/restoring-a-bool-inside-an-nsdictionary-from-a-plist-file
-(id) initWithDictionaryInfo:(NSDictionary*)data {
	NSLog(@"data when initiize material   .....    %@", data) ;
	// if ( data != NULL && [data objectForKey:@"product_server_id" ] && [data objectForKey:@"product_identifier" ] ) {
	
		if ( (self = [super init]) ) {
			self.idServerSide = [data objectForKey:@"product_server_id" ] ;
			self.name = [data objectForKey:@"product_name" ] ;
			self.productIdentifier = [data objectForKey:@"product_identifier" ] ;
			
			self.coverFullPathAtDevice = [data valueForKey:@"cover_full_path_at_device" ] ;
			self.coverURLString = [data valueForKey:@"cover_url_string" ] ;
			
			NSString *contentPath = [data valueForKey:@"content_full_path_at_device" ] ;
			if ( contentPath  != nil) {
				self.contentFullPathAtDevice = contentPath ;
			}else {
				self.contentFullPathAtDevice = nil;
			}

			NSString *contentURL = [data valueForKey:@"content_url_string" ] ;
			if ( contentURL  != nil) {
				self.contentURLString = contentURL ;
			}else {
				self.contentURLString = nil;
			}

//			NSLog(@"**********************");
			
			
			
			if ([data objectForKey:@"product_is_downloaded"] != [NSNull null] ) {
				self.downloaded = [[data objectForKey:@"product_is_downloaded"] boolValue ] ;
			}else{
				self.downloaded = NO ;  // not downloaded yet
			}
			// self.downloaded = [[data objectForKey:@"product_is_downloaded"] boolValue ] ;
				 
//			NSLog(@"downloaded   set ok");
//			
//			NSLog(@"********************** class for data %@ ",  [[data objectForKey:@"product_is_free_available"] class ] );
			
			if ( [data objectForKey:@"product_is_free_available"] !=  [NSNull null]  ) {
				self.freeAvailable = [[data objectForKey:@"product_is_free_available"] boolValue ] ;
			}else {
				self.freeAvailable = NO ;
			}			
			//self.freeAvailable = [[data objectForKey:@"product_is_free_available"] boolValue ] ;
			
				 
			
			
				 if ( [data objectForKey:@"product_is_purchased"] !=  [NSNull null]  ) {
					 self.purchased = [[data objectForKey:@"product_is_purchased"] boolValue ] ;
				 }else {
					 self.purchased = NO ;
				 }			 
			//self.purchased =  [[data objectForKey:@"product_is_purchased" ] boolValue ] ;
			//self.purchased =  [data objectForKey:@"product_is_purchased" ]  ;
			
				 
				 if ( [data objectForKey:@"product_is_purchase_verified"] != [NSNull null]) {
					 self.purchaseVerified = [[data objectForKey:@"product_is_purchase_verified"] boolValue ] ;
				 }else {
					 self.purchaseVerified = NO ;
				 }	
			//self.purchaseVerified = [[data objectForKey:@"product_is_purchase_verified" ]boolValue ];
			NSLog(@"Materila %@ has been loaded from dictionary config", self);
			return self;
		}
	//}
	//return NULL; 
	return self;
}


// NOTE: only set the info related to the information of the server side, shall not update identifier 
-(void) updateWithNewInfo:(NSDictionary *)data{
	NSLog(@"updateWithNewInfo    data.....  %@", data);
	self.idServerSide = [data objectForKey:@"product_server_id" ] ;
	self.name = [data objectForKey:@"product_name" ] ;
	// self.productIdentifier = [data objectForKey:@"product_identifier" ] ;
	
	
	if ([data valueForKey:@"cover_full_path_at_device" ] == (id)[NSNull null] ) {
		self.coverFullPathAtDevice = @"";
	}else {
		self.coverFullPathAtDevice = [data valueForKey:@"cover_full_path_at_device" ] ;
	}
	
	if ([data valueForKey:@"cover_url_string" ]  == (id)[NSNull null] ) {
		self.coverURLString = @"" ;
	}else {
		self.coverURLString = [data valueForKey:@"cover_url_string" ] ;
	}

	if ([data valueForKey:@"content_full_path_at_device" ] == (id)[NSNull null] ) {
		self.contentFullPathAtDevice = @""  ;
	}else {
		self.contentFullPathAtDevice = [data valueForKey:@"content_full_path_at_device" ]  ;
	}
	 
	if ([data valueForKey:@"content_url_string" ] == (id)[NSNull null] ) {
		self.contentURLString = @"";
	}else {
		self.contentURLString = [data valueForKey:@"content_url_string" ] ;

	}
	
	
	if ([data valueForKey:@"product_is_free_available"]  == (id)[NSNull null]) {
		self.freeAvailable = NO;
	}else {
		self.freeAvailable = [[data valueForKey:@"product_is_free_available"]  boolValue ] ;	
	}


	// also the product info. e.g. set product  'free available' during some holidays.
	
		
	NSLog(@"in updateWithNewInfo, product_is_free_available,  %@", [data objectForKey:@"product_is_free_available"] ) ; 
	NSLog(@"in updateWithNewInfo, self.freeAvailable,  %@", self.isFreeAvailable ? @"YES" : @"NO" ) ; 	
}

// TODO: http://stackoverflow.com/questions/1215330/how-does-synchronized-lock-unlock-in-objective-c
// REF. http://stackoverflow.com/questions/1893530/how-to-update-an-nsuserdefault
-(BOOL) save{
	NSLog(@"Saving ..........................");
	BOOL hasRecord = NO;  
	NSString *ids_key = @"inventory" ;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *allMaterials = [[[prefs objectForKey:ids_key ] mutableCopy] autorelease ] ; // wtf, that's a big surprise!
	
	if (allMaterials == nil ) {
		allMaterials = [NSMutableArray arrayWithCapacity:5] ; 
	}
	
	//[allMaterials retain ];
	NSLog(@"allMaterials retainCount  is   %d",  [allMaterials retainCount]);
	
	NSLog(@">>>>>>>>  allMaterial before saving. class is :    %@",   [allMaterials class ]   ); 
	//interate and update
	for (NSUInteger i=0; i<[allMaterials count ]; i++) {
		NSString *identifier = [[allMaterials objectAtIndex:i] valueForKey:PRODUCT_IDENTIFIER] ;
				
		// setup a mutable dictionary to allow setup and write back.
		NSMutableDictionary *newData = [[ [allMaterials objectAtIndex:i] mutableCopy] autorelease];
		
		
		if (  [identifier isEqualToString:[self productIdentifier] ] ) {
			NSLog(@" in saving materials   is :   %@", [allMaterials objectAtIndex:i] ) ;

			// Q: what 's the best way to persist all the info, even if new attribute is added. A:
			
			// ESP, here never set the identifier on which many resource are depending on.
			[newData setValue:self.idServerSide			forKey:@"product_server_id"] ;
			[newData setValue:self.name					forKey:@"product_name"] ;
			[newData setValue:self.productIdentifier		forKey:PRODUCT_IDENTIFIER] ;
			
			[newData setValue:self.coverFullPathAtDevice	forKey:@"cover_full_path_at_device"] ;
			[newData setValue:self.coverURLString		forKey:@"cover_url_string"] ;
			
			[newData setValue:self.contentFullPathAtDevice	forKey:@"content_full_path_at_device"] ;
			[newData setValue:self.contentURLString		forKey:@"content_url_string"] ;

			if ( self.isDownloaded != YES) {
				self.downloaded = NO;
			}
			
			if ( self.isFreeAvailable != YES) {
				self.freeAvailable = NO ;
			}
			
			if (self.isPurchased  != YES) {
				self.purchased  = NO;
			}
			
			if ( self.isPurchaseVerified != YES) {
				self.purchaseVerified = NO;
			}
			
			
			[newData setValue:[NSNumber numberWithBool: self.isDownloaded ]			forKey:@"product_is_downloaded"] ;			
			[newData setValue:[NSNumber numberWithBool: self.isFreeAvailable ]		forKey:@"product_is_free_available"] ;
			[newData setValue:[NSNumber numberWithBool: self.isPurchased ]			forKey:@"product_is_purchased"] ;
			[newData setValue:[NSNumber numberWithBool: self.isPurchaseVerified ]	forKey:@"product_is_purchase_verified"] ;
			NSLog(@"In saving  new data is ..... %@ ", newData);
			
			// write back to an
			[allMaterials replaceObjectAtIndex:i withObject:newData ];			
			NSLog(@" After saving new material data   is :   %@", newData  ) ;
			hasRecord = YES ;
			break ;
		}else {
			continue ;
		}		
	}
	
	if ( hasRecord == NO) {
		// if not found, add one
		NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithCapacity:6] ;
		[newData setValue:self.idServerSide			forKey:@"product_server_id"] ;
		[newData setValue:self.name					forKey:@"product_name"] ;
		[newData setValue:self.productIdentifier		forKey:PRODUCT_IDENTIFIER] ;
		
		if ( (NSNull *)self.coverFullPathAtDevice == [NSNull null]) {
			self.coverFullPathAtDevice =  @"" ;
		}
		
		if ( (NSNull *)self.coverURLString == [NSNull null]) {
			self.coverURLString =  @"" ;
		}
		
		if ( (NSNull *)self.contentFullPathAtDevice == [NSNull null]) {
			self.contentFullPathAtDevice =  @"" ;
		}
		
		if ( (NSNull *)self.contentURLString == [NSNull null]) {
			self.contentURLString =  @"" ;
		}
		
		
		[newData setValue:self.coverFullPathAtDevice	forKey:@"cover_full_path_at_device"] ;
		[newData setValue:self.coverURLString		forKey:@"cover_url_string"] ;
		
		[newData setValue:self.contentFullPathAtDevice	forKey:@"content_full_path_at_device"] ;
		[newData setValue:self.contentURLString		forKey:@"content_url_string"] ;
		
		if ( self.isDownloaded != YES) {
			self.downloaded = NO;
		}
		
		if ( self.isFreeAvailable != YES) {
			self.freeAvailable = NO ;
		}
		
		if (self.isPurchased  != YES) {
			self.purchased  = NO;
		}
		
		if ( self.isPurchaseVerified != YES) {
			self.purchaseVerified = NO;
		}
		
		
		[newData setValue:[NSNumber numberWithBool: self.isDownloaded ]			forKey:@"product_is_downloaded"] ;		
		[newData setValue:[NSNumber numberWithBool: self.isFreeAvailable ]		forKey:@"product_is_free_available"] ;
		[newData setValue:[NSNumber numberWithBool: self.isPurchased ]			forKey:@"product_is_purchased"] ;
		[newData setValue:[NSNumber numberWithBool: self.isPurchaseVerified ]	forKey:@"product_is_purchase_verified"] ;
		NSLog(@"In adding  new data is ..... %@ ", newData);
		
		// write back to an
		[allMaterials addObject:newData];		
	}
		
	
	// Debug information
	NSLog(@"--------------------------------------------");
	NSLog(@" After saving materials  count   is  :   %d", [allMaterials  count ] ) ;
	NSLog(@" After saving materials   is  :   %@", allMaterials  ) ;
	[prefs setObject:[NSMutableArray arrayWithArray:allMaterials ] forKey:ids_key ] ;
	NSLog(@"pref .... %@", prefs) ;
	BOOL syncOK = [[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"syncOK    .... %@", syncOK ? @"YES":@"NO") ;
	allMaterials = [[[prefs objectForKey:ids_key ] mutableCopy] autorelease ] ;
	NSLog(@"after sync, see all materials  .....  %@",  allMaterials ) ;

	return YES;
}

// TODO:  how to handle access lock to avoid dirty data?
+(Material*)findByIdentifier:(NSString *)identifier {
	NSString *ids_key = @"inventory" ;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *allMaterials = [prefs objectForKey:ids_key ] ;
	
	NSLog(@"[DEBUG] ------all materials from local repo are: -----\n %@", allMaterials) ;
	
	//interate and update
	for (NSUInteger i=0; i<[allMaterials count ]; i++) {
		NSString *localIdentifier = [[allMaterials objectAtIndex:i] valueForKey:PRODUCT_IDENTIFIER] ;
		NSLog(@"identifier [ %@ ],  localIdentifier [ %@ ]", identifier, localIdentifier) ;
		if ( [ localIdentifier isEqualToString:identifier]  ) {
			// Q: what 's the best way to persist all the info, even if new attribute is added. A:
			Material *mat =[[Material alloc] initWithDictionaryInfo: [allMaterials objectAtIndex:i] ];			
			return mat ;
		}else {
			continue ;
		}
	}
	NSLog(@"[DEBUG] Identifier %@  not found.", identifier);
	return NULL ;
}

#pragma mark Object override
- (NSString *)description
{
	return [NSString stringWithFormat:@"\nMaterial: [name: %@ coverFullPathAtDevice:%@ contentFullPathAtDevice:%@", name, coverFullPathAtDevice,contentFullPathAtDevice ];
}


@end
