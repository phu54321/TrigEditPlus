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

#include "MapNamespace.h"
#include "TriggerEditor.h"
#include "StringUtils/StringCast.h"
#include <map>

// Simple bimap structure.
template <typename U, typename V>
class bimap {
public:
	bimap() {}
	~bimap() {}

	void insert(const std::pair<U, V>& data) {
		_l2r.insert(std::make_pair(data.first, data.second));
		_r2l.insert(std::make_pair(data.second, data.first));
	}

	bool l2r(const U& key, V& data) const {
		auto it = _l2r.find(key);
		if(it == _l2r.end()) return false;
		data = it->second;
		return true;
	}

	bool r2l(const V& key, U& data) const {
		auto it = _r2l.find(key);
		if(it == _r2l.end()) return false;
		data = it->second;
		return true;
	}

private:
	std::map<U, V> _l2r;
	std::map<V, U> _r2l;
};




// Some function for UnduplicateString.
inline void AddIndexTrail(std::string &string, int index) {
	char s[20];
	sprintf(s, " (%d)", index);
	string += s;
}


/* UnduplicateString : Convert string list to non-duplicating list of strings.
 *
 * ex) A, AA, AAA -> A, AA, AAA
 * ex) AA, AA, AA -> AA(0), AA(1), AA(2)
 * ex) A, AA, AA  -> A, AA(1), AA(2)
 * ex) A, A(0), A -> A(0), A(0)(1), A(2)
 */

/*
def UnduplicateString(stringlist, defstringlist):
    assert len(stringlist) == len(defstringlist), 'length mismatch'

    stringmap = {}  # String -> corresponding index

    for i, string in enumerate(stringlist):
        if string not in stringmap:  # ok
            stringmap[string] = [i, False]

        else:  # duplicate things
            stringlist[i] += ' (%s)' % defstringlist[i]
            stringmap[stringlist[i]] = [i, True]

            dupit = stringmap[string]
            if dupit[1] is True:
                pass

            else:
                dupindex = dupit[0]
                stringmap[string] = None
                stringlist[dupindex] += ' (%s)' % defstringlist[dupindex]
                stringmap[stringlist[dupindex]] = [dupindex, True]
*/

void UnduplicateString(std::string stringlist[], size_t begin, size_t end) {
	struct IndexDupPair {
		IndexDupPair(int index, bool dup) : index(index), dup(dup) {};
		int index; // Index of string
		int dup;  // Is this string already trailed with string id?
	};

	std::map<std::string, IndexDupPair> stringmap;

	for(size_t i = begin ; i < end ; i++) {
		auto insret = stringmap.insert(std::make_pair(stringlist[i], IndexDupPair(i, 0)));
		if(insret.second == 0) { // there is duplicate item.
			
			auto dupit = insret.first;
			if(dupit->second.dup  == 0) {
				// Add trail to duplicate items if nessecary.
				dupit->second.dup = 2;

				int dupindex = dupit->second.index;
				AddIndexTrail(stringlist[dupindex], dupindex);

				stringmap.erase(dupit);
				stringmap.insert(std::make_pair(stringlist[dupindex], IndexDupPair(dupindex, 1)));
			}

			// Add trail to this item.
			AddIndexTrail(stringlist[i], i);
			stringmap.insert(std::make_pair(stringlist[i], IndexDupPair(i, 1))); // This should succeed.
		}
	}
}




// Simple decoloring
std::string RemoveColorFromString(const std::string& str) {
	const size_t slen = str.size();
	char *newstr = (char*)alloca(slen + 1);
	char *p = newstr;

	for(char ch: str) {
		if(1 <= ch && ch <= 31) continue;
		else *p++ = ch;
	}

	*p = '\0';
	return std::string(newstr);
}


// TriggerNamespace : Unit/Location/Switch name <-> Unit/Location/Switch ID converter.
class MapNamespaceImpl {
public:
	MapNamespaceImpl(const TriggerEditor_Arg& data);
	~MapNamespaceImpl();

	// name -> id
	int GetSwitchID(const std::string& str) const;
	int GetLocationID(const std::string& str) const;
	int GetUnitID(const std::string& str) const;

	// id -> name
	std::string GetSwitchName(int ID) const;
	std::string GetLocationName(int ID) const;
	std::string GetUnitName(int ID) const;

private:
	bimap<int, std::string> _unitmap;
	bimap<int, std::string> _locationmap;
	bimap<int, std::string> _switchmap;
	std::map<std::string, int> _unitmap_defnames;
};


