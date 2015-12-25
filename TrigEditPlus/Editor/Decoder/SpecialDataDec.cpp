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

#include "../TriggerEditor.h"
#include "../StringUtils/StringCast.h"
#include <algorithm>

bool ProcessSpecialData(StringBuffer& buf, char data[2320]);

bool DecodeSpecialData(StringBuffer& buf, const Trig& trg) {
	const int condition_size = 20 * 15;
	const int action_size = 20 * 15;

	char data[2320];

	// trg.effplayer & trg.current_action should be filled with 0.
	for(int i = 0 ; i < 28 ; i++) {
		if (*(trg.effplayer + i) != 0) return false;
	}

	if (trg.cond[0].condtype != 0) return false;  // First condition should be 'no condition'
	if (trg.act[0].acttype != 0) return false; // Second condition should be 'no action'

	// Get data
	memcpy(data, &trg.cond[1], 300); // 15 conditions
	memcpy(data + 300, &trg.act[1], 2020); // 63 actions + flag)
	return ProcessSpecialData(buf, data);
}


bool ProcessSpecialData(StringBuffer& buf, char data[2320])
{
	if(memcmp(data, "\xd8\x58\x0a\x9b", 4) == 0)  // Special comment
	{
		data[2319] = '\0';
		buf << "TEPComment(" << Raw2CString(data + 4) << ")\r\n";
		return true;
	}
	return false;
}
