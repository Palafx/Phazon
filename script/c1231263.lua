--次元领域决斗
--Dimension Duel
--Scripted by Larry126
--note: Please contact with me if wanting to edit this script
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.op)
end
function s.op(c)
	--limit summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.limitcon)
	e1:SetOperation(s.limitop)
	Duel.RegisterEffect(e1,0)
	--Dimension Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e4:SetTarget(aux.FieldSummonProcTg(s.nttg))
	e4:SetCondition(s.ntcon)
	e4:SetValue(6)
	Duel.RegisterEffect(e4,0)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e5:SetTarget(aux.FieldSummonProcTg(s.nttg2))
	e5:SetValue(6)
	Duel.RegisterEffect(e5,0)
end
function s.limitfilter(c)
	return c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC) and c:GetFlagEffect(51160002)<=0
end
function s.limitcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.limitfilter,tp,0xff,0xff,1,nil)
end
function s.limitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.limitfilter,tp,0xff,0xff,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(51160002,0,0,0)
		end
	end
end
------------------------------------------------------------------------
--tribute
function s.nttg(e,c)
	return c==0 or c==1 or c:GetFlagEffect(51160002)==0
end
function s.nttg2(e,c)
	return c==0 or c==1 or c:GetFlagEffect(51160002)>0
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	local _,max=c:GetTributeRequirement()
	return max>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end