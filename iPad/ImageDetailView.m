    //
//  ImageDetailView.m
//  MarksArtBookI
//
//  Created by anonymous on 11/18/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import "ImageDetailView.h"
#import "BookShelfManager.h"
#import "AppDelegate_iPad.h"
#import "CustomizedUIScrollViewForImageView.h"

@implementation ImageDetailView
//@synthesize theImage;
@synthesize imageScrollView;
@synthesize artView;
@synthesize autoHideControlButtonsTimer;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.


- (id)initWithPageNumber:(int)page
{
    
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		if  ((self = [super initWithNibName:@"ImageDetailView_iPad" bundle:nil]))
		{		
			artPageNumber = page;		
			
		}
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		if  ((self = [super initWithNibName:@"ImageDetailView_iPhone" bundle:nil]))
		{		
			artPageNumber = page;		
			
		}		
	}
	
	

    return self;
}


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization.
//
//    }
//    return self;
//} 


-(BOOL) canBecomeFirstResponder {
	return YES;
}

//- (void)loadView {
//	
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	int theArtId = artPageNumber ; //[BookShelfManager sharedInstance].currentProcessingImageID ;   //  = 2 //(for debugging)
	NSLog(@"(Material *)[[[BookShelfManager sharedInstance] allMaterials] objectAtIndex:theArtId] is %@", [[[BookShelfManager sharedInstance] allMaterials] objectAtIndex:theArtId]);
	NSString *fileName = ((Material *)[[[BookShelfManager sharedInstance] allMaterials] objectAtIndex:theArtId]).contentFullPathAtDevice;

	UIImage *image = [UIImage imageNamed:[fileName lastPathComponent]];
	//self.theImage = image;
	if (image != nil) {
		[self.artView setImage:image];
		[image release];
		[self.artView setUserInteractionEnabled:YES];
	}

	// NOTE: copied code from RootViewController
	// first remove previous image view, if any
  
	
	// NOTE: uncomment if use TapDetectingImageViewDelegate
	// [self pickImageNamed:image];
	
	
	self.imageScrollView.contentSize = imageScrollView.bounds.size; // image.size;
	NSLog(@" imageScrollView  content Size is   (%f, %f)", imageScrollView.contentSize.width, imageScrollView.contentSize.height);
	NSLog(@" imageScrollView   bounds   is  (%f, %f)", imageScrollView.bounds.size.width, imageScrollView.bounds.size.height);
	
    self.imageScrollView.minimumZoomScale = 0.2;
    self.imageScrollView.maximumZoomScale = 4.0;
    self.imageScrollView.bounces = NO;
    self.imageScrollView.delegate = self;
	self.imageScrollView.userInteractionEnabled = YES;
	self.imageScrollView.multipleTouchEnabled = YES;
	self.imageScrollView.canCancelContentTouches = NO;
	self.imageScrollView.delaysContentTouches = YES;
//  self.imageScrollView.delegate = self ;
	
	
	// uiview touch event handling
	self.artView.userInteractionEnabled = YES;
	self.artView.multipleTouchEnabled = YES;

	// set timer to hide the control buttons.
	autoHideControlButtonsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
																   target:self
																 selector:@selector(hideControlResetTimer)
																 userInfo:nil
																  repeats:NO];
	
	// swipe recognizers
	leftSwipeRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPrevArt)];
    [leftSwipeRecog setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:leftSwipeRecog];
    [leftSwipeRecog release];
	
    rightSwipeRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextArt)];
    [rightSwipeRecog setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:rightSwipeRecog];
    [rightSwipeRecog release];
	
	
    [super viewDidLoad];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    //return YES;
	return (interfaceOrientation ==  UIInterfaceOrientationLandscapeLeft  
			|| interfaceOrientation ==  UIInterfaceOrientationLandscapeRight );
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[theImage release];
	[artView release];
	
	[autoHideControlButtonsTimer release];
    [super dealloc];
}

#pragma mark -
#pragma mark IBAction

// NOTE: for more issues, remember to check 

// TODO:  twitter auth problem, http://jayrparro.posterous.com/incorrect-signature-sharekittwitter-error
// DONE: quick fix of acitivity indicator orientation, see: https://github.com/simonmaddox/ShareKit/commit/e2587fc6d5ab2ff234584dfe10f258aea213783e#diff-0
-(IBAction) shareSocially:(id)sender{	
	//code example http://getsharekit.com/docs/#image
	NSMutableArray *shelf = [[BookShelfManager sharedInstance] allMaterials];
	NSString *name = ((Material *)[shelf objectAtIndex: [BookShelfManager sharedInstance].currentProcessingImageID]).name;
	UIImage *image = [UIImage imageNamed:name];
	SHKItem *item = [SHKItem image:image title:@"Look at this picture!"];
		
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	//AppDelegate_iPad *delegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	//[delegate.navController popViewControllerAnimated:YES];
	//[actionSheet showFromToolbar:delegate.navController.toolbar];
	[actionSheet showInView:self.view]; 
}

