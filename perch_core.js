/**
 * PERCH CORE v1
 * ─────────────────────────────────────────────
 * Single import for all Perch screens.
 * Contains: Date Helpers · Memory Layer · Event System
 *
 * Usage:  <script src="perch_core.js"></script>
 * Then:   PerchDate.today(), PerchMemory.get('user.name'), PerchEvents.getToday()
 */

// ════════════════════════════════════════════
// 1. DATE HELPERS
// ════════════════════════════════════════════
const PerchDate = (() => {

  function today() {
    const d = new Date(); d.setHours(0,0,0,0); return d;
  }
  function fmt(d) {
    // Returns YYYY-MM-DD string — no hardcoded years
    return d.toISOString().split('T')[0];
  }
  function fromStr(str) {
    if (!str) return null;
    const d = new Date(str + 'T00:00:00');
    return isNaN(d) ? null : d;
  }
  function plusDays(n, base) {
    const d = new Date(base || today());
    d.setDate(d.getDate() + n);
    return d;
  }
  function plusMonths(n, base) {
    const d = new Date(base || today());
    d.setMonth(d.getMonth() + n);
    return d;
  }
  function thisWeekday(dow, base) {
    // Returns the date of the given day-of-week within the current week (Mon-start)
    const d = new Date(base || today());
    const day = d.getDay(); // 0=Sun
    const diff = dow - day;
    d.setDate(d.getDate() + diff);
    return d;
  }
  function nextWeekday(dow, base) {
    // Returns NEXT occurrence of day-of-week (never today)
    const d = new Date(base || today());
    const diff = (dow - d.getDay() + 7) % 7 || 7;
    d.setDate(d.getDate() + diff);
    return d;
  }
  function thisSaturday(base)  { return nextWeekday(6, base); }
  function nextThursday(base)  { return nextWeekday(4, base); }
  function thisMonthDay(day, base) {
    // Next occurrence of day-of-month
    const d = new Date(base || today());
    d.setDate(day);
    if (d < (base || today())) d.setMonth(d.getMonth() + 1);
    return d;
  }
  function daysUntil(d) {
    if (!d) return null;
    const target = new Date(d); target.setHours(0,0,0,0);
    return Math.round((target - today()) / 86400000);
  }
  function intel(d) {
    if (!d) return { daysUntil: null, isToday: false, isThisWeek: false, isThisMonth: false, isOverdue: false };
    const du = daysUntil(d);
    return { daysUntil: du, isToday: du===0, isThisWeek: du>=0&&du<=6, isThisMonth: du>=0&&du<=30, isOverdue: du<0 };
  }
  function label(du) {
    if (du === null) return '';
    if (du === 0)   return 'Today';
    if (du === 1)   return 'Tomorrow';
    if (du < 0)     return `${Math.abs(du)}d overdue`;
    return `${du}d away`;
  }
  function greetingTime() {
    const h = new Date().getHours();
    return h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
  }
  function dayName(d) {
    return (d || today()).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
  }
  function weekRange(base) {
    const d = new Date(base || today());
    const mon = new Date(d); mon.setDate(d.getDate() - ((d.getDay()+6)%7));
    const sun = new Date(mon); sun.setDate(mon.getDate() + 6);
    const mo = mon.toLocaleDateString('en-US',{month:'short',day:'numeric'});
    const su = sun.toLocaleDateString('en-US',{month:'short',day:'numeric'});
    return `${mo} – ${su}`;
  }

  return { today, fmt, fromStr, plusDays, plusMonths, thisWeekday, nextWeekday,
           thisSaturday, nextThursday, thisMonthDay, daysUntil, intel, label,
           greetingTime, dayName, weekRange };
})();
window.PerchDate = PerchDate;


