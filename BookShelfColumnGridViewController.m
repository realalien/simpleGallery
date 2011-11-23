    //
//  BookShelfColumnGridViewController.m
//  Milestones
//
//  Created by GuZhenZhen on 6/28/11.
//  Copyright 2011 Spicyhorse Studio. All rights reserved.
//

#import "BookShelfColumnGridViewController.h"
#define HUMAN_MACHINE_NUM_INDEX_DIFF 1
#define SEVER_VERIFY_RECIPT @"http://localhost:3000/receipt/verify"
//#import	"ImageScene.h"
#import "UIKit/UIDevice.h"
#import "AppDelegate_iPad.h"
#import "ImageDetailView.h"

@implementation BookShelfColumnGridViewController


// temp, copied example
//@synthesize pageNumberLabel, numberTitle ;

@synthesize gridView ;
@synthesize currentProcessingCell ;
- (id)initWithPageNumber:(int)page
{
	
	NSLog(@"UI_USER_INTERFACE_IDIOM  is  %d", UI_USER_INTERFACE_IDIOM() );
	NSLog(@"UIUserInterfaceIdiomPhone  is  %d", UIUserInterfaceIdiomPhone );
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		self = [self initWithNibName:@"BookShelfColumnGridViewController" bundle:nil];
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		self = [self initWithNibName:@"BookShelfColumnGridViewController_iPhone" bundle:nil];
	}
	
	
	if  ( self)
	{
		pageNumber = page;
	}
	return self;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSLog(@"viewDidLoad in ColumnGridViewController ....");
    [super viewDidLoad];
    
	pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + HUMAN_MACHINE_NUM_INDEX_DIFF ];
	
	// RAEXP, add gridview component which is injected with book cover
	// REF. ImageDemoViewController.m from ImageDemo, https://github.com/AlanQuatermain/AQGridView
	self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin; //   
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
	self.gridView.resizesCellWidthToFit = YES;
	self.gridView.separatorColor = [UIColor blueColor];
	
		
	bookcovers = [[ BookShelfManager sharedInstance ] getBookCoversForShelfColumn:pageNumber ];
	NSLog(@"bookcovers  for shelf column  %d..... loaded, total %d", pageNumber, [bookcovers count]);
		
//	NSLog(@"Debugging UI.......");
//	NSLog(@"%@", self.gridView) ;
//	NSLog(@"%@", self.gridView.recursiveDescription) ;
//	self.gridView.layer.borderColor = [UIColor redColor].CGColor;
//	self.gridView.layer.borderWidth = 1.0;
	
	//[[DownloadManager sharedInstance ] retain ];	
	
    [self.gridView reloadData];
	
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// is it safe?
	[bookcovers release ];
	bookcovers  = nil ;
	
    self.gridView = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[gridView release ];
	[currentProcessingCell release ] ;
	[bookcovers release ];
	
	// temp, copied example
	
	//[pageNumberLabel release];
    //[numberTitle release];
	
    [super dealloc];
}


- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index {

	//TODO: FIXME, code template
	static NSString * PlainCellIdentifier = @"PlainCellIdentifier";
	
	AQGridViewCell * cell = nil;
		
	BookShelfColumnGridViewCell * plainCell = (BookShelfColumnGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: PlainCellIdentifier];
	
	if ( plainCell == nil )
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
			plainCell = [[[BookShelfColumnGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 240.0)  // CGRectMake(0.0, 0.0, 150.0, 200.0)  
															reuseIdentifier: PlainCellIdentifier] autorelease];  //  768 / 2, 1024 / 2
		}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			plainCell = [[[BookShelfColumnGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 160.0, 120.0)  // CGRectMake(0.0, 0.0, 150.0, 200.0)  
															reuseIdentifier: PlainCellIdentifier] autorelease];  //  768 / 2, 1024 / 2
		}
			
		plainCell.selectionGlowColor = [UIColor blueColor];
		
	}
	
	Material *mat = [[[ BookShelfManager sharedInstance] allMaterials ] objectAtIndex:(pageNumber * [BookShelfManager sharedInstance ].bookNumberOnEachColumn + index )  ] ;	
	NSString *fileName = mat.coverFullPathAtDevice ;
	
	//NSLog(@"fileName is %@",  fileName) ;
	plainCell.image =  [UIImage imageWithData:[NSData dataWithContentsOfFile:fileName]  ]  ;
	plainCell.material = mat ;
	//plainCell.bookTitle = mat.name ;
	

	//debug
