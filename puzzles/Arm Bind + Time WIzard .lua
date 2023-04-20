--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Monster Zones (yours)
Debug.AddCard(2964201,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)
Debug.AddCard(65570596,0,0,LOCATION_MZONE,3,POS_FACEUP_ATTACK,true)
Debug.AddCard(89631146,0,0,LOCATION_MZONE,1,POS_FACEUP_ATTACK,true)
Debug.AddCard(1231262,0,0,LOCATION_MZONE,4,POS_FACEUP_ATTACK,true)

--Spell & Trap Zones (yours)
Debug.AddCard(1231254,1,1,LOCATION_SZONE,2,POS_FACEDOWN)

--Monster Zones (opponent's)

Debug.AddCard(3557275,1,1,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()