--米迦勒 路西法
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cos)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(cm.glo)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.glo(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p=tc:GetControler()
	if Duel.GetAttackTarget()~=nil then return end
	if tc:GetFlagEffect(m)==0 then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.GetFlagEffect(p,m)==0 then
			Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1)
		else
			Duel.RegisterFlagEffect(p,m+1,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.cos(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,m+1)==0 and (Duel.GetFlagEffect(tp,m)==0 or c:GetFlagEffect(m)~=0) end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.cos_tg)
	e2:SetLabel(c:GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.cos_tg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function cm.tgf(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackAbove(1) and (c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_LIGHT))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(cm.tgf,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if #g~=0 then
		local tc = g:GetFirst()
		local total = 0
		while tc do
			local atk = tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(atk/2)
			tc:RegisterEffect(e1)
			total = total + atk - tc:GetAttack()
			tc=g:GetNext()
		end
		if c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(total)
			c:RegisterEffect(e1)
		end
	end
end