script_name = "Boldify uppercase lines"
script_description = "Finds uppercase lines and adds bold tags to them"
script_author = "fmmagalhaes"
script_version = "1.0"

require("re")

function boldify_uppercase_lines(subs)
	for i=1, #subs do
		local line = subs[i]

		if line.class == "dialogue" then 
			local text = line.text

			-- now we check if it's uppercase and it does not have bold tag already
			if is_uppercase_text(text) and not re.match(text, "\\{[^}]*\\\\(?:b)\\d", re.ICASE) then
				line.text = "{\\b1}" .. text .. "{\\b0}"
				subs[i] = line
			end
		end
	end

	aegisub.set_undo_point("Boldify")
end

function is_uppercase_text(text)
	local cleanText = text:gsub("{[^}]+}", "") -- remove tags
	cleanText = cleanText:gsub(" *\\[Nn] *"," ") -- remove line breaks
	return cleanText ~= '' and cleanText == cleanText:upper()
end

aegisub.register_macro(script_name, script_description, boldify_uppercase_lines)