/*
 *  Constants.h
 *  Milestones
 *
 *  Created by GuZhenZhen on 6/23/11.
 *  Copyright 2011 Spicyhorse Studio. All rights reserved.
 *
 */

#import "UIKit/UIDevice.h"


//#define BOOKS_NUMBER_ON_EACH_SHELF 3   // 6 for ipad, 3 for iphone, moved to BookShelfManager instance variable
//#define COVERS_IN_TOTAL  25   // temp

enum SceneDepth{
	kTagPageBackground ,
	kTagLevelOfBookCover
	
}  ;

enum ResourceRepo {
	kTagBackground = 2,
	kTagBackgroundBacktress,
	kTagBookCover  
}  ;