--Trap Displacement (Phazon version)
--This is just "Stat Stealing Statute"'s script, but for the purposes of this card's use, it will be this
local s,id=GetID()
function s.initial_effect(c)
	--attack up
	local e3=Effect.CreateEffect(c)
e3:SetCategory(CATEGORY_ATKCHANGE)
e3:SetDescription(aux.Stringid(id,0))
e3:SetType(EFFECT_TYPE_ACTIVATE)
e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
e3:SetHintTiming(TIMING_DAMAGE_STEP)
e3:SetCode(EVENT_FREE_CHAIN)
e3:SetTarget(s.target)
e3:SetOperation(s.operation)
c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function s.filter2(c)
	return c:IsFaceup() and c:GetAttack()==c:GetBaseAttack()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) and s.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local tc1=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(tc1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc2=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc1:GetFirst())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetTargetCards(e)
	if #sg~=2 then return end
	local mc1=sg:GetFirst()
	if not mc1 or mc1:IsImmuneToEffect(e) then return end
	local atk=mc1:GetAttack()
	local batk=mc1:GetBaseAttack()
	if batk~=atk then
		local dif=(batk>atk) and (batk-atk) or (atk-batk)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue((dif)*-1)
		mc1:RegisterEffect(e1)
		local mc2=(sg-mc1):GetFirst()
		if not mc2 or mc2:IsImmuneToEffect(e) then return end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(dif)
		mc2:RegisterEffect(e2)
	end
end