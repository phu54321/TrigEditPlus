#pragma once

#include <stdio.h>
#include <stdint.h>
#include <list>
#define STRINGBUFFER_NODE_SIZE 4096

// Someone says that stringstream is slow. So I made one.
class StringBuffer {
public:
	StringBuffer();
	~StringBuffer();

	void clear();
	std::string str() const;

	StringBuffer& operator<<(const std::string& s);
	StringBuffer& operator<<(const char* s);
	StringBuffer& operator<<(int i);

	void putchar(char ch);

private:
	void AllocNewNode();
	void AddBlock(const void* data, int length);

	struct BufferNode{
		uint8_t buffer[STRINGBUFFER_NODE_SIZE];
	};

	std::list<BufferNode*> _buftb;
	BufferNode* _currentnode;
	size_t _currentsize;
	size_t _bufnode_pos;
};