local m=95010
local cm=_G["c"..m]
cm.name="四元素感知"
function cm.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95010+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95010,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return c:IsSetCard(0x9500)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9500)
end

function cm.tfilter(c,att,e,tp,tc)
	if not (c:IsSetCard(0x9500) and (not c:IsAttribute(att)) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false))
end
function cm.filter(c,e,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp,c)
end
function cm.chkfilter(c,att)
	return c:IsFaceup() and (c:GetAttribute()&att)~=att
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1500)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tcc=Duel.GetFirstTarget()
	if not tcc:IsRelateToEffect(e) then return end
	local att=tcc:GetAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_DECK,0,1,1,nil,att,e,tp,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=sg:GetFirst()
	if tc and tcc:IsFaceup() then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.BreakEffect()
		Duel.Damage(tp,1500,REASON_EFFECT)
	end
end