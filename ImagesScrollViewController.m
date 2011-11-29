    //
//  ImagesScrollViewController.m
//  SimpleGallery
//
//  Created by anonymous on 11/28/11.
//  Copyright 2011 comanyName. All rights reserved.
//

#import "ImagesScrollViewController.h"
#import "MyViewController.h"
#import "BookShelfManager.h"
#import "SHK.h"
#import "AppDelegate_iPad.h"

@implementation ImagesScrollViewController

@synthesize scrollView, viewControllers;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		
		// view controllers are created lazily
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *controllers = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < 20; i++)
		{
			[controllers addObject:[NSNull null]];
		}
		self.viewControllers = controllers;
		[controllers release];
		
	
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
    [super viewDidLoad];
	
	imageSwipeControlledByHuman = NO;
	scrollView.pagingEnabled = YES;
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 20, scrollView.frame.size.height);
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.scrollsToTop = NO;
	scrollView.delegate = self;

	// pages are created on demand
	// load the visible page and load the page on either side to avoid flashes when the user starts scrolling
	// TODO: code smells bad.
	[BookShelfManager sharedInstance].currentProcessingImageID =  [BookShelfManager sharedInstance].targetImageID - 1;
	NSLog(@"[BookShelfManager sharedInstance].currentProcessingImageID  is  [ %d ]", [BookShelfManager sharedInstance].currentProcessingImageID);
	[self loadScrollViewWithPage:[BookShelfManager sharedInstance].currentProcessingImageID ];
	
	[BookShelfManager sharedInstance].currentProcessingImageID =  [BookShelfManager sharedInstance].targetImageID ;
	[self loadScrollViewWithPage:[BookShelfManager sharedInstance].currentProcessingImageID ];
	
	[BookShelfManager sharedInstance].currentProcessingImageID =  [BookShelfManager sharedInstance].targetImageID + 1;
	[self loadScrollViewWithPage:[BookShelfManager sharedInstance].currentProcessingImageID ];
	
	
	float xOffset = (([BookShelfManager sharedInstance].targetImageID ) * self.view.bounds.size.width);
	NSLog(@"xOffset when loading page [ %d ] is calculated for [ %f ]", [BookShelfManager sharedInstance].currentProcessingImageID,xOffset);
	CGPoint offset = CGPointMake(xOffset , 0) ;
	[scrollView setContentOffset:offset  animated:YES];
	
	imageSwipeControlledByHuman = YES;	  // TODO: still need tuning?
	
	//[self loadScrollViewWithPage:0];
	//[self loadScrollViewWithPage:1];
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[scrollView release];
	[viewControllers release];
    [super dealloc];
}


#pragma mark -
#pragma mark Utilities
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= 20)
        return;
	
	NSLog(@"loading .... %d", page);
    
    // replace the placeholder if necessary
    MyViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[MyViewController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
        
        //NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        //controller.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
		//controller.numberImage.image = [UIImage imageNamed:@"thumbPG1.jpg"];
        //controller.numberTitle.text = @"thumb";
    }
}


- (void)unloadScrollViewWithPage:(int)page
{
	
    if (page < 0)
        return;
    if (page >= 20)
        return;
	
	//NSLog(@"un ... loading .... %d", page);
	
	if (page >= [viewControllers count]) {
		return ;
	}
    
    // replace the placeholder if necessary
    MyViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]){
		// do nothing as it's empty
	}else {
		//[viewControllers removeObjectAtIndex:page] ;
		[controller.view removeFromSuperview];
        [viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
		// TODO: anything else? 
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (! imageSwipeControlledByHuman)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    // pageControl.currentPage = page;
    
	[BookShelfManager sharedInstance].currentProcessingImageID = page;
	
	NSLog(@"scroll did scrolling,  page for indexing is %d", page);
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
	// ESP.
	[self unloadScrollViewWithPage:page - 2];
	[self unloadScrollViewWithPage:page + 2];	
	// TODO: anything else? Try to get some info from some profiling tool!
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


-(IBAction) setAutoSlideshow:(id)sender{
	if (autoSlideShowTimer) {  
		[autoSlideShowTimer invalidate];
	}else {
		autoSlideShowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
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
	[BookShelfManager sharedInstance].targetImageID +=1;
	int theArtId = [BookShelfManager sharedInstance].targetImageID ;
	
	NSLog(@"In showNextArt, theArtId  is  [ %d ]",theArtId);
	if (theArtId == [[[BookShelfManager sharedInstance]allMaterials]count]) { 
		[BookShelfManager sharedInstance].targetImageID = theArtId = 0;
		CGPoint offset = CGPointMake( -self.scrollView.bounds.size.width * ( [[[BookShelfManager sharedInstance]allMaterials]count] - 1 )  , 0) ;
		[scrollView setContentOffset:offset animated:YES];
		
	}else {
		// shift one view.
		NSLog(@"self.view.bounds.size.width   (%f, %f)", self.view.bounds.size.width, self.view.bounds.size.height);
		CGPoint offset = CGPointMake( self.view.bounds.size.width * [BookShelfManager sharedInstance].targetImageID , 0) ;
		[scrollView setContentOffset:offset animated:YES];
	}

	

}


-(void) showPrevArt {
	[BookShelfManager sharedInstance].targetImageID -=1;
	int theArtId = [BookShelfManager sharedInstance].targetImageID ;
	
	if (theArtId == -1 ) { 
		
	}else {
		CGPoint offset = CGPointMake( - self.view.bounds.size.width , 0) ;
		[scrollView setContentOffset:offset animated:YES];
	}
	//[BookShelfManager sharedInstance].currentProcessingImageID = theArtId = [[[BookShelfManager sharedInstance]allMaterials]count] -1;
	//[self setImageTo:theArtId];
	
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


@end
