-- fm.lua – compact HUD for RadioMaster Boxer (EdgeTX) + CRSF/ELRS + ArduPilot
-- Uses your exact sensor names: FM, Alt, GSpd, Hdg, Sats, Bat%, RQly, 1RSS (dB), 2RSS (dB)

-- Exact sensor names (as shown in Model -> Telemetry -> Sensors)
local N_FM   = "FM"
local N_ALT  = "Alt"
local N_SPD  = "GSpd"
local N_HDG  = "Hdg"
local N_SATS = "Sats"
local N_BATP = "Bat%"
local N_LQ   = "RQly"
local N_R1   = "1RSS"
local N_R2   = "2RSS"

-- cache field IDs and last values
local id, last = {}, {
  FM="(no data)", ALT=nil, SPD=nil, HDG=nil, SATS=nil, BATP=nil, LQ=nil, R1=nil, R2=nil
}
local lastLookup = 0
local prevMode = nil

local function fid(name)
  local info = getFieldInfo(name)
  return info and info.id or nil
end

local function lookupIds()
  id.FM   = id.FM   or fid(N_FM)
  id.ALT  = id.ALT  or fid(N_ALT)
  id.SPD  = id.SPD  or fid(N_SPD)
  id.HDG  = id.HDG  or fid(N_HDG)
  id.SATS = id.SATS or fid(N_SATS)
  id.BATP = id.BATP or fid(N_BATP)
  id.LQ   = id.LQ   or fid(N_LQ)
  id.R1   = id.R1   or fid(N_R1)
  id.R2   = id.R2   or fid(N_R2)
end

local function pull()
  -- re-lookup missing IDs about 1x/sec
  local now = getTime()  -- 10ms ticks
  if now - lastLookup > 100 then lastLookup = now; lookupIds() end

  -- FM (string)
  if id.FM then
    local v = getValue(id.FM)
    if type(v)=="string" and #v>0 then last.FM = v end
  end

  -- numeric helper
  local function upd(k, idx)
    if idx then
      local v = getValue(idx)
      if type(v)=="number" then last[k] = v end
    end
  end

  upd("ALT",  id.ALT)
  upd("SPD",  id.SPD)
  upd("HDG",  id.HDG)
  upd("SATS", id.SATS)
  upd("BATP", id.BATP)
  upd("LQ",   id.LQ)
  upd("R1",   id.R1)
  upd("R2",   id.R2)
end

-- formatters
local function fmtAlt(a)  if not a then return "--m"  end return string.format("%dm", math.floor(a+0.5)) end
local function fmtSpd(s)  if not s then return "--"   end return string.format("%.1f", s) end  -- unit depends on radio
local function fmtHdg(h)  if not h then return "---°" end return string.format("%03d°", math.floor((h%360)+0.5)) end
local function fmtSats(n) if not n then return "--"   end return string.format("%d", math.floor(n+0.5)) end
local function fmtBat(p)  if not p then return "--%"  end return string.format("%d%%", math.floor(p+0.5)) end
local function fmtLQ(p)   if not p then return "--%"  end return string.format("%d%%", math.floor(p+0.5)) end
local function fmtRssi(r) if not r then return "--"   end return string.format("%d", math.floor(r+0.5)) end

local function run(e)
  pull()
  lcd.clear()

  -- Row 1: Big flight mode (no label)
  lcd.drawText(1, 2, last.FM, DBLSIZE)

  -- Row 2: Alt | Spd | Hdg
  lcd.drawText(1,   30, "Alt "..fmtAlt(last.ALT),   SMLSIZE)
  lcd.drawText(64,  30, "Spd "..fmtSpd(last.SPD),   SMLSIZE)
  lcd.drawText(108, 30,      fmtHdg(last.HDG),      SMLSIZE)

  -- Row 3: Sats | Bat% | LQ
  lcd.drawText(1,   42, "Sats "..fmtSats(last.SATS), SMLSIZE)
  lcd.drawText(64,  42, "Bat  "..fmtBat(last.BATP),  SMLSIZE)
  lcd.drawText(108, 42, "LQ "..fmtLQ(last.LQ),       SMLSIZE)

  -- Row 4: RSSI1 / RSSI2 (dB)
  lcd.drawText(1,  54, "R1 "..fmtRssi(last.R1).." dB", SMLSIZE)
  lcd.drawText(64, 54, "R2 "..fmtRssi(last.R2).." dB", SMLSIZE)

  -- Beep on mode change (after first draw)
  if last.FM ~= prevMode then
    if prevMode ~= nil then playTone(880,120,0,0) end
    prevMode = last.FM
  end

  return 0
end

return { run = run }
