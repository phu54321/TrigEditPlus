#include <map>
#include <vector>

const std::map<wchar_t, const wchar_t*> jamo_table = {
	{ 0x3131, L"r" },
	{ 0x3132, L"R" },
	{ 0x3133, L"rt" },
	{ 0x3134, L"s" },
	{ 0x3135, L"sw" },
	{ 0x3136, L"sg" },
	{ 0x3137, L"e" },
	{ 0x3138, L"E" },
	{ 0x3139, L"f" },
	{ 0x313A, L"fr" },
	{ 0x313B, L"fa" },
	{ 0x313C, L"fq" },
	{ 0x313D, L"ft" },
	{ 0x313E, L"fx" },
	{ 0x313F, L"fv" },
	{ 0x3140, L"fg" },
	{ 0x3141, L"a" },
	{ 0x3142, L"q" },
	{ 0x3143, L"Q" },
	{ 0x3144, L"qt" },
	{ 0x3145, L"t" },
	{ 0x3146, L"T" },
	{ 0x3147, L"d" },
	{ 0x3148, L"w" },
	{ 0x3149, L"W" },
	{ 0x314A, L"c" },
	{ 0x314B, L"z" },
	{ 0x314C, L"x" },
	{ 0x314D, L"v" },
	{ 0x314E, L"g" },

	{ 0x314F, L"k" },
	{ 0x3150, L"o" },
	{ 0x3151, L"i" },
	{ 0x3152, L"O" },
	{ 0x3153, L"j" },
	{ 0x3154, L"p" },
	{ 0x3155, L"u" },
	{ 0x3156, L"P" },
	{ 0x3157, L"h" },
	{ 0x3158, L"hk" },
	{ 0x3159, L"ho" },
	{ 0x315A, L"hl" },
	{ 0x315B, L"y" },
	{ 0x315C, L"n" },
	{ 0x315D, L"nj" },
	{ 0x315E, L"np" },
	{ 0x315F, L"nl" },
	{ 0x3160, L"b" },
	{ 0x3161, L"m" },
	{ 0x3162, L"ml" },
	{ 0x3163, L"l" },
};

const std::vector<const wchar_t*> chosungList = { L"r", L"R", L"s", L"e", L"E", L"f", L"a", L"q", L"Q", L"t", L"T", L"d", L"w", L"W", L"c", L"z", L"x", L"v", L"g" };
const std::vector<const wchar_t*> jhungsungList = { L"k", L"o", L"i", L"O", L"j", L"p", L"u", L"P", L"h", L"hk", L"ho", L"hl", L"y", L"n", L"nj", L"np", L"nl", L"b", L"m", L"ml", L"l" };
const std::vector<const wchar_t*> jhongsungList = { L"", L"r", L"R", L"rt", L"s", L"sw", L"sg", L"e", L"f", L"fr", L"fa", L"fq", L"ft", L"fx", L"fv", L"fg", L"a", L"q", L"qt", L"t", L"T", L"d", L"w", L"c", L"z", L"x", L"v", L"g" };

static wchar_t* wsc(wchar_t* dst, const wchar_t* src)
{
	while(*src)
	{
		*dst++ = *src++;
	}
	return dst;
}

std::wstring unpack_hangeul(const std::wstring& in)
{
	std::vector<wchar_t> unpacked;
	unpacked.resize(in.size() * 5);
	wchar_t* unpacked_ptr = unpacked.data();

	for(auto ch : in)
	{
		if(ch >= 44032 && ch < 44032 + 11172)
		{
			ch -= 44032;
			unpacked_ptr = wsc(unpacked_ptr, chosungList[ch / 588]);
			unpacked_ptr = wsc(unpacked_ptr, jhungsungList[ch / 28 % 21]);
			unpacked_ptr = wsc(unpacked_ptr, jhongsungList[ch % 28]);
		}

		else
		{
			auto it = jamo_table.find(ch);
			if(it != jamo_table.end()) unpacked_ptr = wsc(unpacked_ptr, it->second);
			else *unpacked_ptr++ = ch;
		}
	}
	return std::wstring(unpacked.data(), unpacked_ptr);
}
