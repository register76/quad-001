## Receiver → Flight Controller Wiring (RP4TD ↔ F405-HDTE)

| RP4TD Receiver Pin | Signal Type | FC Pad (Matek F405-HDTE) | Notes |
|--------------------|-------------|--------------------------|-------|
| **GND**            | Ground      | Any GND pad              | Common ground |
| **VCC (5V)**       | Power       | 5V pad                   | Powers receiver |
| **TX**             | CRSF signal | RX2 (UART2_RX)           | Receiver → FC |
| **RX**             | CRSF signal | TX2 (UART2_TX)           | FC → Receiver |
| **ANT1 / ANT2**    | Antennas    | —                        | Mounted in 45° tubes |
