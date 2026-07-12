local TYPES_TO_TEST = {
	"int",
	"float",
	"complex",
	"bool",
	"str",
	"bytes",
	"Any",
	"object",
	"list",
}

local COLLECTIONS_WITH_GENERICS = {
	"list[%data_type]",
	"set[%data_type]",
	"frozenset[%data_type]",
	"dict[int, %data_type]",
	"tuple[int, %data_type]",
	"Iterator[%data_type]",
	"Generator[str, int, %data_type]",
	"Callable[[int, %data_type], bool]",
	"Literal[int, %data_type]",
	"Sequence[%data_type]",
	"MutableSequence[%data_type]",
	"Mapping[int, %data_type]",
	"MutableMapping[int, %data_type]",
	"int | %data_type",
	"Union[int, %data_type]",
	"Optional[%data_type]",
}

return {
	cursor_pos = { row = 2, col = 1 },
	expected_item_name = "",
	types_to_test = TYPES_TO_TEST,
	collections_with_generics = COLLECTIONS_WITH_GENERICS,
}