// ════════════════════════════════════════════
// 2. MEMORY LAYER
// ════════════════════════════════════════════
const PerchMemory = (() => {

  // All dates use PerchDate helpers — zero hardcoded years
  function D(d) { return PerchDate.fmt(d); }
  const T = PerchDate.today;

  const DEFAULTS = {
    user: {
      name: 'Jeff',
      location: 'Murfreesboro, TN',
      timezone: 'America/Chicago',
      mode: 'recovery',
      last_checkin: null,
      checkins: []
    },
    people: [
      { id: 'noah',   name: 'Noah',    relationship: 'son',      birth_year: 2013, notes: 'Baseball most Thursdays. $35–50/game.', priority_tags: ['family_experiences'], seed: true },
      { id: 'emma',   name: 'Emma',    relationship: 'daughter', birth_year: 2015, notes: '', priority_tags: ['family_experiences'], seed: true },
      { id: 'samuel', name: 'Samuel',  relationship: 'son',      birth_year: 2021, notes: '', priority_tags: ['family_experiences'], seed: true },
      { id: 'william',name: 'William', relationship: 'son',      birth_year: 2022, notes: '', priority_tags: ['family_experiences'], seed: true },
      { id: 'wife',   name: 'Wife',    relationship: 'spouse',   birth_year: null, notes: 'Prefers simplified view.', priority_tags: ['family_experiences','financial_freedom'], seed: true }
    ],
    priorities: [
      { id: 'financial_freedom',   name: 'Financial Freedom',   description: 'Eliminate debt, build savings, gain control over money.',              rank: 1, active: true, color: '#3a8c62', bg: '#eef7f2' },
      { id: 'family_experiences',  name: 'Family Experiences',  description: 'Create memories with Noah and the family. Protect family time.',       rank: 2, active: true, color: '#d97706', bg: '#fef9ec' },
      { id: 'homestead_expansion', name: 'Homestead Expansion', description: 'Develop the property — garden, animals, infrastructure.',              rank: 3, active: true, color: '#6b4fbb', bg: '#f0ecf9' },
      { id: 'health_recovery',     name: 'Health & Recovery',   description: 'Protect sleep, downtime, and physical health between shifts.',         rank: 4, active: true, color: '#0e7490', bg: '#ecfeff' },
      { id: 'career_growth',       name: 'Career Growth',       description: 'Additional income, skills, certifications, shift strategy.',           rank: 5, active: true, color: '#9f7aea', bg: '#f5f0ff' }
    ],
    properties: [
      { id: 'bronze',    name: 'Bronze (primary)', type: 'primary_residence', notes: 'Personal home. Pool. Chickens.', priority_tags: ['homestead_expansion','financial_freedom'], seed: true },
      { id: 'spicewood', name: 'Spicewood (rental)', type: 'rental', rent_monthly: 1200, mortgage_monthly: 780, cash_flow_monthly: 335, cash_on_cash_return: 0.084, estimated_equity: 41800, priority_tags: ['financial_freedom','homestead_expansion'], seed: true }
    ],
    finances: {
      accounts: [
        { id: 'checking', name: 'Checking', balance: 3241, delta: 180, seed: true },
        { id: 'savings',  name: 'Savings',  balance: 1850, delta: 50,  seed: true },
        { id: 'jeff_cc',  name: 'Jeff CC',  balance: 2100, limit: 6000, delta: -340, seed: true },
        { id: 'wife_cc',  name: 'Wife CC',  balance: 890,  limit: 4000, delta: -65,  seed: true }
      ],
      safe_to_spend: 812,
      paycheck: { amount: 2800, next_date: D(PerchDate.nextWeekday(3)), seed: true },
      goals: [
        { id: 'emergency_fund', name: 'Emergency fund',      target: 5000, current: 1850, priority_tags: ['financial_freedom'], created_date: D(PerchDate.today()), seed: true },
        { id: 'cc_utilization', name: 'CC utilization <10%', target: 10,   current: 18, unit: 'percent', priority_tags: ['financial_freedom'], created_date: D(PerchDate.today()), seed: true }
      ],
      snapshots: []
    },
    bills: [
      { id: 'electric',             name: 'Electric',        provider: 'Duke Energy', amount: 148,  due_day: T().getDate(),         autopay: false, payment_url: 'https://www.duke-energy.com/home/billing/pay-your-bill', priority_tags: ['financial_freedom'], seed: true },
      { id: 'internet',             name: 'Internet',        provider: 'AT&T',        amount: 79,   due_day: T().getDate() + 4,     autopay: true,  payment_url: 'https://www.att.com/pay',                              priority_tags: ['financial_freedom'], seed: true },
      { id: 'water',                name: 'Water',           provider: 'Rural Water', amount: 42,   due_day: T().getDate() + 6,     autopay: true,  payment_url: null,                                                   priority_tags: ['financial_freedom'], seed: true },
      { id: 'rental_mortgage_bill', name: 'Rental mortgage', provider: 'Wells Fargo', amount: 1100, due_day: T().getDate() + 8,     autopay: true,  payment_url: 'https://www.wellsfargo.com/mortgage/manage-account/',  priority_tags: ['financial_freedom'], seed: true },
      { id: 'insurance',            name: 'Insurance',       provider: 'State Farm',  amount: 210,  due_day: T().getDate() + 12,    autopay: true,  payment_url: null,                                                   priority_tags: ['financial_freedom'], seed: true },
      { id: 'phone',                name: 'Phone',           provider: 'Carrier',     amount: 95,   due_day: T().getDate() - 6,     autopay: true,  status: 'completed', payment_url: null,                             priority_tags: ['financial_freedom'], seed: true },
      { id: 'netflix',              name: 'Netflix',         provider: 'Netflix',     amount: 17,   due_day: T().getDate() - 8,     autopay: true,  status: 'completed', payment_url: null,                             priority_tags: ['financial_freedom'], seed: true }
    ],
    work: {
      schedule: [
        { id: 'shift_wed', name: 'ICU Shift', day_of_week: 3, time: '07:00', hours: 12, recurrence: 'weekly', seed: true, priority_tags: ['career_growth','financial_freedom'] },
        { id: 'shift_thu', name: 'ICU Shift', day_of_week: 4, time: '07:00', hours: 12, recurrence: 'weekly', seed: true, priority_tags: ['career_growth','financial_freedom'] },
        { id: 'shift_sat', name: 'ICU Shift', day_of_week: 6, time: '07:00', hours: 12, recurrence: 'weekly', seed: true, priority_tags: ['career_growth','financial_freedom'] }
      ],
      opportunities: [
        { id: 'extra_icu_shift', name: 'Extra ICU Shift', date: D(PerchDate.plusDays(18)), value: 'Fully funds dentist visit', priority_tags: ['financial_freedom','career_growth'], seed: true }
      ],
      completed_shifts: []
    },
    future_horizon: [
      { id: 'yellowstone',       name: 'Yellowstone trip',       date_start: D(PerchDate.plusDays(43)), date_end: D(PerchDate.plusDays(50)), status: 'on_track',  icon: '🏔️', priority_tags: ['family_experiences','health_recovery'], created_date: D(PerchDate.today()), seed: true },
      { id: 'anniversary',       name: 'Anniversary',            date_start: D(PerchDate.plusDays(23)),                                     status: 'important', icon: '💍', priority_tags: ['family_experiences'],                    created_date: D(PerchDate.today()), seed: true },
      { id: 'insurance_renewal', name: 'Insurance renewal',      date_start: D(PerchDate.plusDays(33)),                                     status: 'waiting_on',icon: '🛡️', priority_tags: ['financial_freedom'],                     created_date: D(PerchDate.today()), seed: true },
      { id: 'maura_ring',        name: "Maura's ring returns",   date_start: D(PerchDate.plusDays(14)),                                     status: 'waiting_on',icon: '💍', priority_tags: ['family_experiences'],                    created_date: D(PerchDate.today()), seed: true }
    ],
    opportunities: [
      { id: 'festival',          name: 'Local Festival',              date: D(PerchDate.thisSaturday()),    icon: '🎡', detail: 'This Saturday · Local',           context: 'Jeff is free Saturday afternoon.',  priority_tags: ['family_experiences'], seed: true },
      { id: 'fireworks',         name: 'County Fireworks',            date: D(PerchDate.plusDays(28)),      icon: '🎆', detail: '4th of July · Free',               context: 'Free family event.',                priority_tags: ['family_experiences'], seed: true },
      { id: 'homestead_workshop',name: 'Fall Homesteading Workshop',  date: D(PerchDate.plusMonths(3)),     icon: '🍂', detail: 'Nearby · Skills + community',      context: 'Builds homestead skills.',          priority_tags: ['homestead_expansion','career_growth'], seed: true },
      { id: 'garden_window',     name: 'Garden window — Thursday',    date: D(PerchDate.nextThursday()),    icon: '🌱', detail: 'Forecast clear · Jeff off',         context: 'Best outdoor conditions this week.',priority_tags: ['homestead_expansion','health_recovery'], seed: true }
    ],
    homestead: {
      animals: [
        { type: 'chickens', count: 'flock', notes: 'Free range barnyard mix.', seed: true }
      ],
      maintenance: [
        { id: 'hvac_filter',  name: 'Rental HVAC filter',   urgency: 'high',      overdue_months: 4, cost_estimate: 25, priority_tags: ['financial_freedom','homestead_expansion'], seed: true },
        { id: 'lawn_mow',     name: 'Lawn mow',              urgency: 'this_week',                    priority_tags: ['homestead_expansion'], seed: true },
        { id: 'coop_clean',   name: 'Chicken coop clean',    urgency: 'soon',      days_since: 12,    priority_tags: ['homestead_expansion'], seed: true },
        { id: 'gutter_check', name: 'Gutter check',          urgency: 'upcoming',                     priority_tags: ['homestead_expansion'], seed: true }
      ],
      goals: [
        { id: 'greenhouse', name: 'Greenhouse build', cost_estimate: 400, season: 'spring', priority_tags: ['homestead_expansion'], created_date: D(PerchDate.today()), seed: true }
      ],
      log: []
    },
    captures: [
      { id: 'c_ring',     label: "Waiting On Maura\u2019s Ring", perch_action: 'waiting_on',  expected: D(PerchDate.plusDays(14)), priority_tags: ['family_experiences'], seed: true },
      { id: 'c_shift',    label: 'Extra Shift Opportunity',  perch_action: 'opportunity', expected: D(PerchDate.plusDays(18)), priority_tags: ['financial_freedom','career_growth'], seed: true },
      { id: 'c_permit',   label: 'Call County About Permit', perch_action: 'reminder',    expected: null,                      priority_tags: ['homestead_expansion'], seed: true },
      { id: 'c_baseball', label: "Noah\u2019s Baseball",     perch_action: 'recurring',   day_of_week: 4,                      priority_tags: ['family_experiences'], seed: true }
    ],
    protected_time: [
      { id: 'sun_morning', label: 'Sunday morning',  icon: '\u2600\uFE0F', description: 'Longest recovery window this week' },
      { id: 'tue_evening', label: 'Tuesday evening', icon: '\uD83C\uDF19', description: 'Family time \u2014 nothing scheduled' }
    ],
    significance_history: [],
    ok_rules: {
      enabled: true,
      conditions: {
        no_bills_today:         { on: true },
        no_manual_bills_soon:   { on: true, days: 3 },
        no_autopay_bills_soon:  { on: false, days: 3 },
        bills_before_payday:    { on: true },
        no_overdue_housing:     { on: true },
        safe_to_spend_floor:    { on: false, amount: 0 },
        no_urgent_maintenance:  { on: true },
        no_waiting_past_due:    { on: true },
        no_high_priority_open:  { on: false },
        no_heavy_work_stretch:  { on: true, hours: 72, shift_count: 3 },
        no_event_planning_soon: { on: true, days: 7 }
      },
      awareness_days: 7,
      last_edited: null
    },
    _meta: { version: 4, schema: 'perch_memory_v4', last_updated: new Date().toISOString() }
  };

  const KEY = 'perch_memory_v1';
  function deepMerge(t, s) {
    const o = { ...t };
    for (const k of Object.keys(s)) {
      if (Array.isArray(s[k])) o[k] = s[k];
      else if (s[k] && typeof s[k] === 'object') o[k] = deepMerge(t[k] || {}, s[k]);
      else o[k] = s[k];
    }
    return o;
  }
  function load() {
    try { const s = localStorage.getItem(KEY); if (s) return deepMerge(DEFAULTS, JSON.parse(s)); } catch(e) {}
    return JSON.parse(JSON.stringify(DEFAULTS));
  }
  function save(data) {
    try { data._meta.last_updated = new Date().toISOString(); localStorage.setItem(KEY, JSON.stringify(data)); } catch(e) {}
  }

  // ── SEED MIGRATION ──────────────────────────
  // localStorage loaded before this build won't have seed:true on any items.
  // We detect them by canonical ID or fingerprint and tag them so clearSeedData works.
  // A user_owned:true flag means the user explicitly edited the item — don't re-tag.
  const SEED_PERSON_IDS  = new Set(['noah','emma','samuel','william','wife','maura']);
  const SEED_BILL_IDS    = new Set(['electric','internet','water','rental_mortgage_bill','insurance','phone','netflix']);
  const SEED_SHIFT_IDS   = new Set(['shift_wed','shift_thu','shift_sat']);
  const SEED_ACCOUNT_IDS = new Set(['checking','savings','jeff_cc','wife_cc']);
  const SEED_PROP_IDS    = new Set(['bronze','spicewood']);
  const SEED_HORIZON_IDS = new Set(['yellowstone','anniversary','insurance_renewal','maura_ring']);
  const SEED_OPP_IDS     = new Set(['festival','fireworks','homestead_workshop','garden_window','extra_icu_shift']);
  const SEED_MAINT_IDS   = new Set(['hvac_filter','lawn_mow','coop_clean','gutter_check']);
  const SEED_CAP_IDS     = new Set(['c_ring','c_shift','c_permit','c_baseball']);

  function migrateSeedFlags(st) {
    let dirty = false;
    function tag(arr, idSet) {
      (arr || []).forEach(x => {
        if (!x.seed && !x.user_owned && idSet.has(x.id)) { x.seed = true; dirty = true; }
      });
    }
    tag(st.people, SEED_PERSON_IDS);
    tag(st.bills, SEED_BILL_IDS);
    tag(st.properties, SEED_PROP_IDS);
    tag(st.captures, SEED_CAP_IDS);
    tag(st.future_horizon, SEED_HORIZON_IDS);
    tag(st.opportunities, SEED_OPP_IDS);
    if (st.work) {
      tag(st.work.schedule, SEED_SHIFT_IDS);
      tag(st.work.opportunities, SEED_OPP_IDS);
    }
    if (st.homestead) {
      tag(st.homestead.maintenance, SEED_MAINT_IDS);
    }
    const fin = st.finances || {};
    tag(fin.accounts, SEED_ACCOUNT_IDS);
    if (fin.paycheck && !fin.paycheck.seed && !fin.paycheck.user_owned
        && fin.paycheck.amount === 2800) { fin.paycheck.seed = true; dirty = true; }
    if (dirty) save(st);
    return st;
  }

  let state = migrateSeedFlags(load());
  function get(path)       { return path.split('.').reduce((o,k) => o?.[k], state); }
  function set(path, val)  { const ks=path.split('.'); const last=ks.pop(); const t=ks.reduce((o,k)=>o?.[k],state); if(t){t[last]=val;save(state);} }
  function remember(col, item) { const a=get(col); if(Array.isArray(a)){item.id=item.id||col+'_'+Date.now();a.push(item);save(state);} }
  function forget(col, id)     { const a=get(col); if(Array.isArray(a)){const i=a.findIndex(x=>x.id===id);if(i>-1){a.splice(i,1);save(state);}} }
  function reset()             { localStorage.removeItem(KEY); state=JSON.parse(JSON.stringify(DEFAULTS)); }
  function snapshot()          { return JSON.parse(JSON.stringify(state)); }

  // ── SCHEMA MIGRATION ─────────────────────
  // Runs once on load when stored version < current DEFAULTS version.
  // Silently backfills new fields without disrupting existing data.
  function migrate() {
    const storedVersion = state._meta?.version || 1;
    if (storedVersion >= 4) return; // already current

    const today = PerchDate.fmt(PerchDate.today());
    const createdProxy = state._meta?.last_updated
      ? state._meta.last_updated.split('T')[0]
      : today;

    // v1 → v2
    if (storedVersion < 2) {
      if (!state.user.checkins)     state.user.checkins = [];
      if (!state.user.last_checkin) state.user.last_checkin = null;
      const birthYears = { noah: 2013, emma: 2015, samuel: 2021, william: 2022, wife: null };
      (state.people || []).forEach(p => {
        if (p.birth_year === undefined) p.birth_year = birthYears[p.id] ?? null;
      });
      if (!state.finances.snapshots) state.finances.snapshots = [];
      (state.finances?.goals || []).forEach(g => {
        if (!g.created_date) g.created_date = createdProxy;
      });
      if (!state.work.completed_shifts) state.work.completed_shifts = [];
      (state.future_horizon || []).forEach(f => {
        if (!f.created_date) f.created_date = createdProxy;
      });
      if (!state.homestead.log) state.homestead.log = [];
      (state.homestead?.goals || []).forEach(g => {
        if (!g.created_date) g.created_date = createdProxy;
      });
      if (!state.actions) state.actions = [];
      console.log('[PerchMemory] migrated to v2');
    }

    // v2 → v3
    if (storedVersion < 3) {
      if (!state.significance_history) state.significance_history = [];
      console.log('[PerchMemory] migrated to v3');
    }

    // v3 → v4: add ok_rules
    if (storedVersion < 4) {
      if (!state.ok_rules) state.ok_rules = JSON.parse(JSON.stringify(DEFAULTS.ok_rules));
      console.log('[PerchMemory] migrated to v4');
    }
    // Backfill: ensure newer ok_rules conditions exist for users already on v4
    if (state.ok_rules && state.ok_rules.conditions && !state.ok_rules.conditions.no_autopay_bills_soon) {
      state.ok_rules.conditions.no_autopay_bills_soon = { on: false, days: 3 };
    }

    state._meta.version = 4;
    state._meta.schema  = 'perch_memory_v4';
    save(state);
  }

  // ── CHECKIN RECORDER ─────────────────────
  // Call once per page load. Records session timestamp.
  // Caps checkins[] at 365 entries (one year rolling).
  function recordCheckin() {
    const now     = new Date();
    const dateStr = PerchDate.fmt(PerchDate.today());
    const timeStr = now.toTimeString().slice(0, 5); // HH:MM
    const dow     = now.getDay(); // 0=Sun

    // Don't double-record the same date+time (e.g. hot reload)
    const checkins = state.user.checkins || [];
    const last     = checkins[checkins.length - 1];
    if (last && last.date === dateStr && last.time === timeStr) return;

    checkins.push({ date: dateStr, time: timeStr, dow });
    // Cap at 365 — drop oldest
    if (checkins.length > 365) checkins.splice(0, checkins.length - 365);

    state.user.checkins     = checkins;
    state.user.last_checkin = dateStr;
    save(state);
  }

  // ── MONTHLY FINANCIAL SNAPSHOT ───────────
  // Call once per page load. Writes one snapshot per calendar month.
  // Caps snapshots[] at 24 entries (two years rolling).
  function takeMonthlySnapshot() {
    const today    = new Date();
    const month    = today.toISOString().slice(0, 7); // 'YYYY-MM'
    const snapshots = state.finances.snapshots || [];

    // Already have a snapshot for this month — skip
    if (snapshots.find(s => s.month === month)) return;

    // Build account balance map
    const accounts = {};
    (state.finances.accounts || []).forEach(a => {
      accounts[a.id] = a.balance;
    });

    // CC utilization: sum CC balances / sum CC limits
    const ccAccounts = (state.finances.accounts || []).filter(a => a.limit);
    const ccBalance  = ccAccounts.reduce((s, a) => s + (a.balance || 0), 0);
    const ccLimit    = ccAccounts.reduce((s, a) => s + (a.limit   || 0), 0);
    const ccUtilPct  = ccLimit > 0 ? Math.round((ccBalance / ccLimit) * 100) : null;

    const entry = {
      month,
      date:          PerchDate.fmt(PerchDate.today()),
      accounts,                             // {checking: 3241, savings: 1850, ...}
      safe_to_spend: state.finances.safe_to_spend,
      cc_balance:    ccBalance,
      cc_limit:      ccLimit,
      cc_utilization_pct: ccUtilPct,
      goal_progress: (state.finances.goals || []).map(g => ({
        id: g.id, current: g.current, target: g.target
      }))
    };

    snapshots.push(entry);
    // Cap at 24 months
    if (snapshots.length > 24) snapshots.splice(0, snapshots.length - 24);

    state.finances.snapshots = snapshots;
    save(state);
    console.log('[PerchMemory] monthly snapshot taken:', month);
  }

  // ── SIGNIFICANCE HISTORY ─────────────────
  // Records a shown observation. Caps at 90 entries.
  function recordSignificance(entry) {
    // entry: {type, text, source_ids, expires_after_days}
    const hist = state.significance_history || [];
    hist.push({
      id:                 'sig_' + Date.now(),
      type:               entry.type,
      text:               entry.text,
      shown_date:         PerchDate.fmt(PerchDate.today()),
      source_ids:         entry.source_ids || [],
      expires_after_days: entry.expires_after_days || 7
    });
    if (hist.length > 90) hist.splice(0, hist.length - 90);
    state.significance_history = hist;
    save(state);
  }

  function getSignificanceHistory() {
    return (state.significance_history || []).slice();
  }

  // ── "MY OK" EVALUATION ───────────────────
  // Returns {ok, passed:[], failed:[], notable:[]} based on Jeff's OK rules.
  // failed[] entries carry the specific reason + items so the message can be honest.
  // notable[] = things in the awareness window (7d) that don't block OK but are worth a mention.
  function evaluateOK() {
    const rules = state.ok_rules;
    if (!rules || !rules.enabled) {
      return { ok: null, passed: [], failed: [], notable: [], disabled: true };
    }
    const cond   = rules.conditions || {};
    const passed = [], failed = [], notable = [];

    const todayDate = new Date(); todayDate.setHours(0,0,0,0);
    const fmtDate = d => PerchDate.fmt(d);
    const bills = (state.bills || []).filter(b => b.status !== 'completed' && b.status !== 'dismissed');

    // resolve a bill's next due date from due_day
    const billDue = b => {
      const d = new Date(todayDate.getFullYear(), todayDate.getMonth(), b.due_day);
      if (d < todayDate) d.setMonth(d.getMonth() + 1);
      return d;
    };
    const daysOut = d => Math.round((d - todayDate) / 86400000);
    const cleanNm = n => (n || '').split('\u2014')[0].split('\u2013')[0].trim();

    // payday
    const pay = state.finances && state.finances.paycheck;
    const paydayDate = pay && pay.next_date ? new Date(pay.next_date + 'T00:00:00') : null;

    // 1. no bills due today
    if (cond.no_bills_today && cond.no_bills_today.on) {
      const due = bills.filter(b => daysOut(billDue(b)) === 0);
      if (due.length) failed.push({ rule:'no_bills_today', reason:'due today', items: due.map(b=>cleanNm(b.name)) });
      else passed.push({ rule:'no_bills_today', reason:'nothing due today' });
    }

    // 2. no MANUAL bills in next N days
    if (cond.no_manual_bills_soon && cond.no_manual_bills_soon.on) {
      const n = cond.no_manual_bills_soon.days || 3;
      const soon = bills.filter(b => !b.autopay && daysOut(billDue(b)) >= 0 && daysOut(billDue(b)) <= n);
      if (soon.length) {
        failed.push({ rule:'no_manual_bills_soon', reason:'manual bills due within '+n+' days',
          items: soon.map(b=>({name:cleanNm(b.name), amount:b.amount, days:daysOut(billDue(b))})) });
      } else {
        passed.push({ rule:'no_manual_bills_soon', reason:'nothing manual due for '+n+' days' });
      }
    }

    // 2b. no AUTOPAY bills due soon (opt-in; off by default)
    if (cond.no_autopay_bills_soon && cond.no_autopay_bills_soon.on) {
      const n = cond.no_autopay_bills_soon.days || 3;
      const soon = bills.filter(b => b.autopay && daysOut(billDue(b)) >= 0 && daysOut(billDue(b)) <= n);
      if (soon.length) {
        failed.push({ rule:'no_autopay_bills_soon', reason:'autopay bills due within '+n+' days',
          items: soon.map(b=>({name:cleanNm(b.name), amount:b.amount, days:daysOut(billDue(b))})) });
      } else {
        passed.push({ rule:'no_autopay_bills_soon', reason:'no autopay bills due for '+n+' days' });
      }
    }

    // 3. bills before payday covered by current balance (computed, not a stored constant)
    if (cond.bills_before_payday && cond.bills_before_payday.on && paydayDate) {
      const fin = financeSnapshot();
      if (fin.projected < 0) {
        failed.push({ rule:'bills_before_payday', reason:'bills before payday exceed your balance',
          items:[{ total: fin.totalBefore, balance: fin.balance, projected: fin.projected }] });
      } else {
        passed.push({ rule:'bills_before_payday', reason:'bills before payday are covered' });
      }
    }

    // 4. no overdue housing (mortgage/rent)
    if (cond.no_overdue_housing && cond.no_overdue_housing.on) {
      const housing = bills.filter(b => /mortgage|rent/i.test(b.name) && daysOut(billDue(b)) < 0);
      if (housing.length) failed.push({ rule:'no_overdue_housing', reason:'housing overdue', items: housing.map(b=>cleanNm(b.name)) });
      else passed.push({ rule:'no_overdue_housing', reason:'no overdue mortgage or rent' });
    }

    // 5. safe-to-spend floor
    if (cond.safe_to_spend_floor && cond.safe_to_spend_floor.on) {
      const safe = (state.finances && state.finances.safe_to_spend) || 0;
      const floor = cond.safe_to_spend_floor.amount || 0;
      if (safe < floor) failed.push({ rule:'safe_to_spend_floor', reason:'below your safe-to-spend floor', items:[{safe, floor}] });
      else passed.push({ rule:'safe_to_spend_floor', reason:'above your spending floor' });
    }

    // 6. no urgent maintenance
    if (cond.no_urgent_maintenance && cond.no_urgent_maintenance.on) {
      const urgent = ((state.homestead && state.homestead.maintenance) || []).filter(m => m.urgency === 'high' && m.status !== 'completed');
      if (urgent.length) failed.push({ rule:'no_urgent_maintenance', reason:'urgent maintenance', items: urgent.map(m=>m.name) });
      else passed.push({ rule:'no_urgent_maintenance', reason:'no urgent maintenance' });
    }

    // 7. no waiting item past its expected date
    // Waiting items live in TWO places with TWO shapes:
    //   • future_horizon[]: status 'waiting_on', date field 'date_start'
    //   • captures[]:       perch_action 'waiting_on', date field 'expected'
    // Treat an item as still-waiting unless it's been resolved/arrived/completed/dismissed.
    if (cond.no_waiting_past_due && cond.no_waiting_past_due.on) {
      const DONE = new Set(['resolved','arrived','completed','dismissed']);
      const overdue = [];
      // future_horizon shape
      (state.future_horizon || []).forEach(f => {
        if (f.status !== 'waiting_on') return;
        const dstr = f.date_start || f.expected;
        if (dstr && new Date(dstr + 'T00:00:00') < todayDate) overdue.push(cleanNm(f.name));
      });
      // captures shape (Tell Perch)
      (state.captures || []).forEach(c => {
        if (c.perch_action !== 'waiting_on') return;
        if (DONE.has(c.status)) return;
        const dstr = c.expected || c.date_start;
        if (dstr && new Date(dstr + 'T00:00:00') < todayDate) overdue.push(cleanNm(c.label || c.name));
      });
      if (overdue.length) failed.push({ rule:'no_waiting_past_due', reason:'waiting item overdue', items: overdue });
      else passed.push({ rule:'no_waiting_past_due', reason:'nothing waiting is overdue' });
    }

    // 8. no high-priority open action
    if (cond.no_high_priority_open && cond.no_high_priority_open.on) {
      const acts = (state.actions || []).filter(a => a.status === 'open' && a.priority === 'high');
      if (acts.length) failed.push({ rule:'no_high_priority_open', reason:'high-priority task open', items: acts.map(a=>a.target_name||'task') });
      else passed.push({ rule:'no_high_priority_open', reason:'no urgent tasks open' });
    }

    // 9. no heavy work stretch in next N hours
    if (cond.no_heavy_work_stretch && cond.no_heavy_work_stretch.on) {
      const hrs = cond.no_heavy_work_stretch.hours || 72;
      const need = cond.no_heavy_work_stretch.shift_count || 3;
      const dayWindow = Math.ceil(hrs/24);
      const todayDow = todayDate.getDay();
      const schedule = (state.work && state.work.schedule) || [];
      let count = 0;
      for (let i=0;i<=dayWindow;i++){ const dow=(todayDow+i)%7; count += schedule.filter(s=>s.day_of_week===dow).length; }
      // Also honor a user-declared work stretch (from the Today input)
      let declared = null;
      (state.captures||[]).forEach(c=>{
        if (c.work_stretch && c.range_start && c.range_end) {
          const s = new Date(c.range_start+'T00:00:00'), e = new Date(c.range_end+'T00:00:00');
          if (e >= todayDate && s <= new Date(todayDate.getTime()+dayWindow*86400000)) {
            const dayspan = Math.round((e - todayDate)/86400000)+1;
            declared = Math.max(declared||0, Math.min(dayspan, dayWindow+1));
          }
        }
      });
      if (declared && declared >= need) {
        failed.push({ rule:'no_heavy_work_stretch', reason:'you said you\u2019re working the next '+declared+' days', items:[{count:declared, hours:hrs, declared:true}] });
      } else if (count >= need) {
        failed.push({ rule:'no_heavy_work_stretch', reason:count+' shifts in next '+hrs+'h', items:[{count, hours:hrs}] });
      } else {
        passed.push({ rule:'no_heavy_work_stretch', reason:'no heavy work stretch ahead' });
      }
    }

    // 10. no event planning due within N days  (this is a BLOCKER only inside 3d; otherwise notable)
    if (cond.no_event_planning_soon && cond.no_event_planning_soon.on) {
      const n = cond.no_event_planning_soon.days || 7;
      const fh = (state.future_horizon || []).filter(f => f.date_start && f.status !== 'completed');
      const within = fh.filter(f => { const dd = daysOut(new Date(f.date_start+'T00:00:00')); return dd>=0 && dd<=n; });
      // Only block if within 3 days; otherwise just notable
      const blocking = within.filter(f => daysOut(new Date(f.date_start+'T00:00:00')) <= 3);
      if (blocking.length) failed.push({ rule:'no_event_planning_soon', reason:'event needs planning soon', items: blocking.map(f=>cleanNm(f.name)) });
      else passed.push({ rule:'no_event_planning_soon', reason:'no imminent event planning' });
    }

    // NOTABLE: things in awareness window (default 7d) that don't block OK
    const awareDays = rules.awareness_days || 7;
    const manualSoonDays = (cond.no_manual_bills_soon && cond.no_manual_bills_soon.days) || 3;
    bills.forEach(b => {
      const dd = daysOut(billDue(b));
      if (dd > manualSoonDays && dd <= awareDays && !b.autopay) {
        notable.push({ kind:'bill', name:cleanNm(b.name), amount:b.amount, days:dd });
      }
    });
    (state.future_horizon || []).forEach(f => {
      if (f.date_start && f.status !== 'completed') {
        const dd = daysOut(new Date(f.date_start+'T00:00:00'));
        if (dd > 3 && dd <= awareDays) notable.push({ kind:'event', name:cleanNm(f.name), days:dd });
      }
    });

    return { ok: failed.length === 0, passed, failed, notable, disabled:false };
  }

  // Apply a single OK-rule change. spec: {kind, ...}
  //   {kind:'condition', key, on}          → toggle a condition
  //   {kind:'param', key, field, value}    → set a numeric param (days/hours/shift_count)
  //   {kind:'awareness', value}            → set awareness_days
  //   {kind:'enabled', on}                 → master switch
  function updateOKRule(spec) {
    const r = state.ok_rules || (state.ok_rules = JSON.parse(JSON.stringify(DEFAULTS.ok_rules)));
    if (!r.conditions) r.conditions = {};
    if (spec.kind === 'condition' && r.conditions[spec.key]) {
      r.conditions[spec.key].on = !!spec.on;
    } else if (spec.kind === 'param' && r.conditions[spec.key]) {
      r.conditions[spec.key][spec.field] = spec.value;
      if (spec.also_on) r.conditions[spec.key].on = true;
    } else if (spec.kind === 'awareness') {
      r.awareness_days = spec.value;
    } else if (spec.kind === 'enabled') {
      r.enabled = !!spec.on;
    } else {
      return false;
    }
    r.last_edited = PerchDate.fmt(PerchDate.today());
    save(state);
    return true;
  }

  // Detect a natural-language request to change an OK rule. Returns a preview
  // object {spec, ruleLabel, newValue, sentence} or null if no rule-change intent.
  function detectOKRuleChange(text) {
    const low = (text || '').toLowerCase();
    let m;

    // Heavy work stretch — "if I work 3 days in a row don't tell me I'm clear", "heavy work should block ok"
    if (/work\s+\d*\s*days? in a row|don.?t (tell me|say) i.?m clear.*work|work stretch (should|block)|if i (work|am working)/.test(low)
        || (/work/.test(low) && /don.?t (tell me|say).*(clear|ok)/.test(low))) {
      let n = null; m = low.match(/(\d+)\s*days?/); if (m) n = parseInt(m[1]);
      const spec = { kind:'condition', key:'no_heavy_work_stretch', on:true };
      if (n) return { spec:[spec,{kind:'param',key:'no_heavy_work_stretch',field:'shift_count',value:n,also_on:true}],
                      ruleLabel:'Heavy work stretch blocks OK', newValue:'on \u00b7 '+n+'+ shifts', sentence:text };
      return { spec:[spec], ruleLabel:'Heavy work stretch blocks OK', newValue:'on', sentence:text };
    }

    // Awareness window — "watch 14 days ahead", "awareness 7 days" (check before lookahead)
    if (/(watch|aware|awareness|keep an eye).*\d+\s*days?/.test(low)) {
      m = low.match(/(\d+)\s*days?/);
      if (m) return { spec:[{kind:'awareness',value:parseInt(m[1])}],
                      ruleLabel:'Awareness window', newValue:m[1]+' days', sentence:text };
    }

    // Lookahead window — "I feel OK if nothing is due for the next 3 days", "look ahead 5 days"
    if (/(feel ok|i.?m ok|tell me i.?m clear|clear).*(next |for )?\d+\s*days?/.test(low)
        || /look ?ahead\s*\d+\s*days?/.test(low)
        || /\d+\s*days?\s*(ahead|window|out)/.test(low)) {
      m = low.match(/(\d+)\s*days?/);
      if (m) {
        const n = parseInt(m[1]);
        return { spec:[{kind:'param',key:'no_manual_bills_soon',field:'days',value:n,also_on:true}],
                 ruleLabel:'Look-ahead window for manual bills', newValue:n+' days', sentence:text };
      }
    }

    // Autopay — "autopay doesn't stress me" / "I only care about manual bills" → off
    if (/autopay (doesn.?t|does not) (stress|bother|worry)|only care about manual|manual bills only|ignore autopay/.test(low)) {
      return { spec:[{kind:'condition',key:'no_autopay_bills_soon',on:false}],
               ruleLabel:'Autopay bills block OK', newValue:'off', sentence:text };
    }
    // Autopay — "tell me about autopay too" / "warn me about autopay" → on
    if (/autopay too|about autopay|warn me .* autopay|count autopay|include autopay/.test(low)) {
      return { spec:[{kind:'condition',key:'no_autopay_bills_soon',on:true}],
               ruleLabel:'Autopay bills block OK', newValue:'on', sentence:text };
    }

    // Maintenance — "don't warn me about maintenance"
    if (/(don.?t|do not|stop).*(warn|tell|bother).*(maintenance|repair|hvac|filter)/.test(low)
        || /maintenance (doesn.?t|does not) (block|matter|stress)/.test(low)) {
      return { spec:[{kind:'condition',key:'no_urgent_maintenance',on:false}],
               ruleLabel:'Urgent maintenance blocks OK', newValue:'off', sentence:text };
    }
    // Maintenance on — "warn me about maintenance"
    if (/(warn|tell|remind) me about (urgent )?(maintenance|repairs)/.test(low)) {
      return { spec:[{kind:'condition',key:'no_urgent_maintenance',on:true}],
               ruleLabel:'Urgent maintenance blocks OK', newValue:'on', sentence:text };
    }

    return null;
  }

  // Remove demo/seed shifts the user never entered. Returns count removed.
  function clearSeedShifts() {
    const sched = (state.work && state.work.schedule) || [];
    const before = sched.length;
    state.work.schedule = sched.filter(s => !s.seed);
    save(state);
    return before - state.work.schedule.length;
  }
  function hasSeedShifts() {
    return ((state.work && state.work.schedule) || []).some(s => s.seed);
  }

  // ── SEED / DEMO DATA MANAGEMENT ──────────────
  // An item is "seed" if it has seed:true, OR matches a known starter ID and lacks user_owned.
  function _isSeedItem(x, idSet) {
    if (!x) return false;
    if (x.user_owned || x.user_created) return false; // user explicitly owns/created it
    if (x.seed === true) return true;
    return idSet ? idSet.has(x.id) : false;
  }

  function getSeedCounts() {
    const fin = state.finances || {};
    const workOpps = (state.work && state.work.opportunities) || [];
    const globalOpps = state.opportunities || [];
    // paycheck is seed if seed flag is set, OR amount matches the default AND not user_owned
    const paycheckIsSeed = !!(fin.paycheck && !fin.paycheck.user_owned &&
      (fin.paycheck.seed || fin.paycheck.amount === 2800));
    return {
      shifts:       ((state.work && state.work.schedule) || []).filter(s => _isSeedItem(s, SEED_SHIFT_IDS)).length,
      bills:        (state.bills || []).filter(b => _isSeedItem(b, SEED_BILL_IDS)).length,
      accounts:     (fin.accounts || []).filter(a => _isSeedItem(a, SEED_ACCOUNT_IDS)).length,
      paycheck:     paycheckIsSeed ? 1 : 0,
      people:       (state.people || []).filter(p => _isSeedItem(p, SEED_PERSON_IDS)).length,
      properties:   (state.properties || []).filter(p => _isSeedItem(p, SEED_PROP_IDS)).length,
      captures:     (state.captures || []).filter(c => _isSeedItem(c, SEED_CAP_IDS)).length,
      maintenance:  ((state.homestead && state.homestead.maintenance) || []).filter(m => _isSeedItem(m, SEED_MAINT_IDS)).length,
      horizon:      (state.future_horizon || []).filter(h => _isSeedItem(h, SEED_HORIZON_IDS)).length,
      opportunities:[...workOpps, ...globalOpps].filter(o => _isSeedItem(o, SEED_OPP_IDS)).length,
    };
  }

  function hasSeedData() {
    // Check ALL collections, not just a subset
    return Object.values(getSeedCounts()).some(n => n > 0);
  }

  function clearSeedData() {
    // Remove ALL known starter items — by seed flag OR by ID (belt-and-suspenders)
    if (state.work) {
      state.work.schedule     = (state.work.schedule     || []).filter(s => !_isSeedItem(s, SEED_SHIFT_IDS));
      state.work.opportunities= (state.work.opportunities|| []).filter(o => !_isSeedItem(o, SEED_OPP_IDS));
    }
    state.bills          = (state.bills          || []).filter(b => !_isSeedItem(b, SEED_BILL_IDS));
    state.people         = (state.people         || []).filter(p => !_isSeedItem(p, SEED_PERSON_IDS));
    state.properties     = (state.properties     || []).filter(p => !_isSeedItem(p, SEED_PROP_IDS));
    state.captures       = (state.captures       || []).filter(c => !_isSeedItem(c, SEED_CAP_IDS));
    state.future_horizon = (state.future_horizon || []).filter(h => !_isSeedItem(h, SEED_HORIZON_IDS));
    state.opportunities  = (state.opportunities  || []).filter(o => !_isSeedItem(o, SEED_OPP_IDS));

    const fin = state.finances || {};
    fin.accounts  = (fin.accounts || []).filter(a => !_isSeedItem(a, SEED_ACCOUNT_IDS));
    fin.goals     = (fin.goals    || []).filter(g => !g.seed);
    fin.safe_to_spend = 0;
    // Clear seed paycheck (identified by seed flag OR default amount of 2800 when not user_owned)
    if (fin.paycheck && !fin.paycheck.user_owned && (fin.paycheck.seed || fin.paycheck.amount === 2800)) {
      fin.paycheck = { amount: 0, next_date: null };
    }
    state.finances = fin;

    if (state.homestead) {
      state.homestead.maintenance = (state.homestead.maintenance || []).filter(m => !_isSeedItem(m, SEED_MAINT_IDS));
      state.homestead.animals     = (state.homestead.animals     || []).filter(a => !a.seed);
      state.homestead.goals       = (state.homestead.goals       || []).filter(g => !g.seed);
    }

    // Only mark as fully cleared if counts are truly zero now
    const remaining = getSeedCounts();
    const allGone   = Object.values(remaining).every(n => n === 0);
    if (!state._meta) state._meta = {};
    if (allGone) {
      state._meta.seed_cleared      = true;
      state._meta.seed_cleared_date = PerchDate.fmt(PerchDate.today());
    } else {
      // Partial clear — do NOT set seed_cleared; let the banner/settings remain available
      delete state._meta.seed_cleared;
    }
    save(state);
    return remaining;
  }

  function dismissSeedBanner() {
    // "Keep for now" — just records the explicit dismiss without clearing.
    // Banner will re-appear next session unless user clears or dismisses again.
    if (!state._meta) state._meta = {};
    state._meta.seed_dismissed = true;
    save(state);
  }

  function seedBannerDismissed() {
    // Banner is hidden ONLY if:
    // (a) user explicitly dismissed ("keep for now") AND no seed data remains, OR
    // (b) seed was successfully fully cleared (seed_cleared:true AND zero remaining)
    if (!state._meta) return false;
    const fullyCleared = state._meta.seed_cleared && !hasSeedData();
    const dismissedWhileEmpty = state._meta.seed_dismissed && !hasSeedData();
    return fullyCleared || dismissedWhileEmpty;
  }

  // ── FINANCE SOURCE OF TRUTH ──────────────
  // Single computed snapshot used by BOTH the Money Flow card and My OK,
  // so the displayed numbers can never contradict each other.
  // Returns the next payday (rolling forward if the stored date is in the past),
  // bills before that payday, and a projected balance = balance − bills before payday.
  function getNextPayday() {
    const pay = state.finances && state.finances.paycheck;
    if (!pay || !pay.next_date) return { date: null, amount: pay ? pay.amount : 0, stale: false };
    const today = new Date(); today.setHours(0,0,0,0);
    let d = new Date(pay.next_date + 'T00:00:00');
    let stale = false;
    // Roll a past/stored payday forward by whole weeks (biweekly→2w not assumed; weekly step is safe default)
    // We step by 14 days first if it looks biweekly, else 7; here we step 7 until not in the past.
    let guard = 0;
    while (d < today && guard < 60) { d.setDate(d.getDate() + 7); stale = true; guard++; }
    return { date: d, amount: pay.amount || 0, stale };
  }

  function financeSnapshot() {
    const today = new Date(); today.setHours(0,0,0,0);
    const accounts = (state.finances && state.finances.accounts) || [];
    const checking = accounts.find(a => /check/i.test(a.name)) || accounts[0] || null;
    const balance = checking ? (checking.balance || 0) : 0;

    const pd = getNextPayday();
    const billDue = b => {
      const d = new Date(today.getFullYear(), today.getMonth(), b.due_day);
      if (d < today) d.setMonth(d.getMonth() + 1);
      return d;
    };
    // Bills that still count against balance: not paid, not pulled, not skipped, not dismissed
    const SETTLED = new Set(['completed','dismissed','paid_this_month','pulled_this_month','skipped_this_month']);
    const unsettled = (state.bills || []).filter(b => !SETTLED.has(b.status));

    // Bills strictly before payday (a bill due ON payday is covered by the deposit)
    const beforeBills = pd.date
      ? unsettled.filter(b => { const d = billDue(b); return d >= today && d < pd.date; })
             .map(b => ({
               id: b.id,
               name: b.name,
               amount: b.amount || 0,
               autopay: b.autopay,
               payment_type: b.payment_type || (b.autopay ? 'autopay' : 'manual'),
               date: billDue(b),
               status: b.status || 'active'
             }))
             .sort((a,b) => a.date - b.date)
      : [];
    const totalBefore = beforeBills.reduce((s,b) => s + b.amount, 0);
    const projected = balance - totalBefore;
    const daysToPayday = pd.date ? Math.round((pd.date - today) / 86400000) : null;

    return {
      balance, beforeBills, totalBefore, projected,
      safeUntilPayday: projected,
      payday: pd.date, paydayAmount: pd.amount, daysToPayday,
      paydayStale: pd.stale, covered: projected >= 0
    };
  }

  // Reset monthly bill statuses at the start of a new month.
  // paid_this_month / pulled_this_month / skipped_this_month → 'active'
  // Called on each app load; only acts when the stored month differs from today.
  function resetMonthlyBillStatuses() {
    const today = new Date();
    const thisMonth = today.getFullYear() + '-' + String(today.getMonth() + 1).padStart(2, '0');
    if (!state._meta) state._meta = {};
    if (state._meta.bills_month === thisMonth) return; // already current
    const RESET = new Set(['paid_this_month', 'pulled_this_month', 'skipped_this_month']);
    let changed = false;
    (state.bills || []).forEach(b => {
      if (RESET.has(b.status)) { b.status = 'active'; changed = true; }
    });
    state._meta.bills_month = thisMonth;
    if (changed) save(state);
  }

  // ── SCHEDULE CORRECTION ──────────────────
  // Day shorthand → day_of_week
  const DAY_TOKENS = {
    sun:0, sunday:0,
    mon:1, monday:1,
    tue:2, tues:2, tuesday:2,
    wed:3, weds:3, wednesday:3,
    thu:4, thur:4, thurs:4, thursday:4,
    fri:5, friday:5,
    sat:6, saturday:6
  };
  const DAY_NAMES = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];

  // Find all day tokens in a fragment of text → array of {dow}
  function _daysIn(fragment) {
    const found = [];
    // match whole words only; longest-first so "tuesday" wins over "tue"
    const re = /\b(sunday|saturday|thursday|wednesday|tuesday|monday|friday|thurs|tues|weds|thur|sun|mon|tue|wed|thu|fri|sat)\b/g;
    let m;
    while ((m = re.exec(fragment)) !== null) {
      const dow = DAY_TOKENS[m[1]];
      if (dow != null && !found.includes(dow)) found.push(dow);
    }
    return found;
  }

  // Detect a schedule correction. Returns {remove:[dow], add:[dow], shiftName, sentence} or null.
  function detectScheduleCorrection(text) {
    const low = (text || '').toLowerCase();
    // Must be schedule-related
    if (!/\b(work|shift|shifts|off|schedule)\b/.test(low)) return null;

    let remove = [], add = [];

    // "next N days" forms (whole-stretch) — but affirmative "I work for the next N days"
    // is a work STRETCH (handled by PerchParse), not a schedule add. Negation/off forms
    // ("I don't work the next 3 days", "I'm off for the next 3 days") ARE schedule removals.
    let nMatch = low.match(/next (\d+) days?/);
    let nDays = nMatch ? parseInt(nMatch[1]) : (/next few days/.test(low) ? 3 : null);
    const todayDow = new Date().getDay();
    const isNeg = /(don.?t|do not|not|off)\b/.test(low);
    const affirmativeStretch = /for (?:the )?next (?:\d+|few) days?/.test(low) && !isNeg;
    if (nDays && !affirmativeStretch) {
      const span = [];
      for (let i=0;i<nDays;i++) span.push((todayDow+i)%7);
      if (/(don.?t|do not|not|off)/.test(low)) remove = span;
      else if (/\bi work\b|\bworking\b/.test(low)) add = span;
      if (remove.length||add.length) {
        return _finalizeCorrection(remove, add, text);
      }
    }

    // "move my X shift to Y"
    let mv = low.match(/move (?:my )?(\w+)(?:\s+shift)? to (\w+)/);
    if (mv) {
      const from = DAY_TOKENS[mv[1]], to = DAY_TOKENS[mv[2]];
      if (from != null && to != null) return _finalizeCorrection([from], [to], text);
    }

    // "I work X instead of Y"
    let inst = low.match(/(?:i )?work (.+?) instead of (.+)/);
    if (inst) {
      add = _daysIn(inst[1]); remove = _daysIn(inst[2]);
      if (add.length || remove.length) return _finalizeCorrection(remove, add, text);
    }

    // Robust approach: split the sentence into fragments on connectors, then
    // classify each fragment as remove (negation/off) or add (work/instead).
    // "and"/"but" only split when they separate clauses, but day-lists also use
    // "and" ("wed and thurs"). So: protect day-list "and" by only splitting on
    // connectors that are followed by a verb phrase (i / work / off / move).
    const protectedLow = low.replace(/\band\b(?=\s+(?:i\b|i'|im\b|i am\b))/g, ' ||SPLIT|| ');
    const fragments = protectedLow.split(/\|\|SPLIT\|\||[.;]| but /);

    fragments.forEach(frag => {
      const f = frag.trim();
      if (!f) return;
      const days = _daysIn(f);
      if (!days.length) return;
      const isRemove = /(?:don.?t|do not|no longer)\s+work|(?:i.?m|im|i am)\s+off|\boff\b/.test(f) && !/instead/.test(f.replace(/instead of/,''));
      const isAddInstead = /\binstead\b/.test(f) && !/instead of/.test(f);
      const isWork = /\bi work\b|\bworking\b/.test(f) && !/don.?t|do not|no longer/.test(f);

      // "X instead of Y": X(before instead)=add, Y(after of)=remove
      const io = f.match(/(.+?)\s+instead of\s+(.+)/);
      if (io) {
        _daysIn(io[1]).forEach(d=>{ if(!add.includes(d)) add.push(d); });
        _daysIn(io[2]).forEach(d=>{ if(!remove.includes(d)) remove.push(d); });
        return;
      }
      if (isRemove) { days.forEach(d=>{ if(!remove.includes(d)) remove.push(d); }); }
      else if (isWork || isAddInstead) { days.forEach(d=>{ if(!add.includes(d)) add.push(d); }); }
    });

    if (remove.length || add.length) return _finalizeCorrection(remove, add, text);
    return null;
  }

  function _finalizeCorrection(remove, add, text) {
    // If a day appears in both, ADD wins (remove it from the remove list)
    remove = remove.filter(d => !add.includes(d));
    // Derive a shift name from existing schedule (default "ICU Shift")
    const sched = (state.work && state.work.schedule) || [];
    const shiftName = (sched[0] && sched[0].name) || 'ICU Shift';
    return {
      remove: remove.map(dow => ({ dow, label: DAY_NAMES[dow], name: shiftName })),
      add:    add.map(dow => ({ dow, label: DAY_NAMES[dow], name: shiftName })),
      shiftName, sentence: text
    };
  }

  // Apply a confirmed (and possibly edited) schedule correction.
  function applyScheduleCorrection(correction) {
    if (!correction) return false;
    const sched = (state.work && state.work.schedule) || [];
    const removeDows = (correction.remove||[]).map(r=>r.dow);
    const addItems   = (correction.add||[]);

    // Remove
    let next = sched.filter(s => !removeDows.includes(s.day_of_week));
    // Add (skip days already present after removal)
    addItems.forEach(a => {
      if (!next.some(s => s.day_of_week === a.dow)) {
        next.push({
          id: 'shift_' + DAY_NAMES[a.dow].slice(0,3).toLowerCase() + '_' + Date.now() + '_' + a.dow,
          name: a.name || correction.shiftName || 'ICU Shift',
          day_of_week: a.dow, time: '07:00', hours: 12, recurrence: 'weekly'
          // no seed flag — user-entered
        });
      }
    });
    state.work.schedule = next;

    // Log the correction in actions
    const actions = state.actions || [];
    actions.push({
      id: 'corr_' + Date.now(),
      action: 'corrected', correction_kind: 'schedule',
      detail: {
        removed: removeDows.map(d=>DAY_NAMES[d]),
        added: addItems.map(a=>DAY_NAMES[a.dow])
      },
      target_name: 'Work schedule',
      timestamp: new Date().toISOString(),
      date: PerchDate.fmt(PerchDate.today())
    });
    state.actions = actions;
    save(state);
    if (window.PerchEvents) PerchEvents.refresh();
    return true;
  }

  return { get, set, remember, forget, reset, snapshot, DEFAULTS,
           migrate, recordCheckin, takeMonthlySnapshot,
           recordSignificance, getSignificanceHistory, evaluateOK,
           updateOKRule, detectOKRuleChange, clearSeedShifts, hasSeedShifts,
           detectScheduleCorrection, applyScheduleCorrection,
           getNextPayday, financeSnapshot,
           hasSeedData, getSeedCounts, clearSeedData, dismissSeedBanner, seedBannerDismissed,
           resetMonthlyBillStatuses };
})();
window.PerchMemory = PerchMemory;
// Run migration immediately on load — silent, idempotent
PerchMemory.migrate();

// ════════════════════════════════════════════
// 2b. NATURAL-LANGUAGE PARSER (shared by Capture + Today input)
// ════════════════════════════════════════════
const PerchParse = (() => {
  const RULES = [
    { type:'waiting_on', label:'Waiting On',
      patterns:[/back in/i,/returns? in/i,/should (be|arrive|come)/i,/should be (back|ready|done|here)/i,/waiting (for|on)/i,/expect(ed)? (in|back|by)/i,/arrives? in/i],
      icon:'\u23F3' },
    { type:'recurring', label:'Recurring',
      patterns:[/every (monday|tuesday|wednesday|thursday|friday|saturday|sunday)/i,/every (week|day|morning|night|evening)/i,/each (week|month|day)/i,/most (thursday|friday|monday|tuesday|wednesday|saturday|sunday)/i,/(monday|tuesday|wednesday|thursday|friday|saturday|sunday)s\b/i,/weekly/i,/monthly/i,/always on/i],
      icon:'\uD83D\uDD01' },
    { type:'opportunity', label:'Opportunity',
      patterns:[/available shift/i,/shift available/i,/extra shift/i,/job opportunity/i,/chance to/i,/open position/i],
      icon:'\u26A1' },
    { type:'goal', label:'Goal',
      patterns:[/save (for|up|\$)/i,/goal is/i,/want to (save|build|pay|reach)/i,/saving for/i,/pay off/i,/build (a|the|my)/i],
      icon:'\uD83C\uDFAF' },
    { type:'event', label:'Event',
      patterns:[/appointment/i,/meeting/i,/game on/i,/show on/i,/trip (on|in|to|this)/i,/festival/i,/wedding/i,/graduation/i,/concert/i,/plan .* (this weekend|weekend|trip)/i],
      icon:'\uD83D\uDCC5' },
    { type:'reminder', label:'Reminder',
      patterns:[/call/i,/remind/i,/don.?t forget/i,/need to/i,/have to/i,/must /i,/check on/i,/check the/i,/follow up/i,/contact/i,/email/i,/text/i,/renew/i,/schedule/i,/book/i,/make an? appointment/i,/clean/i,/pick up/i,/drop off/i],
      icon:'\uD83D\uDD14' },
  ];

  function resolveMonthDay(month, day) {
    const d = new Date(); d.setMonth(month); d.setDate(day);
    if (d < PerchDate.today()) d.setFullYear(d.getFullYear()+1);
    return PerchDate.fmt(d);
  }

  const DATE_PATTERNS = [
    { re:/in (\d+) weeks?/i,   resolve:m=>PerchDate.fmt(PerchDate.plusDays(parseInt(m[1])*7)) },
    { re:/in (\d+) days?/i,    resolve:m=>PerchDate.fmt(PerchDate.plusDays(parseInt(m[1]))) },
    { re:/in (\d+) months?/i,  resolve:m=>PerchDate.fmt(PerchDate.plusMonths(parseInt(m[1]))) },
    { re:/in (a|one) week/i,   resolve:()=>PerchDate.fmt(PerchDate.plusDays(7)) },
    { re:/in two weeks/i,      resolve:()=>PerchDate.fmt(PerchDate.plusDays(14)) },
    { re:/this weekend/i,      resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(6)) },
    { re:/tonight/i,           resolve:()=>PerchDate.fmt(PerchDate.today()) },
    { re:/today/i,             resolve:()=>PerchDate.fmt(PerchDate.today()) },
    { re:/yesterday/i,         resolve:()=>PerchDate.fmt(PerchDate.plusDays(-1)) },
    { re:/tomorrow/i,          resolve:()=>PerchDate.fmt(PerchDate.plusDays(1)) },
    { re:/next (monday|mon)\b/i,    resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(1)) },
    { re:/next (tuesday|tue)\b/i,   resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(2)) },
    { re:/next (wednesday|wed)\b/i, resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(3)) },
    { re:/next (thursday|thu)\b/i,  resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(4)) },
    { re:/next (friday|fri)\b/i,    resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(5)) },
    { re:/next (saturday|sat)\b/i,  resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(6)) },
    { re:/next (sunday|sun)\b/i,    resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(0)) },
    // bare weekday → the upcoming instance of that day
    { re:/\b(this )?(monday|mon)\b/i,    resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(1)) },
    { re:/\b(this )?(tuesday|tue)\b/i,   resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(2)) },
    { re:/\b(this )?(wednesday|wed)\b/i, resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(3)) },
    { re:/\b(this )?(thursday|thu)\b/i,  resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(4)) },
    { re:/\b(this )?(friday|fri)\b/i,    resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(5)) },
    { re:/\b(this )?(saturday|sat)\b/i,  resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(6)) },
    { re:/\b(this )?(sunday|sun)\b/i,    resolve:()=>PerchDate.fmt(PerchDate.nextWeekday(0)) },
    { re:/january (\d+)/i,   resolve:m=>resolveMonthDay(0,parseInt(m[1])) },
    { re:/february (\d+)/i,  resolve:m=>resolveMonthDay(1,parseInt(m[1])) },
    { re:/march (\d+)/i,     resolve:m=>resolveMonthDay(2,parseInt(m[1])) },
    { re:/april (\d+)/i,     resolve:m=>resolveMonthDay(3,parseInt(m[1])) },
    { re:/may (\d+)/i,       resolve:m=>resolveMonthDay(4,parseInt(m[1])) },
    { re:/june (\d+)/i,      resolve:m=>resolveMonthDay(5,parseInt(m[1])) },
    { re:/july (\d+)/i,      resolve:m=>resolveMonthDay(6,parseInt(m[1])) },
    { re:/august (\d+)/i,    resolve:m=>resolveMonthDay(7,parseInt(m[1])) },
    { re:/september (\d+)/i, resolve:m=>resolveMonthDay(8,parseInt(m[1])) },
    { re:/october (\d+)/i,   resolve:m=>resolveMonthDay(9,parseInt(m[1])) },
    { re:/november (\d+)/i,  resolve:m=>resolveMonthDay(10,parseInt(m[1])) },
    { re:/december (\d+)/i,  resolve:m=>resolveMonthDay(11,parseInt(m[1])) },
    { re:/(\d+) weeks?/i,    resolve:m=>PerchDate.fmt(PerchDate.plusDays(parseInt(m[1])*7)) },
  ];

  const PRIORITY_RULES = [
    { tags:['financial_freedom'],   patterns:[/shift|pay|money|debt|credit|save|saving|rent|mortgage|bill|afford|fund|cost|expensive|cheap|insurance/i] },
    { tags:['family_experiences'],  patterns:[/noah|emma|samuel|william|maura|wife|family|kid|son|daughter|game|trip|together|birthday|anniversary|school|park|festival|yellowstone/i] },
    { tags:['homestead_expansion'], patterns:[/garden|chicken|coop|greenhouse|permit|county|property|fence|land|homestead|livestock|animals?|pool|yard|hvac|filter/i] },
    { tags:['health_recovery'],     patterns:[/dentist|doctor|appointment|health|medical|sleep|rest|recovery|workout|medicine/i] },
    { tags:['career_growth'],       patterns:[/work|icu|hospital|overtime|certification|training|career|job|schedule/i] },
  ];

  const DOW_MAP = {sunday:0,monday:1,tuesday:2,wednesday:3,thursday:4,friday:5,saturday:6};

  // ── DISPLAY CLEANUP ──────────────────────────
  // Turn messy/casual input into a clean short label + display sentence.
  // Preserves meaning; never invents detail. Original text is kept separately.
  const FILLER_PREFIXES = [
    /^i\s+need\s+to\s+/i, /^i\s+needta\s+/i, /^i\s+gotta\s+/i, /^i\s+have\s+to\s+/i,
    /^i\s+want\s+to\s+/i, /^i\s+should\s+/i, /^i\s+must\s+/i, /^i\s+must\s+remember\s+to\s+/i,
    /^can\s+you\s+remind\s+me\s+to\s+/i, /^remind\s+me\s+to\s+/i, /^please\s+remind\s+me\s+to\s+/i,
    /^reminder\s+to\s+/i, /^note\s+to\s+self[:,]?\s*/i, /^todo[:,]?\s*/i, /^to\s+do[:,]?\s*/i,
    /^don'?t\s+forget\s+to\s+/i, /^make\s+sure\s+to\s+/i, /^i\s+have\s+got\s+to\s+/i,
    /^need\s+to\s+/i, /^got\s+to\s+/i, /^gotta\s+/i,
    /^remind\s+me\s+about\s+/i, /^please\s+remind\s+me\s+about\s+/i,
    /^remember\s+to\s+/i, /^remember\s+/i,
  ];
  // Known proper-noun casing fixes (extend as needed; meaning-preserving only)
  const PROPER_CASE = {
    netflix:'Netflix', hulu:'Hulu', disney:'Disney', spotify:'Spotify', amazon:'Amazon',
    yellowstone:'Yellowstone', duke:'Duke', icu:'ICU', hvac:'HVAC', dvr:'DVR',
    maura:'Maura', noah:'Noah', emma:'Emma', samuel:'Samuel', william:'William'
  };

  function _titleCaseFirst(s){ return s ? s.charAt(0).toUpperCase()+s.slice(1) : s; }
  function _fixCasingWords(s){
    return s.replace(/\b([a-z]+)\b/gi, (w)=>{
      const lw=w.toLowerCase();
      if (PROPER_CASE[lw]) return PROPER_CASE[lw];
      return w;
    });
  }
  function _fixApostrophes(s){
    // mauras → Maura's, noahs → Noah's, etc. (only for known names)
    return s.replace(/\b(maura|noah|emma|samuel|william)s\b/gi, (m,n)=>{
      const proper=PROPER_CASE[n.toLowerCase()]||_titleCaseFirst(n);
      return proper+'\u2019s';
    });
  }
  function _stripTrailingClause(s){
    // remove a trailing "that was due yesterday / due friday / by monday" date clause for the LABEL only
    return s.replace(/\s+(that\s+)?(was\s+|is\s+)?(due|by|on|before)\s+[a-z0-9 ,]+$/i,'')
            .replace(/\s+(yesterday|today|tomorrow|tonight|this\s+\w+|next\s+\w+|in\s+\w+\s+\w+)$/i,'')
            .replace(/\s+(on\s+)?(sunday|monday|tuesday|wednesday|thursday|friday|saturday)$/i,'')
            .trim();
  }

  // Build a clean action/title label from raw text
  function cleanLabel(rawText, type){
    if(!rawText) return '';
    let s = rawText.trim().replace(/\s+/g,' ').replace(/[.\s]+$/,'');

    // ── 1. TRAILING FILLER — "X today please remind me" → "X"
    // Strip trailing date+filler combos in any order first (greedy from end)
    s = s.replace(/\s+(please\s+)?(can\s+you\s+)?remind\s+me\s*$/i,'');
    s = s.replace(/\s+(please\s+)?(can\s+you\s+)?remind\s+me\s+(please|ok|thanks)?\s*$/i,'');
    // "for today please remind me" / "today please" / "please" at end
    s = s.replace(/\s+(for\s+)?(today|tonight|tomorrow|this\s+\w+|next\s+\w+)?\s*please\s*$/i,'');
    s = s.replace(/\s+please\s*$/i,'');
    // Strip trailing date words that only exist as filler after the real content
    s = s.replace(/\s+(for\s+)?(today|tonight|tomorrow)\s*$/i,'');

    // ── 2. LEADING "remind me [date] to X" patterns (existing, extended)
    s = s.replace(/^(can\s+you\s+|please\s+)?remind\s+me\s+(to\s+|(?:on\s+|this\s+|next\s+|[a-z]+day|tomorrow|today|tonight|in\s+\w+\s+\w+)\s+to\s+)/i, '');

    // ── 3. INLINE "X [date] please remind me" — already stripped above
    //    Also handle "X [date] to remind me" or "X, remind me [date]"
    s = s.replace(/,?\s*(please\s+)?remind\s+me\s+(by\s+|on\s+|[a-z]+day|today|tomorrow|tonight|this\s+\w+|next\s+\w+)?\s*(please|ok)?\s*$/i,'');

    // ── 4. LEADING filler ("i need to", "i gotta", "need to", ...)
    for(const re of FILLER_PREFIXES){ if(re.test(s)){ s = s.replace(re,''); break; } }

    // ── 5. Trailing date clause cleanup (dates live on their own line)
    if(type==='waiting_on'){
      // strip leading "waiting on / waiting for" prefix
      s = s.replace(/^waiting\s+(on|for)\s+/i,'');
      // strip trailing arrival phrase in either form
      s = s.replace(/\s+to\s+(arrive|come|ship|return|get\s+here|be\s+here|be\s+ready)\s*$/i,'').trim();
      s = s.replace(/\s+(should|will|is|are|might|may|expected\s+to)\s+(arrive|come|be|get|ship|return|show\s+up|be\s+here|be\s+ready|be\s+back)[a-z0-9 ,'\u2019]*$/i,'').trim();
    } else if(type==='reminder'||type==='event'||type==='recurring'){
      s = _stripTrailingClause(s);
    }

    s = s.replace(/\s+/g,' ').trim();
    s = _fixApostrophes(s);
    s = _fixCasingWords(s);
    s = _titleCaseFirst(s);
    if(!s) s = _titleCaseFirst(rawText.trim());
    if(s.length>56) s = s.slice(0,56).replace(/\s+\S*$/,'')+'\u2026';
    return s;
  }

  // Build a friendly display sentence (used in rows/summaries)
  function displaySentence(rawText, type, dateLabel){
    const lbl = cleanLabel(rawText, type);
    if(type==='reminder'||type==='event'||type==='recurring'){
      if(dateLabel==='yesterday'||(dateLabel&&/overdue|ago|last /i.test(dateLabel))) return lbl+' \u2014 was due '+dateLabel+'.';
      return dateLabel ? lbl+' '+_titleCaseFirst(dateLabel)+'.' : lbl+'.';
    }
    if(type==='waiting_on'){
      return lbl+(dateLabel?' should arrive '+dateLabel:'')+'.';
    }
    return lbl+'.';
  }

  // Parse free text → {type,label,text,detectedDate,recurring_dow,priority_tags,icon}
  function parse(text) {
    if (!text || !text.trim()) return null;
    const low = text.toLowerCase();

    // ── Detect related person / event from memory ──
    let relatedPerson=null, relatedEvent=null;
    (PerchMemory.get('people')||[]).forEach(pp=>{ if(pp.name && low.includes(pp.name.toLowerCase())) relatedPerson=pp; });
    (PerchMemory.get('future_horizon')||[]).forEach(ev=>{ if(ev.name && low.includes(ev.name.toLowerCase().split(' ')[0])) relatedEvent=ev; });

    // ── Detect duration / work-stretch (NEW) ──
    // "next 3 days", "for the next 3 days", "working the next N days", "next few days"
    let rangeStart=null, rangeEnd=null, durationDays=null;
    let m;
    if ((m = low.match(/(?:for )?(?:the )?next (\d+) days?/))) {
      durationDays = parseInt(m[1]);
    } else if (/(?:for )?(?:the )?next few days/.test(low)) {
      durationDays = 3;
    } else if ((m = low.match(/(?:for )?(?:the )?next (\d+) weeks?/))) {
      durationDays = parseInt(m[1]) * 7;
    }
    const isWork = /\bwork(ing|s)?\b|shift|on call|on-call|hospital|icu/.test(low);

    // ── Detect type ──
    const isWorry = /i('m| am) worried|i('m| am) concerned|worried (about|that)|not sure if|anxious about|stressed about/.test(low);
    const isHope  = /i (really )?hope|i wish|i want .* to enjoy|means? a lot|matters? to me|looking forward/.test(low);

    let type, typeLabel, icon;
    if (durationDays && isWork) {
      type='work_stretch'; typeLabel='Work stretch'; icon='\uD83C\uDFE5';
      rangeStart = PerchDate.fmt(PerchDate.today());
      rangeEnd   = PerchDate.fmt(PerchDate.plusDays(durationDays - 1));
    } else if (durationDays && !isWork) {
      type='context'; typeLabel='Short-term context'; icon='\uD83D\uDCDD';
      rangeStart = PerchDate.fmt(PerchDate.today());
      rangeEnd   = PerchDate.fmt(PerchDate.plusDays(durationDays - 1));
    } else if (isWorry) {
      type='worry'; typeLabel='Worry'; icon='\uD83D\uDCAD';
    } else if (isHope && (relatedPerson||relatedEvent)) {
      type='meaning'; typeLabel='Long-term meaning'; icon='\u2764\uFE0F';
    } else {
      // fall through to keyword RULES
      let matched=null;
      for (const rule of RULES) { if (rule.patterns.some(p=>p.test(text))) { matched=rule; break; } }
      if (!matched) matched = { type:'reminder', label:'Reminder', icon:'\uD83D\uDD14' };
      type=matched.type; typeLabel=matched.label; icon=matched.icon;
    }

    // ── Detect single date (for reminders/events/waiting) ──
    let detectedDate = null;
    if (!rangeStart) {
      for (const dp of DATE_PATTERNS) {
        const mm = text.match(dp.re);
        if (mm) { detectedDate = dp.resolve(mm); break; }
      }
    }

    // ── Recurring weekday ──
    let recurringDow = null;
    if (type === 'recurring') {
      for (const [day,dow] of Object.entries(DOW_MAP)) { if (low.includes(day)) { recurringDow=dow; break; } }
    }

    // ── Priority tags ──
    const tags = [];
    for (const pr of PRIORITY_RULES) {
      if (pr.patterns.some(p=>p.test(text))) pr.tags.forEach(t=>{ if(!tags.includes(t)) tags.push(t); });
    }
    if (isWork && !tags.includes('career_growth')) tags.push('career_growth');
    if (!tags.length) tags.push('financial_freedom');

    // ── Label (clean, polished) ──
    let label, cleanLbl;
    if (type==='work_stretch') { label = 'Work stretch'; cleanLbl = 'Work stretch'; }
    else { cleanLbl = cleanLabel(text, type); label = cleanLbl; }

    return {
      type, typeLabel, icon, label, clean_label: cleanLbl, original_text: text.trim(),
      text:text.trim(),
      detectedDate, range_start:rangeStart, range_end:rangeEnd, duration_days:durationDays,
      recurring_dow:recurringDow, priority_tags:tags,
      related_person: relatedPerson?relatedPerson.id:null, related_person_name: relatedPerson?relatedPerson.name:null,
      related_event: relatedEvent?relatedEvent.id:null, related_event_name: relatedEvent?relatedEvent.name:null
    };
  }

  // Commit a parsed object to memory as a real capture. Returns the stored capture.
  // Accepts an optional `edits` object to override fields (from the confirmation card).
  function commit(parsed, edits) {
    if (!parsed) return null;
    const p = Object.assign({}, parsed, edits||{});

    // Meaning → write to the related person/event significance_notes, not a capture
    if (p.type==='meaning' && (p.related_event || p.related_person)) {
      const colKey = p.related_event ? 'future_horizon' : 'people';
      const id     = p.related_event || p.related_person;
      const arr = PerchMemory.get(colKey)||[];
      const item = arr.find(x=>x.id===id);
      if (item) {
        item.significance_notes = (item.significance_notes||[]).concat([p.text]);
        PerchMemory.set(colKey, arr);
        return { id:'meaning_'+Date.now(), label:p.label, perch_action:'meaning', meaning:true,
                 related:(p.related_event_name||p.related_person_name) };
      }
    }

    const capture = {
      id: 'cap_' + Date.now(),
      label: p.clean_label || p.label,
      clean_label: p.clean_label || p.label,
      original_text: p.original_text || p.text,
      text: p.text,
      perch_action: (p.type==='work_stretch'||p.type==='context') ? 'context'
                  : (p.type==='worry') ? 'worry'
                  : p.type,
      expected: p.detectedDate || null,
      priority_tags: p.priority_tags || ['financial_freedom'],
      source: 'perch_input',
      created: PerchDate.fmt(PerchDate.today())
    };
    if (p.range_start) { capture.range_start=p.range_start; capture.range_end=p.range_end; }
    if (p.duration_days) capture.duration_days=p.duration_days;
    if (p.type==='work_stretch') capture.work_stretch=true;
    if (p.type==='recurring' && p.recurring_dow!==null && p.recurring_dow!==undefined) capture.day_of_week=p.recurring_dow;
    if (p.related_event)  capture.related_event=p.related_event;
    if (p.related_person) capture.related_person=p.related_person;

    PerchMemory.remember('captures', capture);
    return capture;
  }

  return { parse, commit, DOW_MAP, cleanLabel, displaySentence };
})();
window.PerchParse = PerchParse;

