--Black Illusion Ritual
--Scripted by EP Custom Cards
local s, id=GetID()
function s.initial_effect(c)
	--Ritual Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.indfilter(e,c)
	return c:IsCode(64631466)
end
function s.spfilter(c,e,tp)
	return s.indfilter(e,c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g,exg=Duel.GetReleaseGroup(tp):Split(aux.ReleaseCostFilter,nil,tp)
	e:SetLabel(#g)
	if chk==0 then return #g>0 and Duel.GetMZoneCount(tp,g)>0 end
	if #exg>0 and Duel.SelectYesNo(tp,aux.Stringid(59160188,2)) then
		g:Merge(exg)
	end
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP) then
		tc:CompleteProcedure()
	end
end
