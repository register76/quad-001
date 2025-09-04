# Custom Quadcopter Project

This is an endurance-optimized 450 mm quadcopter powered by a Matek F405-HDTE flight controller and running ArduPilot firmware.  

## Goals
- Max flight time
- Modular design
- Open-frame for FPV and sensor expansion

## Key Components
- Matek F405-HDTE flight controller
- DYS 65A 2–8S AM32 4-in-1 ESC (30×30)
- 3112 900KV brushless motors
- DJI 1045 / 1147 carbon props
- 4S LiPo battery (3S & 6S also tested)

## 📐 Frame & Layout
- 450 mm X-frame design.
- Components temporarily secured with Velcro/zip ties.
- Permanent 3D-printed mounts planned for a later phase.

## ⚡ Power & Propulsion
- Motors: 3112 900 KV brushless outrunners (14-pole).
- Propellers: 1147 (11×4.7).
- ESC: DYS 65 A 2–8 S AM32 4-in-1 (30×30 stack).
- Battery: Primarily 4 S, with 3 S and 6 S packs available for testing.
- Power rail capacitor: Installed for ESC stability.

## 🎛️ Flight Controller & Electronics
- Flight Controller: Matek F405-HDTE.
- Receiver: To be finalized (RadioMaster Boxer + ExpressLRS considered).
- Servo rail voltage: Confirmed at 5 V.
- Integration: FC wired to ESC, motor order verified, motor directions corrected in AM32 Configurator.

## 🧭 Companion & Telemetry
- Companion computer: Raspberry Pi 3 running Rpanion.
- Camera options: Raspberry Pi camera modules (IMX477 HQ, IMX462, others).
- Telemetry: PiFi Wi-Fi streaming with MAVLink router planned.0

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
│   ├── esc/             # ESC Paramters
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
└── README.md            # Project overview, quickstart, links
```

</details>

## CAD & 3D Models
- Fusion 360, OpenSCAD, and STL files in [`/cad`](./cad)

## Bill of Materials (BOM)
- CSV format in [`/docs/bom`](./docs/bom)  

## Tuning & Flight Logs
- PID tuning checklist: [`docs/setup/tuning-checklist.md`](./docs/setup/tuning-checklist.md)
- Flight logs: [`/flight-logs`](./flight-logs)

## Firmware & Params
- ArduPilot config: [`firmware/ardupilot/quad.param`](./firmware/ardupilot/quad.param)
- ESC config:[`firmware/esc/`](./firmware/esc/)

## License
MIT License – free to use, modify, and share.
