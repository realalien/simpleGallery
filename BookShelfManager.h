//
//  BookShelfManager.h
//  Milestones
//
//  Created by anonymous on 6/23/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

// Manage the books in the bookshelf


//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"


#import "Material.h"
//#import "SBJson.h"
//#import "ASIHTTPRequest.h"
//#import "DownloadManager.h"

typedef UIImage CCSprite;

@interface CCSprite (AliasMethodsFromCocos2d)

+(CCSprite*) spriteWithFile:(NSString*)filename;

@end



@interface BookShelfManager : NSObject {
	int bookNumberOnEachColumn;
	
	int currentViewingColumn ;  // if bookshelf has multiple columns, decide which one to be shown, also with target books cover on that 
	

	int targetImageID;  // the image ID to be shown in the containing scrollview
	// NOTE: because in our scrollview, we will prepare 3 consecutive subviews (instances of MyViewController with ImageDetailView insided),
	//       so the currentProcessingImageID will be used in the subview to have a knowledge about which art work to load from BookShelfManager.
	int currentProcessingImageID;  // to facilitate the loading of images just at the left and right side of the targetImage
	
	NSMutableArray *covers ;
	//NSMutableDictionary *idToFilePath ;
	
	NSString *bookCoversDir ;
	NSString *contentRootDir ;
	
	NSMutableArray *allMaterials ; // the books/video plain objects, for easier access of local resource files.
	NSMutableArray *sortedMaterials ;  // the seq in bookshelf, default seq. is the published seq (ordered by id from server).
	
	// Experimenet, keeps of loaded books instances? 
}

@property int currentViewingColumn ;
//@property (retain) NSMutableDictionary *idToFilePath ;
@property (retain) NSMutableArray *covers ;
@property int bookNumberOnEachColumn;


@property (retain) NSMutableArray *allMaterials ;
@property (retain) NSMutableArray *sortedMaterials ;

@property(retain)	NSString *bookCoversDir ;
@property(retain)	NSString *contentRootDir ;

@property int currentProcessingImageID;
@property int targetImageID;

+(BookShelfManager*) sharedInstance ;

-(NSArray *) getBookCoversForShelfColumn:(int)number ;


//-(CCScene *)getNthColumn:(int)columnNumber ;  // NOTE: start from zero!


//-(void) updateShelfFromJSONString:(NSString *)jsonString ;

-(void) loadExistingMaterials ;
-(void) prepareMaterialCoverFolder ;

//-(NSString *) getCoverDownloadDestinationFromMaterialInfo:(NSDictionary *)jsonInfo ;
//-(NSString *) getCoverDownloadURLFromMaterialInfo:(NSDictionary *)jsonInfo ;
//
//-(NSString *) getContentDownloadDestinationFromMaterialInfo:(NSDictionary *)jsonInfo ;
//-(NSString *) getContentDownloadURLFromMaterialInfo:(NSDictionary *)jsonInfo ;


//-(void) updateMaterialFromJSONString:(NSString *)jsonString ;
-(void) persistAllMaterialsToPlist ;
-(void) loadMaterialCoversForBookShelf ;

//-(void)downloadBookCoverFor:(NSMutableDictionary *)oneMaterial;
//-(void)downloadBookCoverForMaterial:(Material *)mat ;

-(NSArray *)allValuesFromArrayOfDictionary:(NSArray*)arrayOfDictionary forKey:(NSString*)key ;

-(void) reloadAllMaterials ;

/**
 *  
 */
-(void) loadInventory;
-(void)saveAllMaterialsToConfig:(NSArray *) materialObjects ;

@end
