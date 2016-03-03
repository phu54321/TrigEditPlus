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

#ifndef SCMD_PLUGIN_H
#define SCMD_PLUGIN_H

#include "SICStringList.h"

#define PLUGINVERSION		0x00000002

// malloc/free used inside SCMDraft2. You may not need this function.
typedef void*	(*AllocRam)(DWORD Size);
typedef void	(*DeAllocRam)(void*	Ram);
typedef void*	(*ReAllocRam)(void*	Ram, DWORD Size);

extern HWND hSCMD2MainWindow;
extern HINSTANCE hSCMD2Instance;
extern HINSTANCE hInstance;


extern AllocRam scmd2_malloc;
extern DeAllocRam scmd2_free; 
extern ReAllocRam scmd2_realloc;





// Various structures for arguments passed from SCMDraft2.
#pragma pack(1)

// Location structure. Structure follows MRGN section format.
typedef struct _SCLocation { 
	DWORD     x0;        // Left
	DWORD     y0;        // Top
	DWORD     x1;        // Right
	DWORD     y1;        // Bottom
	WORD     Name;       // String ID for location name.
	WORD     Elevation;  // Elevation flags.
} SCLocation;


// What SCMDraft2 really passes to us.
typedef struct _LocationNode {
	SCLocation     Data;   // Location data.
	BYTE          Exists;  // True: Location exists. False: Unused location
} LocationNode;
#pragma pack()


// Structure for CHK Sections
typedef struct _CChunkData {
	DWORD			ChunkSize;   // Size of section
	BYTE*			ChunkData;   // Data pointer. Maybe you can use scmd_alloc, scmd_realloc
} CChunkData;


typedef struct _TEngineData { 
	WORD Size; 
	SI_VirtSCStringList* StatTxt; 
	SI_VirtSCStringList* MapStrings; 
	SI_VirtSCStringList* MapInternalStrings; 
	LocationNode*		MapLocations;
	DWORD*				WavStringIndexii;
	void*				ActionLog;			//	Also NULL
	WORD				ActionLogLevel;
	void*				DataInterface;		//	Also NULL, until virtual class is implemented
	int*				CurSelLocation;
	int*				UnitCustomNames;	//	0 == none, everything else is off by 1, 228 entries
	int*				ForceNames;			//	0 == none, everything else is off by 1, 4 entries
	char**				UnitNames;			//	char*[228] with non identical unit names
} TEngineData; 

typedef struct _TPluginInfo {
	TEngineData * EngineData;
	AllocRam AllocMem;
	DeAllocRam DeleteMem;
	ReAllocRam ResizeMem;
	HWND hWindow;
	BOOL fDone;
} TPluginInfo;

struct UnitProp {
	WORD wPropValid;
	WORD wElValid;
	BYTE bOwner;
	BYTE bHP;
	BYTE bSP;
	BYTE bEP;
	DWORD dwResAmount;
	WORD wHangarUnits;
	WORD wFlags;
	DWORD dwUnknown;
};



#endif