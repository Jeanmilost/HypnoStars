/**
* IP_Camera.h
* HypnoStars
*
* Created by Jean-Milost Reymond on 05.04.10.
* Copyright 2010 Jean-Milost Reymond. All rights reserved.
*/

#import <OpenGLES/ES1/gl.h>

@interface IP_Camera : NSObject
{}

- (id)init;
- (void)dealloc;
- (void)CreateOrtho :(float)width :(float)height :(float)deep;

@end
