local m=94040
local cm=_G["c"..m]
cm.name="世界法则 无限时间者"
function cm.initial_effect(c)
		--Normal monster
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e1:SetCode(EFFECT_ADD_TYPE)
	--e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	--e1:SetValue(TYPE_NORMAL)
	--c:RegisterEffect(e1)
	--local e2=e1:Clone()
	--e2:SetCode(EFFECT_REMOVE_TYPE)
	--e2:SetValue(TYPE_EFFECT)
	--c:RegisterEffect(e2)
		--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(cm.valcon)
	e2:SetValue(cm.indct)
	c:RegisterEffect(e2)

	--special summon proc
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(cm.spcon)
	e3:SetOperation(cm.spop)
	e3:SetCountLimit(1,94040)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)

	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(94040,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,94040)
	e4:SetCost(cm.cost3)
	e4:SetCondition(cm.spcon3)
	e4:SetTarget(cm.sptg3)
	e4:SetOperation(cm.spop3)
	c:RegisterEffect(e4)
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE)
end
function cm.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
	end
end



function cm.counterfilter(c)
	return c:IsSetCard(0x9401)
end
function cm.alllimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9401)
end
function cm.spfilter1(c,tp)
	tp=c:GetControler()
	return c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsReleasable() and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c)
end
function cm.spfilter2(c)
	return c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsReleasable() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9401)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
		and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.alllimit)
	Duel.RegisterEffect(e1,tp)
end
