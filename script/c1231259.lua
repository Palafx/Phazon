 --Roll of Fate
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct={}
	for i=6,1,-1 do
		if Duel.IsPlayerCanDraw(tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then 
		Duel.Draw(tp,ct[1],REASON_EFFECT)
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local rg=Duel.GetDecktopGroup(tp,1)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		Duel.Draw(tp,ac,REASON_COST)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		local rg=Duel.GetDecktopGroup(tp,ac)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end