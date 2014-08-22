#pragma once

#include <string>
#include <functional>
#include <map>
#include "../../PluginBase/SCMDPlugin.h"


class MapNamespaceImpl;
struct TriggerEditor_Arg;

// TriggerNamespace : Unit/Location/Switch name <-> Unit/Location/Switch ID converter.
class MapNamespace {
public:
	MapNamespace(const TriggerEditor_Arg& data);
	~MapNamespace();

	// name -> id
	int GetSwitchID(const std::string& str) const;
	int GetLocationID(const std::string& str) const;
	int GetUnitID(const std::string& str) const;

	// id -> name
	std::string GetSwitchName(int ID) const;
	std::string GetLocationName(int ID) const;
	std::string GetUnitName(int ID) const;

private:
	MapNamespaceImpl* _impl; //pimpl idiom
};
