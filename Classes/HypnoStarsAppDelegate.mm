/**
* HypnoStarsAppDelegate.mm
* HypnoStars
*
* Created by Jean-Milost Reymond on 05.04.10.
* Copyright 2010 Jean-Milost Reymond. All rights reserved.
*/

#import "HypnoStarsAppDelegate.h"
#import "EAGLView.h"

//------------------------------------------------------------------------------
#define M_App_DisplayBar_Enabled @"App_DisplayBar_Enabled"
#define M_App_Background_R       @"App_Background_R"
#define M_App_Background_G       @"App_Background_G"
#define M_App_Background_B       @"App_Background_B"
#define M_App_Stars_R            @"App_Stars_R"
#define M_App_Stars_G            @"App_Stars_G"
#define M_App_Stars_B            @"App_Stars_B"
#define M_App_Stars_Velocity     @"App_Stars_Velocity"
#define M_App_Stars_Rotation     @"App_Stars_Rotation"
#define M_App_Stars_Quantity     @"App_Stars_Quantity"
//------------------------------------------------------------------------------
// class HypnoStarsAppDelegate - objective c
//------------------------------------------------------------------------------
@implementation HypnoStarsAppDelegate
//------------------------------------------------------------------------------
@synthesize window;
@synthesize glView;
//------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(UIApplication*)application
{
	@try
	{
		NSUserDefaults* pDefaults = [NSUserDefaults standardUserDefaults];

		objc_object* pTestValue = [pDefaults objectForKey: M_App_Background_R];

		if (pTestValue == nil)
		{
			// no default values have been set, create them here based on what's in our Settings bundle info
			NSString* pPathStr                = [[NSBundle mainBundle] bundlePath];
			NSString* pSettingsBundlePath     = [pPathStr stringByAppendingPathComponent: @"Settings.bundle"];
			NSString* pFinalPath              = [pSettingsBundlePath stringByAppendingPathComponent: @"Root.plist"];
			
			NSDictionary* pSettingsDict       = [NSDictionary dictionaryWithContentsOfFile: pFinalPath];
			NSArray*      pPrefSpecifierArray = [pSettingsDict objectForKey: @"PreferenceSpecifiers"];
			
			NSNumber*     pDefShowStatusBar;
			NSNumber*     pDefBackgroundColor_R;
			NSNumber*     pDefBackgroundColor_G;
			NSNumber*     pDefBackgroundColor_B;
			NSNumber*     pDefStarsColor_R;
			NSNumber*     pDefStarsColor_G;
			NSNumber*     pDefStarsColor_B;
			NSNumber*     pDefStarsVelocity;
			NSNumber*     pDefStarsRotation;
			NSNumber*     pDefStarsQuantity;
			NSDictionary* pPrefItem;
			
			for (pPrefItem in pPrefSpecifierArray)
			{
				NSString* pKeyValueStr = [pPrefItem objectForKey: @"Key"];
				id        defaultValue = [pPrefItem objectForKey: @"DefaultValue"];
				
				if ([pKeyValueStr isEqualToString: M_App_DisplayBar_Enabled])
					pDefShowStatusBar = defaultValue;
				else
				if ([pKeyValueStr isEqualToString: M_App_Background_R])
					pDefBackgroundColor_R = defaultValue;
				else
				if ([pKeyValueStr isEqualToString: M_App_Background_G])
					pDefBackgroundColor_G = defaultValue;
				else
				if ([pKeyValueStr isEqualToString: M_App_Background_B])
					pDefBackgroundColor_B = defaultValue;
				else
				if ([pKeyValueStr isEqualToString: M_App_Stars_R])
					pDefStarsColor_R = defaultValue;
				else
			    if ([pKeyValueStr isEqualToString: M_App_Stars_G])
					pDefStarsColor_G = defaultValue;
				else
				if ([pKeyValueStr isEqualToString: M_App_Stars_B])
					pDefStarsColor_B = defaultValue;
				else
				if ([pKeyValueStr isEqualToString: M_App_Stars_Velocity])
					pDefStarsVelocity = defaultValue;
				else
				if ([pKeyValueStr isEqualToString: M_App_Stars_Rotation])
					pDefStarsRotation = defaultValue;
				else
				if ([pKeyValueStr isEqualToString: M_App_Stars_Quantity])
					pDefStarsQuantity = defaultValue;
			}
			
			// since no default values have been set (i.e. no preferences file created), create it here		
			NSDictionary* pAppDefaults = [NSDictionary dictionaryWithObjectsAndKeys: pDefShowStatusBar, M_App_DisplayBar_Enabled,
			        pDefBackgroundColor_R, M_App_Background_R, pDefBackgroundColor_G, M_App_Background_G, pDefBackgroundColor_B,
					M_App_Background_B, pDefStarsColor_R, M_App_Stars_R, pDefStarsColor_G, M_App_Stars_G, pDefStarsColor_B,
					M_App_Stars_B, pDefStarsVelocity, M_App_Stars_Velocity, pDefStarsRotation, M_App_Stars_Rotation, pDefStarsQuantity,
					M_App_Stars_Quantity, nil];
			[[NSUserDefaults standardUserDefaults] registerDefaults: pAppDefaults];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		[application setStatusBarHidden: ![pDefaults boolForKey: M_App_DisplayBar_Enabled]];
		
		glView.animationInterval = 1.0 / 60.0;
		
		glView.m_BackgroundR = (unsigned char)[pDefaults integerForKey: M_App_Background_R];
		glView.m_BackgroundG = (unsigned char)[pDefaults integerForKey: M_App_Background_G];
		glView.m_BackgroundB = (unsigned char)[pDefaults integerForKey: M_App_Background_B];
		
		glView.m_ForegroundR = (unsigned char)[pDefaults integerForKey: M_App_Stars_R];
		glView.m_ForegroundG = (unsigned char)[pDefaults integerForKey: M_App_Stars_G];
		glView.m_ForegroundB = (unsigned char)[pDefaults integerForKey: M_App_Stars_B];
		
		glView.m_StarVelocity   = 10.0f + (((float)[pDefaults integerForKey: M_App_Stars_Velocity] * 40.0f) / 255.0f);
		glView.m_RotateVelocity = ((float)[pDefaults integerForKey: M_App_Stars_Rotation] * 0.001f) / 128.0f;
		glView.m_StarsQuantity  = [pDefaults integerForKey: M_App_Stars_Quantity] + 100;
		
		[glView startAnimation];
	}
	@catch (id)
	{
		exit(0);
	}
}
//------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication*)application
{
	@try
	{
		glView.animationInterval = 1.0 / 5.0;
	}
	@catch (id)
	{
		exit(0);
	}
}
//------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication*)application
{
	@try
	{
		glView.animationInterval = 1.0 / 60.0;
	}
	@catch (id)
	{
		exit(0);
	}
}
//------------------------------------------------------------------------------
- (void)dealloc
{
	[window release];
	[glView release];
	[super dealloc];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
