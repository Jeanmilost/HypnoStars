//
//  Shader.vsh
//  HypnoStars
//
//  Created by Jean-Milost Reymond on 20.06.10.
//  Copyright WindSolutions 2010. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate) / 2.0;

    colorVarying = color;
}
