--Power Balance
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0  and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,tp,0,ct)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local act=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct={}
	for i=act,1,-1 do
		if Duel.IsPlayerCanDraw(tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then 
		local dct=Duel.DiscardHand(1-tp,nil,ct,ct,REASON_EFFECT+REASON_DISCARD)
	if dct==ct then
		Duel.BreakEffect()
		Duel.Draw(tp,dct,REASON_EFFECT)
	end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		local dct=Duel.DiscardHand(1-tp,nil,ac,ac,REASON_EFFECT+REASON_DISCARD)
		if dct==ac then
			Duel.BreakEffect()
			Duel.Draw(tp,dct,REASON_EFFECT)
		end
	end
end
