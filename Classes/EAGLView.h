/**
* EAGLView.h
* HypnoStars
*
* Created by Jean-Milost Reymond on 05.04.10.
* Copyright 2010 Jean-Milost Reymond. All rights reserved.
*/

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "IP_Star.h"
#import "IP_Camera.h"

/*
* This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
* The view content is basically an EAGL surface you render your OpenGL scene into.
* Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView
{
	@private
		/* The pixel dimensions of the backbuffer */
		GLint          backingWidth;
		GLint          backingHeight;

		EAGLContext*   context;

		/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
		GLuint         viewRenderbuffer, viewFramebuffer;

		/* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
		GLuint         depthRenderbuffer;

		NSTimer*       animationTimer;
		NSTimeInterval animationInterval;

		IP_Camera*     m_pCamera;
		IP_Starfield*  m_pStarfield;

        unsigned char  m_BackgroundR;
        unsigned char  m_BackgroundG;
        unsigned char  m_BackgroundB;
        unsigned char  m_ForegroundR;
        unsigned char  m_ForegroundG;
        unsigned char  m_ForegroundB;

        float          m_StarVelocity;
        float          m_RotateVelocity;

        unsigned       m_StarsQuantity;
}

@property NSTimeInterval animationInterval;
@property unsigned char  m_BackgroundR;
@property unsigned char  m_BackgroundG;
@property unsigned char  m_BackgroundB;
@property unsigned char  m_ForegroundR;
@property unsigned char  m_ForegroundG;
@property unsigned char  m_ForegroundB;
@property float          m_StarVelocity;
@property float          m_RotateVelocity;
@property unsigned       m_StarsQuantity;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end