// ── SIGNAL NORMALISER — module scope so PerchFeedback can use it ──────────
function normaliseSignal(raw) {
  const s = (raw || '').toLowerCase().replace(/[_\s-]/g, '');
  if (s === 'more' || s === 'morelikethis' || s === 'star') return 'more';
  if (s === 'good' || s === 'thumbsup')                      return 'good';
  if (s === 'bad'  || s === 'notforme' || s === 'thumbsdown' ||
      s === 'less' || s === 'irrelevant')                    return 'bad';
  return 'good';
}

// ════════════════════════════════════════════
// 3. EVENT SYSTEM
// ════════════════════════════════════════════
const PerchEvents = (() => {

  // ── PRIORITY SCORING ──────────────────────
  function priorityScore(tags) {
    const priorities = PerchMemory.get('priorities') || [];
    const n = priorities.length || 5;
    const matched = (tags || [])
      .map(pid => priorities.find(x => x.id === pid))
      .filter(p => p && p.active !== false)
      .sort((a, b) => a.rank - b.rank);
    if (!matched.length) return 0;
    const primary = matched[0];
    const primaryWeight = parseFloat((1 - ((primary.rank - 1) / n) * 0.6).toFixed(2));
    let score = primaryWeight * 100;
    matched.slice(1).forEach(p => {
      const w = parseFloat((1 - ((p.rank - 1) / n) * 0.6).toFixed(2));
      score += w * 100 * 0.3;
    });
    return Math.round(score * 10) / 10;
  }


  // ── FEEDBACK MODIFIERS ────────────────────
  // more=×1.3  good=×1.1  bad=×0+hidden
  function applyFeedback(id, baseScore) {
    const feedback = PerchMemory.get('recommendation_feedback') || [];
    const entry = feedback.find(f => f.id === id);
    if (!entry) return { score: baseScore, hidden: false, feedback_signal: null };
    const canonical = normaliseSignal(entry.signal);
    const multipliers = { more: 1.3, good: 1.1, bad: 0 };
    const m = multipliers[canonical] ?? 1;
    const hidden = canonical === 'bad';
    const finalScore = Math.round(baseScore * m * 10) / 10;
    console.log(
      `[Perch Scoring] id=${id} base=${baseScore} signal=${canonical} ×${m} final=${finalScore} hidden=${hidden}`
    );
    return { score: finalScore, hidden, feedback_signal: canonical };
  }

  function whyItMatters(tags, context) {
    const priorities = PerchMemory.get('priorities') || [];
    const names = (tags||[]).map(pid=>priorities.find(p=>p.id===pid)?.name).filter(Boolean);
    const base = names.length ? `Supports ${names.join(' + ')}.` : '';
    return context ? `${base} ${context}`.trim() : base;
  }

  function statusFromIntel(intel, explicit) {
    if (explicit === 'completed') return 'completed';
    if (explicit === 'snoozed')   return 'snoozed';
    if (explicit === 'dismissed') return 'dismissed';
    if (explicit === 'archived')  return 'archived';
    if (explicit === 'waiting_on' || explicit === 'waiting') return 'waiting';
    if (explicit === 'tentative') return 'tentative';
    if (!intel || intel.daysUntil === null) return explicit || 'upcoming';
    if (intel.isOverdue)  return 'overdue';
    if (intel.isToday)    return 'today';
    if (intel.isThisWeek) return 'thisweek';
    return 'upcoming';
  }

  // ── NORMALIZE one event ───────────────────
  function norm({ id, name, icon, type, date, time, recurrence, status, detail, context, priority_tags, payment_url, amount, day_of_week, range_start, range_end, work_stretch }) {
    const d = date ? PerchDate.fromStr(date)
            : (day_of_week != null ? PerchDate.nextWeekday(day_of_week) : null);
    const intel = PerchDate.intel(d);
    const resolved = statusFromIntel(intel, status);
    const baseScore = priorityScore(priority_tags);
    const fb = applyFeedback(id, baseScore);
    return {
      id, name,
      icon: icon || '📅',
      type,
      date:           d ? PerchDate.fmt(d) : null,
      time:           time || null,
      recurrence:     recurrence || null,
      day_of_week:    day_of_week ?? null,
      range_start:    range_start || null,
      range_end:      range_end || null,
      work_stretch:   work_stretch || false,
      daysUntil:      intel.daysUntil,
      daysLabel:      PerchDate.label(intel.daysUntil),
      isToday:        intel.isToday,
      isThisWeek:     intel.isThisWeek,
      isThisMonth:    intel.isThisMonth,
      isOverdue:      intel.isOverdue,
      status:         resolved,
      detail:         detail || null,
      context:        context || null,
      priority_tags:  priority_tags || [],
      priority_score: fb.score,
      hidden:         fb.hidden,
      feedback_signal:fb.feedback_signal || null,
      why:            whyItMatters(priority_tags, context),
      payment_url:    payment_url || null,
      amount:         amount || null
    };
  }

  // ── BUILD all events from memory ──────────
  function buildAll() {
    const events = [];

    // Bills → monthly recurring
    (PerchMemory.get('bills') || []).forEach(b => {
      const date = PerchDate.thisMonthDay(b.due_day);
      events.push(norm({
        id: 'bill_' + b.id, name: b.name + (b.provider ? ` — ${b.provider}` : ''),
        icon: '💳', type: 'bill',
        date: PerchDate.fmt(date), recurrence: 'monthly',
        status: b.status,
        detail: `$${b.amount} · ${b.autopay ? 'Autopay' : 'Manual'}`,
        context: b.autopay ? 'Auto-pay set.' : 'Needs manual payment.',
        priority_tags: b.priority_tags, payment_url: b.payment_url, amount: b.amount
      }));
    });

    // Work schedule → weekly recurring
    (PerchMemory.get('work.schedule') || []).forEach(s => {
      const date = PerchDate.nextWeekday(s.day_of_week);
      events.push(norm({
        id: s.id, name: s.name, icon: '🏥', type: 'work_shift',
        date: PerchDate.fmt(date), time: s.time, recurrence: 'weekly', day_of_week: s.day_of_week,
        detail: `${s.hours}hr · ${s.time}`, context: 'Recurring shift.',
        priority_tags: s.priority_tags
      }));
    });

    // Work opportunities
    (PerchMemory.get('work.opportunities') || []).forEach(w => {
      events.push(norm({
        id: 'workopp_' + w.id, name: w.name, icon: '⚡', type: 'opportunity',
        date: w.date, status: 'tentative',
        detail: w.value, context: `One shift — ${w.value}.`,
        priority_tags: w.priority_tags
      }));
    });

    // Future horizon
    (PerchMemory.get('future_horizon') || []).forEach(f => {
      events.push(norm({
        id: 'fh_' + f.id, name: f.name, icon: f.icon || '🏔️', type: 'future_horizon',
        date: f.date_start, status: f.status,
        detail: f.date_end ? `${f.date_start} – ${f.date_end}` : f.date_start,
        context: `Status: ${f.status}.`,
        priority_tags: f.priority_tags
      }));
    });

    // Opportunities
    (PerchMemory.get('opportunities') || []).forEach(o => {
      events.push(norm({
        id: 'opp_' + o.id, name: o.name, icon: o.icon || '🌿', type: 'opportunity',
        date: o.date, day_of_week: o.day_of_week ?? null, status: o.status || null,
        detail: o.detail, context: o.context, priority_tags: o.priority_tags
      }));
    });

    // Homestead maintenance
    const urgencyToStatus = { high: 'overdue', this_week: 'thisweek', soon: 'upcoming', upcoming: 'upcoming' };
    const ACTION_STATUSES = new Set(['completed','snoozed','dismissed','waiting','resolved','archived']);
    (PerchMemory.get('homestead.maintenance') || []).forEach(m => {
      // If the item has been acted on, respect that over urgency mapping
      const resolvedStatus = ACTION_STATUSES.has(m.status) ? m.status : (urgencyToStatus[m.urgency] || 'upcoming');
      events.push(norm({
        id: 'maint_' + m.id, name: m.name, icon: '🔧', type: 'maintenance',
        status: resolvedStatus,
        detail: m.urgency==='high' ? `${m.overdue_months}mo overdue · ~$${m.cost_estimate||'?'}`
               : m.urgency==='this_week' ? 'Due this week'
               : m.days_since ? `${m.days_since} days since last` : 'Scheduled',
        context: m.urgency==='high' ? 'Preventive fix prevents larger cost.' : 'Scheduled maintenance.',
        priority_tags: m.priority_tags
      }));
    });

    // Captures
    (PerchMemory.get('captures') || []).forEach(c => {
      // Respect acted-on status; fall back to perch_action-based default
      const capStatus = ACTION_STATUSES.has(c.status) ? c.status
                      : c.perch_action==='waiting_on' ? 'waiting' : 'upcoming';
      // Work-stretch / short-term context carry a date RANGE, not a single expected date.
      // Anchor them to range_start so they appear on Today/Week; carry range fields through.
      const anchorDate = c.expected || c.range_start || null;
      events.push(norm({
        id: 'cap_' + c.id, name: c.label, type: c.perch_action,
        icon: c.perch_action==='reminder'?'🔔':c.perch_action==='opportunity'?'⚡':c.perch_action==='waiting_on'?'⏳':c.perch_action==='context'?'📝':c.work_stretch?'🏥':'🔁',
        date: anchorDate, day_of_week: c.day_of_week ?? null,
        range_start: c.range_start || null, range_end: c.range_end || null,
        work_stretch: c.work_stretch || false,
        recurrence: c.perch_action==='recurring' ? 'weekly' : null,
        status: capStatus,
        detail: c.label, context: c.text || '',
        priority_tags: c.priority_tags
      }));
    });

    // Sort: by daysUntil asc (nulls last), then score desc
    events.sort((a, b) => {
      const da = a.daysUntil ?? 9999, db = b.daysUntil ?? 9999;
      return da !== db ? da - db : b.priority_score - a.priority_score;
    });
    return events;
  }

  let _cache = null;
  function all()     { if (!_cache) _cache = buildAll(); return _cache; }
  function refresh() { _cache = null; return all(); }

  // ── PUBLIC API ────────────────────────────
  // Statuses hidden from all active surfaces (Today/Week recommendations)
  const HIDDEN_STATUSES = new Set(['dismissed', 'snoozed', 'archived']);

  const DONE_STATUSES   = new Set(['completed','resolved','dismissed','snoozed','archived']);
  function getToday()    { return all().filter(e => (e.isToday||e.status==='today') && !DONE_STATUSES.has(e.status)); }
  function getOverdue()  { return all().filter(e => (e.isOverdue||e.status==='overdue') && !DONE_STATUSES.has(e.status)); }
  function getThisWeek() { return all().filter(e => e.isThisWeek && !e.isOverdue && !e.isToday && !HIDDEN_STATUSES.has(e.status)); }
  function getThisMonth(){ return all().filter(e => e.isThisMonth && !e.isOverdue); }
  function getUpcoming(n=10){ return all().filter(e=>!e.isOverdue&&!e.isToday&&e.daysUntil!==null).slice(0,n); }
  function getByPriority(pid){ return all().filter(e=>e.priority_tags.includes(pid)); }
  function getOpportunitiesThisWeek() {
    return all()
      .filter(e =>
        (e.type==='opportunity'||e.type==='future_horizon') &&
        e.daysUntil!==null && e.daysUntil<=14 && !e.isOverdue &&
        !e.hidden &&                         // feedback bad signal
        !HIDDEN_STATUSES.has(e.status)       // snoozed or dismissed
      )
      .sort((a,b)=>b.priority_score-a.priority_score);
  }
  // Brain view — includes hidden items so user can see and undo feedback
  function getAllOpportunities() {
    return all()
      .filter(e => e.type==='opportunity'||e.type==='future_horizon')
      .sort((a,b)=>b.priority_score-a.priority_score);
  }
  // Rolling 7-day window starting TODAY — single source of truth for Week screen
  // Returns every event whose date falls on day 0 (today) through day 6
  // Maintenance/overdue items with null dates but status='overdue' are anchored to today
  function getNext7Days() {
    const events = all();
    const result = [];
    const today = PerchDate.today();
    // Build set of valid date strings: today through today+6
    const window7 = new Set();
    for (let i = 0; i < 7; i++) {
      window7.add(PerchDate.fmt(PerchDate.plusDays(i, today)));
    }
    events.forEach(e => {
      if (e.status === 'completed' || e.status === 'archived' || e.status === 'dismissed') return;
      // Work-stretch / range events span multiple days — show on each day in window
      if (e.range_start && e.range_end) {
        const rs = new Date(e.range_start+'T00:00:00');
        const re = new Date(e.range_end+'T00:00:00');
        let any = false;
        for (let d = new Date(rs); d <= re; d.setDate(d.getDate()+1)) {
          const ds = PerchDate.fmt(d);
          if (window7.has(ds)) {
            any = true;
            const isFirst = ds === e.range_start;
            result.push({ ...e, date: ds, _rangeDay: true, _rangeFirst: isFirst });
          }
        }
        if (any) return; // handled as a range; don't also push the anchor
      }
      if (e.date && window7.has(e.date)) {
        result.push(e);
      } else if (!e.date && (e.status === 'overdue' || e.isOverdue)) {
        // Anchor dateless overdue items (maintenance) to today so they're visible
        result.push({ ...e, date: PerchDate.fmt(today), daysUntil: 0, isToday: true });
      }
    });
    // Sort by date asc, then priority score desc within each day
    result.sort((a, b) => {
      if (a.date < b.date) return -1;
      if (a.date > b.date) return 1;
      return b.priority_score - a.priority_score;
    });
    return result;
  }
  // For Today screen — bills due today or overdue
  function getActionableToday() {
    return all().filter(e =>
      (e.isToday || e.isOverdue || e.status === 'overdue' || e.status === 'today') &&
      e.type !== 'work_shift' &&
      e.status !== 'completed' &&
      !HIDDEN_STATUSES.has(e.status)
    );
  }
  // What Perch verified (safe items)
  function getVerifiedSafe() {
    return all().filter(e => e.type === 'bill' && (e.status === 'completed' || (e.recurrence && !e.isToday && !e.isOverdue && e.amount)));
  }

  return { all, refresh, getToday, getOverdue, getThisWeek, getThisMonth, getUpcoming,
           getByPriority, getOpportunitiesThisWeek, getAllOpportunities,
           getNext7Days, getActionableToday, getVerifiedSafe };
})();
window.PerchEvents = PerchEvents;

