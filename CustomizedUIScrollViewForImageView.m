    //
//  CustomizedUIScrollViewForImageView.m
//  companyNameGallary
//
//  Created by anonymous on 11/22/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import "CustomizedUIScrollViewForImageView.h"


@implementation CustomizedUIScrollViewForImageView

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithFrame:(CGRect)frame{
	return [super initWithFrame:frame];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.nextResponder touchesBegan:touches withEvent:event];
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {	
	// If not dragging, send event to next responder
	if (!self.dragging) 
		[self.nextResponder touchesEnded: touches withEvent:event]; 
	else
		[super touchesEnded: touches withEvent: event];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (interfaceOrientation ==  UIInterfaceOrientationLandscapeLeft  
			|| interfaceOrientation ==  UIInterfaceOrientationLandscapeRight );
}


- (void)dealloc {
    [super dealloc];
}


@end
