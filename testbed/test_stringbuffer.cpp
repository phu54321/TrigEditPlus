#include <iostream>

#include <stdio.h>
#include <stdint.h>
#include <vector>
#define STRINGBUFFER_NODE_SIZE 10

// Someone says that stringstream is slow. So I made one.
class StringBuffer {
public:
	StringBuffer();
	~StringBuffer();

	void clear();
	std::string str() const;

	StringBuffer& operator<<(const std::string& s);
	StringBuffer& operator<<(unsigned int i);


private:
	void AllocNewNode();
	void AddBlock(const void* data, int length);

	struct BufferNode{
		uint8_t buffer[STRINGBUFFER_NODE_SIZE];
	};

	std::vector<BufferNode*> _buftb;
	BufferNode* _currentnode;
	size_t _currentsize;
	size_t _bufnode_pos;
};

StringBuffer::StringBuffer() : _currentsize(0), _bufnode_pos(0) {
	AllocNewNode();
}

StringBuffer::~StringBuffer() {
	for(auto bufnode : _buftb) {
		delete bufnode;
	}
}

void StringBuffer::AddBlock(const void* data, int length){
	const char* sdata = (const char*)data;

	_currentsize += length;


	// Case 1 : All data fills in the last buffer
	if(length + _bufnode_pos <= STRINGBUFFER_NODE_SIZE) {
		memcpy(_currentnode->buffer + _bufnode_pos, sdata, length);
		_bufnode_pos += length;

		if(_bufnode_pos == STRINGBUFFER_NODE_SIZE) AllocNewNode();

		return;
	}

	// Case 2 : Else:
	size_t copylen;

	//  - Fill the first remaining buffer.
	copylen = STRINGBUFFER_NODE_SIZE - _bufnode_pos;
	memcpy(_currentnode->buffer + _bufnode_pos, sdata, copylen);
	AllocNewNode();
	sdata += copylen;
	length -= copylen;

	//  - Fill some whole nodes.
	while(length > STRINGBUFFER_NODE_SIZE) {
		memcpy(_currentnode->buffer, sdata, STRINGBUFFER_NODE_SIZE);
		sdata += STRINGBUFFER_NODE_SIZE;
		length -= STRINGBUFFER_NODE_SIZE;
		AllocNewNode();
	}

	//  - Fill remaining
	memcpy(_currentnode->buffer, sdata, length);
	_bufnode_pos += length;

	if(length == STRINGBUFFER_NODE_SIZE) {
		AllocNewNode();
	}

	return;
}


StringBuffer& StringBuffer::operator<<(const std::string& s) {
	AddBlock(s.data(), s.size());
	return *this;
}

StringBuffer& StringBuffer::operator<<(unsigned int i) {
	char data[1000];
	int slen = sprintf(data, "%d", i);
	AddBlock(data, slen);
	return *this;
}


void StringBuffer::clear() {
	for(auto bufnode : _buftb) {
		delete bufnode;
	}
	_buftb.clear();
	_currentsize = 0;
	_bufnode_pos = STRINGBUFFER_NODE_SIZE;
	AllocNewNode();
}


std::string StringBuffer::str() const {
	std::string str(_currentsize, '\0');
	char* strdata = const_cast<char*>(str.data());

	int remaining_bytes = _currentsize;
	int index = 0;

	for(auto bufnode : _buftb) {
		int copylen = STRINGBUFFER_NODE_SIZE;
		if(STRINGBUFFER_NODE_SIZE > remaining_bytes) {
			copylen = remaining_bytes;
		}
		memcpy(strdata, bufnode->buffer, copylen);
		strdata += copylen;
		remaining_bytes -= copylen;
	}

	return str;
}


void StringBuffer::AllocNewNode() {
	_bufnode_pos = 0;
	BufferNode* newnode = new BufferNode;
	_currentnode = newnode;
	_buftb.push_back(newnode);
}


int main() {
	StringBuffer sb;
	int i;
	
	sb << std::string(STRINGBUFFER_NODE_SIZE, 'A');
	sb << std::string(STRINGBUFFER_NODE_SIZE, 'B');
	sb << std::string(STRINGBUFFER_NODE_SIZE, 'C');

	std::cout << sb.str().c_str() << std::endl;
	getchar();
}