// ════════════════════════════════════════════
// PERCH COMPLETE — completion + waiting-on system
// Works across bills, captures, and maintenance.
// Never deletes — sets status, records date.
// ════════════════════════════════════════════
window.PerchComplete = (() => {

  const today = () => PerchDate.fmt(PerchDate.today());

  // ── find an item by id across collections ──
  function findItem(id) {
    const collections = ['bills','captures','homestead.maintenance','opportunities','future_horizon'];
    for (const col of collections) {
      const arr = PerchMemory.get(col) || [];
      const item = arr.find(x => x.id === id);
      if (item) return { item, col, arr };
    }
    return null;
  }

  // ── MARK COMPLETE ──────────────────────────
  // Sets status:'completed', records completed_date
  function markComplete(id, note) {
    const found = findItem(id);
    if (!found) { console.warn('[PerchComplete] item not found:', id); return false; }
    const { item, col, arr } = found;
    item.status        = 'completed';
    item.completed_date = today();
    if (note) item.completed_note = note;
    PerchMemory.set(col, arr);
    PerchEvents.refresh();
    console.log('[PerchComplete] marked complete:', id, 'in', col);
    return true;
  }

  // ── MARK WAITING-ON ───────────────────────
  // Sets status:'waiting', records waiting_since + optional expected_by
  function markWaiting(id, expectedDate) {
    const found = findItem(id);
    if (!found) { console.warn('[PerchComplete] item not found:', id); return false; }
    const { item, col, arr } = found;
    item.status       = 'waiting';
    item.waiting_since = today();
    if (expectedDate) item.expected = expectedDate;
    PerchMemory.set(col, arr);
    PerchEvents.refresh();
    console.log('[PerchComplete] marked waiting:', id);
    return true;
  }

  // ── UNMARK (reopen) ───────────────────────
  function unmark(id) {
    const found = findItem(id);
    if (!found) return false;
    const { item, col, arr } = found;
    delete item.status;
    delete item.completed_date;
    delete item.completed_note;
    delete item.waiting_since;
    PerchMemory.set(col, arr);
    PerchEvents.refresh();
    console.log('[PerchComplete] unmarked:', id);
    return true;
  }

  // ── QUERIES ───────────────────────────────
  function getCompleted() {
    return PerchEvents.all().filter(e => e.status === 'completed');
  }

  function getWaitingOn() {
    return PerchEvents.all().filter(e => e.status === 'waiting');
  }

  // Monthly completion count (for "you completed X things")
  function completedThisMonth() {
    const thisMonth = PerchDate.fmt(PerchDate.today()).slice(0, 7); // 'YYYY-MM'
    const collections = ['bills','captures','homestead.maintenance'];
    let count = 0;
    collections.forEach(col => {
      (PerchMemory.get(col) || []).forEach(item => {
        if (item.status === 'completed' && (item.completed_date || '').startsWith(thisMonth)) count++;
      });
    });
    return count;
  }

  return { markComplete, markWaiting, unmark, getCompleted, getWaitingOn, completedThisMonth };
})();

