muxu=muxu or {}
local cm=muxu
--scripts
--====================
function cm.AddSpsummonSelf(c,fcon,fop,limit,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	if limit and limit>0 then e1:SetCountLimit(limit,code+EFFECT_COUNT_CODE_OATH) end
	e1:SetCondition(cm.AddSpsummonSelfFcon(fcon))
	e1:SetOperation(cm.AddSpsummonSelfFop(fop))
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	return e1
end
function cm.AddSpsummonSelfFcon(fcon)
	return
	function(e,c)
		if c==nil then return true end
		if fcon then return fcon(e,c) end
		return true
	end
end
function cm.AddSpsummonSelfFop(fop)
	return
	function(e,tp,eg,ep,ev,re,r,rp,c)
		if fop then fop(e,tp,eg,ep,ev,re,r,rp,c) end
	end
end
--
function cm.CardSingleUpdateAttack(c,tc,val,reset,fcon)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	if aux.GetValueType(val)=="int" then
		e1:SetValue(val)
	elseif aux.GetValueType(val)=="function" then
		e1:SetValue(cm.CardSingleUpdateAttackVal(val))
	end
	e1:SetCondition(cm.CardSingleUpdateAttackFcon(fcon))
	if reset then e1:SetReset(reset) end
	c:RegisterEffect(e1)
end
function cm.CardSingleUpdateDefense(c,tc,val,reset,fcon)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_DEFENSE)
	if aux.GetValueType(val)=="int" then
		e1:SetValue(val)
	elseif aux.GetValueType(val)=="function" then
		e1:SetValue(cm.CardSingleUpdateAttackVal(val))
	end
	e1:SetCondition(cm.CardSingleUpdateAttackFcon(fcon))
	if reset then e1:SetReset(reset) end
	c:RegisterEffect(e1)
end
function cm.CardSingleUpdateAttackVal(val)
	return
	function(e,c) return val(e,c) end
end
function cm.CardSingleUpdateAttackFcon(fcon)
	return
	function(e,c)
		if fcon then return fcon(e,c) end
		return true
	end
end
--
function cm.CardSingleChangeCode(c,tc,code,reset,fcon)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	e1:SetReset(reset)
	e1:SetCondition(cm.CardSingleChangeCodeFcon(fcon))
	c:RegisterEffect(e1)
end
function cm.CardSingleChangeCodeFcon(fcon)
	return
	function(e,c)
		if fcon then return fcon(e,c) end
		return true
	end
end
--
function cm.CardSzoneMoveSequence(c,tp)
	local seq=0
	local flag=0
	while seq<5 do
		if Duel.CheckLocation(tp,LOCATION_SZONE,seq) then
			flag=bit.replace(flag,0x1,seq+7)
		end
		seq=seq+1
	end
	flag=bit.bxor(flag,0xff)
	local s=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,~flag)
	Duel.MoveSequence(c,(math.log(s,2)-8))
end
--
function cm.CardSelectingMoveSequenceNear(c,tc,loc)
	local flag=0
	local seq=c:GetSequence()
	if seq>0 and Duel.CheckLocation(tp,loc,seq-1) then
		if loc==LOCATION_MZONE then
			flag=bit.replace(flag,0x1,seq-1)
		else
			flag=bit.replace(flag,0x1,seq+7)
		end
	end
	if seq<4 and Duel.CheckLocation(tp,loc,seq+1) then
		if loc==LOCATION_SZONE then
			flag=bit.replace(flag,0x1,seq+1)
		else
			flag=bit.replace(flag,0x1,seq+7)
		end
	end
	flag=bit.bxor(flag,0xff)
	local s=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,~flag)
	if loc==LOCATION_MZONE then nseq=math.log(s,2) end
	if loc==LOCATION_SZONE then nseq=math.log(s,2)-8 end
	Duel.MoveSequence(tc,nseq)
end
--====================
--====================
--Bug
function cm.CardFieldUpdateAttack(c,range,loc1,loc2,ftg,val,reset)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(range)
	e1:SetTargetRange(loc1,loc2)
	e1:SetTarget(cm.CardFieldUpdateAttacktg(ftg))
	e1:SetValue(val)
	if reset then e1:SetReset(reset) end
	c:RegisterEffect(e1)
end
function cm.CardFieldUpdateAttacktg(ftg)
	return
	function(e,c)
		if ftg then return ftg(e,c) end
		return 1
	end
