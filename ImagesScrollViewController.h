//
//  ImagesScrollViewController.h
//  SimpleGallery
//
//  Created by anynomous on 11/28/11.
//  Copyright 2011 companyName. All rights reserved.
//

#import <UIKit/UIKit.h>

// NOTE: some code are borrowed from 'PageControl' example code.
@interface ImagesScrollViewController : UIViewController <UIScrollViewDelegate> {

	UIScrollView* scrollView;
	
	NSMutableArray *viewControllers;   // a image detail view's controller
	
	
	
	// NOTE:TODO: copied from , 
	// TODO: need decided by design.
	BOOL isAutoSlideShow;
	
	//UIImage *theImage;
	
	//IBOutlet UIScrollView *imageScrollView;
	//IBOutlet UIImageView *artView;
	IBOutlet UIButton *shareSocially;
	IBOutlet UIButton *returnToGridView;
	IBOutlet UIButton *saveToCameraRoll;
	IBOutlet UIButton *setAutoSliding;
	
	IBOutlet UIToolbar *sliderToolbar;
	
	
	BOOL imageSwipeControlledByHuman;
	
	
	NSTimer *autoHideControlButtonsTimer;
	NSTimer *autoSlideShowTimer;
	
}

-(IBAction) shareSocially:(id)sender;
-(IBAction) saveToCameraRoll:(id)sender;
-(IBAction) returnToGridView:(id)sender;
-(IBAction) setAutoSlideshow:(id)sender;


@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;


- (void)loadScrollViewWithPage:(int)page;
@end
