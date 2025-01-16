extends CodeEdit

@export var keyword_colour = Color("a75261")
@export var comment_colour = Color("707378")
@export var string_colour = Color("feeca1")

func _ready() -> void:
	var highlighter: CodeHighlighter = syntax_highlighter
	
	highlighter.add_keyword_color("func", keyword_colour)
	highlighter.add_keyword_color("var", keyword_colour)
	
	highlighter.add_color_region("#", "", comment_colour, true)
	highlighter.add_color_region("\"", "\"", string_colour, false)
	
