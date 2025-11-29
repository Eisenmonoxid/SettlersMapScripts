function SetMyBuildingCosts()
	LoadBuildingCostSystem()
	BCS.SetKnockDownFactor(0, 0)
	BCS.SetRefundCityGoods(false)
	BCS.SetCountGoodsOnMarketplace(false)
end
function LoadBuildingCostSystem()
	-- Initialize BCS --
	if BCS ~= nil then
		-- Init System
		BCS.InitializeBuildingCostSystem()
		-- Add Savegame when QSB is present
		if (API and QSB) then
			-- Register Savegame
			if API.AddSaveGameAction then -- QSB-S 2.x
				GUI.SendScriptCommand([[
					API.AddSaveGameAction(function()
						Logic.ExecuteInLuaLocalState('BCS.InitializeBuildingCostSystem()')
					end)
				]])
				Framework.WriteToLog("BCS: QSB-S 2.x found! AddSaveGameAction for Savegame registered!")
			elseif API.AddScriptEventListener and QSB.ScriptEvents ~= nil then -- QSB-S 3.x
				API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, BCS.InitializeBuildingCostSystem)
				API.AddScriptEventListener(QSB.ScriptEvents.BriefingEnded, BCS.OverwriteEndScreenCallback)
				Framework.WriteToLog("BCS: QSB-S 3.x found! ScriptEventListener for Savegame and BriefingEnded registered!")
			else
				Framework.WriteToLog("BCS: QSB-S found, but no Savegame registered. Has to be done manually!")
			end
		else
			Framework.WriteToLog("BCS: QSB-S NOT found! Savegamehandling has to be done manually!")
		end
	else
		local ErrorMessage = "ERROR: Could not load BuildingCostSystem!"
		Framework.WriteToLog(ErrorMessage)
		assert(false, ErrorMessage)
		return;
	end
	-- Done --
end
--#EOF