//	plainCell.layer.borderColor = [UIColor redColor].CGColor;
//	plainCell.layer.borderWidth = 1.0;

	cell = plainCell;
	
	return cell ;
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
	//TODO: FIXME, code template
    return ( [bookcovers count] );
}


- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
	//bak  
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		return CGSizeMake(240.0, 200.0);
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		return CGSizeMake(140.0, 120.0);
	}
	
	//TODO: FIXME, code template
	// return ( CGSizeMake( (1024-20) / 2, (768 -20)/ 2) );    // 2x2 full screen on iPad.
		
	//return CGSizeMake( 1024 / 4 , 1024 / 4 * (3/4) );
}

-(void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index{
	NSLog(@"the selected index is %d", index);
	NSLog(@"probably you clicked the  book %d in sequence. ",  pageNumber * [BookShelfManager sharedInstance ].bookNumberOnEachColumn + index + HUMAN_MACHINE_NUM_INDEX_DIFF); 
	
	// NOTE: to avoid probable later requirement of deleting one book(either at server side or client side), 
	//  the 'id' info shall not be used in counting, indexing because programs will be easily crippled. Use identifier instead.
	// TODO:  later use sorted materials
	
	// Note: because this class will be responsible for UI change of its cell content like download progress, 
	//       we will use gridcell to get reference to an material.
	//Material *mat = [[[BookShelfManager sharedInstance] allMaterials ] objectAtIndex:(pageNumber * 6 + index )]  ;
	//[self loadOrBuy:mat  ]; 
		
	// TODO: I forget what to do with the cell, probably should be removed for clearity.
	BookShelfColumnGridViewCell *cell = [self.gridView.visibleCells objectAtIndex:index ];	
	[self setCurrentProcessingCell: cell];
	
	[BookShelfManager sharedInstance].currentProcessingImageID = pageNumber * [BookShelfManager sharedInstance ].bookNumberOnEachColumn + index ;
	
	// [self loadOrBuy:cell ] ;
	

	
	//	CCScene* scene = [PictureRotation scene];
	//	PictureRotation *layer = (PictureRotation *) [scene.children objectAtIndex:0];
	//    UIRotationGestureRecognizer *gestureRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:layer action:@selector(handleRotation:)] autorelease];
	//    [viewController.view addGestureRecognizer:gestureRecognizer]; // NOTE: we may call scene.parent.viewControll whatever to register Gesture recognizeer to allow reotation
	//	[[CCDirector sharedDirector] runWithScene:scene ];

// ---->
	// Used to remove the GridView
//	[[[[[CCDirector sharedDirector] openGLView ] subviews ] objectAtIndex:0 ] removeFromSuperview ]  ;
//	
//	CCScene *sc = [ ImageScene sceneWithImageID:(pageNumber * BOOKS_NUMBER_ON_EACH_SHELF + index) ];
//	ImageScene *layer = (ImageScene *) [sc.children objectAtIndex:0];
	
	// NOTE: not to use the swipe gesture recognizer because such action will render the movement of scaled image movement impossible
//	UISwipeGestureRecognizer *leftSwiperGR = [[[UISwipeGestureRecognizer alloc] initWithTarget:layer action:@selector(handleSwipeLeft:)] autorelease];
//	leftSwiperGR.direction = UISwipeGestureRecognizerDirectionLeft;
//	[[[CCDirector sharedDirector] openGLView] addGestureRecognizer:leftSwiperGR];
//	UISwipeGestureRecognizer *rightSwiperGR = [[[UISwipeGestureRecognizer alloc] initWithTarget:layer action:@selector(handleSwipeRight:)] autorelease];
//	rightSwiperGR.direction = UISwipeGestureRecognizerDirectionRight;
//	[[[CCDirector sharedDirector] openGLView] addGestureRecognizer:rightSwiperGR];

// ---->
//	UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:layer action:@selector(handlePinch:)];	
//	[[[CCDirector sharedDirector] openGLView] addGestureRecognizer:pinch];
//	
//	
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:sc]  ];
	//[[CCDirector sharedDirector] pushScene:sc  ];
	
	//UIImage *image = [[[BookShelfManager sharedInstance] allMaterials] objectAtIndex:(pageNumber * BOOKS_NUMBER_ON_EACH_SHELF + index)];
	
	
	ImageDetailView *theDetailView ;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		theDetailView = [[ImageDetailView alloc] initWithNibName:@"ImageDetailView" bundle:nil];
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		theDetailView = [[ImageDetailView alloc] initWithNibName:@"ImageDetailView_iPhone" bundle:nil];
	}
	
	
	// ImageDetailView *theDetailView = [[ImageDetailView alloc] initWithNibName:@"ImageDetailView" bundle:nil];
	
	//theDetailView.theImage = image;
	
	AppDelegate_iPad *delegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:theDetailView animated:YES];
	
	
}




