--地獄詩人ヘルポエマー
local s,id=GetID()
function s.initial_effect(c)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.hdcon)
	e3:SetTarget(s.hdtg)
	e3:SetOperation(s.hdop)
	c:RegisterEffect(e3)
end
function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local sg=g:Select(1-tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
