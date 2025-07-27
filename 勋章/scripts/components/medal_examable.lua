local medal_exams=require("medal_defs/"..(TUNING.MEDAL_LANGUAGE =="ch" and "medal_exam_defs" or "medal_exam_defs_en"))

--更新网络变量
local function onexamid(self,examid)
	if self.inst.replica.medal_examable then
		self.inst.replica.medal_examable._examid:set(examid)
	end
end

local medal_examable = Class(function(self, inst)
    self.inst = inst
	self.examid = 0--当前试题ID，无试题则为0
	self.totalid = medal_exams and #medal_exams or 0--试题总数
	self:ChangeExamId()
end,
nil,
{
    examid = onexamid
})

--获取试题ID
function medal_examable:GetExamId()
	return self.inst.replica.medal_examable and self.inst.replica.medal_examable._examid:value() or self.examid
end

--更改试题ID(试题ID为空则随机)
function medal_examable:ChangeExamId(examid)
	if examid then
		self.examid = examid
	else
		for i = 1, 10 do
			local newid = math.random(self.totalid)
			--确保不会连着出现同一个问题
			if self.examid~=newid or i>=10 then
				self.examid = newid
				return
			end
		end
	end
end

--做出选择(答案,回答者)
function medal_examable:MakeChoice(answer,answerer)
	local true_answer = medal_exams and medal_exams[self.examid] and medal_exams[self.examid].answer or 0
	local answer_str = true_answer>0 and medal_exams[self.examid].options and medal_exams[self.examid].options[true_answer]
	if answer == true_answer and answerer.hasdictionary then--答对了扣耐久(必须用了字典才能答对哦)
		if self.inst.components.finiteuses then
			--原本会读书的角色收益更大
			local consume = ((answerer:HasTag("reader") and not answerer:HasTag("aspiring_bookworm")) and 2 or 1)*TUNING_MEDAL.WISDOM_TEST.EXAM_CONSUME
			self.inst.components.finiteuses:Use(consume)
			if not RewardToiler(answerer,0.1) then--天道酬勤
				SpawnMedalTips(answerer,consume,5)--弹幕提示
			end
		end
	else--答错了加耐久
		if self.inst.components.finiteuses then
			local consume = TUNING_MEDAL.WISDOM_TEST.EXAM_CONSUME
			self.inst.components.finiteuses:Repair(consume)
			-- self.inst.components.finiteuses:SetUses(math.min(self.inst.components.finiteuses:GetUses()+consume,self.inst.components.finiteuses.total))
			SpawnMedalTips(answerer,consume,15)--弹幕提示
		end
		if answer_str ~= nil and answerer.hasdictionary then
			MedalSay(answerer,STRINGS.WISDOM_MEDAL_SPEECH.SAYANSWER..answer_str)
		end
	end
	answerer.hasdictionary=nil
	self:ChangeExamId()
end

function medal_examable:OnSave() 
	return  {examid=self.examid}
end

function medal_examable:OnLoad(data)       
	if data and data.examid then
        self.examid = data.examid
	end
end

return medal_examable