//
//  StaticBook.m
//  Milestones
//
//  Created by GuZhenZhen on 6/24/11.
//  Copyright 2011 Spicyhorse Studio. All rights reserved.
//

#import "StaticBook.h"


@implementation StaticBook

@synthesize title ;
@synthesize subtitle ;
@synthesize resourceName ;
@synthesize pages ;


- (id) init {
	self = [super init]; 
	if (self != nil){
	} 
	return(self);
}


-(id)initWithName:(NSString *)bookname andResourceName:(NSString *)fileName  {
	
	if ((self = [super init]))
    {
		self.title  = bookname ;
		self.resourceName  = fileName ;
    }
    return self;
}


-(void) dealloc {
	[title release ];
	[resourceName release ];
	
	[super dealloc] ;
}

@end
