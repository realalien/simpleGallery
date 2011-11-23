
/*
 * ImageDemoGridViewCell.m
 * Classes
 * 
 * Created by Jim Dovey on 17/4/2010.
 * 
 * Copyright (c) 2010 Jim Dovey
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

//
//  BookShelfColumnGridViewCell.m
//  Milestones
//
//  Created by GuZhenZhen on 6/28/11.
//  Copyright 2011 Spicyhorse Studio. All rights reserved.
//

// NOTES: for the cell imageview shadow, please refer to th example code of SpringBoard (of AQGridView source)

#import "BookShelfColumnGridViewCell.h"
#import "QuartzCore/CALayer.h"
#import "UIKit/UIDevice.h"

@implementation BookShelfColumnGridViewCell

@synthesize material ;
@synthesize bookTitle ;
@synthesize spinner ;

@synthesize container=_container;
@synthesize imageView=_imageView ;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    //_container = [[UIView alloc] initWithFrame: CGRectMake( 0 , 0, 300.0, 200.0) ];
   // _imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		_imageView = [[UIImageView alloc] initWithFrame: CGRectMake( 0 , 0, 250.0, 180.5)];
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		_imageView = [[UIImageView alloc] initWithFrame: CGRectMake( 0 , 0, 160.0, 120.0)];
	}
	
	//_bookTitle = [[UITextField alloc] initWithFrame: CGRectMake( 0 , 0, 50.0, 20.0) ];  //   
	// add shadow
	//UIImage *bgImage = [UIImage imageNamed:@"embedded_bg.png"];
	//_container.backgroundColor = [UIColor colorWithPatternImage:bgImage];
	
	 //[_container addSubview:_imageView];
//	_imageView.center = _container.center;
//	
	
	_imageView.backgroundColor = [UIColor clearColor];
    _imageView.opaque = NO;
	_imageView.layer.shadowColor = [UIColor blackColor].CGColor;
	_imageView.layer.shadowOffset = CGSizeMake(0, 5);
	_imageView.layer.shadowOpacity = 0.3;
	_imageView.layer.shadowRadius = 2.0;
	_imageView.clipsToBounds = NO;
	
	// TODO: temp nasty solution, fixme: hard coded.
	UIBezierPath *path ;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		path = [UIBezierPath bezierPathWithRect: _imageView.bounds];  // 
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		path = [UIBezierPath bezierPathWithRect: CGRectMake( 0 , 0, 130.0, 95.0)];  // _imageView.bounds
	}

	_imageView.layer.shadowPath = path.CGPath;
	
	[self.contentView addSubview: _imageView];
	//[self.contentView addSubview:_container];
	self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView.opaque = NO;
    self.opaque = NO;
    
    self.selectionStyle = AQGridViewCellSelectionStyleNone;
	
	
//	NSLog(@"Debugging UI.......");
//	
//	NSLog(@"%@", _imageView) ;
//	_container.layer.borderColor = [UIColor greenColor].CGColor;
//	_container.layer.borderWidth = 1.0;
//	_imageView.layer.borderColor = [UIColor redColor].CGColor;
//	_imageView.layer.borderWidth = 1.0;
//	self.layer.borderColor = [UIColor blueColor].CGColor;
//	self.layer.borderWidth = 1.0;
	
	[_container release];
	[_imageView release];
	//[self.contentView addSubview: _bookTitle];
    

	
    return ( self );
}

- (void) dealloc
{
    [_imageView release];
	//[_bookTitle release];
    [super dealloc];
}

- (CALayer *) glowSelectionLayer
{
    return ( _imageView.layer );
}

- (UIImage *) image
{
    return ( _imageView.image );
}

- (void) setImage: (UIImage *) anImage
{
    _imageView.image = anImage;
    [self setNeedsLayout];
}

- (void) setBookTitle:(NSString *)aBookTitle{
	_bookTitle.text = aBookTitle ;
}

- (NSString *) bookTitle:(NSString *)bookTitle{
	return _bookTitle.text ;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = _imageView.image.size;
	NSLog(@"CGSize  width, height are  %f, %f  ", imageSize.width, imageSize.height) ;
    CGRect aframe = _imageView.frame;
	NSLog(@"frame  point, size  ,  %f, %f  ",  aframe.size.width, aframe.size.height) ;  //frame.origin,
	
	NSLog(@"gridcell  point, size  ,  %f, %f  ",  self.frame.size.width, self.frame.size.height) ;  //frame.origin,

    CGRect abounds = self.contentView.bounds;
    NSLog(@"bounds of contentView is   point, size    %f, %f  ", abounds.size.width, abounds.size.height) ;  //bounds.origin,
	
//    if ( (imageSize.width <= abounds.size.width) &&
//		(imageSize.height <= abounds.size.height) )
//    {
////		// TODO: question, the _imageView.frame  seem not set. I don't know why.
//	    aframe.size.width = imageSize.width ;
//		aframe.size.height = imageSize.height ;
//		aframe.origin.x = floorf((abounds.size.width - aframe.size.width) * 0.5);
//		aframe.origin.y = floorf((abounds.size.height - aframe.size.height) * 0.5);
//		_imageView.frame = aframe;
////				
////		// set the book title location , alignment, etc.
//////		CGRect textFrame = _bookTitle.frame ;
//////		textFrame.origin.x = floorf(( bounds.size.width  - textFrame.size.width ) * 0.5);
//////		textFrame.origin.y = floorf((   bounds.size.height - textFrame.size.height )   );  //- frame.size.height    ;  bounds.size.height - textFrame.size.height
////////		CGSize textSize = _bookTitle.size ;
////////		textFrame.width = textSize.width ;
////////		textFrame.height = textSize.height ;
//////		
//////		_bookTitle.frame = textFrame ;
////		
//////		NSLog(@"origin of textFrame is , %f,  %f  ", textFrame.origin.x,textFrame.origin.y  ) ;
//////		NSLog(@"textFrame.size        %f,  %f  ", textFrame.size.width ,textFrame.size.height ) ;
//        return;
//    } else {
		// TODO, handle the over size the book cover with book title.
		
		// scale it down to fit
		
		CGFloat hRatio = (abounds.size.width  - 20 )/ imageSize.width;
		CGFloat vRatio = (abounds.size.height - 20 )/ imageSize.height;
		//CGFloat ratio = MAX(hRatio, vRatio);
		CGFloat resizeRatio = MIN(hRatio, vRatio);
		
		//	CGFloat hRatio =  imageSize.width / bounds.size.width;
		//    CGFloat vRatio =  imageSize.height  / bounds.size.height;
		//    CGFloat ratio = MIN(hRatio, vRatio);
	    
		aframe.size.width = floorf(imageSize.width * resizeRatio) ;
		aframe.size.height = floorf(imageSize.height * resizeRatio) ;
		aframe.origin.x = floorf((abounds.size.width - aframe.size.width) * 0.5);
		aframe.origin.y = floorf((abounds.size.height - aframe.size.height) * 0.5);
		_imageView.frame = aframe;
		//[_imageView sizeToFit];  // Q: what it actually does? To what size it will fit? A:
		
//	}
		//TODO: remove me: debug code

	
}

#pragma mark -
#pragma mark ASIProgressDelegate method


- (void)setProgress:(float)newProgress {
	
//	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//	//从持久化里面取出内容的总大小

	_bookTitle.text = [NSString stringWithFormat:@"%f", newProgress ];
//	self.contentLength = [[userDefaults objectForKey:[NSString stringWithFormat:@"book_%d_contentLength",bookID]] floatValue];
//	//设置进度文本
//	downText.text = [NSString stringWithFormat:@"%.2f/%.2fM",self.contentLength*newProgress,self.contentLength];
//	//设置自己的进度条
//	imageProView.frame = CGRectMake(75, 121, 150*newProgress, 4);
//	//设置系统的进度条
//	zztjProView.progress = newProgress;
}


@end
