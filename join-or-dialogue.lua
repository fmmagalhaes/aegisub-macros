-- Adapted from "Join / Split / Snap" version 1.2 from http://unanimated.github.io/ts/scripts-unanimated.htm

-- Disclaimer:
-- the script does its job in no-ASS tags scenarios
-- it does not work perfectly with ASS tags
-- in the worst case, you can simply revert the change with Ctrl+Z

script_name  =  "Join (line break) / Create dialogue"
script_description  =  "Joins two lines with \\N (line break) / Creates a dialogue from two lines with –"
script_author  =  "fmmagalhaes"
script_version  =  "2.1"

re  =  require 'aegisub.re'

function concatenate_n(subs,sel)
	if #sel == 2 then
		values = concatenate_generic(subs,sel)
		line = subs[sel[1]]
		line2 = subs[sel[2]]
		
		new_text = values[1].."\\N"..values[2]..values[3]
		new_text = new_text:gsub("%.%.%. %.%.%."," "):gsub("\" \""," ")
		:gsub("^({[^}]*\\i1.-){\\i0[^}]*}(\\N.-\\i0[^}]*})$", "%1%2") -- removes inner {\i0} from {\i1}xyz{\i0}abx{\i0}
		:gsub("^({[^}]*\\b1.-){\\b0[^}]*}(\\N.-\\b0[^}]*})$", "%1%2") -- removes inner {\b0} from {\b1}xyz{\b0}abx{\b0}
		:gsub("{}","")
		
		if line2.end_time > line.end_time then
			line.end_time = line2.end_time
		end
		
		subs.delete(sel[2])
		
		line.text = new_text
		subs[sel[1]] = line
		sel = {sel[1]}
		
		aegisub.set_undo_point("Join")
		return sel
	end
end

function create_dialogue(subs,sel)
	if #sel == 2 then
		line = subs[sel[1]]
		line2 = subs[sel[2]]
		
		values = concatenate_generic(subs,sel)
		first = values[1]
		second = values[2]..values[3]
		
		-- the following pattern matches the first character if it is different from "{"
		-- hello -> – hello
		first = first:gsub("^([^{])", "– %1", 1)
		-- the following regex expression is used to find the first character different from "{" that comes after a "}"
		-- so we can add a "–" before that character
		-- {xyz}{\i0}{abc}hello -> {xyz}{\i0}{abc}– hello
		-- does not work with gsub
		first = re.sub(first, "^(({[^}]*\\})+)([^{])","$1– $3")
		
		second = second:gsub("^([^{])", "– %1", 1)
		second = re.sub(second, "^(({[^}]*\\})+)([^{])","$1– $3")
		
		new_text = first.."\\N"..second
		new_text = new_text:gsub("%.%.%. %.%.%."," "):gsub("\" \""," ")
		:gsub("^({[^}]*\\i1.-){\\i0[^}]*}(\\N.-\\i0[^}]*})$", "%1%2") -- removes inner {\i0} from {\i1}xyz{\i0}abx{\i0}
		:gsub("^({[^}]*\\b1.-){\\b0[^}]*}(\\N.-\\b0[^}]*})$", "%1%2") -- removes inner {\b0} from {\b1}xyz{\b0}abx{\b0}
		:gsub("{}","")
		:gsub("– %- ", "– ") -- removing hifens in case there was any before being used as a dash
		
		if line2.end_time > line.end_time then
			line.end_time = line2.end_time
		end
		
		subs.delete(sel[2])
		
		line.text = new_text
		subs[sel[1]] = line
		sel = {sel[1]}
		
		aegisub.set_undo_point("Create dialogue")
		return sel
	end
end

function concatenate_generic(subs,sel)
	line = subs[sel[1]]
	t = line.text:gsub(" *\\[Nn] *"," ")
	
	line2 = subs[sel[2]]
	t2 = line2.text:gsub(" *\\[Nn] *"," ")
	
	ct3 = t2:gsub("^{[^}]-}","")
	 
	tt = t:match("^{\\[^}]-}") or ""
	tt2 = t2:match("^{[^}]-}") or ""
	
	tt1 = tt:gsub("\\an?%d",""):gsub("\\%a%a+%b()",""):gsub("\\q%d",""):gsub("\\t%([^\\]*%)",""):gsub("{}","")
	tt2 = tt2:gsub("\\an?%d",""):gsub("\\%a%a+%b()",""):gsub("\\q%d",""):gsub("\\t%([^\\]*%)",""):gsub("{}","")
	
	--[[ removing repetitions of tags when possible
		example: if we have two lines like 1:{\i1}abc 2:{\i1}xyz
		it will turn to {\i1}abc xyz
		example2: 1:{\i1}abc{\i0} 2:{\i1}xyz{\i0} -> {\i1}abc{\i0}xyz{\i0}
		which is fixed after adding the \\N in the middle: check above ]]
	if not tt1:match("\\t") and not tt2:match("\\t") then
		for tag in tt1:gmatch("\\[^\\}]+") do
			tt2 = tt2:gsub(esc(tag),"")
		end
	end

	return {t, tt2, ct3}
end

function can_join(subs, sel)
	return #sel == 2
end


function esc(str) str = str:gsub("[%%%(%)%[%]%.%-%+%*%?%^%$]","%%%1") return str end

aegisub.register_macro("Join-Dialogue/Join with \\N", "Joins lines with \\N", concatenate_n, can_join)
aegisub.register_macro("Join-Dialogue/Create dialogue", "Creates dialog with –", create_dialogue, can_join)
