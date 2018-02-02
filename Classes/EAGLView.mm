/**
* EAGLView.mm
* HypnoStars
*
* Created by Jean-Milost Reymond on 05.04.10.
* Copyright 2010 Jean-Milost Reymond. All rights reserved.
*/

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0

//------------------------------------------------------------------------------
// class EAGLView (extension) - objective c
//------------------------------------------------------------------------------
// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end
//------------------------------------------------------------------------------
// class EAGLView - objective c
//------------------------------------------------------------------------------
@implementation EAGLView
//------------------------------------------------------------------------------
@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;
@synthesize m_BackgroundR;
@synthesize m_BackgroundG;
@synthesize m_BackgroundB;
@synthesize m_ForegroundR;
@synthesize m_ForegroundG;
@synthesize m_ForegroundB;
@synthesize m_StarVelocity;
@synthesize m_RotateVelocity;
@synthesize m_StarsQuantity;
//------------------------------------------------------------------------------
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}
//------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:NO],
		        kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];

        if (!context || ![EAGLContext setCurrentContext:context])
		{
            [self release];
            return nil;
        }
        
        animationInterval = 1.0 / 60.0;

		// initialize starfield objects
		m_pCamera    = [[IP_Camera alloc]init];
        m_pStarfield = [[IP_Starfield alloc]init];
    }

    return self;
}
//------------------------------------------------------------------------------
- (void)drawView
{
    [EAGLContext setCurrentContext:context];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

	float r = (float)m_BackgroundR / 255.0f;
	float g = (float)m_BackgroundG / 255.0f;
	float b = (float)m_BackgroundB / 255.0f;

    glClearColor(r, g, b, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glMatrixMode(GL_MODELVIEW);
	[m_pStarfield Render :backingWidth :backingHeight];

    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
//------------------------------------------------------------------------------
- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}
//------------------------------------------------------------------------------
- (BOOL)createFramebuffer
{
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);

    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);

    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

    if (USE_DEPTH_BUFFER)
	{
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

	// initialize starfield objects
	[m_pStarfield InitializeStars :m_StarsQuantity :backingHeight + 150.0f :backingHeight + 150.0f];
	[m_pStarfield SetBackgroundColor :m_BackgroundR :m_BackgroundG :m_BackgroundB];
	[m_pStarfield SetStarsColor :m_ForegroundR :m_ForegroundG :m_ForegroundB];
	[m_pStarfield SetSpeedVelocity :m_StarVelocity];
	[m_pStarfield SetRotateVelocity :m_RotateVelocity];
    [m_pCamera CreateOrtho :backingWidth :backingHeight :M_StarDepth];

    return YES;
}
//------------------------------------------------------------------------------
- (void)destroyFramebuffer
{
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer)
	{
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}
//------------------------------------------------------------------------------
- (void)startAnimation
{
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}
//------------------------------------------------------------------------------
- (void)stopAnimation
{
    self.animationTimer = nil;
}
//------------------------------------------------------------------------------
- (void)setAnimationTimer:(NSTimer *)newTimer
{
    [animationTimer invalidate];
    animationTimer = newTimer;
}
//------------------------------------------------------------------------------
- (void)setAnimationInterval:(NSTimeInterval)interval
{
    animationInterval = interval;

	if (animationTimer)
	{
        [self stopAnimation];
        [self startAnimation];
    }
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [context release];  
    [super dealloc];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