// FIXME: dulplicated code from BookManagerShelf.
-(void) prepareFolder:(NSString *)folderPath {
	NSError *error;
	
	NSLog(@"testing or creating folderPath ,  %@", folderPath );
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

//-(void)downloadMaterial: ( BookShelfColumnGridViewCell *)cell {
//	
//	if ( [[DownloadManager sharedInstance ] networkExists ] ) {
//		Material *mat = cell.material ;
//		NSString *contentFullPath = mat.contentFullPathAtDevice ;
//		if (contentFullPath != NULL ) {
//			//[self prepareFolder:contentFullPath ] ;	// NOTE: not sure where to put the download content
//			
//			ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: [NSURL URLWithString:mat.contentURLString] ];
//			[request setDownloadDestinationPath:mat.contentFullPathAtDevice ];
//			// To allow resumable download
//			NSString *tempfile = [mat.contentFullPathAtDevice stringByAppendingString:@".temp"] ;
//			[request setTemporaryFileDownloadPath:tempfile];
//			[request setAllowResumeForFileDownloads:YES];
//			NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: mat.productIdentifier, @"product_identifier", cell, @"cell", nil ] ;
//			[request setUserInfo:userInfo ];
//			
//			[request setDelegate:self];  
//						
//			[request setDidFinishSelector:@selector(downloadFinished:)];
//			[request setDidFailSelector:@selector(downloadFailed:)];
//			
//			[request setDownloadProgressDelegate:cell ] ;   // Q: is it OK to delegate to 
//			
//			[request startAsynchronous] ;
//			
//			
//			// Show an activity indicator 
//			UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
//			//int center = [cell frame].size.height / 2;
//			
//			// Size (width) of the text in the cell
//			//CGSize size = [[[cell textLabel] text] sizeWithFont:[[cell textLabel] font]];
//			float SPINNER_SIZE = 100.0f ;
//			
//			// Locate spinner in the center of the cell at end of text
//			[spinner setFrame:CGRectMake([cell frame].size.width / 2 - SPINNER_SIZE / 2, [cell frame].size.height / 2 - SPINNER_SIZE / 2, SPINNER_SIZE, SPINNER_SIZE)];
//			cell.spinner = spinner ;
//			[[cell contentView] addSubview:spinner]; 
//			
//			[spinner startAnimating];
//			[spinner release];
//			
//			
//			// TODO: see if really need a ASINetworkQueue.
//			//[[DownloadManager sharedInstance] addOperation:request ];
//			
//			
//		} else {
//			NSLog(@"[WARN] coverFullPath is NULL or doesn't exist!");		
//		}
//	}else {
//		// NOTE: UI prompt is already implemented in DownloadManager.
//	}
//
//	
//	
//}

// TODO: not only the network connection, but also the server application up-and-running test.
// TODO: anyway, UI will be more complex 
//-(void) loadOrBuy:(BookShelfColumnGridViewCell *)cell {
//	Material *mat = cell.material ;
//	if (mat.isFreeAvailable ) {
//		if (mat.isDownloaded) {
//			[self useMaterial:cell];
//		}else {
//			[self downloadMaterial:cell ] ;
//		}
//
//	}else {
//		[self debugAlertWithTitle:@"Info" message:@"The material is not free, since this product is not published yet. The book will not load now."];
//	}
//
////	if ( mat.isPurchased) {
////		if ( mat.isDownloaded ) {
////			
////		}else {  // not downloaded
////			
////			// unpack 
////			// selected.downloaded = YES;   // set true once the 
////		}
////	}else {  // not purchased 
////		[self debugAlertWithTitle:@"Debug Info" message:@"Not purchased, Go To Store!" ] ;
////		// TODO: give a popup to give detailed information.
////		SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:mat.productIdentifier]];
////        preq.delegate = self;
////        [preq start];
////		
////	}	
//}


// TEMP: it seems that the InAppPurchaseManager has pains in handling each product request
//       for the sake of simplicity, transaction management is temporarily handled in this View class.
/////////////////////////////////////////////////////////////////////////////////
///////    in-app purchase 
/////////////////////////////////////////////////////////////////////////////////


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	if (response.invalidProductIdentifiers != NULL && [response.invalidProductIdentifiers count ] > 0) {
		// send maintaining report to the server side 
		NSLog(@"[ERROR] User got invalid product identifer(s) when requesting Apple store, please check following identifier, %@",response.invalidProductIdentifiers );
		[self debugAlertWithTitle:@"ERROR" message:@"User got invalid product identifer(s) when requesting Apple store, please check following identifier"];
	}
	
	SKProduct *product = [[response products] lastObject];
    if (!product)
    {   
		NSLog(@"[Error] The product request doesn't get a valid product in the response");
		[self debugAlertWithTitle:@"ERROR" message:@"The product request doesn't get a valid product in the response" ];
    }else {
		// Update product information at local(if not free)
		
		// Note, the senderObject seems useless as the object is general used/known to other source code.
		// Q: the problem is how to update gridcell with new information.
		
		// TODO: we will use ModalView or Popup to present product detail, now just an alert button/logging.
		NSLog(@"localizedDescription [%@]\tlocalizedTitle [%@]\tprice [%@]\tpriceLocale [%@]\tproductIdentifier [%@]", product.localizedDescription , product.localizedTitle, product.price, product.priceLocale, product.productIdentifier);
		
		// INFO sample code can be got from 
		// Retrieve the localized price
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:product.priceLocale];
//		NSString *formattedString = [numberFormatter stringFromNumber:product.price];
		[numberFormatter release];

		// Create a description that gives a heads up about
		// a non-consumable purchase

//		NSString *buyString = formattedString;
//		NSString *describeString = [NSString stringWithFormat:@"%@\n\nIf you have already purchased this item, you will not be charged again.", product.localizedDescription];
//		NSArray *buttons = [NSArray arrayWithObject: buyString];
		
		// Offer the user a choice to buy or not buy
//		if ([ModalAlert ask:describeString withCancel:@"No Thanks" withButtons:buttons])
//		{
//			[self startCheckPurchasing];
//			SKPayment *payment = [SKPayment paymentWithProductIdentifier:product.productIdentifier];  //[response.products objectAtIndex:0].productIdentifier];
//			[[SKPaymentQueue defaultQueue] addPayment:payment];
//		}
//		else
//		{
//			// restore the GUI to provide a buy/purchase button
//			// or otherwise to a ready-to-buy state  
//			[self loadingViewData];
//		}
		
		//   ----------- end of sample code 
		
	}
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
	[self debugAlertWithTitle:@"ERROR" message:[@"Request failed, Error: " stringByAppendingString:[error localizedFailureReason] ]];
}

