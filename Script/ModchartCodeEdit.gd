extends CodeEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	delimiter_comments.append("--")
	delimiter_comments.append("--[[ ]]")
	indent_automatic_prefixes.append("then")
	
	syntax_highlighter = CodeHighlighter.new()
	syntax_highlighter.add_keyword_color("local", "#1e90ff")
	
	syntax_highlighter.add_keyword_color("function", "#ff00ff")
	syntax_highlighter.add_keyword_color("end", "#ff00ff")
	syntax_highlighter.add_keyword_color("if", "#ff00ff")
	syntax_highlighter.add_keyword_color("else", "#ff00ff")
	syntax_highlighter.add_keyword_color("elseif", "#ff00ff")
	syntax_highlighter.add_keyword_color("for", "#ff00ff")
	syntax_highlighter.add_keyword_color("while", "#ff00ff")
	syntax_highlighter.add_keyword_color("repeat", "#ff00ff")
	syntax_highlighter.add_keyword_color("then", "#ff00ff")
	
	syntax_highlighter.add_keyword_color("and", "#ff4500")
	syntax_highlighter.add_keyword_color("or", "#ff4500")
	syntax_highlighter.add_keyword_color("true", "#ff4500")
	syntax_highlighter.add_keyword_color("false", "#ff4500")
	syntax_highlighter.add_keyword_color("nil", "#ff4500")
	
	syntax_highlighter.add_color_region("\"", "\"", "#FFFF88")
	syntax_highlighter.add_color_region("--", "", "#888888")
	syntax_highlighter.add_color_region("--[[", "]]", "#888888")
	syntax_highlighter.set_symbol_color("#FFFF88")
	syntax_highlighter.set_number_color("#98fb98")
	syntax_highlighter.set_function_color("#9b3cf3")
	syntax_highlighter.set_member_variable_color("#afeeee")

func _on_text_changed():
	Audio.a_play("Type")
