--幻星魔女
local m=17014
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,17000) 
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,17000),aux.NonTuner(nil),1,1)
	c:EnableReviveLimit() 
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13455674,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)  
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetValue(cm.indct)
	c:RegisterEffect(e2)  
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.rmfilters(c)
	return c:IsCode(17001) or c:IsCode(17000)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=Duel.GetMatchingGroup(cm.rmfilters,tp,LOCATION_GRAVE,0,nil)
	local ct=cg:GetCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.rmfilter(chkc) end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(cm.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,ct,nil)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end