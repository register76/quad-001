# Harmonic Notch Tuning Guide (ArduPilot – Quad-001)

> **Version:** v1.0  
> **Applies to:** ArduPilot Copter 4.x+  
> **Vehicle:** Quad-001 (S500, 3112-900KV, 10×4.7 props)

This guide documents how to identify rotor vibration frequencies using FFT analysis and how to configure ArduPilot’s **Dynamic Harmonic Notch Filter** to suppress them.  
It includes the full workflow, recommended parameters, and annotated FFT screenshots.

## 📘 Overview

The **Harmonic Notch Filter** removes high-energy vibrations created by the propeller / motor system.  
Correct configuration:

- Reduces motor noise in the gyro signal  
- Improves PID tuning results  
- Allows higher rate gains without oscillation  
- Improves stability and efficiency  

This document walks through:

1. Pre-flight parameter setup  
2. Collecting hover data  
3. Using the ArduPilot FFT WebTool  
4. Identifying the rotor fundamental and harmonics  
5. Selecting the correct notch center, bandwidth, and reference throttle  
6. Verifying the result

## 🔧 1. Pre-Flight Parameter Setup

Ensure these parameters are set *before* collecting hover data:

```
LOG_BITMASK      = 131070     ; Log almost everything
FFT_ENABLE       = 1          ; Enable FFT logging
INS_LOG_BAT_OPT  = 2          ; Log raw IMU sensor data
INS_GYRO_FILTER  = 40–80 Hz   ; Standard gyro filter range
```

Reboot the flight controller after changing these.

## 🛫 2. Hover Data Collection Flight

Perform a short test flight:

1. Arm and take off.
2. Maintain **steady hover** for **20–30 seconds**.
3. Optionally do:
   - Small throttle variations  
   - A few gentle climbs  
4. Land and disarm.
5. Remove the SD card and obtain the `.BIN` file.

## 🌐 3. Analyze the Hover Log Using ArduPilot Web Tools

Open the official FFT analyzer:

👉 **https://firmware.ardupilot.org/Tools/WebTools/FilterReview/**

Steps:

- Upload your hover `.BIN` file  
- Select **Gyro 1** or **Gyro 2** (whichever is cleaner)  
- Set the hover time window  
- Click **Calculate**  
- View:
  - **IMU Spectrum** (frequency domain)
  - **IMU Spectrogram** (time vs frequency)

## 📊 4. Identify the Rotor Fundamental

Look for the **sharpest, narrowest, repeating peak** in the Pre-Filter traces.

A valid motor fundamental exhibits:

- A **distinct peak** at low frequency (often 50–200 Hz)  
- A **2× harmonic** exactly double the frequency  
- A **3× harmonic** triple the frequency  

Example from Quad-001:

```
Fundamental ≈ 86 Hz
2nd Harmonic ≈ 172 Hz
3rd Harmonic ≈ 258 Hz
```

## 🖼️ 5. Annotated Spectrum (Peaks & Harmonics)

Below is a labeled version of the FFT spectrum highlighting:

- Rotor fundamental (F₀)
- 2× harmonic
- 3× harmonic
- Notch filter location
- Pre- vs Post-filter response

> **Replace the placeholder image below with your actual plot.**  
> Keep the text labels — they match how ArduPilot FFT plots should be interpreted.

### 📌 Annotated Spectrum Example

```
+---------------------------------------------------------------+
|                                                               |
|   ^                                                           |
|   |                                      (3× Harmonic ~258Hz) |
| amplitude                                                    |
|   |                 (2× Harmonic ~172Hz)                     |
|   |     F₀ (Fundamental ~86Hz)                               |
|   |      ↓               ↓               ↓                   |
|   |     /|\             /|\             /|\                  |
|   |    / | \           / | \           / | \                 |
|   +--------------------------------------------------------->|
|                         frequency (Hz)                       |
+---------------------------------------------------------------+
```

### Markdown image embedding

```
![Annotated Spectrum](../images/notch-spectrum-annotated.png)
```

## 🎯 6. Configure the Harmonic Notch Filter

Using the identified fundamental (example: **86 Hz**):

```
INS_HNTCH_ENABLE = 1          ; Enable harmonic notch
INS_HNTCH_MODE   = 3          ; Throttle-based dynamic notch
INS_HNTCH_FREQ   = 86         ; Rotor fundamental frequency
INS_HNTCH_BW     = 40         ; Bandwidth (covers ~66–106 Hz)
INS_HNTCH_ATT    = 40         ; Attenuation strength
INS_HNTCH_HMNCS  = 3          ; Filter 1×, 2×, 3× harmonics
INS_HNTCH_REF    = <CTUN.ThO> ; Set to hover throttle value
```

Determine hover throttle:

Open the `.BIN` in Mission Planner and graph:

```
CTUN.ThO
```

Average during hover, e.g.:

```
INS_HNTCH_REF = 0.40
```

## 🔁 7. Verify the Notch Filter

Perform a second hover test. Upload the new `.BIN` to Filter Review again.

A correct notch will show:

- A **dip** in the Post-Filter traces at the fundamental  
- Reduced amplitude at 2× and 3× harmonics  
- No major shift in the fundamental frequency  
- No new oscillation peaks introduced  

If the Post-Filter dip is slightly off-center:

- Adjust `INS_HNTCH_FREQ` by ±5–10 Hz  
- Widen `INS_HNTCH_BW` if peak is broad  
- Narrow `BW` if sharp

## 🚀 8. Ready for Autotune

Once the notch filter is properly centered:

✔ Autotune (Roll → Pitch → Yaw)  
✔ Better rate tracking  
✔ Lower vibration  
✔ More stable hover/forward flight  

## 📎 Appendix: Quick Checklist

### Before Flight
- `FFT_ENABLE = 1`
- `INS_LOG_BAT_OPT = 2`
- SD card inserted

### During Flight
- Hold hover 20–30 seconds
- Avoid aggressive yaw

### After Flight
- Use Filter Review tool
- Identify sharp fundamental
- Configure notch

### Ideal Notch Behavior
- Post-filter dip on F₀  
- Harmonics suppressed  
- Lower noise floor  
