GlobalQuestSystem = {}
GlobalQuestSystem.Init = function()
	API.CreateQuest
	{
		Name 	= "000",
		Sender 	= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_AlwaysActive()
	};
	API.CreateQuest
	{
		Name 		= "001",
		Suggestion 	= API.Localize({de = "Es ist an der Zeit, hier den Titel Erzherzog zu erreichen und die beiden Störenfriede zu beseitigen!",
									en = "We need to reach the title Archduke/Archduchess and eliminate the two troublemakers!"}),
		Success 	= API.Localize({de = "Schön.", en = "Nice."}),
		Sender 		= 1,

		Goal_KnightTitle("Archduke"),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("000", 3)
	};
	API.CreateQuest
	{
		Name 		= "002",
		Suggestion 	= API.Localize({de = "Die erste Stadt muss fallen!", en = "The first city must fall!"}),
		Success 	= API.Localize({de = "Schön.", en = "Nice."}),
		Sender 		= 1,

		Goal_DestroyPlayer(2),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("000", 5)
	};
	API.CreateQuest
	{
		Name 		= "003",
		Suggestion 	= API.Localize({de = "Und die zweite gleich hinterher!", en = "And the second one too, of course!"}),
		Success 	= API.Localize({de = "Schön.", en = "Nice."}),
		Sender 		= 1,

		Goal_DestroyPlayer(3),
		Reward_MapScriptFunction("GlobalQuestSystem_FreeLostCity"),
		Trigger_OnQuestSuccess("000", 7)
	};
	API.CreateQuest
	{
		Name 		= "004",
		Suggestion 	= API.Localize({de = "Das Grab des gefallenen Tyrannen muss wieder für Pilger zugänglich sein. Wir müssen das Territorium sichern!", 
									en = "The grave of the fallen tyrant must be available for the pilgrims again. We need to secure the territorium!"}),
		Sender 		= 1,

		Goal_Claim("Lost City"),
		Reward_FakeVictory(),
		Trigger_OnAtLeastXOfYQuestsSuccess(3, 3, "001", "002", "003")
	};
	API.CreateQuest
	{
		Name 		= "005",
		Success 	= API.Localize({de = "Wir haben gewonnen!", en = "We have won!"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_MapScriptFunction("GlobalQuestSystem_GameWon"),
		Trigger_OnQuestSuccess("004", 6)
	};
end
GlobalQuestSystem_GameWon = function()
	API.StartDelay(8,
		function()
			GlobalCameraSystem.ShowEndBriefing()
		end)
end
GlobalQuestSystem_FreeLostCity  = function()
	Logic.SetTerritoryPlayerID(GetTerritoryIDByName("Lost City"), 0);
end
-- #EOF