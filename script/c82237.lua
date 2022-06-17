local m=82237
local cm=_G["c"..m]
cm.name="孑影之扁舟"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)	
	e1:SetCategory(CATEGORY_ATKCHANGE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMING_END_PHASE)  
	e1:SetTarget(cm.atktg)  
	e1:SetOperation(cm.atkop)  
	c:RegisterEffect(e1) 
end
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x3299)  
end  
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		local atk=tc:GetAttack()  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		e1:SetValue(atk*2)  
		tc:RegisterEffect(e1)   
	end  
end  