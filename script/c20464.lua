--双体共生 噬日狼
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m+1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,m+1):FilterCount(Card.IsFaceup,nil)==0
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,m+1):Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if #g<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc = g:Select(tp,1,1,nil):GetFirst()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	local e1 = Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1,true)
	Duel.SpecialSummonComplete()
end