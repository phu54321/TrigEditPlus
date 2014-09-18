#include "../TriggerEditor.h"

void DecodeSpecialComment(const Trig& trg, char output[2320], int& outputlength) {
	// trg.effplayer & trg.current_action should be filled with 0.
	for(int i = 0 ; i < 28 ; i++) {
		if(*(trg.effplayer + i) != 0) throw -1;
	}

	// Get data
	memcpy(output + 0, &trg.cond[1], 300); // 15 conditions
	memcpy(output + 30, &trg.act[1], 2020); // 63 actions + flag)

	for(int i = 0 ; i < 2320 ; i++) {

	}
}
