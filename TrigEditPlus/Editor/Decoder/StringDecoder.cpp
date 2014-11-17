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

#include "../MapNamespace.h"
#include "../TriggerEditor.h"
#include "../StringUtils/StringCast.h"


// Decoder part
std::string TriggerEditor::DecodeUnit(int value) const {
	return _namespace->GetUnitName(value);
}

std::string TriggerEditor::DecodeLocation(int value) const {
	return _namespace->GetLocationName(value);
}

std::string TriggerEditor::DecodeSwitchName(int value) const {
	return _namespace->GetSwitchName(value);
}

std::string TriggerEditor::DecodeString(int value) const {
	SI_VirtSCStringList* stb = _editordata->EngineData->MapStrings;
	int totstringn = StringTable_GetTotalStringNum(stb);
	if(value < 0 || value > totstringn) return Int2String(value);

	const char* rawstr = StringTable_GetString(stb, value);
	if(rawstr == NULL) return Int2String(value);
	else return Raw2CString(rawstr);
}
