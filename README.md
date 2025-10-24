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
- [DYS 65A 2–8S AM32](https://pyrodrone.com/products/dys-am32-65a-2-8s-4in1-esc-30x30mm?srsltid=AfmBOopQYTArh_CXTaMVYLukG8EtwCzhfD9XbQw8DkJbP9Ws5KrN1L8A) 4-in-1 ESC (30×30)
- [3112 900KV brushless motors](https://www.amazon.com/dp/B0F7H2DN7J?ref_=ppx_hzsearch_conn_dt_b_fed_asin_title_3&th=1)
- [1147 carbon props](https://www.amazon.com/dp/B08137LLK7?ref_=ppx_hzsearch_conn_dt_b_fed_asin_title_2&th=1)
- [RadioMaster RP4TD](https://radiomasterrc.com/products/rp4td-expresslrs-2-4ghz-diversity-receiver) Receiver
- [RadioMaster Boxer Controller](https://radiomasterrc.com/products/boxer-radio-controller-m2)
- [HGLRC GPS / Compass](https://www.hglrc.com/products/m100-5883-gps?srsltid=AfmBOoq5upiWIUeaING3ysRxMJ71UZ72I3lojhzPYYxISSO0KZAK4p26)
- [RFD900x](https://rfdesign.com.au/modems/)
- 4S LiPo battery

## 📐 Frame & Layout
- [S500 X-frame design](https://www.amazon.com/dp/B01N0AX1MZ?ref=ppx_yo2ov_dt_b_fed_asin_title)
- Permanent 3D-printed mounts planned for a later phase.

## ⚡ Power & Propulsion
- Motors: 3112 900 KV brushless outrunners (14-pole).
- Propellers: 1147 (11×4.7).
- ESC: DYS 65 A 2–8 S AM32 4-in-1 (30×30 stack).
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
- **Antenna Mounts**: 45° or 90° tube mounts, positioned for clear radiation pattern and cable reach.

## 🧵 Serial Ports

# 🧭 Matek H743-SLIM UART Reference Guide

| **Port Label** | **STM32 Peripheral** | **Typical Use** | **ArduPilot SERIALx** | **Protocol** | **Notes / Tips** |
|----------------|----------------------|-----------------|------------------------|---------------|------------------|
| **UART1**      | USART1 | 🛰 Telemetry / RFD900 | `SERIAL1_PROTOCOL=2` | MAVLink | Use for RFD900 or other long-range radio. Provide dedicated 5 V ≥ 2 A BEC. |
| **UART2**      | USART2 | 🎮 ELRS Receiver (CRSF) | `SERIAL2_PROTOCOL=23` | CRSF | Hardware inverter-free; ideal for ExpressLRS. |
| **UART3**      | USART3 | 📡 GPS #1 | `SERIAL3_PROTOCOL=5` | GPS | Pair with I²C compass on same GPS puck. |
| **UART4**      | UART4 | 📈 ESC Telemetry / GPS #2 | `SERIAL4_PROTOCOL=0` | ESC TLM (auto-detect) | Use ESC TLM RX wire here for current, voltage, RPM. |
| **UART5**      | UART5 | 🔧 Debug / Secondary Telem / Companion Pi | `SERIAL5_PROTOCOL=2` | MAVLink | Good choice for bench testing or Pi link if Wi-Fi not used. |
| **UART6**      | USART6 | 🎥 VTX control | `SERIAL6_PROTOCOL=26 (Tramp)` or `28 (SmartAudio)` | VTX | TX-only. Add 1 kΩ inline resistor if noisy. |
| **UART7**      | UART7 | 🧪 Spare / TF-Luna serial | `SERIAL7_PROTOCOL=9 (Rangefinder)` | Rangefinder | Only if you use UART TF-Luna instead of I²C. |
| **UART8**      | UART8 | 💻 Companion Pi (alternative) | `SERIAL8_PROTOCOL=2` | MAVLink | Use 57600–921600 baud. Prefer UART-Pi over USB for reliability. |
| **USB**        | Virtual `SERIAL0` | 🔌 Ground Station | `SERIAL0_PROTOCOL=2` | MAVLink | Main setup + firmware loading port. |

<!--
### Active links
- **GPS/Compass (HGLRC M100-5883)**
  - **GPS (UART 5):** `SERIAL3_PROTOCOL = 5 (GPS)` @ default baud for module
  - **Compass:** I²C (external) → enable compass and perform calibration

- **RC / ExpressLRS**
  - **CRSF (UART 6):** `SERIAL5_PROTOCOL = 23 (CRSF)`  

- **Motor ESC Telemetry**
  - **ESC (UART 3):** `SERIAL2_PROTOCOL = 16 (ESC Telemetry)`  

- **RFD900x Telemetry**
  - **RFD900x (UART 1):** `SERIAL?_PROTOCOL = 2 (Mavlink 2)`  
 
### Port Map
| Function            | FC Port (pads) | ArduPilot params                            | Notes                    |
|--------------------|-----------------|----------------------------------------------|--------------------------|
| GPS (M100)         | UART **5**      | `SERIAL3_PROTOCOL=5`                         | GPS TX/RX ↔ FC RX/TX     |
| Compass (5883)     | I²C             | Enable ext compass; run compass calibration  | On same puck             |
| RC (ELRS CRSF)     | UART **6**      | `SERIAL5_PROTOCOL=23`                        | Set RC options as needed |
| ESC (DYS-65A)      | UART **3**      | `SERIAL2_PROTOCOL=16`                        |                          |
| RFD900x            | UART **1**      | `SERIAL?_PROTOCOL=2`                        |                          |
-->

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