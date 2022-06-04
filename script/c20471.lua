--浪魔灵 双鱼
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20470") end) then require("script/c20470") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=fu_Mugettsu.graveSP(c,m)
end
--e1
function cm.tgf1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tgf1(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingTarget(cm.tgf1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.tgf1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end