// ════════════════════════════════════════════
// PERCH ACTIONS — unified action/state system
// States: open | completed | dismissed | snoozed | waiting | resolved
// All actions stored in memory.actions — nothing deleted
// ════════════════════════════════════════════
window.PerchActions = (() => {

  const TODAY = () => PerchDate.fmt(PerchDate.today());
  const VALID  = ['open','completed','dismissed','snoozed','waiting','resolved'];

  // ── BUTTON LABELS by item type ────────────
  // Returns { primary, secondary, tertiary? } button config for a given event
  function labelsFor(event) {
    const t = event?.type || '';
    const name = (event?.name || '').toLowerCase();

    // Waiting-on: distinguish delivery vs approval vs generic
    if (t === 'waiting_on' || t === 'future_horizon' || event?.status === 'waiting') {
      // Delivery/physical: ring, package, order, item, part, gear, shipment
      if (/ring|package|order|ship|deliver|part|gear|item|pickup/.test(name))
        return { primary: 'Arrived', action: 'resolved' };
      // Approval/response: renewal, permit, approval, response, decision, insurance, application
      if (/renew|permit|approv|response|decision|insurance|application|license|certif/.test(name))
        return { primary: 'Resolved', action: 'resolved' };
      // Default waiting-on
      return { primary: 'Mark resolved', action: 'resolved' };
    }

    if (t === 'bill')
      return { primary: 'Paid', secondary: 'Snooze', primary_action: 'completed', secondary_action: 'snoozed' };

    if (t === 'maintenance' || t === 'reminder')
      return { primary: 'Done', secondary: 'Snooze', primary_action: 'completed', secondary_action: 'snoozed' };

    if (t === 'opportunity') {
      return {
        primary: 'Interested', secondary: 'Remind me later', tertiary: 'Not for me', quaternary: 'More like this',
        primary_action: 'open',      // stays visible, signals interest
        secondary_action: 'snoozed', // resurfaces after snooze
        tertiary_action: 'dismissed',
        quaternary_action: 'open'    // feedback boost
      };
    }

    if (t === 'recurring')
      return { primary: 'Done', secondary: 'Skip', primary_action: 'completed', secondary_action: 'dismissed' };

    return { primary: 'Done', primary_action: 'completed' };
  }

  // ── RECORD an action ──────────────────────
  function record(targetId, targetName, action, opts = {}) {
    if (!VALID.includes(action)) { console.warn('[PerchActions] unknown action:', action); return null; }
    const actions = PerchMemory.get('actions') || [];
    const entry = {
      id:          'act_' + Date.now(),
      target_id:   targetId,
      target_name: targetName,
      action,
      note:        opts.note || null,
      snooze_until:opts.snooze_until || null,
      created:     TODAY()
    };
    actions.push(entry);
    PerchMemory.set('actions', actions);

    // Also update the item's status in its source collection
    _applyToSource(targetId, action, opts);
    PerchEvents.refresh();
    console.log('[PerchActions] recorded:', action, 'on', targetId);
    return entry;
  }

  function _applyToSource(id, action, opts) {
    const cols = ['bills','captures','homestead.maintenance','opportunities','future_horizon'];
    for (const col of cols) {
      const arr = PerchMemory.get(col) || [];
      // Strip the event-system prefix (bill_ / maint_ / opp_ / fh_ / cap_) if needed
      const bare = id.replace(/^(bill_|maint_|opp_|fh_|cap_|workopp_)/, '');
      const item = arr.find(x => x.id === id || x.id === bare);
      if (!item) continue;
      if (action === 'completed' || action === 'resolved') {
        item.status = 'completed'; item.completed_date = TODAY();
      } else if (action === 'dismissed') {
        item.status = 'dismissed';
      } else if (action === 'snoozed') {
        item.status = 'snoozed';
        item.snooze_until = opts.snooze_until || PerchDate.fmt(PerchDate.plusDays(1));
      } else if (action === 'waiting') {
        item.status = 'waiting'; item.waiting_since = TODAY();
      } else if (action === 'open') {
        // 'open' keeps item visible — used for Interested signal
      }
      PerchMemory.set(col, arr);

      // ── PERMANENT ACTIVITY LOGS ──────────
      // Write to homestead.log when a homestead maintenance item is acted on
      if (col === 'homestead.maintenance' && (action === 'completed' || action === 'resolved')) {
        const log = PerchMemory.get('homestead.log') || [];
        log.push({
          date:      TODAY(),
          item_id:   item.id,
          item_name: item.name,
          action,
          note:      opts.note || null
        });
        PerchMemory.set('homestead.log', log);
      }

      // Write to work.completed_shifts when a work shift or work opportunity is completed
      if ((col === 'captures' && item.perch_action === 'opportunity' && /shift/i.test(item.label || '')) ||
          (id.startsWith('workopp_') && (action === 'completed' || action === 'resolved'))) {
        const shifts = PerchMemory.get('work.completed_shifts') || [];
        shifts.push({
          date:     TODAY(),
          shift_id: item.id,
          name:     item.name || item.label,
          hours:    item.hours || 12,
          type:     id.startsWith('workopp_') ? 'extra' : 'scheduled'
        });
        PerchMemory.set('work.completed_shifts', shifts);
      }

      return;
    }

    // Also handle work schedule shifts (id like 'shift_wed') when completed via action
    if (action === 'completed' || action === 'resolved') {
      const schedule = PerchMemory.get('work.schedule') || [];
      const shift = schedule.find(s => s.id === id);
      if (shift) {
        const shifts = PerchMemory.get('work.completed_shifts') || [];
        shifts.push({
          date:     TODAY(),
          shift_id: shift.id,
          name:     shift.name,
          hours:    shift.hours || 12,
          type:     'scheduled'
        });
        PerchMemory.set('work.completed_shifts', shifts);
      }
    }
  }

  // ── UNDO last action on an item ──────────
  function undo(targetId) {
    const actions = PerchMemory.get('actions') || [];
    const idx = [...actions].reverse().findIndex(a => a.target_id === targetId);
    if (idx === -1) return false;
    const realIdx = actions.length - 1 - idx;
    actions.splice(realIdx, 1);
    PerchMemory.set('actions', actions);
    // Clear status on source item
    const cols = ['bills','captures','homestead.maintenance','opportunities','future_horizon'];
    for (const col of cols) {
      const arr = PerchMemory.get(col) || [];
      const bare = targetId.replace(/^(bill_|maint_|opp_|fh_|cap_|workopp_)/, '');
      const item = arr.find(x => x.id === targetId || x.id === bare);
      if (!item) continue;
      delete item.status; delete item.completed_date; delete item.snooze_until; delete item.waiting_since;
      PerchMemory.set(col, arr);
      break;
    }
    PerchEvents.refresh();
    console.log('[PerchActions] undone for', targetId);
    return true;
  }

  // ── QUERY ─────────────────────────────────
  function getHistory(targetId) {
    return (PerchMemory.get('actions') || []).filter(a => a.target_id === targetId);
  }
  function getAll() {
    return (PerchMemory.get('actions') || []).slice().reverse();
  }

  // ── SNOOZE RESOLUTION ────────────────────
  // Check if snoozed items have expired — call on page load
  function resolveSnoozed() {
    const today = TODAY();
    const cols = ['captures','opportunities'];
    cols.forEach(col => {
      const arr = PerchMemory.get(col) || [];
      let changed = false;
      arr.forEach(item => {
        if (item.status === 'snoozed' && item.snooze_until && item.snooze_until <= today) {
          delete item.status; delete item.snooze_until;
          changed = true;
          console.log('[PerchActions] snooze expired, restored:', item.id);
        }
      });
      if (changed) { PerchMemory.set(col, arr); }
    });
    if (cols.some(() => true)) PerchEvents.refresh();
  }

  // ── STATUS LABEL for display ─────────────
  function statusLabel(action) {
    return {
      completed: 'Marked done',
      resolved:  'Marked resolved',
      dismissed: 'Dismissed',
      snoozed:   'Snoozed',
      waiting:   'Waiting on this',
      open:      'Interested'
    }[action] || action;
  }

  return { labelsFor, record, undo, getHistory, getAll, resolveSnoozed, statusLabel };
})();

