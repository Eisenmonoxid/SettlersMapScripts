ISDEBUG = false;
local Path = (ISDEBUG == true) and "C:\\Siedler\\" or "maps/externalmap/" ..Framework.GetCurrentMapName().. "/";
if GUI then
	Script.Load(Path .. "local.lua")
else
	Script.Load(Path .. "global.lua")
end