end
--====================
--====================
--ByColour
function cm.AddXyzProcedureFreeByColour(c,f,xyzct)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.XyzFreeByColourCondition(f,xyzct))
	e1:SetTarget(cm.XyzFreeByColourFreeTarget(f,xyzct))
	e1:SetOperation(cm.XyzFreeByColourFreeOperation(f,xyzct))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function cm.XyzFreeByColourCondition(f,xyzct)
	return
	function(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local code=c:GetOriginalCode()
		local checkct=xyzct
			-Duel.GetFlagEffect(tp,code)
			-Duel.GetFlagEffect(tp,11101)
			-Duel.GetFlagEffect(tp,11104)
			+Duel.GetFlagEffect(tp,11110)
		if checkct<0 then checkct=0 end
		local minc=checkct
		local maxc=checkct
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		if maxc<minc then return false end
		local mg=nil
		if og then
			mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
		else
			mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
		end
		local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
		if maxc<1 and sg and sg:GetCount()>0 then return false end
		if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg)then return false end
		Duel.SetSelectedCard(sg)
		Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
		if maxc<1 then
			Auxiliary.GCheckAdditional=nil
			return true
		else
			local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,nil)
			Auxiliary.GCheckAdditional=nil
			return res
		end
	end
end
function cm.XyzFreeByColourFreeTarget(f,xyzct)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
		if og and not min then
			return true
		end
		local code=c:GetOriginalCode()
		local checkct=xyzct
			-Duel.GetFlagEffect(tp,code)
			-Duel.GetFlagEffect(tp,11101)
			-Duel.GetFlagEffect(tp,11104)
			+Duel.GetFlagEffect(tp,11110)
		if checkct<0 then checkct=0 end
		local minc=checkct
		local maxc=checkct
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
		end
		local mg=nil
		if og then
			mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
		else
			mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
		end
		local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
		Duel.SetSelectedCard(sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local cancel=Duel.IsSummonCancelable()
		Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
		if maxc<1 then
			Auxiliary.GCheckAdditional=nil
			return true
		else
			local g=mg:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,nil)
			Auxiliary.GCheckAdditional=nil
			if g and g:GetCount()>0 then
				g:KeepAlive()
				e:SetLabelObject(g)
				return true
			else return false end
		end
	end
end
function cm.XyzFreeByColourFreeOperation(f,xyzct)
	return
	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		Duel.ResetFlagEffect(tp,11104)
		Duel.ResetFlagEffect(tp,11110)
		Duel.ResetFlagEffect(tp,c:GetOriginalCode())
		if og and not min then
			local sg=Group.CreateGroup()
			local tc=og:GetFirst()
			while tc do
				local sg1=tc:GetOverlayGroup()
				sg:Merge(sg1)
				tc=og:GetNext()
			end
			if sg:GetCount()>0 then
				Duel.SendtoGrave(sg,REASON_RULE)
				c:SetMaterial(og)
				Duel.Overlay(c,og)
			end
		else
			local mg=e:GetLabelObject()
			if mg then
				local sg=Group.CreateGroup()
				local tc=mg:GetFirst()
				while tc do
					local sg1=tc:GetOverlayGroup()
					sg:Merge(sg1)
					tc=mg:GetNext()
				end
				Duel.SendtoGrave(sg,REASON_RULE)
				Duel.Overlay(c,mg)
			end
			c:SetMaterial(mg)
			if mg then
				mg:DeleteGroup()
			end
		end
	end
end
--====================
--====================
function cm.CanNotDestroy(c,DType,count,Reset,ConFunc,ValFunc)
	local Effect=false
	if c:IsType(TYPE_NORMAL) then Effect=true end
	local code={
		EFFECT_INDESTRUCTABLE,
		EFFECT_INDESTRUCTABLE_EFFECT,
		EFFECT_INDESTRUCTABLE_BATTLE,
		EFFECT_INDESTRUCTABLE_COUNT 
	}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(code[DType])
	if ValFunc then e1:SetValue(ValFunc)
	elseif Dtype<4 then e1:SetValue(1) end
	if Dtype>=4 then
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(count)
	end
	if ConFunc then e1:SetCondition(ConFunc) end
	if Reset then e1:SetReset(Reset) end
	c:RegisterEffect(e1,Effect)
end
--