// ════════════════════════════════════════════
// PERCH CORRECT — Quick Fix edits to source memory
// Edits the real memory item (not just hides a card), records a correction in
// the action log, and refreshes events. Returns true on success.
// ════════════════════════════════════════════
window.PerchCorrect = (() => {
  function logCorrection(kind, targetId, name, detail) {
    const actions = PerchMemory.get('actions') || [];
    actions.push({
      id: 'corr_' + Date.now(),
      target_id: targetId, target_name: name,
      action: 'corrected', correction_kind: kind, detail: detail || null,
      timestamp: new Date().toISOString(),
      date: PerchDate.fmt(PerchDate.today())
    });
    PerchMemory.set('actions', actions);
  }

  // ── SHIFTS (work.schedule recurring) ──
  function removeShift(dayOfWeek, name) {
    const schedule = PerchMemory.get('work.schedule') || [];
    const idx = schedule.findIndex(s => s.day_of_week === dayOfWeek);
    if (idx === -1) return false;
    const removed = schedule.splice(idx, 1)[0];
    PerchMemory.set('work.schedule', schedule);
    logCorrection('shift_removed', 'shift_dow_'+dayOfWeek, removed.name || name, {day_of_week:dayOfWeek});
    if (window.PerchEvents) PerchEvents.refresh();
    return true;
  }
  function moveShift(fromDow, toDow) {
    const schedule = PerchMemory.get('work.schedule') || [];
    const s = schedule.find(x => x.day_of_week === fromDow);
    if (!s) return false;
    s.day_of_week = toDow;
    delete s.seed; s.user_owned = true;
    PerchMemory.set('work.schedule', schedule);
    logCorrection('shift_moved', 'shift_dow_'+fromDow, s.name, {from:fromDow, to:toDow});
    if (window.PerchEvents) PerchEvents.refresh();
    return true;
  }
  function editShiftTime(dayOfWeek, time, hours) {
    const schedule = PerchMemory.get('work.schedule') || [];
    const s = schedule.find(x => x.day_of_week === dayOfWeek);
    if (!s) return false;
    if (time != null)  s.time = time;
    if (hours != null) s.hours = hours;
    delete s.seed; s.user_owned = true;
    PerchMemory.set('work.schedule', schedule);
    logCorrection('shift_time', 'shift_dow_'+dayOfWeek, s.name, {time, hours});
    if (window.PerchEvents) PerchEvents.refresh();
    return true;
  }

  // ── BILLS ──
  function editBill(billId, fields) {
    const bills = PerchMemory.get('bills') || [];
    const b = bills.find(x => x.id === billId);
    if (!b) return false;
    if (fields.due_day != null) b.due_day = fields.due_day;
    if (fields.amount  != null) b.amount  = fields.amount;
    if (fields.autopay != null) b.autopay = fields.autopay;
    delete b.seed; b.user_owned = true;
    PerchMemory.set('bills', bills);
    logCorrection('bill_edited', billId, b.name, fields);
    if (window.PerchEvents) PerchEvents.refresh();
    return true;
  }
  function removeBill(billId) {
    const bills = PerchMemory.get('bills') || [];
    const b = bills.find(x => x.id === billId);
    if (!b) return false;
    b.status = 'dismissed';
    PerchMemory.set('bills', bills);
    logCorrection('bill_removed', billId, b.name, null);
    if (window.PerchEvents) PerchEvents.refresh();
    return true;
  }

  // ── WAITING / FUTURE_HORIZON ──
  function editWaitingDate(id, newDate) {
    const fh = PerchMemory.get('future_horizon') || [];
    const item = fh.find(x => x.id === id || x.id === id.replace(/^fh_/, ''));
    if (item) { item.date_start = newDate; PerchMemory.set('future_horizon', fh);
      logCorrection('waiting_date', id, item.name, {date:newDate});
      if (window.PerchEvents) PerchEvents.refresh(); return true; }
    return false;
  }
  function removeWaiting(id) {
    const fh = PerchMemory.get('future_horizon') || [];
    const item = fh.find(x => x.id === id || x.id === id.replace(/^fh_/, ''));
    if (item) { item.status = 'completed'; PerchMemory.set('future_horizon', fh);
      logCorrection('waiting_removed', id, item.name, null);
      if (window.PerchEvents) PerchEvents.refresh(); return true; }
    // also try captures — hard splice so it disappears from Brain too
    const caps = PerchMemory.get('captures') || [];
    const bare = id.replace(/^cap_/, '');
    const idx  = caps.findIndex(x => x.id === id || x.id === bare);
    if (idx > -1) {
      const name = caps[idx].label || caps[idx].text || id;
      caps.splice(idx, 1);
      PerchMemory.set('captures', caps);
      logCorrection('waiting_removed', id, name, null);
      if (window.PerchEvents) PerchEvents.refresh(); return true;
    }
    return false;
  }

  // Hard-delete a capture by id — removes from captures[] entirely.
  // Use this for user-initiated "Delete" actions so item disappears from Brain too.
  function removeCapture(id) {
    const caps = PerchMemory.get('captures') || [];
    const bare = id.replace(/^cap_/, '');
    const idx  = caps.findIndex(x => x.id === id || x.id === bare);
    if (idx === -1) return false;
    const name = caps[idx].label || caps[idx].text || id;
    caps.splice(idx, 1);
    PerchMemory.set('captures', caps);
    logCorrection('capture_deleted', id, name, null);
    if (window.PerchEvents) PerchEvents.refresh();
    return true;
  }

  // ── BILL STATUS ACTIONS ──────────────────────
  // These record the monthly payment state. resetMonthlyBillStatuses() clears them next month.
  function _setBillStatus(billId, newStatus) {
    const bills = PerchMemory.get('bills') || [];
    const b = bills.find(x => x.id === billId || ('bill_' + x.id) === billId);
    if (!b) return false;
    b.status = newStatus;
    b.status_date = PerchDate.fmt(PerchDate.today());
    PerchMemory.set('bills', bills);
    logCorrection('bill_status_' + newStatus, billId, b.name, { status: newStatus });
    if (window.PerchEvents) PerchEvents.refresh();
    return true;
  }
  function markBillPaid(billId)        { return _setBillStatus(billId, 'paid_this_month'); }
  function markBillPulled(billId)      { return _setBillStatus(billId, 'pulled_this_month'); }
  function skipBillThisMonth(billId)   { return _setBillStatus(billId, 'skipped_this_month'); }
  function resetBillToActive(billId)   { return _setBillStatus(billId, 'active'); }

  return { removeShift, moveShift, editShiftTime, editBill, removeBill, editWaitingDate, removeWaiting, removeCapture,
           markBillPaid, markBillPulled, skipBillThisMonth };
})();

