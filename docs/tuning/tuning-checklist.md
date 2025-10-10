# Tuning Checklist (ArduCopter)  

A practical, step-by-step list you can print or check off during setup and flight testing.

---

## 0) Prep & Safety
- [ ] **Props off** for all bench configuration and spin tests.
- [ ] **Firmware current** (ArduCopter stable) and correct frame type (`FRAME_CLASS/TYPE`).
- [ ] **Radio failsafe** (RC + GCS) set to **RTL** and verified on bench.
- [ ] **Battery**: correct cell count & low-voltage failsafe (`BATT_*`) set.
- [ ] **Logging** enabled (`LOG_BITMASK` includes IMU, PID, RATE, CTUN, VIBE).

---

## 1) Mechanical & Wiring
- [ ] Motors correct order & direction; props marked with CW/CCW.  
- [ ] Arms, plates, and stack **tight**; ESC and FC **soft-mounted** as required.
- [ ] **CG** centered; battery/landing gear secure; wires strain-relieved.
- [ ] Antennas clear of carbon and power leads (RF + GPS hygiene).

---

## 2) Sensor Cal & Basic Params
- [ ] **Accel/Gyro** calibration complete; **compass** oriented & offsets sane.
- [ ] **RC calibration**: endpoints, trims at zero, channels mapped (RCMAP_*).
- [ ] **Flight modes** set (e.g., Stabilize, AltHold/Loiter, AutoTune on a switch).
- [ ] **ANGLE_MAX** conservative (e.g., 3000–3500 = 30–35°) for first tests.

---

## 3) ESC & Motor Checks
- [ ] **Protocol** set (DShot/OneShot/PWM) with correct min/max (`MOT_PWM_*`).
- [ ] **Motor test** in Mission Planner (props off) – verify each motor.
- [ ] **Hover throttle learn** (`MOT_HOVER_LEARN=2`) enabled for initial flights.

---

## 4) Vibration Baseline
- [ ] Short hover (calm air) and review **VIBE**: target **<15 m/s²** peaks, **<30** worst-case.  
- [ ] If high: add foam/gel, fix balance, reroute wires, stiffen structure.

---

## 5) Filters First (before gains)
### 5.1 Notch / Harmonic (with ESC RPM telemetry if available)
- [ ] Enable **Harmonic Notch** (`INS_HNTCH_ENABLE=1`).  
- [ ] Set source to **ESC RPM** or throttle as available (`INS_HNTCH_MODE`).  
- [ ] Set `INS_HNTCH_REF` (hover throttle) or RPM scaling; choose `INS_HNTCH_BW` ≈ **(center freq × 0.5)**.  
- [ ] Log a hover → verify notch centers on motor fundamental and harmonics. Adjust **center**, **BW**, **gain**.

### 5.2 Gyro/Accel filters
- [ ] **Gyro LPF** (`INS_GYRO_FILTER`) reasonable for prop size (e.g., 30–50 Hz for 10–11″ props).  
- [ ] **Accel LPF** (`INS_ACCEL_FILTER`) ~10–20 Hz typical.
- [ ] **Rate-loop LPFs**: `ATC_RAT_RLL_FLTT`, `ATC_RAT_PIT_FLTT` (start ~15–25 Hz for larger props),  
  and `ATC_RAT_*_FLTD` (start ~15–25 Hz). Yaw `FLTT/FLTD` often higher or default.

---

## 6) Initial Gains (safe starting point)
- [ ] Rate P/I modest (e.g., **0.10–0.15** on roll/pitch for 4S 4–5″ props; **lower** for big props).  
- [ ] Rate D small (e.g., **0.002–0.004** roll/pitch for big props).  
- [ ] Angle P (`ATC_ANG_RLL_P`, `ATC_ANG_PIT_P`) **4.0–6.0** to start on larger craft.  
- [ ] Yaw P/I low to moderate; **D=0** on yaw.

---

