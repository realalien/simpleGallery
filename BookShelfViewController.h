//
//  BookShelfViewController.h
//  Milestones
//
//  Created by GuZhenZhen on 6/27/11.
//  Copyright 2011 Spicyhorse Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentController.h"


@interface BookShelfViewController : UIViewController {
	ContentController *contentController;
}

@property (nonatomic, retain) IBOutlet ContentController *contentController;



@end
