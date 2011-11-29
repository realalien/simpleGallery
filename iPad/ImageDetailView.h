//
//  ImageDetailView.h
//  MarksArtBookI
//
//  Created by anonymous on 11/18/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHK.h"
#import "TapDetectingImageView.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

@interface ImageDetailView : UIViewController<UIScrollViewDelegate> {  // TapDetectingImageViewDelegate

	int artPageNumber;
	
	BOOL isAutoSlideShow;
	
	//UIImage *theImage;
	
	IBOutlet UIScrollView *imageScrollView;
	IBOutlet UIImageView *artView;
	IBOutlet UIButton *shareSocially;
	IBOutlet UIButton *returnToGridView;
	IBOutlet UIButton *saveToCameraRoll;
	IBOutlet UIButton *setAutoSliding;
	
	IBOutlet UIToolbar *sliderToolbar;
	
	
	// slide show control
	
	
	NSTimer *autoHideControlButtonsTimer;
	NSTimer *autoSlideShowTimer;
	
	
	// swipe experiment
	UISwipeGestureRecognizer *leftSwipeRecog;
	UISwipeGestureRecognizer *rightSwipeRecog;
}

//@property(nonatomic,retain) UIImage *theImage;
@property(nonatomic,retain) IBOutlet UIImageView *artView;
@property(nonatomic,retain)	IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) NSTimer * autoHideControlButtonsTimer;


-(IBAction) shareSocially:(id)sender;
-(IBAction) saveToCameraRoll:(id)sender;
-(IBAction) returnToGridView:(id)sender;

// slide show control
-(IBAction) showPrev:(id)sender;
-(IBAction) showNext:(id)sender;
-(IBAction) setAutoSlideshow:(id)sender;

-(void) setImageTo:(int)imageID ;
-(void) showNextArt ;

//-(void)pickImageNamed:(UIImage*)image;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

- (id)initWithPageNumber:(int)page;
@end
