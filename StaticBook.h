//
//  StaticBook.h
//  Milestones
//
//  Created by GuZhenZhen on 6/24/11.
//  Copyright 2011 Spicyhorse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StaticBook : NSObject {

	NSString *title;		// main title
	NSString *subtitle;		// sub title
	NSString *resourceName;	// the physical entity on the disk, supposing a proprietary format file for the book
							// NOTE: 
	int pages ;				// total pages
}

@property(retain) NSString *title ;
@property(retain) NSString *subtitle ;
@property(retain) NSString *resourceName ;
@property int pages ;


-(id)initWithName:(NSString *)bookname andResourceName:(NSString *)fileName  ;

@end