// ════════════════════════════════════════════
// PERCH FEEDBACK API
// Stores signal, influences scoring, builds Why explanations
// ════════════════════════════════════════════
window.PerchFeedback = {

  // Normalise before storing so the canonical form is always saved
  store(eventId, eventName, rawSignal) {
    const signal = normaliseSignal(rawSignal);
    const feedback = PerchMemory.get('recommendation_feedback') || [];
    const idx = feedback.findIndex(f => f.id === eventId);
    const entry = {
      id:       eventId,
      name:     eventName,
      signal,                        // always canonical: 'more' | 'good' | 'bad'
      raw:      rawSignal,           // keep original for debugging
      updated:  PerchDate.fmt(PerchDate.today()),
      modifier: signal === 'more' ? 1.3 : signal === 'good' ? 1.1 : 0
    };
    // Save previous for undo
    if (idx > -1) {
      entry._prev = feedback[idx];   // one-level undo
      feedback[idx] = entry;
    } else {
      feedback.push(entry);
    }
    PerchMemory.set('recommendation_feedback', feedback);
    PerchEvents.refresh();
    console.log('[Perch Feedback] stored:', signal, 'for', eventId);
    return entry;
  },

  undo(eventId) {
    const feedback = PerchMemory.get('recommendation_feedback') || [];
    const idx = feedback.findIndex(f => f.id === eventId);
    if (idx === -1) return false;
    const entry = feedback[idx];
    if (entry._prev) {
      feedback[idx] = entry._prev;   // restore previous
    } else {
      feedback.splice(idx, 1);       // remove entirely
    }
    PerchMemory.set('recommendation_feedback', feedback);
    PerchEvents.refresh();
    console.log('[Perch Feedback] undone for', eventId);
    return true;
  },

  get(eventId) {
    const feedback = PerchMemory.get('recommendation_feedback') || [];
    return feedback.find(f => f.id === eventId) || null;
  },

  getAll() {
    return (PerchMemory.get('recommendation_feedback') || [])
      .slice().sort((a, b) => (b.updated || '').localeCompare(a.updated || ''));
  },

  // Full history — what was surfaced, when, and what feedback was given
  getRecommendationHistory() {
    const feedback  = PerchMemory.get('recommendation_feedback') || [];
    const captures  = PerchMemory.get('captures') || [];
    const checkins  = PerchMemory.get('user.checkins') || [];

    return {
      feedback_count:    feedback.length,
      positive:          feedback.filter(f => f.signal === 'good' || f.signal === 'more').length,
      negative:          feedback.filter(f => f.signal === 'bad').length,
      most_recent:       feedback[0] || null,
      top_boosted:       feedback.filter(f => f.signal === 'more')
                                 .map(f => f.name).slice(0, 3),
      top_suppressed:    feedback.filter(f => f.signal === 'bad')
                                 .map(f => f.name).slice(0, 3),
      captures_added:    captures.length,
      checkin_count:     checkins.length
    };
  },

  // Build human-readable "Why did Perch recommend this?"
  buildWhy(event) {
    if (!event) return [];
    const priorities  = PerchMemory.get('priorities') || [];
    const finances    = PerchMemory.get('finances')   || {};
    const feedback    = PerchMemory.get('recommendation_feedback') || [];
    const reasons     = [];

    // 1. Priority match
    const matchedPriorities = (event.priority_tags || [])
      .map(pid => priorities.find(p => p.id === pid))
      .filter(Boolean)
      .sort((a, b) => a.rank - b.rank);

    if (matchedPriorities.length > 0) {
      const top = matchedPriorities[0];
      reasons.push({
        icon: '🎯',
        text: `Matches your #${top.rank} priority — ${top.name}`,
        weight: 'primary'
      });
      matchedPriorities.slice(1).forEach(p => {
        reasons.push({ icon: '🎯', text: `Also supports ${p.name}`, weight: 'secondary' });
      });
    }

    // 2. Score context
    const score = event.priority_score || 0;
    if (score >= 120) {
      reasons.push({ icon: '📈', text: `High priority score (${score}) — near the top of your list`, weight: 'primary' });
    } else if (score >= 80) {
      reasons.push({ icon: '📈', text: `Good priority score (${score})`, weight: 'secondary' });
    }

    // 3. Timing
    if (event.daysUntil === 0) {
      reasons.push({ icon: '📅', text: 'Available today', weight: 'primary' });
    } else if (event.daysUntil !== null && event.daysUntil <= 3) {
      reasons.push({ icon: '📅', text: `Coming up in ${event.daysUntil} days`, weight: 'primary' });
    } else if (event.daysUntil !== null && event.daysUntil <= 14) {
      reasons.push({ icon: '📅', text: `${event.daysUntil} days away — within your planning window`, weight: 'secondary' });
    }

    // 4. Financial relevance
    const safeToSpend = finances.safe_to_spend;
    if (event.amount && safeToSpend && event.amount <= safeToSpend) {
      reasons.push({ icon: '💰', text: `$${event.amount} — within your safe-to-spend ($${safeToSpend})`, weight: 'secondary' });
    }
    if (!event.amount && event.type === 'opportunity') {
      reasons.push({ icon: '💰', text: 'No cost — pure opportunity', weight: 'secondary' });
    }

    // 5. Feedback history
    const prev = feedback.find(f => f.id === event.id);
    if (prev?.signal === 'more') {
      reasons.push({ icon: '⭐', text: "You marked this type as 'more like this' before", weight: 'secondary' });
    }

    // 6. Context from event itself
    if (event.context && event.context !== event.why) {
      reasons.push({ icon: '💡', text: event.context, weight: 'secondary' });
    }

    return reasons;
  }
};


