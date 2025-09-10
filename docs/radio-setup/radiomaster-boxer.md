# Radiomaster Boxer – ELRS Setup Notes

This document records the transmitter settings required to connect the **Radiomaster RP4TD ExpressLRS receiver** to the **Matek F405-HDTE** flight controller.

---

## Model Setup
1. Create a new model for **Quad-001**. 
2. In **Model Setup → External RF**:
  - **Mode** = CRSF 
  - **Baud** = 400k (default) 
3. Internal RF should be **off** (since we’re using the internal ELRS module). 

---

## ExpressLRS Lua Script
1. From the Boxer home screen, press **SYS → TOOLS**. 
2. Launch **ELRS.lua**. 
3. Verify connection to the RP4TD. 
4. Configure:
  - **Packet Rate** (default 150 Hz is fine to start). 
  - **Telemetry Ratio** (e.g. 1:4). 
  - **TX Power** (start low, e.g. 100 mW, for bench testing). 
  - **Binding**: use the Bind command here if receiver isn’t already paired. 

---

## Binding Notes
- First binding was completed successfully; receiver LED is **solid green** when linked. 
- Always power the transmitter **before** the quad. 
- Never run the RP4TD without antennas connected (u.FL connectors can burn out).

---

## Troubleshooting
- If Mission Planner shows no RC input:
  - Confirm **External RF = CRSF**. 
  - Ensure ELRS Lua script can connect to the module. 
  - Check that `SERIALx_PROTOCOL = 23` and `SERIALx_BAUD = 420000` are set on the flight controller. 
