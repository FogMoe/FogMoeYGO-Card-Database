--暴食之根绝者
local cm,m,o=GetID()
fu_Dlit = fu_Dlit or {}
function fu_Dlit.is_Dlit(c)
	return c:IsSetCard(0x5fd6)
end
function fu_Dlit.cont(c,val)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_HAND)
	e:SetLabel(val)
	e:SetTarget(fu_Dlit.cont_tg)
	e:SetOperation(fu_Dlit.cont_op)
	c:RegisterEffect(e)
	return e
end
function fu_Dlit.cont_tgf(c,tp)
	return fu_Dlit.is_Dlit(c) and c:IsFaceup() and Duel.CheckLocation(tp,LOCATION_SZONE,aux.MZoneSequence(c:GetSequence()))
end
function fu_Dlit.cont_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(fu_Dlit.cont_tgf,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function fu_Dlit.cont_op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(fu_Dlit.cont_tgf,tp,LOCATION_MZONE,0,nil,tp)
	if #g==0 then return end
	if e:GetHandler():IsRelateToEffect(e) then
		local c=g:GetFirst()
		local seq=0
		while c do
			seq=seq|c:GetColumnZone(LOCATION_SZONE)
			c=g:GetNext()
		end
		c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		seq=Duel.SelectField(tp,1,LOCATION_SZONE,0,~seq)>>8
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,seq) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(e:GetLabel())
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			e3:SetRange(LOCATION_SZONE)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e3:SetTarget(fu_Dlit.cont_op_tg3)
			e3:SetLabelObject(e2)
			c:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetRange(LOCATION_SZONE)
			e4:SetCode(EVENT_DESTROYED)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e4:SetTarget(fu_Dlit.cont_op_con4)
			e4:SetOperation(fu_Dlit.cont_op_op4)
			c:RegisterEffect(e4)
		end
	end
end
function fu_Dlit.cont_op_tg3(e,c)
	return e:GetHandler():GetSequence()==aux.MZoneSequence(c:GetSequence())
end
function fu_Dlit.cont_op_conf4(c,tp,seq)
	if c:IsPreviousControler(1-tp) or not c:GetPreviousLocation()==LOCATION_MZONE then return false end
	return seq==aux.MZoneSequence(c:GetPreviousSequence())
end
function fu_Dlit.cont_op_con4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(fu_Dlit.cont_op_conf4,1,nil,tp,e:GetHandler():GetSequence())
end
function fu_Dlit.cont_op_op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
if not cm then return end
------------------------------------------------------------
function cm.initial_effect(c)
	local e1=fu_Dlit.cont(c,900)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local rec=bc:GetAttack()
	if chk==0 then return rec>0 end
	Duel.SetTargetCard(bc)
	if rec<0 then rec=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
