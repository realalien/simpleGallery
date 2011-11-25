//
//  BookShelfColumnGridViewController.h
//  Milestones
//
//  Created by anonymous on 6/28/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


#import "AQGridView.h"
#import "BookShelfManager.h"
#import "BookShelfColumnGridViewCell.h"

#import "Material.h"
//#import "ASIHTTPRequest.h"   // to allow Base64 encryption in exchanging receipt.
//#import "DownloadManager.h"

//#import "ZipArchive.h"


@interface BookShelfColumnGridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {   //, ImageDemoCellChooserDelegate, ASIHTTPRequestDelegate,, SKProductsRequestDelegate, SKPaymentTransactionObserver
	NSArray * bookcovers ;
	AQGridView * gridView;
	
		
	// temp, copied exmample
	UILabel *pageNumberLabel;
    int pageNumber;
		
	// download related
	// REF. DownAndASIRequest project from cocoachina.com/bbs
	
	BookShelfColumnGridViewCell *currentProcessingCell ;   // used to indicate the last user interact material, used to load material after download finish.
}

@property (nonatomic, retain) IBOutlet AQGridView * gridView;
@property (retain) BookShelfColumnGridViewCell *currentProcessingCell ;


// temp:  debug use
//@property (nonatomic, retain) IBOutlet UILabel *pageNumberLabel;
//@property (nonatomic, retain) IBOutlet UILabel *numberTitle;


- (id)initWithPageNumber:(int)page;

///   experimental
//-(void) loadOrBuy:(Material *)material ;
//-(void) loadOrBuy:(BookShelfColumnGridViewCell *)cell ;

//-(BOOL) canLoadBookByProductIdentifier:(Material*) material;
//-(NSString *)gridIndexToBookInfo:(int)gridIndex forAttribute:(NSString *)attrName ;
//-(NSDictionary *)gridIndexToBookInfo:(int)gridIndex ;

//-(void)useMaterial:( BookShelfColumnGridViewCell *)cell ;
//-(void)downloadMaterial:( BookShelfColumnGridViewCell *)cell ;

@end



// TODO: remove me, debugging code
@interface UIView (debug)

- (NSString *)recursiveDescription;

@end