-(IBAction) saveToCameraRoll:(id)sender{
	NSMutableArray *shelf = [[BookShelfManager sharedInstance] allMaterials];
	NSString *filepath = ((Material *)[shelf objectAtIndex: [BookShelfManager sharedInstance].currentProcessingImageID]).coverFullPathAtDevice;
	NSString *name = ((Material *)[shelf objectAtIndex: [BookShelfManager sharedInstance].currentProcessingImageID]).name;
	
	NSLog(@"saveToCameraRoll  .....%@, %@", filepath, name);
	UIImage *img = [UIImage imageNamed:name ];  
	
	// Request to save the image to camera roll
	UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	
}

// TODO: more attractive animation detail.
-(IBAction) returnToGridView:(id)sender{
	AppDelegate_iPad *delegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	[delegate.navController popViewControllerAnimated:YES];
}


-(IBAction) showPrev:(id)sender{
	[BookShelfManager sharedInstance].currentProcessingImageID -=1;
	int theArtId = [BookShelfManager sharedInstance].currentProcessingImageID ;
	
	if (theArtId == -1 ) { 
		[BookShelfManager sharedInstance].currentProcessingImageID = theArtId = [[[BookShelfManager sharedInstance] allMaterials]count] -1;
	}
	
	[self setImageTo:theArtId];
	
}
-(IBAction) showNext:(id)sender{
	[BookShelfManager sharedInstance].currentProcessingImageID +=1;
	int theArtId = [BookShelfManager sharedInstance].currentProcessingImageID ;
	
	if (theArtId == [[[BookShelfManager sharedInstance] allMaterials]count]) { 
		[BookShelfManager sharedInstance].currentProcessingImageID = theArtId = 0;
	}
	
	[self setImageTo:theArtId];
}


-(void) setImageTo:(int)imageID {
	NSLog(@"(Material *)[[[BookShelfManager sharedInstance] allMaterials] objectAtIndex:theArtId] is %@", [[[BookShelfManager sharedInstance] allMaterials] objectAtIndex:imageID]);
	NSString *fileName = ((Material *)[[[BookShelfManager sharedInstance] allMaterials] objectAtIndex:imageID]).contentFullPathAtDevice;
	
	// ESP, this can't be done, otherwise crashes, Q: why? A:
	//	if (self.artView.image != nil) {
	//		[self.artView.image release];
	//	}
	
	// TODO: more on resize uiimageview
	// http://stackoverflow.com/questions/1083438/multiple-setting-of-the-image-for-uiimageview
	NSLog(@"fileName   is %@", [fileName lastPathComponent]);
	
	
	UIImage *image = [UIImage imageNamed:[fileName lastPathComponent]];
	if (image != nil) {
		
		// NOTE: uncomment if use TapDetectingImageViewDelegate
		//[self pickImageNamed:image];
		
		// reset imageScrollView zoom factor
		self.imageScrollView.zoomScale = 1.0;
		
		self.artView.image = image;  // deprecated, see pickImageNamed
		[image release];
		[self.artView setUserInteractionEnabled:YES];
		//[self.artView sizeToFit]; // NOTE: do NOT turn it on until you know what will happen.
	}
	
}

#pragma mark -
#pragma mark callback 
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Error"
								   message: [NSString stringWithFormat:@"Can't save the image, sorry!  Description: %@", [error localizedDescription]]
								  delegate: self
						 cancelButtonTitle: @"OK"
						 otherButtonTitles: nil];
		[alert show];
		[alert release];		
    }
    else  // No errors
    {
		// Show message image successfully saved
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Information"
								   message: [NSString stringWithFormat:@"Art work saved to camera roll."]
								  delegate: self
						 cancelButtonTitle: @"OK"
						 otherButtonTitles: nil];
		[alert show];
		[alert release];
    }
}

-(void)hideControlResetTimer {
	shareSocially.hidden = YES;
	returnToGridView.hidden = YES;
	saveToCameraRoll.hidden = YES;
	//sliderToolbar.hidden = YES;
	setAutoSliding.hidden = YES;
	
	autoHideControlButtonsTimer = nil;
}