// Q: what if error occurs, I once saw the some doc about not carrying out this method.
- (void)requestDidFinish:(SKRequest *)request {
	// Release the request
    [request release];
    NSLog(@"Request finished.");	
}


//-(BOOL) verifyReceiptAtDeviceSide:(SKPaymentTransaction *)transaction{
//	NSString *receiptStr = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
//	
//	// encode it using base64 encoding, according to "http://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/StoreKitGuide/VerifyingStoreReceipts/VerifyingStoreReceipts.html"
////	[Base64 initialize];
////	NSString *b64EncStr = [Base64 encode:receiptStr];
//	
//	NSData* data=[receiptStr dataUsingEncoding:NSUTF8StringEncoding];
//	NSString *b64EncStr = [ASIHTTPRequest base64forData: data ];
//	
//	
//	NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:b64EncStr, @"receipt-data",nil];
//	
//	NSString *jsonString = [jsonDictionary JSONRepresentation];
//	NSLog(@"string to send: %@",jsonString);
//	
//	// ---------------------
//	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"]];
//	[request setHTTPMethod:@"POST"];
//	[request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//	NSLog(@"will create connection");
//	//[[NSURLConnection alloc] initWithRequest:request delegate:self];
//	
//	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//	[request release ];
//	
//	NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
//    NSInteger responseValue = [responseString integerValue];
//    [responseString release];
//	
//	return (responseValue == 0) ;
//}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
	
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
			value <<= 8;
			
			if (j < length) {
				value |= (0xFF & input[j]);
			}
        }
		
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}