MapNamespaceImpl::MapNamespaceImpl(const TriggerEditor_Arg& data) {
	TEngineData* EngineData = data.EngineData;


	// Map unit names. Allow custom names.
	std::string unitname[233];
	for(int i = 0 ; i < 228 ; i++) {
		int unameindex = EngineData->UnitCustomNames[i];
		const char* uname = NULL;

		if(unameindex) uname = StringTable_GetString(EngineData->MapStrings, unameindex);
		if(uname == NULL) uname = EngineData->UnitNames[i];
		unitname[i].assign(RemoveColorFromString(uname));
	}

	unitname[228] = "Unused unit 228";
	unitname[229] = "Any unit";
	unitname[230] = "Men";
	unitname[231] = "Buildings";
	unitname[232] = "Factories";

	UnduplicateString(unitname, 0, 233);
	for(int i = 0 ; i < 233 ; i++) {
		_unitmap.insert(std::make_pair(i, unitname[i]));
	}

	// Fallback : default unit names
	for(int i = 0 ; i < 228 ; i++) {
		_unitmap_defnames.insert(std::make_pair(EngineData->UnitNames[i], i));
	}

	_unitmap_defnames.insert(std::make_pair("Unused unit 228", 228));
	_unitmap_defnames.insert(std::make_pair("Any unit", 229));
	_unitmap_defnames.insert(std::make_pair("Men", 230));
	_unitmap_defnames.insert(std::make_pair("Buildings", 231));
	_unitmap_defnames.insert(std::make_pair("Factories", 232));



	// Map location names.
	std::string locationname[256];

	for(int i = 0 ; i < 255; i++) {

		const char* lname = NULL;
		char _lname[32];
		
		if(EngineData->MapLocations[i].Exists) {
			int lnameindex = lnameindex = EngineData->MapLocations[i].Data.Name;
			lname = StringTable_GetString(EngineData->MapStrings, lnameindex);
		}

		if(lname == NULL) {
			sprintf(_lname, "Location %d", i+1);
			lname = _lname;
		}

		locationname[i+1] = RemoveColorFromString(lname);
	}

	UnduplicateString(locationname, 1, 256);
	for(int i = 1 ; i < 256 ; i++) {
		_locationmap.insert(std::make_pair(i, locationname[i]));
	}
	

	// Map switch names
	std::string switchname[256];
	DWORD SwitchName[256] = {0};
	// Read switch names
	{
		CChunkData *SWNM = data.SwitchRenaming;
		if(SWNM->ChunkSize == 1024) {
			memcpy(SwitchName, SWNM->ChunkData, 1024);
		}
	}

	for(int i = 0 ; i < 256; i++) {
		int swnameindex = SwitchName[i];
		const char* swname = NULL;
		char _swname[32];

		if(swnameindex) {
			swname = StringTable_GetString(EngineData->MapStrings, swnameindex);
		}

		if(swname == NULL) {
			sprintf(_swname, "Switch %d", i+1);
			swname = _swname;
		}

		switchname[i] = RemoveColorFromString(swname);
	}

	UnduplicateString(switchname, 0, 256);
	for(int i = 0 ; i < 256 ; i++) {
		_switchmap.insert(std::make_pair(i, switchname[i]));
	}
}

MapNamespaceImpl::~MapNamespaceImpl() {}




// name -> id
int MapNamespaceImpl::GetSwitchID(const std::string& str) const {
	int ret;
	bool isconverted = _switchmap.r2l(str, ret);
	if(!isconverted) return -1;
	return ret;
}

int MapNamespaceImpl::GetLocationID(const std::string& str) const {
	int ret;
	bool isconverted = _locationmap.r2l(str, ret);
	if(!isconverted) return -1;
	return ret;
}

int MapNamespaceImpl::GetUnitID(const std::string& str) const {
	int ret;
	bool isconverted = _unitmap.r2l(str, ret);
	if(isconverted) return ret;

	auto it = _unitmap_defnames.find(str);
	isconverted = (it != _unitmap_defnames.end());
	if(isconverted) return it->second;

	return -1;
}


// id -> name
std::string MapNamespaceImpl::GetSwitchName(int ID) const {
	std::string ret;
	if(!_switchmap.l2r(ID, ret)) return Int2String(ID);
	else {
		return Raw2CString(ret);
	}
}

std::string MapNamespaceImpl::GetLocationName(int ID) const {
	std::string ret;
	if(!_locationmap.l2r(ID, ret)) return Int2String(ID);
	else {
		return Raw2CString(ret);
	}
}

std::string MapNamespaceImpl::GetUnitName(int ID) const {
	std::string ret;
	if(!_unitmap.l2r(ID, ret)) return Int2String(ID);
	else {
		return Raw2CString(ret);
	}
}



// pimpl wrapper
MapNamespace::MapNamespace(const TriggerEditor_Arg& data) : _impl(new MapNamespaceImpl(data)) {}
MapNamespace::~MapNamespace() { delete _impl; }

int MapNamespace::GetSwitchID(const std::string& str) const {
	return _impl->GetSwitchID(str);
}

int MapNamespace::GetLocationID(const std::string& str) const {
	return _impl->GetLocationID(str);
}

int MapNamespace::GetUnitID(const std::string& str) const {
	return _impl->GetUnitID(str);
}


std::string MapNamespace::GetSwitchName(int ID) const {
	return _impl->GetSwitchName(ID);
}

std::string MapNamespace::GetLocationName(int ID) const {
	return _impl->GetLocationName(ID);
}

std::string MapNamespace::GetUnitName(int ID) const {
	return _impl->GetUnitName(ID);
}