#pragma mark -
#pragma mark TouchEvent handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// no matter if timer existes or not, always should controls, TODO: duplicated code,
	NSLog(@"touchesBegan  detected.");
	shareSocially.hidden = NO;
	returnToGridView.hidden = NO;
	saveToCameraRoll.hidden = NO;
	//sliderToolbar.hidden = NO;
	setAutoSliding.hidden = NO;
	
	// recreate the auto hider timer if not presented	
	if (autoHideControlButtonsTimer == nil) {
		autoHideControlButtonsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
																	   target:self
																	 selector:@selector(hideControlResetTimer)
																	 userInfo:nil
																	  repeats:NO];
	}else {
		// if timer exisis, buttons should set
	}

}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{
	// Process the single tap here
	NSLog(@"touchesEnded  SINGLE TAP detected.");
	shareSocially.hidden = NO;
	returnToGridView.hidden = NO;
	saveToCameraRoll.hidden = NO;
	setAutoSliding.hidden = NO;
	//sliderToolbar.hidden = NO;
}


//– touchesMoved:withEvent:
//– touchesEnded:withEvent:
//– touchesCancelled:withEvent:

// TOOD: add time picker 
// TODO: replace button text, and save to config
-(IBAction) setAutoSlideshow:(id)sender{
	if (autoSlideShowTimer) {  
		[autoSlideShowTimer invalidate];
	}else {
		autoSlideShowTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
															  target:self
															selector:@selector(showNextArt)
															userInfo:nil
															 repeats:YES];

	}
	isAutoSlideShow = !isAutoSlideShow;
	NSLog(@"isAutoSlideShow    is   %@", isAutoSlideShow? @"ON": @"OFF");

}


// TODO: refactor, duplicated code from IBAction code.
-(void) showNextArt {
	[BookShelfManager sharedInstance].currentProcessingImageID +=1;
	int theArtId = [BookShelfManager sharedInstance].currentProcessingImageID ;
	
	if (theArtId == [[[BookShelfManager sharedInstance]allMaterials]count]) { 
		[BookShelfManager sharedInstance].currentProcessingImageID = theArtId = 0;
	}
	
	[self setImageTo:theArtId];
}


-(void) showPrevArt {
	[BookShelfManager sharedInstance].currentProcessingImageID -=1;
	int theArtId = [BookShelfManager sharedInstance].currentProcessingImageID ;
	
	if (theArtId == -1 ) { 
		[BookShelfManager sharedInstance].currentProcessingImageID = theArtId = [[[BookShelfManager sharedInstance]allMaterials]count] -1;
	}
	
	[self setImageTo:theArtId];
}


#pragma mark -
#pragma mark UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.artView;
}

// Code example of centering image when zooming out, 
// REF.http://stackoverflow.com/questions/5834312/center-an-uiimageview-on-the-screen-when-zoom-out
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	// center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.imageScrollView.bounds.size;
    CGRect frameToCenter = self.artView.frame;
	
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
    {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
	
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) 
    {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
	
    self.artView.frame = frameToCenter;
}


/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}
//
//#pragma mark TapDetectingImageViewDelegate methods
//
//- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
//    // Single tap shows or hides drawer of thumbnails.
//	NSLog(@"tapDetectingImageView  .... gotSingleTapAtPoint");
////    [self toggleThumbView];
//	
//	[self touchesBegan:nil withEvent:nil];
//}
//
//- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
//    // double tap zooms in
//    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
//    [imageScrollView zoomToRect:zoomRect animated:YES];
//	NSLog(@"tapDetectingImageView  .... gotDoubleTapAtPoint");
//}
//
//- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
//    // two-finger tap zooms out
//    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
//    [imageScrollView zoomToRect:zoomRect animated:YES];
//	NSLog(@"tapDetectingImageView  .... gotTwoFingerTapAtPoint");
//}
//
//
//#pragma mark -
//#pragma mark View handling methods
//-(void)pickImageNamed:(UIImage*)image{
//	[[imageScrollView viewWithTag:ZOOM_VIEW_TAG] removeFromSuperview];
//	
//	//    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]];
//    TapDetectingImageView *zoomView = [[TapDetectingImageView alloc] initWithImage:image];
//    [zoomView setDelegate:self];
//    [zoomView setTag:ZOOM_VIEW_TAG];
//    [imageScrollView addSubview:zoomView];
//    [imageScrollView setContentSize:[zoomView frame].size];
//    [zoomView release];
//	
//    // choose minimum scale so image width fits screen
//    float minScale  = [imageScrollView frame].size.width  / [zoomView frame].size.width;
//    [imageScrollView setMinimumZoomScale:minScale];
//    [imageScrollView setZoomScale:minScale];
//    [imageScrollView setContentOffset:CGPointZero];
//}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end
