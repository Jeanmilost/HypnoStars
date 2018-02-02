/**
* IP_Random.h
* HypnoStars
*
* Created by Jean-Milost Reymond on 05.04.10.
* Copyright 2010 Jean-Milost Reymond. All rights reserved.
*/

#import <Foundation/Foundation.h>
#include <cstdlib>
#include <ctime>
#include <iostream>

class IP_CPP_Random
{
	public:
		/**
		* Initialize random number generator
		*/
		static void Initialize();

		/**
		* Get randomized number
		*@param[optionnal] range - range
		*@returns randomized number
		*/
		static unsigned GetNumber(unsigned range = RAND_MAX);
};

@interface IP_Random : NSObject
{}

- (id)init;
- (unsigned)GetNumber :(unsigned)range;

@end
