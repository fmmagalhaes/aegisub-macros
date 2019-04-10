script_name = "Hyphen to dash"
script_description = "Replaces hyphen with en dash on dialogues"
script_author = "fmmagalhaes"
script_version = "1.1"

function replace_hypen(subs)

	for i=1, #subs do
        local line = subs[i]
		if line.class == "dialogue" then
			line.text = line.text:gsub("^- ?(.*)","– %1")
			line.text = line.text:gsub("^({.-}+ ?)-(.*)","%1– %2")
			line.text = line.text:gsub("(\\[Nn] ?)- ?(.*)","%1– %2")
			line.text = line.text:gsub("(\\[Nn] ?{.-}+)- ?(.*)","%1– %2")
			subs[i] = line
		end
	end

	aegisub.set_undo_point("Hyphen to dash")
end

aegisub.register_macro(script_name, script_description, replace_hypen)