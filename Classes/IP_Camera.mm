/**
* IP_Camera.mm
* HypnoStars
*
* Created by Jean-Milost Reymond on 05.04.10.
* Copyright 2010 Jean-Milost Reymond. All rights reserved.
*/

#import "IP_Camera.h"

//------------------------------------------------------------------------------
// class IP_Camera - objective c
//------------------------------------------------------------------------------
@implementation IP_Camera
//------------------------------------------------------------------------------
- (id)init
{
    if (self = [super init])
	{}
	
    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [super dealloc];
}
//------------------------------------------------------------------------------
- (void)CreateOrtho :(float)width :(float)height :(float)deep
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

	float minX = -width / 2.0f;
	float maxX =  width / 2.0f;
	float minY = -height / 2.0f;
	float maxY =  height / 2.0f;

	glOrthof(minX, maxX, minY, maxY, 0.0f, deep);
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
