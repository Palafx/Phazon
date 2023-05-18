--炎舞－「天璣」
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsSpellTrap() and c:IsAbleToRemove()
end
function s.filter1(c,tp)
	return c:GetOwner()==1-tp
end
function s.filter2(c,tp)
	return c:GetOwner()==tp
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	local con1=true
	local op=2
	if con1 then
		op=Duel.SelectOption(1-tp,aux.Stringid(id,0),aux.Stringid(id,1))
	end
	if op==0 then
		--gain lp
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetOperation(s.recop2)
		Duel.RegisterEffect(e1,p)
		--banish
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
		Duel.Remove(g,POP_FACEUP,REASON_EFFECT)
		--banish constantly
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,0xff)
		e2:SetTarget(s.rmtarget2)
		e2:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(e2,p)
		--cannot sp
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTargetRange(1,0)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetTarget(function(_,c) return c:IsLocation(LOCATION_GRAVE) end)
		Duel.RegisterEffect(e3,p)
	elseif op==1 then
		--banish
		local g=Duel.GetMatchingGroup(s.filter,1-tp,LOCATION_GRAVE,0,nil)
		Duel.Remove(g,POP_FACEUP,REASON_EFFECT)
		--banish constantly
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0xff,0)
		e1:SetTarget(s.rmtarget)
		e1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(e1,p)
		--cannot sp
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTargetRange(0,1)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetTarget(function(_,c) return c:IsLocation(LOCATION_GRAVE) end)
		Duel.RegisterEffect(e3,p)
		--gain lp
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetOperation(s.recop)
		Duel.RegisterEffect(e2,p)
	end
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	--local d1=eg:FilterCount(s.filter1,nil,tp)*200
	local d2=eg:FilterCount(s.filter2,nil,tp)*200
	--Duel.Recover(1-tp,d1,REASON_EFFECT,true)
	Duel.Recover(tp,d2,REASON_EFFECT,true)
	Duel.RDComplete()
end
function s.recop2(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(s.filter1,nil,tp)*200
	--local d2=eg:FilterCount(s.filter2,nil,tp)*200
	Duel.Recover(1-tp,d1,REASON_EFFECT,true)
	--Duel.Recover(tp,d2,REASON_EFFECT,true)
	Duel.RDComplete()
end
function s.rmtarget(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:IsOriginalType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanRemove(e:GetHandlerPlayer(),c)
end
function s.rmtarget2(e,c)
	return c:GetOwner()==e:GetHandlerPlayer() and c:IsOriginalType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanRemove(e:GetHandlerPlayer(),c)
end