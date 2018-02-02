/**
* IP_Random.mm
* HypnoStars
*
* Created by Jean-Milost Reymond on 05.04.10.
* Copyright 2010 Jean-Milost Reymond. All rights reserved.
*/

#import "IP_Random.h"

//------------------------------------------------------------------------------
// class IP_CPP_Random - c++
//------------------------------------------------------------------------------
void IP_CPP_Random::Initialize()
{
	std::srand((unsigned)std::time(0));
}
//------------------------------------------------------------------------------
unsigned IP_CPP_Random::GetNumber(unsigned range)
{
	return (std::rand() % range);
}
//------------------------------------------------------------------------------		
// class IP_Random - objective c
//------------------------------------------------------------------------------		
@implementation IP_Random
//------------------------------------------------------------------------------
- (id)init
{
    if (self = [super init])
		IP_CPP_Random::Initialize();

    return self;
}
//------------------------------------------------------------------------------
- (unsigned)GetNumber :(unsigned)range
{
	return IP_CPP_Random::GetNumber(range);
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
