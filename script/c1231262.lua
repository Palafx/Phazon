--Time Wizard
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.toss_coin=true
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CallCoin(tp) then
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		local b1=#g1>0
		local b2=#g2>0
		if not ((b1 or b2)) then return end
			local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,2)},
			{b2,aux.Stringid(id,3)})
			if op==1 then
				local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
				Duel.Destroy(g,REASON_EFFECT)
				Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,e,0,0,tp,0)
				Duel.BreakEffect()
				Duel.Destroy(e:GetHandler(),REASON_EFFECT)
			elseif op==2 then
				local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
				local tc=g:GetFirst()
				for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				Duel.BreakEffect()
				Duel.Destroy(e:GetHandler(),REASON_EFFECT)
			end
		end
	else
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		Duel.Destroy(g,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local sum=dg:GetSum(Card.GetAttack)
		Duel.Damage(tp,sum/2,REASON_EFFECT)
	end
end