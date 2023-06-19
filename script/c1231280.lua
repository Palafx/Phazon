--Phazon's Darkness
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Rerrange cards
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
	--Set 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(TIMING_DRAW_PHASE,TIMING_DRAW_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(s.condition1)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.descon)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
s.listed_names={511310101,511310102,511310103,511310104,511310105}
function s.filter(c)
	return c:IsCode(511310101,511310102,511310103,511310104,511310105) and c:IsSSetable(true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil):GetClassCount(Card.GetCode)==5 end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,511310101) and sg:IsExists(Card.IsCode,1,nil,511310102) and
		sg:IsExists(Card.IsCode,1,nil,511310103) and sg:IsExists(Card.IsCode,1,nil,511310104) and sg:IsExists(Card.IsCode,1,nil,511310105)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<5 then return end
	Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
	if not s.rescon(sg) then return end
	local setg=aux.SelectUnselectGroup(sg,e,tp,5,5,s.rescon,1,tp,HINTMSG_SET)
	if #sg>0 then
		setg:ForEach(function(c)c:RegisterFlagEffect(id,RESETS_STANDARD-RESET_TOFIELD-RESET_TURN_SET,0,1)end)
		Duel.SSet(tp,setg)
		Duel.ShuffleSetCard(setg)
	end
end
function s.cfilter1(c,tp)
	return c:GetPreviousControler()==tp and c:IsSpellTrap()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp) and re and re:GetHandler()~=e:GetHandler()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Set
function s.cfilter(c)
	return c:IsFaceup() and c:IsTrap()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsTrap),tp,LOCATION_ONFIELD,0,nil)
	if #g>0 and Duel.ChangePosition(g,POS_FACEDOWN) then
		local c=e:GetHandler()
		for tc in g:Iter() do
			--Can be activated this turn
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function s.refilter(c)
	return c:GetFlagEffect(1231280)~=0 and c:GetSequence()<5
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
end
function s.getflag(g,tp)
	local flag = 0
	for c in aux.Next(g) do
		flag = flag|((1<<c:GetSequence())<<(8+(16*c:GetControler())))
	end
	if tp~=0 then
		flag=((flag<<16)&0xffff)|((flag>>16)&0xffff)
	end
	return ~flag
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.refilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if #g==0 then return end
	local p
	if g:GetClassCount(Card.GetControler)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		p=g:Select(tp,1,1,nil):GetFirst():GetControler()
		g=g:Filter(Card.IsControler,nil,p)
	else
		p=g:GetFirst():GetControler()
	end
	local sg=g:Filter(s.setfilter,nil)
	if #sg>0 then
		Duel.SSet(tp,sg)
		Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	g=g:Filter(Card.IsFacedown,nil)
	local filter=s.getflag(g,tp)
	for tc in aux.Next(g) do
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local zone=Duel.SelectFieldZone(tp,1,LOCATION_SZONE,LOCATION_SZONE,filter)
		filter=filter|zone
		local seq=math.log(zone>>8,2)
		local oc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
		if oc then
			Duel.SwapSequence(tc,oc)
		else
			Duel.MoveSequence(tc,seq)
		end
	end
end
function s.setfilter(c)
	return c:IsFaceup() and c:IsSpellTrap() and c:IsSSetable(true)
end