window.PerchAppearance = {
  apply() {
    const settings = PerchMemory.get('settings') || {};
    const theme  = settings.theme  || 'light';
    const accent = settings.accent || '#2d6a4f';
    const root = document.documentElement;
    root.style.setProperty('--green', accent);
    root.style.setProperty('--green-check', accent);
    if (theme === 'dark') {
      root.style.setProperty('--cream',  '#171a16');
      root.style.setProperty('--cream2', '#232820');
      root.style.setProperty('--card',   '#252b23');
      root.style.setProperty('--ink',    '#f5f2eb');
      root.style.setProperty('--ink2',   '#ffffff');
      root.style.setProperty('--muted',  '#b8b09e');
      root.style.setProperty('--muted2', '#8f8878');
      root.style.setProperty('--border', 'rgba(255,255,255,0.12)');
    } else {
      root.style.setProperty('--cream',  '#f0ebe0');
      root.style.setProperty('--cream2', '#ede7d9');
      root.style.setProperty('--card',   '#ffffff');
      root.style.setProperty('--ink',    '#1e1c14');
      root.style.setProperty('--ink2',   '#2d2a1e');
      root.style.setProperty('--muted',  '#7a7060');
      root.style.setProperty('--muted2', '#a09880');
      root.style.setProperty('--border', 'rgba(30,28,20,0.10)');
    }
  },
  saveTheme(theme) {
    const s = PerchMemory.get('settings') || {};
    s.theme = theme; PerchMemory.set('settings', s); this.apply();
  },
  saveAccent(accent) {
    const s = PerchMemory.get('settings') || {};
    s.accent = accent; PerchMemory.set('settings', s); this.apply();
  }
};

console.log(`Perch Core loaded · ${PerchDate.greetingTime()}, ${PerchMemory.get('user.name')} · ${PerchEvents.all().length} events`);