//-(BOOL) verifyReceiptAtServerSide:(SKPaymentTransaction *)transaction{
////	NSString *jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];      
////    NSString *completeString = [NSString stringWithFormat:@"http://localhost:3000/receipt/verify", jsonObjectString];     
////	//TODO: use application preference to allow user to change/specifiy.
////    NSURL *urlForValidation = [NSURL URLWithString:completeString];               
////    NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:urlForValidation];                          
////    [validationRequest setHTTPMethod:@"POST"];             
////    NSData *responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil];  
////    [validationRequest release];
////    NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
////    NSInteger response = [responseString integerValue];
////    [responseString release];
////    return (response == 0);
//	
//	
//	NSString *receiptStr = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
//	
//	// encode it using base64 encoding, according to "http://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/StoreKitGuide/VerifyingStoreReceipts/VerifyingStoreReceipts.html"
//	//[Base64 initialize];
////	NSString *b64EncStr = [Base64 encode:receiptStr];
//	
//	
//	NSData* data=[receiptStr dataUsingEncoding:NSUTF8StringEncoding];
//	NSString *b64EncStr = [ASIHTTPRequest base64forData: data ];
//	
//	NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:b64EncStr, @"receipt-data",nil];
//	
//	NSString *jsonString = [jsonDictionary JSONRepresentation];
//	NSLog(@"string to send: %@",jsonString);
//	
//	// ---------------------
//	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SEVER_VERIFY_RECIPT ]];
//	[request setHTTPMethod:@"POST"];
//	[request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//	NSLog(@"will create connection");
//	//[[NSURLConnection alloc] initWithRequest:request delegate:self];
//	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//	[request release ];
//	
//	NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
//    NSInteger responseValue = [responseString integerValue];
//    [responseString release];
//	
//	return  (responseValue == 0) ;
//}


// REF: http://stackoverflow.com/questions/1298998/verify-receipt-for-in-app-purchase
//-(void) recordTransaction:(SKPaymentTransaction *)transaction {
//	//NSURL *sandboxStoreURL = [[NSURL alloc] initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
//	
//	// INFO: app can either validate the receipt by itself or let server side to 
//	
//	// Device based receipt validation
//	// ------------------------------	
//	BOOL isReceiptVerified = [self verifyReceiptAtDeviceSide:transaction ];
//	if (isReceiptVerified == YES) {
//		//TODO:  unlock product
//	}else {
//		//TODO: deny or do nothing!?
//	}	
//
//	// Sever based receipt validation
//	// ------------------------------	
//	isReceiptVerified = [self verifyReceiptAtServerSide:transaction ];
//	if (isReceiptVerified == YES) {
//		//TODO:unlock product
//	}else {
//		//TODO:deny or do nothing!?
//	}	
//}


