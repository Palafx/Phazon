--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Monster Zones (yours)
Debug.AddCard(1231264,0,0,LOCATION_MZONE,0,POS_FACEUP_ATTACK,true)
Debug.AddCard(1231265,0,0,LOCATION_MZONE,4,POS_FACEUP_ATTACK,true)

--Monster Zones (opponent's)
Debug.AddCard(89631139,1,1,LOCATION_MZONE,3,POS_FACEUP_ATTACK,true)
Debug.AddCard(46986419,1,1,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)
Debug.AddCard(77585513,1,1,LOCATION_MZONE,1,POS_FACEUP_ATTACK,true)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()