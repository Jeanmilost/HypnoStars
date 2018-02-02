/**
* HypnoStarsAppDelegate.h
* HypnoStars
*
* Created by Jean-Milost Reymond on 05.04.10.
* Copyright 2010 Jean-Milost Reymond. All rights reserved.
*/

#import <UIKit/UIKit.h>

@class EAGLView;

@interface HypnoStarsAppDelegate : NSObject<UIApplicationDelegate>
{
    UIWindow* window;
    EAGLView* glView;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet EAGLView* glView;

@end
