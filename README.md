# Custom Quadcopter Project

This is an endurance-optimized S 500 mm quadcopter powered by a Matek H743-SLIM V3 flight controller and running ArduPilot firmware.  

## Project Status
🚧 Work in Progress — Frame and wiring complete, first flight complete, initial tuning complete.  
Next steps: upgrade frame, refine wiring, upgrade flight controller, finalize 3D-printed component mounts, integrate camera, rfd900, and companion computer.

## Goals
- Max flight time
- Modular design
- Open-frame for FPV and sensor expansion

## Key Components
- [Matek H743-SLIM V3](https://www.mateksys.com/?portfolio=h743-slim) flight controller
- [Skystars KO60 BLheli32 60A ESC](https://www.skystars-rc.com/product/ko60-blheli32-60a-3-6s-esc-support-128k-dshot1200-4-in-1-esc/) 4-in-1 ESC (30×30)
- [3112 900KV brushless motors](https://www.amazon.com/dp/B0F7H2DN7J?ref_=ppx_hzsearch_conn_dt_b_fed_asin_title_3&th=1)
- [1147 carbon props](https://www.amazon.com/dp/B08137LLK7?ref_=ppx_hzsearch_conn_dt_b_fed_asin_title_2&th=1)
- [RadioMaster RP4TD](https://radiomasterrc.com/products/rp4td-expresslrs-2-4ghz-diversity-receiver) Receiver
- [RadioMaster Boxer Controller](https://radiomasterrc.com/products/boxer-radio-controller-m2)
- [HGLRC GPS / Compass](https://www.hglrc.com/products/m100-5883-gps?srsltid=AfmBOoq5upiWIUeaING3ysRxMJ71UZ72I3lojhzPYYxISSO0KZAK4p26)
- [RFD900x](https://rfdesign.com.au/modems/)
- 4S LiPo battery

## 📐 Frame & Layout
- [S500 X-frame design](https://www.amazon.com/dp/B01N0AX1MZ?ref=ppx_yo2ov_dt_b_fed_asin_title)
- [FC Adapter Plate Mount](./cad/openscad/fc_plate_30x30_heatset_rect_50x55_engraved.scad)
- [S500 Top Mount Spacer](./cad/stl/S500_Spacerv4.stl)

## ⚡ Power & Propulsion
- Motors: 3112 900 KV brushless outrunners (14-pole).
- Propellers: 1147 (11×4.7).
- ESC: Skystars KO60 BLheli32 60A 3-6S 4-in-1 (30×30 stack).
- Battery: 4S
- Power rail capacitor: Installed for ESC stability.

## 🎛️ Flight Controller & Electronics
- Flight Controller: [Matek H743-SLIM V3](https://www.mateksys.com/?portfolio=h743-slim)
- Receiver: [RadioMaster RP4TD](https://radiomasterrc.com/products/rp4td-expresslrs-2-4ghz-diversity-receiver)

## 🎮 Radio & Receiver
- **Transmitter**: [RadioMaster Boxer Controller](https://radiomasterrc.com/products/boxer-radio-controller-m2) (ExpressLRS 2.4 GHz)
  - Compact, full-size gimbals, supports long-range ELRS.
  - Paired directly with the RP4TD receiver over CRSF protocol.
- **Receiver**: [RadioMaster RP4TD](https://radiomasterrc.com/products/rp4td-expresslrs-2-4ghz-diversity-receiver)
  - Dual antenna diversity for strong link quality.
  - Connected to the Matek F405-HDTE on **UART2** (TX2/RX2) with 5V and GND.
- **Protocol**: ExpressLRS (CRSF)

## 📹 Cameras

### [**RunCam 5 Orange (Primary Recording Camera)**](https://www.runcam.com/download/RunCam-5-OR/RunCam5-or-manual-en.pdf)
- **Role:** Onboard HD recording for post-flight analysis & footage  
- **Mount:** 3D-printed TPU forward mount (shock-isolated)  
- **Resolution:** Up to 4K @ 30 FPS, ~60 Mb/s bitrate  
- **Orientation:** *Mounted inverted* → `rotate=180` in config  
- **Storage:** microSD (U3 recommended; ≥64GB, exFAT)  
- **Gyro Data:** Enabled for post-processing stabilization

### [**Foxeer Mini Standard Razer (FPV Camera)**](https://www.foxeer.com/foxeer-mini-standard-razer-fpv-camera-g-266)
- **Role:** FPV
- **Sensor & Resolution:** 1/3" CMOS sensor, 1200 TVL analog FPV video.
- **Aspect Ratios:** Switchable **4:3 / 16:9** output.
- **Field of View:** Wide FOV depending on lens (approx. 125° H / 155° D in 4:3; ~145° D in 16:9).
- **Low-Light Performance:** 0.01 Lux, 90 dB WDR, 3DNR, Day/Night modes.
- **Video System:** NTSC / PAL switchable; standard **CVBS analog output**.
- **Voltage Input:** **4.5–25 V** wide voltage range.
- **Operating Temp:** –10 °C to +50 °C.
- **Weight:** ~12 g.
- **Form Factor:** Compact **22 × 22 mm mini size** for easy mounting.

## 📡 VTX

### [**TBS Unify Pro32 (5.8 GHz)**](https://www.team-blacksheep.com/products/prod:unifypro32_hv?srsltid=AfmBOorDLRIW3rCqve6KWcg1UdovrVPWY-VS8diG2t2JrGP0k7rQRZgc)
- High-performance analog VTX
- SmartAudio support (VTX control via OSD/Mission Planner)
- Output power profiles: 25 mW → 100 mW → 400 mW → 800 mW+
- MMCX antenna connector
- Excellent noise rejection & strong long-range capability
- Wide input voltage, very stable under voltage sag

## 🧵 Serial Ports

### 🧭 Matek H743-SLIM UART Reference Guide

[H743-SLIM V3 IO Mapping Documentation](https://www.mateksys.com/?portfolio=h743-slim#tab-id-5)

| **GPIO Port Label** | **FC PAD LABEL** | **Typical Use** | **ArduPilot SERIALx** | **Protocol (value)** | **Baud** | **Notes / Tips** |
|----------------|------------------|-----------------|-----------------------|---------------|------------------|------------------|
| **USART1** | RX1/TX1 | 📈 Spare  | SERIAL2 | None (0) |  | Leave unused until you need it (set to device-specific later). |
| **USART2** | RX2/TX2 | 📡 GPS #1 | SERIAL3 | GPS (5)  | 230 | Pair with I²C compass on same GPS puck. |
| **USART3** | RX3/TX3 | 📈 Spare  | SERIAL4 | None (0) | | Leave unused until you need it (set to device-specific later). |
| **UART4**  | RX4/TX4 | 🛰 Telemetry / RFD900 | SERIAL6 | MAVLink (2) | 57 | Long-range radio. Provide dedicated 5 V ≥ 2 A BEC. |
| **USART6** | RX6/TX6 |  📈 Spare | SERIAL7 | None (0) |  | Leave unused until you need it (set to device-specific later).  |
| **UART7** | RX7/TX7 | 🎮 ELRS Receiver (CRSF) | SERIAL1 |  ELRS(23) | 420 | Express LRS (main receiver port). |
| **UART8** | RX8/TX8 | ESC Telemetry | SERIAL5 |  ESC Telemetry(16) | 115 | ESC Telemetry. |
| **USB**  | USB | 🔌 Ground Station | SERIAL0 | MAVLink (2) |  | Main setup + firmware loading port. |

  
## 🧭 Companion & Telemetry
- **Telemetry**
  - [RFD900](https://rfdesign.com.au/modems/)
- **Companion computer** *TBD* Raspberry Pi 3 running Rpanion.
- **Camera options** *TBD* 
  - [FOXEERFPV Camera Razer Mini](https://www.amazon.com/gp/product/B07ZKPDPLM/ref=ox_sc_saved_title_1?smid=A1S7UXKBIJXX1H&th=1)
  - [HGLRC Zeus350mW VTX](https://www.amazon.com/gp/product/B08MQ4ZDVF/ref=ox_sc_saved_title_2?smid=A399B0GHKF2YQX&psc=1)
  - [FOXEER Lollipop FPV U.FL Antenna 5.8G](https://www.amazon.com/gp/product/B07WLCFM5H/ref=ox_sc_saved_title_3?smid=A1JGQIWP459RKC&psc=1)

## CAD & 3D Models
- OpenSCAD, and STL files in [`/cad`](./cad)

## Tuning & Flight Logs
- PID tuning checklist: [`docs/tuning/tuning-checklist.md`](./docs/tuning/tuning-checklist.md)
- Flight logs: [`/flight-logs`](./flight-logs)

## Firmware & Params
- ArduPilot config: [`firmware/ardupilot/quad.param`](./firmware/ardupilot/quad.param)
- ESC config: [`firmware/esc/`](./firmware/esc/)

<details>
<summary><strong>Repository Structure</strong></summary>

```
quad-001/
│
├── docs/                # Build notes, wiring diagrams, schematics, checklists
│   ├── bom/             # Bill of materials spreadsheets
│   ├── images/          # Build photos
│   ├── setup/           # Step-by-step guides, calibration notes
│   └── wiring/          # ESC-FC diagrams, pinouts
│
├── firmware/            # Flight controller firmware configs and parameters
│   ├── ardupilot/       # Parameter files (.param) and tuning notes
│   ├── esc/             # ESC Parameters
│   ├── qgroundcontrol/  # Custom QGC mods, QML, build scripts
│   └── stm32/           # Future STM32 FC project (drivers, experiments)
│
├── companion/           # Raspberry Pi or other onboard computer code
│   ├── video/           # Streaming scripts (GStreamer, RTSP/UDP pipelines)
│   ├── mavlink/         # MAVLink router configs, companion scripts
│   └── utils/           # Helper scripts, test tools
│
├── cad/                 # 3D print and mechanical design
│   ├── f360/            # Fusion 360 source files (.f3d, .step)
│   ├── openscad/        # OpenSCAD models and scripts (.scad)
│   ├── stl/             # Exported printable parts
│   └── renders/         # Screenshots, previews
│
├── sim/                 # Simulation environments
│   ├── sitl/            # ArduPilot SITL configs
│   └── gazebo/          # Gazebo or other sim setups
│
├── tests/               # Bench tests, motor order tests, ESC/motor logs
│
├── scripts/             # Utility scripts (build, flashing, deployment)
│
├── images/              # Build photos
├── models/              # Legacy folder (consolidate into /cad long term)
├── flight-logs/         # Flight logs
├── LICENSE.md           # Project license
└── README.md            # Project overview, quickstart, links
```

</details>

## License
This project is licensed under the [MIT License](./LICENSE).