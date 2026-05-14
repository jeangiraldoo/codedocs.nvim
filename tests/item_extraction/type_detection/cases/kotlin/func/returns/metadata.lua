local TYPES_TO_TEST = {
	"Char",
	"String",
	"Int",
	"Long",
	"Short",
	"Byte",
	"UInt",
	"ULong",
	"UShort",
	"UByte",
	"Float",
	"Double",
	"Boolean",

	"CharArray",
	"IntArray",
	"LongArray",
	"ShortArray",
	"FloatArray",
	"DoubleArray",
	"ByteArray",
	"BooleanArray",

	"Any",
	"Nothing",

	"IntProgression",
	"LongProgression",
	"CharProgression",

	"IntRange",
	"UIntRange",
	"LongRange",
	"ULongRange",
	"CharRange",
	"ClosedFloatingPointRange",
}

local COLLECTIONS_WITH_GENERICS = {
	"Array<%data_type>",

	"List<%data_type>",
	"MutableList<%data_type>",

	"Set<%data_type>",
	"MutableSet<%data_type>",

	"Sequence<%data_type>",
	"Map<String, %data_type>",

	"(Int) -> %data_type",
	"(%data_type) -> Int",

	"Iterable<%data_type>",

	"Pair<int, %data_type>",
	"Triple<int, String, %data_type>",
}

return {
	cursor_pos = { row = 1, col = 1 },
	expected_item_name = "",
	types_to_test = TYPES_TO_TEST,
	collections_with_generics = COLLECTIONS_WITH_GENERICS,
}
