/*
 * Copyright (c) 2014 trgk(phu54321@naver.com)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "../UnitProp.h"
#include "../StringUtils/StringBuffer.h"
#include <string>
#include <vector>

#define PRPFLAG_HITPOINT        (1<<1)
#define PRPFLAG_SHIELD          (1<<2)
#define PRPFLAG_ENERGY          (1<<3)
#define PRPFLAG_RESOURCE        (1<<4)
#define PRPFLAG_HANGER          (1<<5)

#define SPRPFLAG_CLOCKED        (1<<0)
#define SPRPFLAG_BURROWED       (1<<1)
#define SPRPFLAG_INTRANSIT      (1<<2)
#define SPRPFLAG_HALLUCINATED   (1<<3)
#define SPRPFLAG_INVINCIBLE     (1<<4)

std::string DecodeUPRPData(const UPRPData* data) {
	StringBuffer sb;
	std::vector<int> sprplist;
	std::vector<int> prplist;

	sb << "{";

	bool isdata = false; // If uprp entry has no data, then this variable should be set to 0.

    // sprp
    if(data->sprpvalid & SPRPFLAG_CLOCKED) {
        sprplist.push_back(SPRPFLAG_CLOCKED);
    }

    if(data->sprpvalid & SPRPFLAG_BURROWED) {
        sprplist.push_back(SPRPFLAG_BURROWED);
    }

    if(data->sprpvalid & SPRPFLAG_INTRANSIT) {
        sprplist.push_back(SPRPFLAG_INTRANSIT);
    }

    if(data->sprpvalid & SPRPFLAG_HALLUCINATED) {
        sprplist.push_back(SPRPFLAG_HALLUCINATED);
    }

    if(data->sprpvalid & SPRPFLAG_INVINCIBLE) {
        sprplist.push_back(SPRPFLAG_INVINCIBLE);
    }

	if(sprplist.size() > 0) {
		if(!isdata) {
			isdata = true;
			sb << "\n";
		}

		for(size_t i = 0 ; i < sprplist.size() ; i++) {
			const char* sprpname;
			switch(sprplist[i]) {
			case SPRPFLAG_CLOCKED: sprpname = "clocked"; break;
			case SPRPFLAG_BURROWED: sprpname = "burrowed"; break;
			case SPRPFLAG_INTRANSIT: sprpname = "intransit"; break;
			case SPRPFLAG_HALLUCINATED: sprpname = "hallucinated"; break;
			case SPRPFLAG_INVINCIBLE: sprpname = "invincible"; break;
			default:
				std::abort(); // Can't happen
			}

			if(data->sprpflag & sprplist[i]) {
				sb << "\t\t\t" << sprpname << " = " << "true,\n";
			}
			else {
				sb << "\t\t\t" << sprpname << " = " << "false,\n";
			}
		}
	}


	// prp
    if(data->prpvalid & PRPFLAG_HITPOINT) {
        prplist.push_back(PRPFLAG_HITPOINT);
    }

    if(data->prpvalid & PRPFLAG_SHIELD) {
        prplist.push_back(PRPFLAG_SHIELD);
    }

    if(data->prpvalid & PRPFLAG_ENERGY) {
        prplist.push_back(PRPFLAG_ENERGY);
    }

    if(data->prpvalid & PRPFLAG_RESOURCE) {
        prplist.push_back(PRPFLAG_RESOURCE);
    }

    if(data->prpvalid & PRPFLAG_HANGER) {
        prplist.push_back(PRPFLAG_HANGER);
    }



	if(prplist.size() > 0) {
		if(!isdata) {
			isdata = true;
			sb << "\n";
		}

		for(size_t i = 0 ; i < prplist.size() ; i++) {
			const char* prpname;
			unsigned int prpvalue;

			switch(prplist[i]) {
			case PRPFLAG_HITPOINT: prpname = "hitpoint";  prpvalue = data->hitpoint; break; 
			case PRPFLAG_SHIELD:   prpname = "shield";    prpvalue = data->shield; break;
			case PRPFLAG_ENERGY:   prpname = "energy";    prpvalue = data->energy; break;
			case PRPFLAG_RESOURCE: prpname = "resource";  prpvalue = data->resource; break; 
			case PRPFLAG_HANGER:   prpname = "hanger";    prpvalue = data->hanger; break;
			default:
				std::abort(); // Can't happen
			}

			sb << "\t\t\t" << prpname << " = " << prpvalue << ",\n";
		}
	}

	if(isdata) sb << "\t\t}";
	else sb << "}";

	return sb.str();
}