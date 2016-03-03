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

	int GetCurrentLine() const;

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
	size_t _currentLine;
};