- (void)provideContent:(NSString *)productIdentifier {
	
    NSLog(@"Toggling flag for: %@", productIdentifier);
	Material *mat = [Material findByIdentifier:productIdentifier] ;
	
	if (mat != NULL) {
		mat.purchased = YES ;
		[mat save];
	}
		
	// download book with progresss info.
	//TODO: Q: how to update each grid.

    //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:productIdentifier];
	
}

//- (void)completeTransaction:(SKPaymentTransaction *)transaction {
//	
//    NSLog(@"completeTransaction...");
//	
//    [self recordTransaction: transaction];
//    [self provideContent: transaction.payment.productIdentifier];
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//	
//}
//
//- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
//	
//    NSLog(@"restoreTransaction...");
//	
//    [self recordTransaction: transaction];
//    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//	
//}
//
//- (void)failedTransaction:(SKPaymentTransaction *)transaction {
//	
//    if (transaction.error.code != SKErrorPaymentCancelled)
//    {
//        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
//    }
//	
//    //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:transaction];
//	
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//	
//}

// TODO: more implementation according to http://stackoverflow.com/questions/1581246/how-can-my-server-securely-authenticate-iphone-in-app-purchase/1794470#1794470

//-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
//	for (SKPaymentTransaction *transaction in transactions)
//    {
//        switch (transaction.transactionState)
//        {
//            case SKPaymentTransactionStatePurchased:
//                [self completeTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateFailed:
//                [self failedTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateRestored:
//                [self restoreTransaction:transaction];
//            default:
//                break;
//        }
//    }
//}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate method


// ESP.TODO: for the moment, we the unzipped files should be contained in a folder named after the identifier of the material
//- (void)downloadFinished:(ASIHTTPRequest *)request
//{
//
//	//NSString *response = [request responseString];
//	
//	NSDictionary *userInfo = request.userInfo ;
//	
//	Material *mat = [ Material findByIdentifier:[userInfo objectForKey:@"product_identifier"] ];
//	NSLog(@"downloadFinished for material : %@ .... ready to unpack", mat.name ) ;
//	
//	BookShelfColumnGridViewCell *cell = [userInfo objectForKey:@"cell"]  ;
//	
//	// unpack
//	// TODO: remove the objective-Zip and ssziparchive
//	ZipArchive *zip = [[ZipArchive alloc] init];
//	
//	BOOL result;
//	NSString *filePath = mat.contentFullPathAtDevice ;
//	NSString *unZipPath = [filePath stringByDeletingLastPathComponent] ;
//	if ([zip UnzipOpenFile:filePath] ) {
//		
//		result = [zip UnzipFileTo:unZipPath overWrite:YES];//解压文件
//		if (!result) {
//			NSLog(@"unzip fail................");
//		}else {
//			NSLog(@"unzip success............. going to update material info.");
//			mat.downloaded  = YES ;
//			[mat save ] ;
//		}
//		[zip UnzipCloseFile];
//		// remove the activity indicator
//		if ( cell != nil && cell.spinner != nil) {
//			NSLog(@"[debug] ...... going to remove spinner ") ;
//			[cell.spinner removeFromSuperview ];
//			cell.spinner = nil ;
//			// TODO: what else shall I do? A: 
//		}
//		
//	}
//	
//	[self debugAlertWithTitle:@"Info" message:@"The book is fake, going to show demo page...."];
//	
//	if (self.currentProcessingCell != nil ) {
//		[self useMaterial:self.currentProcessingCell ] ;
//	}	
//}
//
//- (void)downloadFailed:(ASIHTTPRequest *)request
//{
//	NSError *error = [request error];
//	NSLog(@"[WARN] Materials download failed.  Error: %@", [error localizedDescription] ) ;
//}

@end
