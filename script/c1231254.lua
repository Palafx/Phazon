--Arm Bind (Phazon version)
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Can make a second attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.atcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(2,id,EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(s.damcon)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
--steal effect
function s.chk(sg,tp,exg,dg)
	return dg:IsExists(aux.TRUE,2,sg)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function s.filter(c,e)
	return c:IsFaceup() and c:IsAbleToChangeControler() and (not e or c:IsCanBeEffectTarget(e))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)>=0
		and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function s.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.tfilter,nil,e)
	if #g<2 then return end
	local rct=1
	if Duel.GetTurnPlayer()~=tp then rct=2 end
	if Duel.GetControl(g,tp,PHASE_END,rct) then
	--Opponent's monsters cannot attack except this monster
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_SINGLE)
		ge0:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		ge0:SetValue(s.vala)
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge1:SetProperty(EFFECT_FLAG_OATH)
		ge1:SetTargetRange(0,LOCATION_MZONE)
		ge1:SetTarget(s.eftg)
		ge1:SetCondition(s.con)
		ge1:SetLabelObject(ge0)
		ge1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(ge1,tp)
	--reflect battle damage
		local ge2=Effect.CreateEffect(e:GetHandler())
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		ge2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge2:SetTargetRange(1,0)
		ge2:SetValue(1)
		ge2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(ge2,tp)
	end
end
--can only be attacked subparts
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.effilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,tp)
end
function s.effilter(c,tp)
	return c:GetOwner()~=tp
end
function s.eftg(e,c)
	return c:IsFaceup()
end
function s.vala(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
--second attack
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsMonster()
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsLinkMonster() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		--Make a second attack
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3201)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
--burn
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsMonster,nil)
	local tc=g:GetFirst()
	return #g==1 and tc:IsReason(REASON_DESTROY) and tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsPreviousControler(tp)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsMonster,nil)
	local tc=g:GetFirst()
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(tc:GetPreviousAttackOnField()/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetPreviousAttackOnField()/2)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
