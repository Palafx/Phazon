--
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:HasNonZeroAttack() end
	if chk==0 then return Duel.IsExistingTarget(Card.HasNonZeroAttack,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.HasNonZeroAttack,tp,0,LOCATION_MZONE,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetSum(Card.GetAttack))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		local sum=g:GetSum(Card.GetAttack)
		local zg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(aux.FaceupFilter(Card.IsRelateToEffect,e),nil)
		if #zg==0 then return end
		zg:ForEach(s.zaop,e:GetHandler())
		Duel.BreakEffect()
		Duel.Recover(tp,sum,REASON_EFFECT)
	end
end
function s.zaop(c,hc)
	local e1=Effect.CreateEffect(hc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(0)
	c:RegisterEffect(e1)
end