## 7) First Flights (manual check)
- [ ] **Stabilize**: quick hops; watch for overshoot/oscillation. Land & adjust **rate P/D**.  
- [ ] **AltHold/Loiter**: check position hold, stick feel (`ATC_INPUT_TC` ~0.15–0.25).  
- [ ] Verify hover throttle learned; set `MOT_THST_HOVER` if needed.

---

## 8) AutoTune (calm air, open space)
- [ ] Mode switch with **AutoTune** option configured.  
- [ ] Battery fresh; no wind/gusts; enough altitude.  
- [ ] Run **roll** first, then **pitch** (or both). If cross-coupling present, do axes separately.  
- [ ] After completion, test tuned PIDs (switch high/low per instructions).  
- [ ] If satisfied, **land with switch HIGH** to save; otherwise switch LOW to keep old PIDs.

---

## 9) Manual Refinement
- [ ] Review logs: **RATE** tracking, **D-term** activity, **vibes**.  
- [ ] If bounce-back on flips: lower **rate D** slightly or raise **FLTD** a bit.  
- [ ] If sluggish: increment **rate P** and **angle P** modestly (10–15% steps).  
- [ ] If mid-throttle oscillations: adjust **notch** (center/BW/gain) or reduce **rate D**.  
- [ ] For cross-coupling (pitch→roll): verify frame stiffness; consider **diagonal brace** before chasing gains.

---

## 10) Position & Velocity Controllers
- [ ] `PSC_VELXY_P/I/D` defaults are good; reduce **D** if twitchy in wind.  
- [ ] `LOIT_SPEED`, `WPNAV_SPEED`, `WPNAV_ACCEL` to match mission style.  
- [ ] Brake behavior: `LOIT_BRK_ACCEL`, `LOIT_BRK_JERK`, `PHLD_BRAKE_*` to taste.

---

## 11) Yaw Tuning
- [ ] Set `ATC_RAT_YAW_P/I` for crisp but stable heading; keep **D=0**.  
- [ ] If tail wags: lower **yaw P** and/or increase **FLTT** a bit.

---

## 12) EKF & Sensors
- [ ] **GPS** HDOP, Sats good; compass consistent; EKF innovations within bounds.  
- [ ] If RF/EMI suspected, reroute cables, add ferrites, separate radios and GPS.  
- [ ] Set `EK3_*` sources as intended (e.g., `EK3_SRC1_POSXY=3` for GPS).

---

## 13) Obstacle & Terrain (optional)
- [ ] Rangefinder/LiDAR configured (`RNGFND*`) with correct orientation.  
- [ ] Enable avoidance: `PRX_TYPE=RangeFinder`, `OA_TYPE=BendyRuler`, `AVOID_ENABLE=1`, set `AVOID_MARGIN`.

---

## 14) Telemetry & GCS
- [ ] RFD900 or Wi‑Fi telemetry stable; `SERIALx_BAUD` and MAVLink rates set.  
- [ ] Antennas oriented; link tested for dropouts.

---

## 15) Post-Flight Review
- [ ] Save a **param snapshot** after good flights.  
- [ ] Plot: **RATE** (desired vs actual), **CTUN.ThO**, **VIBE**, **ATT**, **IMU** clipping.  
- [ ] Note battery SAG; adjust mission speeds accordingly.

---

## 16) Finalize
- [ ] Tighten hardware, re‑route any chafing wires.  
- [ ] Threadlock where needed; add labels for ports/antenna orientation.  
- [ ] Print and insert this checklist into your field kit.

---

### Quick Reference: Typical Starting Filters (large props, calm)
- `INS_GYRO_FILTER`: 30–50 Hz  
- `INS_ACCEL_FILTER`: 10–20 Hz  
- `ATC_RAT_RLL/PIT_FLTT`: 15–25 Hz  
- `ATC_RAT_RLL/PIT_FLTD`: 15–25 Hz  
- Harmonic notch: enable; center = motor fundamental (from ESC RPM), BW ≈ 50% of center

> **Order of operations:** **Filters → Rate P/D → Angle P → Position/Yaw → Mission speeds**.  
> Make one change at a time; log every flight.
