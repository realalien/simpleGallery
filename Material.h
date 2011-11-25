//
//  Material.h
//  Milestones
//
//  Created by anonymous on 7/6/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Material : NSObject {
	NSString *idServerSide ;
	NSString *name ;
	NSString *productIdentifier;
	

	
	// downloadable content related
	NSString *coverURLString ;
	NSString *coverFullPathAtDevice  ; // fullpath of the cover page on user device
	
	NSString *contentURLString ;		// URI for the zipped content at server side.
	NSString *contentFullPathAtDevice ;
	
	BOOL	downloaded ;
	
	
	// Purcahse related
	BOOL freeAvailable ;				// YES: no need to buy, NO: to buy
	BOOL purchased ;			// YES: ,NO: 
	BOOL purchaseVerified ;     // YES: ,NO: , probably used when the receipt verification is interrupted.
	
}


@property(retain) NSString *idServerSide ;
@property(retain) NSString *name ;
@property(retain) NSString *productIdentifier;

//
@property(retain) NSString *coverURLString  ;
@property(retain) NSString *coverFullPathAtDevice  ;

@property(retain) NSString *contentURLString  ;
@property(retain) NSString *contentFullPathAtDevice  ;

-(BOOL)isDownloaded ;
-(void)setDownloaded:(BOOL)val;

//
-(BOOL)isFreeAvailable ;
-(void) setFreeAvailable:(BOOL)val;

-(BOOL)isPurchased ;
-(void) setPurchased:(BOOL) val;

-(BOOL)isPurchaseVerified ;
-(void) setPurchaseVerified:(BOOL)val;


//
-(id) initWithDictionaryInfo:(NSDictionary*)data ;
-(void) updateWithNewInfo:(NSDictionary *)data ;

-(BOOL) save ;
+(Material *) findByIdentifier:(NSString *)identifier; 

-(id) initWithName:(NSString *)aName andPath:(NSString *)filefullPath ;
@end
