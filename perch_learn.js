// ════════════════════════════════════════════════════════════════════════
// PERCH LEARN v1 — Getting to Know You
// ════════════════════════════════════════════════════════════════════════
//
// Handles: memories, person details, interests, preferences, recall.
// Does NOT handle: tasks, reminders, events (those go to PerchParse).
// Runs first on every input. Returns a result or null (pass to PerchParse).
//
// Storage: perch_context_v1 (separate from perch_memory_v1)
// ════════════════════════════════════════════════════════════════════════

(function(global){
'use strict';

const CTX_KEY = 'perch_context_v1';

// ── STORAGE ───────────────────────────────────────────────────────────
function _load(){
  try{
    const raw=localStorage.getItem(CTX_KEY);
    if(raw) return JSON.parse(raw);
  }catch(e){}
  return {
    personal_context: [],   // memories, observations, preferences
    interests:        [],   // projects, hobbies, things Jeff is exploring
    confidence:       {     // 0–1, grows with evidence
      person:0, money:0, work:0, goals:0, interests:0, family:0
    },
    questions:        [],   // pending relationship questions
    _meta:{ version:1, created: new Date().toISOString().slice(0,10) }
  };
}
function _save(ctx){
  try{localStorage.setItem(CTX_KEY,JSON.stringify(ctx));}catch(e){}
}
function _today(){ return new Date().toISOString().slice(0,10); }
function _confirm(fallback){
  try{ if(global.PerchVoice){ const v=PerchVoice.say('confirm_memory_saved',{}); if(v) return v; } }catch(e){}
  return fallback;
}
function _id(prefix){
  return prefix+'_'+Date.now().toString(36)+'_'+Math.random().toString(36).slice(2,5);
}

// ── KNOWN PEOPLE from perch_memory_v1 ─────────────────────────────────
function _knownPeople(){
  try{ return (PerchMemory.get('people')||[]).filter(p=>p.name&&!p.seed); }
  catch(e){ return []; }
}
function _findPerson(text){
  const lower=text.toLowerCase();
  return _knownPeople().find(p=>lower.includes(p.name.toLowerCase()));
}
function _addPersonDetail(personId, detail){
  try{
    const people=PerchMemory.get('people')||[];
    const p=people.find(x=>x.id===personId);
    if(!p) return;
    if(!Array.isArray(p.known_details)) p.known_details=[];
    // Dedup: don't add if same detail text already stored
    const already=p.known_details.some(d=>
      (d.label||'').toLowerCase()===detail.label.toLowerCase()
    );
    if(!already){
      p.known_details.push({
        id:_id('kd'), ...detail,
        created_date:_today(), source:'tell_perch'
      });
      PerchMemory.set('people',people);
    }
  }catch(e){}
}

// ── CONFIDENCE BUMP ────────────────────────────────────────────────────
function _bumpConfidence(ctx, dimension, amount=0.08){
  if(!(dimension in ctx.confidence)) return;
  ctx.confidence[dimension]=Math.min(1,
    parseFloat((ctx.confidence[dimension]+amount).toFixed(2))
  );
}

// ── DEDUP CHECK ────────────────────────────────────────────────────────
function _isDuplicate(ctx, label){
  const norm=label.toLowerCase().replace(/\s+/g,' ').trim();
  return ctx.personal_context.some(m=>
    (m.label||'').toLowerCase().replace(/\s+/g,' ').trim()===norm
  );
}

// ── PATTERN RULES ────────────────────────────────────────────────────
// Order matters: more specific patterns first.
const PATTERNS = [

  // ── RECALL: "what was that X called", "what's the name of the X" ──
  { type:'recall',
    test:(raw)=>/what was (that|the)|what('?s| is) the name|remind me what|do you remember|what did i call/i.test(raw),
    handle:(raw,ctx)=>{
      const keywords=raw.toLowerCase()
        .replace(/what (was|is|'?s) (that|the)?|name of|remind me|do you remember|what did i call/ig,'')
        .replace(/[?!.,]/g,' ').trim().split(/\s+/).filter(w=>w.length>2);
      const matches=ctx.personal_context.filter(m=>
        keywords.some(kw=>(m.label+' '+(m.clean_summary||'')+(m.original_text||'')).toLowerCase().includes(kw))
      );
      if(!matches.length) return { type:'recall', found:false, reply:"I don\u2019t have that one. You can tell me and I\u2019ll remember it." };
      const best=matches[0];
      best.last_referenced_date=_today();
      _save(ctx);
      // Voice layer makes recall conversational
      let recallReply;
      if(global.PerchVoice){
        // Find a related interest for context ("when blacksmithing caught your interest")
        let interestCtx=null;
        (ctx.interests||[]).forEach(i=>{
          if((i.related_memories||[]).includes(best.id)) interestCtx=i.label;
        });
        recallReply=PerchVoice.say('recall_answer',{
          summary:best.label||best.clean_summary,
          people:best.related_people||[],
          interestContext:interestCtx
        });
      } else {
        recallReply=(best.clean_summary||best.label)+(best.related_people&&best.related_people.length?' \u2014 you mentioned it with '+best.related_people.join(' and ')+'.':'.');
      }
      return { type:'recall', found:true, memory:best, reply:recallReply };
    }
  },

  // ── ME + PERSON saw/visited/did (shared memory) ───────────────────
  { type:'shared_memory',
    test:(raw)=>/\b(me and|i and|noah and me|emma and me|maura and me)\b|\b(we|us)\b.*\b(saw|visited|went|went to|checked out|stopped by|found)\b/i.test(raw),
    handle:(raw,ctx)=>{
      const p=_findPerson(raw);
      const people=p?[p.name]:[];

      // Extract a name/label from the text (quoted or after "called")
      let memLabel='';
      const quotedM=raw.match(/"([^"]+)"|'([^']+)'/);
      const calledM=raw.match(/called\s+([A-Za-z0-9 ]+?)(?:\s+and|\s*$|[.,])/i);
      const namedM =raw.match(/named\s+([A-Za-z0-9 ]+?)(?:\s+and|\s*$|[.,])/i);
      if(quotedM) memLabel=(quotedM[1]||quotedM[2]).trim();
      else if(calledM) memLabel=calledM[1].trim();
      else if(namedM)  memLabel=namedM[1].trim();
      else {
        // Fall back: grab noun after saw/visited/went to
        const verbM=raw.match(/(?:saw|visited|went to|checked out|stopped by|found)\s+(?:the\s+|a\s+)?([A-Za-z0-9 ]{2,40}?)(?:\s+and|\s*called|\s*$|[.,])/i);
        if(verbM) memLabel=verbM[1].trim();
      }
      if(!memLabel) return null;

      const clean=people.length
        ?'Saw '+memLabel+(people.length?' with '+people.join(' and '):'')+'.'
        :'Visited '+memLabel+'.';

      const entry={
        id:_id('pc'), type:'memory', label:memLabel,
        clean_summary:clean, original_text:raw,
        related_people:people, confidence:0.85,
        created_date:_today(), last_referenced_date:_today(),
        source:'tell_perch', status:'active'
      };

      if(!_isDuplicate(ctx,memLabel)){
        ctx.personal_context.push(entry);
        _bumpConfidence(ctx,'family',people.length?0.06:0);
        _save(ctx);
        return { type:'memory', entry, reply:'Got it \u2014 '+clean };
      }
      return { type:'memory', duplicate:true, reply:'Already have '+memLabel+' noted.' };
    }
  },

  // ── PERSON + LIKES/FAVORITE ─────────────────────────────────────
  // "[person] likes X" / "[person]'s favorite X is Y"
  { type:'person_detail',
    test:(raw)=>{
      const p=_findPerson(raw);
      return p && /likes?|favorite|loves?|enjoys?|into\b|obsessed|hates?|doesn.?t like|can.?t stand/i.test(raw);
    },
    handle:(raw,ctx)=>{
      const p=_findPerson(raw);
      if(!p) return null;
      // Extract what they like/favorite
      const lower=raw.toLowerCase();
      const afterName=raw.slice(raw.toLowerCase().indexOf(p.name.toLowerCase())+p.name.length).trim();
      const sentiment=/hates?|doesn.?t like|can.?t stand/i.test(raw)?'dislikes':'likes';
      const verbStripped=afterName.replace(/^'?s?\s+/,'').replace(/^(likes?|loves?|enjoys?|hates?|doesn.?t\s+like|can.?t\s+stand|is\s+into|is\s+obsessed\s+with)\s+/i,'').trim();
      const detail={ label:verbStripped, sentiment, type:'preference' };
      _addPersonDetail(p.id, detail);
      _bumpConfidence(ctx,'family',0.1);
      _bumpConfidence(ctx,'person',0.08);
      const entry={
        id:_id('pc'), type:'person_detail', label:p.name+' \u2014 '+detail.label,
        clean_summary:p.name+(sentiment==='likes'?' likes ':' doesn\u2019t like ')+detail.label+'.',
        original_text:raw, related_people:[p.name],
        confidence:0.9, created_date:_today(), last_referenced_date:_today(),
        source:'tell_perch', status:'active'
      };
      if(!_isDuplicate(ctx,entry.label)){
        ctx.personal_context.push(entry);
        _save(ctx);
        return { type:'person_detail', person:p, detail, entry,
          reply:'Got it \u2014 '+p.name+(sentiment==='likes'?' likes ':' doesn\u2019t like ')+detail.label+'.'
        };
      }
      return { type:'person_detail', duplicate:true, reply:'Already have that about '+p.name+'.' };
    }
  },

  // ── ME + PERSON saw/visited/did (shared memory) ───────────────────
  { type:'shared_memory',
    test:(raw)=>/\b(me and|i and|noah and me|emma and me|maura and me)\b|\b(we|us)\b.*\b(saw|visited|went|went to|checked out|stopped by|found)\b/i.test(raw),
    handle:(raw,ctx)=>{
      const p=_findPerson(raw);
      const people=p?[p.name]:[];

      // Extract a name/label from the text (quoted or after "called")
      let memLabel='';
      const quotedM=raw.match(/"([^"]+)"|'([^']+)'/);
      const calledM=raw.match(/called\s+([A-Za-z0-9 ]+?)(?:\s+and|\s*$|[.,])/i);
      const namedM =raw.match(/named\s+([A-Za-z0-9 ]+?)(?:\s+and|\s*$|[.,])/i);
      if(quotedM) memLabel=(quotedM[1]||quotedM[2]).trim();
      else if(calledM) memLabel=calledM[1].trim();
      else if(namedM)  memLabel=namedM[1].trim();
      else {
        // Fall back: grab noun after saw/visited/went to
        const verbM=raw.match(/(?:saw|visited|went to|checked out|stopped by|found)\s+(?:the\s+|a\s+)?([A-Za-z0-9 ]{2,40}?)(?:\s+and|\s*called|\s*$|[.,])/i);
        if(verbM) memLabel=verbM[1].trim();
      }
      if(!memLabel) return null;

      const clean=people.length
        ?'Saw '+memLabel+(people.length?' with '+people.join(' and '):'')+'.'
        :'Visited '+memLabel+'.';

      const entry={
        id:_id('pc'), type:'memory', label:memLabel,
        clean_summary:clean, original_text:raw,
        related_people:people, confidence:0.85,
        created_date:_today(), last_referenced_date:_today(),
        source:'tell_perch', status:'active'
      };

      if(!_isDuplicate(ctx,memLabel)){
        ctx.personal_context.push(entry);
        _bumpConfidence(ctx,'family',people.length?0.06:0);
        _save(ctx);
        return { type:'memory', entry, reply:'Got it \u2014 '+clean };
      }
      return { type:'memory', duplicate:true, reply:'Already have '+memLabel+' noted.' };
    }
  },

  // ── INTEREST/CONSIDERING ──────────────────────────────────────────
  // "I'm considering X" / "I might get into X" / "thinking about X"
  { type:'interest',
    test:(raw)=>/i.?m\s+(considering|thinking about|exploring|looking into|interested in|curious about|might get into|getting into)/i.test(raw)||
                /i might (try|get into|start|explore|pick up)/i.test(raw)||
                /i.?ve been (thinking about|considering|looking into)/i.test(raw),
    handle:(raw,ctx)=>{
      // Extract what they're considering
      const m=raw.match(/(?:considering|thinking about|exploring|looking into|interested in|curious about|might get into|getting into|might try|might start|might explore|might pick up|been thinking about|been considering|been looking into)\s+(.+?)(?:\s*$|[.,!?])/i);
      if(!m) return null;
      let topic=m[1].trim().replace(/^(a |an |the )/i,'');
      // If a named thing was mentioned (from shared memory pattern), link it
      const related=ctx.personal_context.filter(pc=>raw.toLowerCase().includes(pc.label.toLowerCase()));

      const status=/seriously|really|definitely|committed/i.test(raw)?'actively_exploring':'considering';
      const person=_findPerson(raw);

      const entry={
        id:_id('in'), type:'interest', label:topic,
        clean_summary:'Considering '+topic+'.', original_text:raw,
        status, related_people:person?[person.name]:[],
        related_memories:related.map(r=>r.id),
        confidence:0.75, created_date:_today(), last_referenced_date:_today(),
        source:'tell_perch'
      };

      const already=ctx.interests.some(i=>i.label.toLowerCase()===topic.toLowerCase());
      if(!already){
        ctx.interests.push(entry);
        _bumpConfidence(ctx,'interests',0.1);
        _save(ctx);
        const reply=status==='actively_exploring'
          ?'Noted \u2014 '+topic+' sounds like something you\u2019re seriously exploring.'
          :'Got it \u2014 '+topic+' is something you\u2019re thinking about.';
        return { type:'interest', entry, reply };
      }
      return { type:'interest', duplicate:true, reply:'Already have '+topic+' in your interests.' };
    }
  },

  // ── TRAIT / PREFERENCE ("I am X", "I like X", "I prefer X") ─────
  { type:'trait',
    test:(raw)=>/^i\s+(am|am very|tend to be|can be|get)\s+/i.test(raw.trim())||
                /^i\s+(like|love|prefer|enjoy|hate|dislike|always|never|usually|often)\s+/i.test(raw.trim())||
                /^i.?m\s+(very|really|quite|pretty|extremely|always|never)\s+/i.test(raw.trim()),
    handle:(raw,ctx)=>{
      const clean=raw.trim().replace(/^i\s+(am|am very|tend to be|can be|get|like|love|prefer|enjoy|hate|dislike|always|never|usually|often|'m|'m very|'m really|'m quite|'m pretty|'m extremely|'m always|'m never)\s+/i,'');
      const sentiment=/hate|dislike|don.?t like/i.test(raw)?'negative':
                      /like|love|prefer|enjoy/i.test(raw)?'positive':'neutral';
      const isForgetful=/forget|forgetful|bad memory/i.test(raw);

      const entry={
        id:_id('pc'), type:'trait', label:raw.trim(),
        clean_summary:'Jeff '+raw.trim().replace(/^i\s+/i,'').replace(/\.$/,'')+'.',
        original_text:raw, related_people:[], confidence:0.8,
        sentiment, created_date:_today(), last_referenced_date:_today(),
        source:'tell_perch', status:'active',
        ...(isForgetful?{support_hint:'extra_reminders'}:{})
      };

      if(!_isDuplicate(ctx,raw.trim())){
        ctx.personal_context.push(entry);
        _bumpConfidence(ctx,'person',0.08);
        if(isForgetful) _bumpConfidence(ctx,'person',0.05);
        _save(ctx);
        // Forgetful trait gets a special acknowledgment
        const reply=isForgetful
          ?'Noted \u2014 I\u2019ll make sure to surface things before they sneak up on you.'
          :'Got it.';
        return { type:'trait', entry, reply };
      }
      return { type:'trait', duplicate:true, reply:'Got it \u2014 already noted.' };
    }
  },

  // ── "DID YOU KNOW" / "REMEMBER THAT" ────────────────────────────
  { type:'memory',
    test:(raw)=>/^did you know\b|^remember (that|when|this)\b|^just so you know\b|^fyi[,:]?\s+/i.test(raw.trim()),
    handle:(raw,ctx)=>{
      const clean=raw.replace(/^did you know[,:]?\s*/i,'')
                     .replace(/^remember (that|when|this)[,:]?\s*/i,'')
                     .replace(/^just so you know[,:]?\s*/i,'')
                     .replace(/^fyi[,:]?\s*/i,'').trim();
      if(!clean) return null;
      const person=_findPerson(clean);
      const entry={
        id:_id('pc'), type:'memory', label:clean,
        clean_summary:clean.charAt(0).toUpperCase()+clean.slice(1)+(clean.endsWith('.')?'':'.'),
        original_text:raw, related_people:person?[person.name]:[],
        confidence:0.8, created_date:_today(), last_referenced_date:_today(),
        source:'tell_perch', status:'active'
      };
      if(!_isDuplicate(ctx,clean)){
        ctx.personal_context.push(entry);
        _bumpConfidence(ctx,person?'family':'person',0.06);
        _save(ctx);
        return { type:'memory', entry, reply:'Got it \u2014 I\u2019ll remember that.' };
      }
      return { type:'memory', duplicate:true, reply:'Already have that noted.' };
    }
  },
];

// ── QUESTION ENGINE ───────────────────────────────────────────────────
// Questions that help Perch give better recommendations.
// Each question must pass: "could knowing this help Perch?"
const QUESTION_BANK = [
  { id:'q_emma_interests', dimension:'family',
    condition:(ctx)=>{
      const people=_knownPeople();
      const emma=people.find(p=>p.name==='Emma');
      return emma&&!(emma.known_details||[]).some(d=>d.type==='preference');
    },
    get text(){
      try{ if(global.PerchVoice) return PerchVoice.say('ask_about_person',{person:'Emma',bias:'mix'}); }catch(e){}
      return 'What\u2019s Emma into right now?';
    },
    followUp:null
  },
  { id:'q_blacksmith_serious', dimension:'interests',
    condition:(ctx)=>ctx.interests.some(i=>/blacksmith|smithing|forge/i.test(i.label)&&i.status==='considering'),
    text:'Is blacksmithing something you want to seriously explore, or just a passing interest for now?',
    options:['Seriously exploring','Just curious','Not sure yet'],
    followUp:(ans,ctx)=>{
      const i=ctx.interests.find(x=>/blacksmith/i.test(x.label));
      if(i){
        i.status=ans==='Seriously exploring'?'actively_exploring':ans==='Just curious'?'casual':'unknown';
        _save(ctx);
      }
    }
  },
  { id:'q_reminder_timing', dimension:'person',
    condition:(ctx)=>ctx.personal_context.some(m=>m.support_hint==='extra_reminders'),
    text:'Do you prefer reminders well in advance, or closer to when things are due?',
    options:['Well in advance','Day before','Same day'],
    followUp:(ans,ctx)=>{
      const trait={ id:_id('pc'), type:'preference', label:'reminder_timing',
        clean_summary:'Jeff prefers reminders '+ans.toLowerCase()+'.',
        confidence:0.9, created_date:_today(), source:'question_answer', status:'active',
        related_people:[], original_text:ans };
      if(!_isDuplicate(ctx,'reminder_timing')){ ctx.personal_context.push(trait); _save(ctx); }
    }
  },
];

function _pickQuestion(ctx){
  // Don't ask if a question was asked in the last 3 days
  const recent=ctx.questions.find(q=>{
    if(q.status==='snoozed'&&q.snoozed_until&&q.snoozed_until>_today()) return true;
    const daysAgo=Math.floor((Date.now()-new Date(q.asked_date||0))/86400000);
    return daysAgo<3&&q.status!=='dismissed'&&q.status!=='answered';
  });
  if(recent) return null;
  return QUESTION_BANK.find(q=>{
    const alreadyDone=ctx.questions.some(cq=>cq.id===q.id&&['answered','dismissed'].includes(cq.status));
    return !alreadyDone && q.condition(ctx);
  })||null;
}

function _recordQuestionShown(ctx, question){
  const existing=ctx.questions.find(q=>q.id===question.id);
  if(existing){ existing.asked_date=_today(); existing.status='pending'; }
  else ctx.questions.push({ id:question.id, status:'pending', asked_date:_today() });
  _save(ctx);
}
function _answerQuestion(questionId, answer){
  const ctx=_load();
  const q=QUESTION_BANK.find(x=>x.id===questionId);
  let cq=ctx.questions.find(x=>x.id===questionId);
  if(!cq){ cq={id:questionId,status:'pending',asked_date:_today()}; ctx.questions.push(cq); }
  cq.status='answered';
  if(q&&q.followUp){ q.followUp(answer,ctx); _save(ctx); }
  else _save(ctx);
  return { replied:'Thanks \u2014 that helps me give you better suggestions.' };
}
function _snoozeQuestion(questionId){
  const ctx=_load();
  const cq=ctx.questions.find(x=>x.id===questionId);
  if(cq){ cq.status='snoozed'; const d=new Date(); d.setDate(d.getDate()+7); cq.snoozed_until=d.toISOString().slice(0,10); }
  else ctx.questions.push({ id:questionId, status:'snoozed', asked_date:_today(),
    snoozed_until:new Date(Date.now()+7*86400000).toISOString().slice(0,10) });
  _save(ctx);
}
function _dismissQuestion(questionId){
  const ctx=_load();
  const cq=ctx.questions.find(x=>x.id===questionId);
  if(cq) cq.status='dismissed';
  else ctx.questions.push({ id:questionId, status:'dismissed', asked_date:_today() });
  _save(ctx);
}

// ── CONFIDENCE SUMMARY ────────────────────────────────────────────────
function _confidenceSummary(ctx){
  const c=ctx.confidence;
  const total=Object.values(c).reduce((s,v)=>s+v,0);
  const avg=total/Object.keys(c).length;
  if(avg<0.15) return null;
  if(avg<0.35) return 'Perch is starting to understand your life.';
  if(avg<0.6)  return 'Perch is getting to know you.';
  return 'Perch knows you well.';
}

// Per-dimension plain-English confidence line
function _dimensionPhrase(dimension, value){
  const labels={ person:'you', money:'your finances', work:'your work',
    goals:'your goals', interests:'your interests', family:'your family' };
  const who=labels[dimension]||dimension;
  if(value<0.1)  return null;
  if(value<0.3)  return 'Perch is starting to understand '+who+'.';
  if(value<0.6)  return 'Perch knows a little about '+who+'.';
  if(value<0.85) return 'Perch knows '+who+' fairly well.';
  return 'Perch knows '+who+' well.';
}

// ── MAIN ENTRY: learn(rawText) ────────────────────────────────────────
// Returns a result object if the input was a memory/interest/person/recall,
// or null if it should fall through to PerchParse (task/reminder).
function learn(rawText){
  if(!rawText||rawText.trim().length<3) return null;
  const raw=rawText.trim();
  const ctx=_load();

  for(const pattern of PATTERNS){
    if(pattern.test(raw)){
      const result=pattern.handle(raw,ctx);
      if(result) return result;
    }
  }
  return null; // pass through to PerchParse
}

// ── MEMORY MANAGEMENT (for What Perch Knows page) ─────────────────────
function _deleteMemory(id){
  const ctx=_load();
  ctx.personal_context=ctx.personal_context.filter(m=>m.id!==id);
  ctx.interests=ctx.interests.filter(m=>m.id!==id);
  _save(ctx);
}
function _archiveMemory(id){
  const ctx=_load();
  const m=ctx.personal_context.find(x=>x.id===id)||ctx.interests.find(x=>x.id===id);
  if(m){ m.status='archived'; _save(ctx); }
}
function _editMemory(id, newSummary){
  const ctx=_load();
  const m=ctx.personal_context.find(x=>x.id===id)||ctx.interests.find(x=>x.id===id);
  if(m){ m.clean_summary=newSummary; m.last_referenced_date=_today(); _save(ctx); }
}
function _addDetail(text){
  // Route a manually-added detail through the same learn() pipeline
  return learn(text);
}
function _setInterestStatus(id, status){
  const ctx=_load();
  const i=ctx.interests.find(x=>x.id===id);
  if(i){ i.status=status; _save(ctx); }
}

// ── EXPORTS ────────────────────────────────────────────────────────────
global.PerchLearn = {
  learn,
  pickQuestion:()=>{ const ctx=_load(); return _pickQuestion(ctx); },
  recordQuestionShown:(q)=>{ const ctx=_load(); _recordQuestionShown(ctx,q); },
  answerQuestion:_answerQuestion,
  snoozeQuestion:_snoozeQuestion,
  dismissQuestion:_dismissQuestion,
  getContext:_load,
  confidenceSummary:()=>_confidenceSummary(_load()),
  dimensionPhrase:_dimensionPhrase,
  // Management (What Perch Knows page)
  deleteMemory:_deleteMemory,
  archiveMemory:_archiveMemory,
  editMemory:_editMemory,
  addDetail:_addDetail,
  setInterestStatus:_setInterestStatus,
  allPendingQuestions:()=>{
    const ctx=_load();
    return QUESTION_BANK.filter(q=>{
      const cq=ctx.questions.find(x=>x.id===q.id);
      const done=cq&&['answered','dismissed'].includes(cq.status);
      const snoozed=cq&&cq.status==='snoozed'&&cq.snoozed_until&&cq.snoozed_until>_today();
      return !done&&!snoozed&&q.condition(ctx);
    });
  },
  // For tests / Settings
  reset:()=>{ try{localStorage.removeItem(CTX_KEY);}catch(e){} }
};

})(typeof window!=='undefined'?window:global);
