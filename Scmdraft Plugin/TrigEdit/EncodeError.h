#pragma once

#include <string>
#include <exception>

class EncodeError : public std::exception {
public:
	EncodeError(std::string reason) {
		const char* orig = reason.c_str();
		strncpy(_errmsg_storage, orig, 1024);
		_errmsg_storage[1023] = 0;
	}

	virtual ~EncodeError() {}

	virtual const char* what() const {
		return _errmsg_storage;
	}

private:
	char _errmsg_storage[1024];
};
