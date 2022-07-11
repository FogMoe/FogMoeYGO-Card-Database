--逆位挑战者
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and a:IsRelateToBattle() and d:IsRelateToBattle()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:GetAttack()~=d:GetAttack() then
		if a:GetAttack()<d:GetAttack() then
			a=Duel.GetAttackTarget()
			d=Duel.GetAttacker()
		end
		Duel.SetTargetPlayer(a:GetControler())
		Duel.SetTargetParam(a:GetAttack()-d:GetAttack())
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,a:GetControler(),a:GetAttack()-d:GetAttack())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a and d and a:IsRelateToBattle() and d:IsRelateToBattle() then
		if a:GetAttack()==d:GetAttack() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
			a:RegisterEffect(e1)
			local e2=e1:Clone()
			d:RegisterEffect(e2)
		else
			if a:GetAttack()<d:GetAttack() then
				a=Duel.GetAttackTarget()
				d=Duel.GetAttacker()
			end
			if Duel.Damage(a:GetControler(),a:GetAttack()-d:GetAttack(),REASON_EFFECT)>0 then Duel.Destroy(a,REASON_EFFECT) end
		end
	end
end