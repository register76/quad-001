# Boxer Backup & Restore

This guide explains how to back up and restore all **RadioMaster Boxer** settings, models, and SD card content. Keeping both copies ensures you can recover after firmware updates, SD card failures, or if you migrate to a new radio.

---

## 🔧 Backup with EdgeTX Companion (Models & Settings)

1. **Install Companion**  
   - Download [EdgeTX Companion](https://edgetx.org/download) for your OS.  
   - Install and open it.  

2. **Connect Boxer**  
   - On the Boxer:  
     - Long-press **SYS** → `Radio Setup` → `Hardware` tab.  
     - Set **USB Mode = CDC (Serial)**.  
   - Power-cycle radio.  
   - Plug into your PC with USB-C.  

3. **Read Models & Settings**  
   - In Companion, select radio profile = **RadioMaster Boxer**.  
   - Click **Read Models and Settings from Radio**.  
   - Save the `.otx` file (example: `Boxer_Backup_2025-09-09.otx`).  

👉 This captures:  
- All models  
- Inputs, mixes, outputs  
- Switch assignments  
- Telemetry screen setups  
- Global radio settings  

---

## 💾 Backup SD Card (Sounds, Scripts, Extras)

1. Power off Boxer.  
2. Remove SD card → insert into PC.  
3. Copy the entire SD card to a folder on your computer.  
   - Key folders:  
     - `/MODELS/` (model icons)  
     - `/RADIO/` (global settings)  
     - `/SCRIPTS/TOOLS/` (Lua scripts like ExpressLRS)  
     - `/SOUNDS/` (voice packs)  

👉 Store this folder alongside your `.otx` backup.  

---

## 🔄 Restore Process

1. **Models/Settings**  
   - Open Companion.  
   - Connect Boxer in **CDC mode**.  
   - Click **Write Models and Settings to Radio** → select your `.otx` backup.  

2. **SD Card Content**  
   - Copy saved SD card folders back onto a new or formatted card.  
   - Ensure firmware version and SD card pack version match (EdgeTX releases include matching SD packs).  

---

## 🛡️ Best Practices
- Backup before any firmware update.  
- Name files with date (`Boxer_Backup_YYYY-MM-DD.otx`).  
- Store one copy in your **GitHub repo** (private branch if preferred), and another in **cloud storage**.  
- Periodically test restoring to confirm backups are valid.  
