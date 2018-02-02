//
//  Shader.fsh
//  HypnoStars
//
//  Created by Jean-Milost Reymond on 20.06.10.
//  Copyright WindSolutions 2010. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
