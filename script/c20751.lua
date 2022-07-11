--破坏启示录
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m-1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.tgf2(c)
	return c:IsCode(m-1) and c:IsAbleToGraveAsCost()
end
function cm.tgf1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.tgf11,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end
function cm.tgf11(c,e,tp,att)
	return c:IsSetCard(0xcfd5) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_MZONE,0,1,nil,e,tp) 
			and Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_SZONE,0,2,nil)
	end
	local g=Duel.SelectMatchingCard(tp,cm.tgf2,tp,LOCATION_SZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
	g=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.tgf11,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK)>0 then
		tc:CompleteProcedure()
	end
end