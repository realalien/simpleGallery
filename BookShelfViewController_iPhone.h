//
//  BookShelfViewController_iPhone.h
//  MarksArtBookI
//
//  Created by anonymous on 11/15/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentController.h"

@interface BookShelfViewController_iPhone : UIViewController {
	ContentController *contentController;
}

@property (nonatomic, retain) IBOutlet ContentController *contentController;

@end
