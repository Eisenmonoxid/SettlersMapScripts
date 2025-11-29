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
		Suggestion 	= API.Localize({de = "Was für eine furchtbare Reise. Schwerer Seegang und diese Schaukelei ... ich fürchte, mein Magen wird mir das nie verzeihen.",
									en = "What a horrible journey. Heavy seas and all this rocking ... I fear my stomach will never forgive me."}),
		Success 	= API.Localize({de = "Nichtsdestotrotz ist der Hafenmeister mein erster Ansprechpartner. Bevor ich in diesen Landen ohne Ziel mäandere, sollte es mir möglich sein, durch ihn den Verlauf meines Weges in Erfahrung bringen zu können.", 
									en = "Nevertheless, the harbour master is my first point of contact. Before wandering aimlessly in these lands, I should be able to determine my path through him."}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("000", 5)
	};
	API.CreateQuest
	{
		Name 		= "002",
		Suggestion 	= API.Localize({de = "Mal sehen, was man mir mittzuteilen hat.", en = "Let's see what they have to tell me."}),
		Success 	= API.Localize({de = "Seid gegrüßt, Herr Hafenmeister. Ich denke, ihr erwartet mich bereits.", 
									en = "Greetings, harbour master. I believe you were expecting me."}),
		Sender 		= 1,

		Goal_NPC("Hafenmeister"),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("001", 3)
	};
	API.CreateQuest
	{
		Name 		= "003",
		Suggestion 	= API.Localize({de = "Gott zum Gruße an den Herrn Ritter hoch zu Ross. Ihr wäret Thordal, der Barde? Wenn ja, hat man mir euer Erscheinen im Voraus angekündigt, wie von euch bereits treffend bemerkt.", en = "Greetings to the knight on horseback. Are you Thordal, the bard? If so, your arrival was announced to me in advance, as you rightly pointed out."}),
		Success 	= API.Localize({de = "Die euch zugeteilte Siedlung befindet sich im Süden. Folgt der Straße, trotzt den Wegelagerern und erreicht euer Ziel.", 
									en = "Your assigned settlement is located in the south. Follow the road, brave the bandits, and reach your destination."}),
		Sender 		= 6,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("002", 3)
	};
	API.CreateQuest
	{
		Name 		= "004",
		Suggestion 	= API.Localize({de = "Wenn ihr exotische Güter erwerben wollt, steht euch das Lager des Hafens immer zur Verfügung. Ich habe den leisen Verdacht, dass einige dieser Waren unerlässlich beim Aufbau einer Stadt sein werden.", en = "If you wish to acquire exotic goods, the harbour's warehouse is always available to you. I have a suspicion that some of these goods will be essential for building a city."}),
		Success 	= API.Localize({de = "Ich möchte euch auf eurem Weg viel Glück wünschen. Auf Wiedersehen.", 
									en = "I wish you the best of luck on your journey. Farewell."}),
		Sender 		= 6,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("003", 3)
	};
	API.CreateQuest
	{
		Name 		= "005",
		Suggestion 	= API.Localize({de = "Habt Dank, Herr Hafenmeister. Ich mache mich sogleich auf den Weg.", en = "Thank you, harbour master. I will set off right away."}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("004", 3)
	};
	API.CreateQuest
	{
		Name 		= "006",
		Suggestion 	= API.Localize({de = "Ab in den Süden. Bis ich dort bin, sollte es auch langsam Tag werden.", en = "Off to the south. By the time I get there, it should be daylight."}),
		Sender 		= 1,

		Goal_EntityDistance(Logic.GetKnightID(1), Logic.GetStoreHouse(1), "<", 6000),
		Reward_MapScriptFunction(GlobalCameraSystem.ShowMainTerritoryCutscene),
		Reward_MapScriptFunction(GlobalQuestSystem.AddResourcesToStart),
		Reward_ObjectActivate("tradepost_03", 1),
		Trigger_OnQuestSuccess("005", 3)
	};
	API.CreateQuest
	{
		Name 		= "007",
		Suggestion 	= API.Localize({de = "Das ist also meine neue Heimat. Nun gut. Mal sehen, was sich damit machen lässt. Ein erster Grundstein muss gelegt werden!", en = "So this is my new home. Alright. Let's see what can be done with it. A first foundation must be laid!"}),
		Success 	= API.Localize({de = "Die kleine Siedlung läuft und ich bin Baron. Damit kann ich mich nun um meine eigentliche Mission hier kümmern. Ich sollte einmal mit den hier ansässigen Parteien sprechen!", 
									en = "The small settlement is running, and I am a baron. Now I can focus on my real mission here. I should speak to the local parties!"}),
		Sender 		= 1,

		Goal_KnightTitle("Baron"),
		Reward_MapScriptFunction(GlobalQuestSystem.PumpHandlerQuestline),
		Reward_MapScriptFunction(GlobalQuestSystem.BloodMoonQuestline),
		Reward_MapScriptFunction(GlobalQuestSystem.VillageQuestLine),
		Reward_Diplomacy(1, 7, "EstablishedContact"),
		Reward_Diplomacy(1, 4, "EstablishedContact"),
		Trigger_OnQuestSuccess("006", 8)
	};
end

GlobalQuestSystem.PumpHandlerQuestline = function()
	API.CreateQuest
	{
		Name 		= "P001",
		Suggestion 	= API.Localize({de = "In der Nähe der Banditen gibt es im Wald ein kleines Lager. Ich sollte mir das einmal genauer ansehen!", en = "There is a small camp in the forest near the bandits. I should take a closer look!"}),
		Sender 		= 1,

		Goal_EntityDistance(Logic.GetKnightID(1), "Pumpenwart", "<", 1200),
		Reward_FakeVictory(),
		Trigger_AlwaysActive()
	};
	API.CreateQuest
	{
		Name 		= "P002",
		Suggestion 	= API.Localize({de = "Wos is los? I? Wer i bin? Wos i do moch? I bin fia die Pumpn do und schau, dass do ois so laft wies suit.", en = "What's going on? Me? Who am I? What am I doing here? I'm here for the pumps, making sure everything runs as it should."}),
		Success 	= API.Localize({de = "Wenn die Pumpn ausfoin würd, wea des a scheina Schlamassl. Deswegen wirf ih do mei wachsames Auge drauf!", 
									en = " If the pumps were to fail, that'd be quite a mess. That's why I keep a watchful eye on them!"}),
		Sender 		= 8,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("P001", 1)
	};
	API.CreateQuest
	{
		Name 		= "P003",
		Suggestion 	= API.Localize({de = "Owa sogns moi, der Herr Ritter, i kaun do leider ned weg, zu hoch is die Gfoahr dass'd do wos passian wüad. Owa as Essn wiad laungsaum knopp, und die Lieferung is ned kumman.", en = "But tell me, Sir Knight, I can't leave here because the risk of something happening is too high. But food is running low, and the delivery hasn’t arrived."}),
		Success 	= API.Localize({de = "Kennts eis nochschaun gei, wos do mit da Lieferung los is? Wuin mi dei vahungaun lossn oda wos sui deis? Wia i do wegrationalisiert? Gengans doch bitte in die Stodt nochfrogn!", 
									en = "Could you check what’s going on with the delivery? Do you want me to starve, or what should I do? Get laid off here? Please go to the city and ask about it!"}),
		Sender 		= 8,

		Goal_InstantSuccess(),
		Reward_Diplomacy(1, 2, "EstablishedContact"),
		Trigger_OnQuestSuccess("P002", 3)
	};
	API.CreateQuest
	{
		Name 		= "P004",
		Suggestion 	= API.Localize({de = "Kein Problem, Herr Pumpenwart, ein Ritter hilft, wo er kann. Ich werde in der Stadt nachfragen, warum eure Vorratslieferung nicht angekommen ist!", en = "No problem, Mr. Pump Keeper. A knight helps wherever he can. I'll ask in the city why your supply delivery hasn’t arrived!"}),
		Success 	= API.Localize({de = "Guten Tag der Herr. Mein Name ist Thordal, ich bin der neue Verwalter des kleinen Weilers im Süden. Der Bürgermeister, wenn man so möchte. Wer seid denn ihr?", 
									en = "Good day, sir. My name is Thordal. I am the new administrator of the small hamlet in the south. The mayor, so to speak. Who are you?"}),
		Sender 		= 1,

		Goal_EntityDistance(Logic.GetKnightID(1), Logic.GetKnightID(2), "<", 1200),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("P003", 3)
	};
	API.CreateQuest
	{
		Name 		= "P005",
		Suggestion 	= API.Localize({de = "Soso, ihr seid es also, der die Aufbautätigkeiten im Süden vorantreibt. Ich war mir sicher, ihr würdet früher oder später hier aufschlagen.", en = "So, you’re the one advancing the construction efforts in the south. I was certain you’d show up here sooner or later."}),
		Success 	= API.Localize({de = "Mein Name ist Praphat. Wie euch aufgrund meiner Aufmachung sicherlich nicht entgangen sein dürfte, stamme ich aus dem fernen Osten.", 
									en = "My name is Praphat. As you’ve probably noticed from my appearance, I hail from the distant east."}),
		Sender 		= 2,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("P004", 3)
	};
	API.CreateQuest
	{
		Name 		= "P006",
		Suggestion 	= API.Localize({de = "Ja, ihr wirkt durchaus etwas ... herausstechend. Das soll mich aber keinesfalls stören.", en = "Yes, you do stand out a bit ... strikingly. But that doesn’t bother me at all."}),
		Success 	= API.Localize({de = "Tatsächlich komme ich im Auftrag des Pumpenwarts am Gebirgsfluss zu euch. Er hat mich gebeten, nach dem Status seiner Vorratslieferung zu fragen. Scheinbar ist diese nicht wie erwartet bei ihm eingetroffen.", 
									en = "In fact, I’m here on behalf of the pump keeper by the mountain river. He asked me to inquire about the status of his supply delivery. Apparently, it didn’t arrive as expected."}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("P005", 3)
	};
	API.CreateQuest
	{
		Name 		= "P007",
		Suggestion 	= API.Localize({de = "Ach ... er schickt euch also. Nun gut. Die Lieferung wird von Wegelagerern abgefangen. Ihr seid diesem Gesindel auf dem Weg hierher sicherlich schon begegnet.", en = "Ah ... so he sent you. Very well. The delivery is being intercepted by bandits. You’ve probably encountered this rabble on your way here."}),
		Success 	= API.Localize({de = "Ich hatte noch keine Zeit, mich darum zu kümmern. Wenn ihr es schafft, und die Wege wieder sicher sind, können wir - von mir aus - den Handel aufnehmen.", 
									en = "I haven’t had time to deal with it yet. If you manage to secure the roads again, we can resume trade, as far as I’m concerned."}),
		Sender 		= 2,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("P006", 3)
	};
	API.CreateQuest
	{
		Name 		= "P008",
		Suggestion 	= API.Localize({de = "Alles klar! Diese Räuber sind auch für mich wandelnde Störfaktoren. Zwar nicht sonderlich stark, aber sie behindern meine Mission. Weg damit!", en = "Alright! These bandits are a nuisance to me as well. Not particularly strong, but they’re hindering my mission. Let’s get rid of them!"}),
		Success 	= API.Localize({de = "Sehr schön. Damit sind die Handelsstraßen nun sicher.", 
									en = "Excellent. The trade routes are now secure."}),
		Sender 		= 1,

		Goal_DestroyAllPlayerUnits(5),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("P007", 3)
	};
	API.CreateQuest
	{
		Name 		= "P009",
		Suggestion 	= API.Localize({de = "Kommt doch bitte wieder zu mir!", en = "Please come back to me!"}),
		Success 	= API.Localize({de = "Ich habe von euren Taten erfahren. Die Lieferungen können nun wieder ungehindert durchs Land gelangen. Als Dank, dass ihr mir die Arbeit abgenommen habt, öffne ich für euch mein Lagerhaus. Beim Pumpenwart solltet ihr auch nochmals vorbeischauen.", 
									en = "I’ve heard of your deeds. The deliveries can now flow freely through the land again. As thanks for taking the task off my hands, I’m opening my warehouse for you. You should also visit the pump keeper again."}),
		Sender 		= 2,

		Goal_EntityDistance(Logic.GetKnightID(1), Logic.GetKnightID(2), "<", 1200),
		Reward_Diplomacy(1, 2, "TradeContact"),
		Trigger_OnQuestSuccess("P008", 3)
	};
	API.CreateQuest
	{
		Name 		= "P010",
		Success 	= API.Localize({de = "Die Lieferung is do, und i muass nerma hungern! I daunk eich tausendmoi, Herr Ritter! Eis keinnts jetzt ah mit mir haundln, wauns' wuits.", 
									en = "The delivery is here, and I don’t have to go hungry anymore! Thank you a thousand times, Sir Knight! You can trade with me now if you want."}),
		Sender 		= 8,

		Goal_EntityDistance(Logic.GetKnightID(1), "Pumpenwart", "<", 1200),
		Reward_Diplomacy(1, 8, "TradeContact"),
		Reward_MapScriptFunction(GlobalQuestSystem.UpdatePumpHandlerLine),
		Trigger_OnQuestSuccess("P008", 3)
	};
end

GlobalQuestSystem.PumpHandlerLine = false;
GlobalQuestSystem.VillageLine = false;
GlobalQuestSystem.CloisterLine = false;
GlobalQuestSystem.UpdatePumpHandlerLine = function()
	GlobalQuestSystem.PumpHandlerLine = true;
end
GlobalQuestSystem.UpdateVillageLine = function()
	GlobalQuestSystem.VillageLine = true;
end
GlobalQuestSystem.UpdateCloisterLine = function()
	GlobalQuestSystem.CloisterLine = true;
end
GlobalQuestSystem.TriggerThiefQuest = function()
	if GlobalQuestSystem.PumpHandlerLine and GlobalQuestSystem.VillageLine and GlobalQuestSystem.CloisterLine then
		return true;
	else
		return nil;
	end
end

GlobalQuestSystem.BloodMoonQuestline = function()
	API.CreateQuest
	{
		Name 		= "B001",
		Suggestion 	= API.Localize({de = "So beehrt unser bescheidenes Kloster in eurer Barmherzigkeit doch mit eurer Präsenz, Herr Ritter!",
									en = "Please honor our humble monastery with your merciful presence, Sir Knight!"}),
		Success 	= API.Localize({de = "Habt einen von Gott gesegneten wundervollen Tag!", en = "Have a blessed and wonderful day!"}),
		Sender 		= 7,

		Goal_EntityDistance(Logic.GetKnightID(1), "Klostermonk", "<", 1200),
		Reward_FakeVictory(),
		Trigger_AlwaysActive()
	};
	API.CreateQuest
	{
		Name 		= "B002",
		Suggestion 	= API.Localize({de = "Gott zum Gruße, Mönch. Ich suche nach ... Dingen, die in Legenden über diese Region besungen werden.",
									en = "God’s blessings, monk. I am searching for ... things sung about in the legends of this region."}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("B001", 3)
	};
	API.CreateQuest
	{
		Name 		= "B003",
		Suggestion 	= API.Localize({de = "Ach ... Ihr sucht \"danach\" ? Das ist ... unvorteilhaft.",
									en = "Ah ... you’re looking for \"that\"? That is ... unwise."}),
		Success 	= API.Localize({de = "Ich vermute, ihr wisst, worum es sich dabei handelt? Und die Gefahren? Und ihr habt euch trotzdessen entschieden, es zu finden?", en = "I assume you know what it entails? And the dangers? And you’ve still decided to seek it out?"}),
		Sender 		= 7,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("B002", 3)
	};
	API.CreateQuest
	{
		Name 		= "B004",
		Suggestion 	= API.Localize({de = "Ich kann euch nicht sagen, wo es ist. Die Wahrheit ist: Ich weiß es nicht. Es kam aus dem fernen Osten, wurde hier in der Region vergraben. Das ist Jahrhunderte her. Ihr kennt die Legenden.",
									en = "I cannot tell you where it is. The truth is: I don’t know. It came from the distant East, buried here in the region centuries ago. You know the legends."}),
		Success 	= API.Localize({de = "Es gibt jemanden, der den Ort wohl kennt. Er hat Jahre seines Lebens damit zugebracht, danach zu suchen. Aber er wird es euch bestimmt nicht verraten.", en = "There is someone who likely knows the location. He has spent years of his life searching for it. But he surely won’t tell you."}),
		Sender 		= 7,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("B003", 3)
	};
	API.CreateQuest
	{
		Name 		= "B005",
		Suggestion 	= API.Localize({de = "Wenn ich euch einen Rat geben darf: Vergesst das Ganze. Kümmert euch um eure Siedlung, baut sie zu einer Stadt aus.",
									en = "If I may offer advice: Forget about it. Focus on your settlement; build it into a city."}),
		Success 	= API.Localize({de = "Nun muss ich mich wieder meinen Pflichten zuwenden. Einen schönen Tag noch, Herr Ritter.", en = "Now I must return to my duties. Have a good day, Sir Knight."}),
		Sender 		= 7,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("B004", 3)
	};
	API.CreateQuest
	{
		Name 		= "B006",
		Suggestion 	= API.Localize({de = "Ebenso. Auf Wiedersehen.",
									en = "Likewise. Goodbye."}),
		Success 	= API.Localize({de = "(Das ist schlecht. Aber ich weiß, was zu tun ist)", en = "(This is bad. But I know what to do.)"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_MapScriptFunction(GlobalQuestSystem.UpdateCloisterLine),
		Reward_Diplomacy(1, 7, "TradeContact"),
		Reward_ObjectActivate("tradepost_02", 1),
		Trigger_OnQuestSuccess("B005", 3)
	};
	API.CreateQuest
	{
		Name 		= "B007",
		Suggestion 	= API.Localize({de = "Wir können die Information, die den Aufenthaltsort verrät, stehlen lassen. Ein Dieb muss in die Burg vordringen, am besten, ohne Verdacht zu erregen.",
									en = "We can have the information revealing the location stolen. A thief must infiltrate the castle, preferably without arousing suspicion."}),
		Success 	= API.Localize({de = "Der Dieb ist erfolgreich zurückgekehrt. Mal sehen, was sich finden ließ.", en = "The thief has returned successfully. Let’s see what was found."}),
		Sender 		= 1,

		Goal_StealInformation("EnemyTent"),
		Reward_MapScriptFunction(GlobalQuestSystem.ResetCastle),
		Reward_MapScriptFunction(GlobalQuestSystem.ArchdukeNeeded),
		Trigger_MapScriptFunction(GlobalQuestSystem.TriggerThiefQuest),
	};
end

GlobalQuestSystem.ArchdukeNeeded = function()
	API.CreateQuest
	{
		Name 		= "A001",
		Suggestion 	= API.Localize({de = "Ich fürchte, es ist nur eine Frage der Zeit, bis der Kastellan Praphat meine wahren Absichten erkennt und unseren Diebstahl bemerkt. Eine große, wehrhafte Stadt mit angemessenem Titel für mich wird unumgänglich sein.", en = "I fear it is only a matter of time before Castellan Praphat discovers my true intentions and notices our theft. A large, fortified city with an appropriate title for me will be indispensable."}),
		Success 	= API.Localize({de = "Das wäre geschafft.", 
									en = "That’s done."}),
		Sender 		= 1,

		Goal_KnightTitle("Duke"),
		Reward_MapScriptFunction(GlobalQuestSystem.BloodMoonActivated),
		Trigger_AlwaysActive(),
	};
	API.CreateQuest
	{
		Name 		= "A002",
		Suggestion 	= API.Localize({de = "Praphat konnte den Aufenthaltsort bestimmen. Aber er hat es niemals genutzt. Wieso nicht? Wegen den Gefahren? Was für ein Angsthase.", en = "Praphat was able to determine the location. But he never used it. Why not? Because of the dangers? What a coward."}),
		Success 	= API.Localize({de = "Es gibt eine Opferstätte in der Nähe der Burgruine südlich des Dorfes. Dort müssen Gold und Edelsteine dargebracht werden. Danach wird sich grenzenlose Macht mir offenbaren. Kein Problem.", 
									en = "There is a sacrificial site near the castle ruins south of the village. Gold and gems must be offered there. Then boundless power will be revealed to me. No problem."}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_AlwaysActive(),
	};
end

GlobalQuestSystem.BloodMoonActivated = function()
	GlobalQuestSystem.CreateBloodMoonObject();
	API.CreateQuest
	{
		Name 		= "M001",
		Suggestion 	= API.Localize({de = "Wir haben alle Informationen und sind Herzog. Gold und Edelsteine sind die Opfergaben, die erbracht werden müssen. Ich sollte zur Opferstätte reiten!", en = "We have all the information and are now a Duke. Gold and gems are the sacrifices that must be offered. I should ride to the sacrificial site!"}),
		Sender 		= 1,

		Goal_EntityDistance(Logic.GetKnightID(1), "BloodMoonObject", "<", 3500),
		Reward_MapScriptFunction(GlobalCameraSystem.ShowCastleCutscene),
		Trigger_AlwaysActive(),
	};
	API.CreateQuest
	{
		Name 		= "M002",
		Suggestion 	= API.Localize({de = "Es ist soweit. Wenn meine Informationen korrekt sind, befindet es sich hier. Wenn ich die Opfergaben darbringe, sollte alles laufen.", en = "The time has come. If my information is correct, it is here. Once I offer the sacrifices, everything should proceed."}),
		Success 	= API.Localize({de = "Das wäre es gewesen. Eigentlich sollte jetzt etwas geschehen.", 
									en = "That should have done it. Something should be happening now."}),
		Sender 		= 1,

		Goal_ActivateObject("BloodMoonObject"),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("M001", 2),
	};
	API.CreateQuest
	{
		Name 		= "M003",
		Suggestion 	= API.Localize({de = "Hmmm ... was ist das?", en = "Hmm... what’s this?"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("M002", 12),
	};
	API.CreateQuest
	{
		Name 		= "M004",
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_MapScriptFunction(GlobalQuestSystem.ActivateBloodMoon),
		Trigger_OnQuestSuccess("M003", 2),
	};
	API.CreateQuest
	{
		Name 		= "M005",
		Suggestion 	= API.Localize({de = "Hahaha. Ich wusste es. Ich hatte Recht! Die alten Legenden hatten Recht! Diese Macht ... meine Macht! Niemand wird mich aufhalten können. ", en = "Hahaha. I knew it. I was right! The old legends were true! This power... my power! No one will be able to stop me."}),
		Success 	= API.Localize({de = "Jetzt geht es zur Sache. Zieht euch warm an, Kastellan Praphat! Ihr werdet der erste sein, der Zeuge meiner Macht werden wird!", 
									en = "Now the real action begins. Brace yourself, Castellan Praphat! You will be the first to witness my power!"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("M003", 15),
	};
	API.CreateQuest
	{
		Name 		= "M006",
		Suggestion 	= API.Localize({de = "Der Geisterturm der Verdammnis ist ein treuer Diener des Blutmondes. Wenn wir ihm den Befehl erteilen, wird er uns in die Schlacht folgen und uns als Verbündeter zur Seite stehen!", en = "The Ghost Tower of Doom is a loyal servant of the Blood Moon. If we command it, it will join us in battle and stand as an ally by our side!"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_MapScriptFunction(HookLibHandler.CreateMovingObject),
		Reward_Diplomacy(1, 2, "Enemy"),
		Trigger_OnQuestSuccess("M005", 15),
	};
	API.CreateQuest
	{
		Name 		= "M007",
		Suggestion 	= API.Localize({de = "Mithilfe des Geisterturms werden die Mauern des Feindes kein Problem darstellen! Kastellan Praphat, macht euch auf etwas gefasst!", en = "With the help of the Ghost Tower, the enemy's walls will be no problem! Castellan Praphat, prepare yourself!"}),
		Sender 		= 1,

		Goal_DestroyPlayer(2),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("M006", 3),
	};
	API.CreateQuest
	{
		Name 		= "M008",
		Suggestion 	= API.Localize({de = "Dieser Irre hat es tatsächlich getan. Unfassbar. Soviel Macht sollte nicht in den Händen einer Person sein! Männer, schließt die Tore und macht euch kampfbereit!", en = "That lunatic actually did it. Unbelievable. Such power should not be in the hands of one person! Men, close the gates and prepare for battle!"}),
		Sender 		= 2,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("M006", 6),
	};
	API.CreateQuest
	{
		Name 		= "M009",
		Suggestion 	= API.Localize({de = "Na bitte!", en = "There we go!"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("M007", 3),
	};
	API.CreateQuest
	{
		Name 		= "M010",
		Suggestion 	= API.Localize({de = "Wir haben gewonnen!", 
									en = "We won!"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_MapScriptFunction(GlobalQuestSystem.BuildShip),
		Trigger_OnQuestSuccess("M009", 3),
	};
end

GlobalQuestSystem.VillageQuestLine = function()
	API.CreateQuest
	{
		Name 		= "V001",
		Suggestion 	= API.Localize({de = "Wenn ihr eure Siedler mit erlesenen Luxusgütern verwöhnen wollt, Herr Ritter, so stattet unserem Dorf doch einen Besuch ab!",
									en = "If you want to treat your settlers to exquisite luxury goods, Sir Knight, then pay a visit to our village!"}),
		Success 	= API.Localize({de = "Herzlich Willkommen!", en = "Welcome!"}),
		Sender 		= 4,

		Goal_EntityDistance(Logic.GetKnightID(1), "Dorfarbeiter", "<", 1200),
		Reward_FakeVictory(),
		Trigger_AlwaysActive()
	};
	API.CreateQuest
	{
		Name 		= "V002",
		Suggestion 	= API.Localize({de = "Ich wünsche einen gesegneten Tag. Eure Einladung erwähnte Luxusgüter. Was hat es damit auf sich?",
									en = "I wish you a blessed day. Your invitation mentioned luxury goods. What is this about?"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("V001", 3)
	};
	API.CreateQuest
	{
		Name 		= "V003",
		Suggestion 	= API.Localize({de = "Wir sind Händler, Herr Ritter, und verkaufen Waren aus aller Welt. Wenn ihr möchtet, könnt ihr euch an unserem Warenbestand bedienen!",
									en = "We are traders, Sir Knight, and sell goods from all over the world. If you like, you can help yourself to our stock!"}),
		Success 	= API.Localize({de = "Und wenn ich euch persönlich einen Tipp geben darf: Haltet euch von der alten Burgruine auf dem Plateu südlich unserer Position fern! Dieser Ort hat noch niemandem Glück gebracht.", en = "And if I may personally give you a tip: Stay away from the old castle ruin on the plateau south of our position! This place has never brought anyone luck."}),
		Sender 		= 4,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("V002", 3)
	};
		API.CreateQuest
	{
		Name 		= "V004",
		Suggestion 	= API.Localize({de = "Ich werde euren Rat beherzigen. Habt vielen Dank!",
									en = "I will heed your advice. Thank you very much!"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_Diplomacy(1, 4, "TradeContact"),
		Reward_MapScriptFunction(GlobalQuestSystem.UpdateVillageLine),
		Reward_ObjectActivate("tradepost_01", 1),
		Trigger_OnQuestSuccess("V003", 3)
	};
end

GlobalQuestSystem.BuildShip = function()
	GlobalQuestSystem.DeleteAllTradeShips();
	API.SpeedLimitActivate(false);
	API.DisableSaving(false);
	API.CreateQuest
	{
		Name 		= "E001",
		Suggestion 	= API.Localize({de = "Nichts wird mich mehr aufhalten können! Dank des Blutmondes werde ich unbesiegbar sein. Also Zeit, dieses Loch hier zu verlassen und die Schlachtfelder des Erdballs aufzusuchen! Ab zum Hafen.", en = "Nothing will stop me now! Thanks to the Blood Moon, I will be invincible. Time to leave this hole and head for the battlefields of the world! Off to the harbor."}),
		Success 	= API.Localize({de = "Hafenmeister, ich brauche ein Schiff. So schnell wie möglich! Und der Geisterturm kann sich derweil hier die Zeit vertreiben.", en = "Harbormaster, I need a ship. As quickly as possible! And the Ghost Tower can entertain itself here in the meantime."}),
		Sender 		= 1,

		Goal_EntityDistance(Logic.GetKnightID(1), "Hafenmeister", "<", 1000),
		Reward_MapScriptFunction(HookLibHandler.ToggleObjectFollowing),
		Trigger_AlwaysActive(),
	};
	API.CreateQuest
	{
		Name 		= "E002",
		Suggestion 	= API.Localize({de = "Es tut mir Leid, Herr Ritter, aber aufgrund der momentanen Situation weigern sich die Händler, den Hafen anzulaufen. Wenn das Wetter wieder normalen Bedingungen entspricht, können wir darüber reden.", en = "I'm sorry, Sir Knight, but due to the current situation, the merchants refuse to dock at the harbor. Once the weather returns to normal conditions, we can talk about it."}),
		Sender 		= 6,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("E001", 3),
	};
	API.CreateQuest
	{
		Name 		= "E003",
		Suggestion 	= API.Localize({de = "Nun, was diesen Umstand betrifft, habe ich schlechte Nachrichten. So schnell wird sich der Himmel nicht ändern, hehe.", en = "Well, as for this situation, I have bad news. The sky won't change that quickly, hehe."}),
		Success 	= API.Localize({de = "Wenn kein Schiff kommen will, muss eben eines gebaut werden. Ich liefere euch das Material. Ihr kümmert euch um den Rest.", en = "If no ship wants to come, then one has to be built. I'll supply the materials. You take care of the rest."}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("E002", 3),
	};
	API.CreateQuest
	{
		Name 		= "E004",
		Suggestion 	= API.Localize({de = "Nun gut. Eine Aufwandsentschädigung für meine Mühen ist natürlich in den Materialkosten inkludiert.", en = "Very well. A compensation for my efforts is, of course, included in the material costs."}),
		Sender 		= 6,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("E003", 3),
	};
	API.CreateQuest
	{
		Name 		= "E005",
		Suggestion 	= API.Localize({de = "Gold für die Arbeiter, die Ingenieure und natürlich für mich.", en = "Gold for the workers, the engineers, and of course for me."}),
		Sender 		= 6,

		Goal_Deliver("G_Gold", 12500, 6, false),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("E004", 3),
	};
	API.CreateQuest
	{
		Name 		= "E006",
		Suggestion 	= API.Localize({de = "Wenig überraschend ist Bauholz unerlässlich.", en = "Not surprisingly, construction wood is essential."}),
		Sender 		= 6,

		Goal_Deliver("G_Wood", 250, 6, false),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("E004", 6),
	};
	API.CreateQuest
	{
		Name 		= "E007",
		Suggestion 	= API.Localize({de = "Wolle ist auch eine Notwendigkeit.", en = "Wool is also a necessity."}),
		Sender 		= 6,

		Goal_Deliver("G_Wool", 95, 6, false),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("E004", 9),
	};
	API.CreateQuest
	{
		Name 		= "E008",
		Suggestion 	= API.Localize({de = "Eisen hält den Rumpf zusammen.", en = "Iron holds the hull together."}),
		Sender 		= 6,

		Goal_Deliver("G_Iron", 125, 6, false),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("E004", 12),
	};
	API.CreateQuest
	{
		Name 		= "E009",
		Suggestion 	= API.Localize({de = "Das Schiff ist fertig. Gesellt euch zu mir, um es zu begutachten.", en = "The ship is ready. Join me to inspect it."}),
		Success		= API.Localize({de = "Na, was sagt ihr? Feinste Handwerkskunst, nicht wahr?", en = "Well, what do you think? Finest craftsmanship, isn't it?"}),
		Sender 		= 6,

		Goal_EntityDistance(Logic.GetKnightID(1), "Hafenmeister", "<", 1000),
		Reward_MapScriptFunction(GlobalQuestSystem.SpawnTradeShip),
		Trigger_OnAtLeastXOfYQuestsSuccess(4, 4, "E005", "E006", "E007", "E008"),
	};
	API.CreateQuest
	{
		Name 		= "E010",
		Suggestion 	= API.Localize({de = "Sieht gut aus. Eines Helden würdig. Wir reisen sofort ab. Nichts hält mich hier länger als es nötig ist.", en = "Looks good. Worthy of a hero. We leave immediately. Nothing will keep me here longer than necessary."}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_FakeVictory(),
		Trigger_OnQuestSuccess("E009", 4),
	};
	API.CreateQuest
	{
		Name 		= "E011",
		Suggestion 	= API.Localize({de = "(Welt, ich komme. Wartet nur ab!)", en = "(World, here I come. Just wait and see!)"}),
		Sender 		= 1,

		Goal_InstantSuccess(),
		Reward_MapScriptFunction(GlobalQuestSystem.GameWon),
		Trigger_OnQuestSuccess("E010", 2),
	};
end

GlobalQuestSystem.SpawnTradeShip = function()
	Logic.SetVisible(GetID("leaving_ship"), true);
end

GlobalQuestSystem.DeleteAllTradeShips = function()
	local Ships = Logic.GetEntitiesOfType(Entities.D_X_TradeShip);
	for i = 1, #Ships do
		Logic.SetVisible(Ships[i], false);
	end
end

GlobalQuestSystem.AddResourcesToStart = function()
	Logic.AddGoodToStock(Logic.GetHeadquarters(1), Goods.G_Gold, 3500)
	Logic.AddGoodToStock(Logic.GetStoreHouse(1), Goods.G_Wood, 45)
	Logic.AddGoodToStock(Logic.GetStoreHouse(1), Goods.G_Stone, 25)
end

GlobalQuestSystem.CreateBloodMoonObject = function()
	local posX, posY = Logic.EntityGetPos(GetID("briefing_pos06"));
	local ID = Logic.CreateEntity(Entities.I_X_Ruins_NE_01, posX, posY, 0, 0);
	Logic.SetModel(ID, Models.Effects_E_Mosquitos);
	Logic.SetEntityName(ID, "BloodMoonObject");

	Logic.InteractiveObjectSetInteractionDistance(ID, 1000);
	Logic.SetEntityInvulnerabilityFlag(ID, true);
	
	SetupInteractiveObject(ID, 0, {Goods.G_Gold, 2500, Goods.G_Gems, 25}, {Entities.U_GoldCart, Entities.U_ResourceMerchant});
	API.InteractiveObjectDeactivate("BloodMoonObject")
end

GlobalQuestSystem.ResetCastle = function()
	Logic.DestroyEntity(GetID("EnemyTent"))
	Logic.SetVisible(Logic.GetHeadquarters(2), true)
end

GlobalQuestSystem.ActivateBloodMoon = function()
	local BloodMoonTimer = 28;
	Logic.ExecuteInLuaLocalState([[
		Display.StopAllEnvironmentSettingsSequences();
		Display.StopUsingExplicitEnvironmentSettings();
		Display.PlayEnvironmentSettingsSequence(Display.AddEnvironmentSettingsSequence('sun_to_bloodmoon.xml'), ]]..BloodMoonTimer..[[);
	]]);
	
	StartSimpleJobEx(GlobalQuestSystem.BloodMoonSwitchAfterSequence, BloodMoonTimer);
	
	API.DisableSaving(true);
	API.SpeedLimitActivate(true);
	GlobalAttacksActive = true;
	GlobalBloodMoonActivated = true;
	ToggleGodrayVisibility(false);
	API.HideMinimap(false);
	
	API.SoundSetAtmoVolume(0);
	API.StartEventPlaylist(gvMission.PlaylistRootPath .. "start_theme.xml");
	
	API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, function()
		if GlobalBloodMoonActivated then
			Logic.ExecuteInLuaLocalState([[
				Display.StopAllEnvironmentSettingsSequences();
				Display.StopUsingExplicitEnvironmentSettings();
				Display.SetExplicitEnvironmentSettings("red_blood_moon_night.xml");
			]]);
		end
	end);
end

GlobalQuestSystem.BloodMoonSwitchAfterSequence = function(_timer)
	GlobalQuestSystem.BloodMoonTimer = GlobalQuestSystem.BloodMoonTimer or 0
	GlobalQuestSystem.BloodMoonTimer = GlobalQuestSystem.BloodMoonTimer + 1
	
	if GlobalQuestSystem.BloodMoonTimer >= (_timer - 6) then
		Logic.ExecuteInLuaLocalState([[
			Display.StopAllEnvironmentSettingsSequences();
			Display.StopUsingExplicitEnvironmentSettings();
			Display.SetExplicitEnvironmentSettings("red_blood_moon_night.xml");
		]]);
		return true;
	end
end

GlobalQuestSystem.GameWon = function()
	API.StartDelay(4,
		function()
			GlobalCameraSystem.ShowEndBriefing()
		end)
end
-- #EOF