--CSTM Cyber Jar
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,5) and Duel.IsPlayerCanSpecialSummon(tp) and Duel.IsPlayerCanDraw(1-tp,5) and Duel.IsPlayerCanSpecialSummon(1-tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,PLAYER_ALL,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.Draw(tp,5,REASON_EFFECT)==5  then
		local g=Duel.GetOperatedGroup()
		for tc in aux.Next(g) do
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsLevelBelow(4) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK|POS_FACEDOWN_DEFENSE)
			end
		end
	end
	Duel.BreakEffect()
	if Duel.Draw(1-tp,5,REASON_EFFECT)==5  then
		local g=Duel.GetOperatedGroup()
		for tc in aux.Next(g) do
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsLevelBelow(4) and tc:IsCanBeSpecialSummoned(e,0,1-tp,false,false) then
				Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK|POS_FACEDOWN_DEFENSE)
			end
		end
	end
end