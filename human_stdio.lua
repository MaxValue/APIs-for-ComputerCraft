
function overwrite()
	_G.raw_input = raw_input
end

function raw_input(msg, numberOfInputValues, wordWrap)
	io.write(msg)
	return tostring(io.read())
end

term.write (msg) --writes in the same line without word wrap, stays in the same line when finished
term.blit (msg, foreground, background) --works as term.write, changes color of every char of msg with the foreground color defined in foreground and the background color defined in background
io.write/write (msg) --writes in the same line with word wrap, prompt is then in the same line
io.read/read (char replace, table history) --reads input from the same line, replaces input with replace, provides command history with history
print --writes in the same line with word wrap and moves a line down, scrolls display
textutils.
