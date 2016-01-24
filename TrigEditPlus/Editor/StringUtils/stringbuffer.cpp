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

#include "stringbuffer.h"

#include <iostream>

StringBuffer::StringBuffer() : _currentsize(0), _bufnode_pos(0), _currentLine(1) {
	AllocNewNode();
}

StringBuffer::~StringBuffer() {
	for(auto bufnode : _buftb) {
		delete bufnode;
	}
}

void StringBuffer::AddBlock(const void* data, int length){
	const char* sdata = static_cast<const char*>(data);

	// Update current line
	const char* sdend = sdata + length;
	for(const char* p = sdata; p < sdend; p++)
	{
		if(*p == '\n') _currentLine++;
	}

	// Update current size
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

StringBuffer& StringBuffer::operator<<(const char* s) {
	AddBlock(s, strlen(s));
	return *this;
}

StringBuffer& StringBuffer::operator<<(int i) {
	if(i == 0) {
		AddBlock("0", 1);
		return *this;
	}

	else {
		char data[20];
		_itoa(i, data, 10);
		AddBlock(data, strlen(data));
		return *this;
	}
}


void StringBuffer::putchar(char ch) {
	AddBlock(&ch, 1);
}

int StringBuffer::GetCurrentLine() const
{
	return _currentLine;
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
