#include <iostream>
#include <string>
#include <map>

inline void AddIndexTrail(std::string &string, int index) {
	char s[20];
	sprintf(s, " (%d)", index);
	string += s;
}

void UnduplicateString(std::string stringlist[], size_t stringn) {
	struct IndexDupPair {
		IndexDupPair(int index, bool dup) : index(index), dup(dup) {};
		int index; // Index of string
		bool dup;  // Is this string already trailed with string id?
	};

	std::map<std::string, IndexDupPair> stringmap;

	for(int i = 0 ; i < stringn ; i++) {
		auto insret = stringmap.insert(std::make_pair(stringlist[i], IndexDupPair(i, false)));
		if(insret.second == false) { // there is duplicate item.
			
			auto dupit = insret.first;

			// Add trail to duplicate items if nessecary.
			if(!dupit->second.dup) {
				int dupindex = dupit->second.index;
				AddIndexTrail(stringlist[dupindex], dupindex);

				stringmap.erase(dupit);
				stringmap.insert(std::make_pair(stringlist[dupindex], IndexDupPair(dupindex, true)));
			}

			// Add trail to this item.
			AddIndexTrail(stringlist[i], i);
			stringmap.insert(std::make_pair(stringlist[i], IndexDupPair(i, true))); // This should succeed.
		}
	}
}



int main() {
	std::string strarr[] = {
		"A",
		"AA",
		"AAA",
		"A",
		"AAAA",
		"AA",
		"AA (1)",
		"AA",
		"A",
		"A (0)",
		"A"
	};

	int strn = sizeof(strarr) / sizeof(std::string);

	UnduplicateString(strarr, strn);
	for(int i = 0 ; i < strn ; i++) {
		std::cout << strarr[i].c_str() << std::endl;
	}
	getchar();
}