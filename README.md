# Analog Measurement System

A simulation and measurement-analysis workflow for evaluating an analog signal through a simple RC measurement circuit.

This project combines **ngspice**, **Python**, **LabVIEW**, and **CUDA** into a single engineering workflow for circuit simulation, data processing, measurement visualization, and numerical analysis.

---

## Project Overview

The system begins with a sinusoidal input signal and passes it through an RC low-pass circuit.

The simulated voltage measurements are exported from ngspice, processed into CSV format using Python, analyzed numerically using CUDA/C, and displayed and analyzed in LabVIEW.

### Measurement Flow

    Analog Circuit
         │
         ▼
      ngspice
         │
         │ transient simulation
         ▼
    Raw Measurement Data
         │
         ▼
       Python
         │
         │ CSV processing
         ▼
    Processed Measurement Data
         │
    ┌────┴────┐
    ▼         ▼
 LabVIEW    CUDA
    │         │
    ▼         ▼
Measurement Numerical
 Dashboard  Analysis

---

## Circuit

The initial circuit is a simple RC low-pass filter.

### Input Signal

- Waveform: sinusoidal
- Amplitude: 10 mV
- Frequency: 1 kHz
- DC offset: 0 V

### Components

- `Rload = 1 kΩ`
- `Cfilter = 100 nF`

### Simulation

- Analysis type: transient
- Simulation time: 5 ms
- Maximum timestep: 1 µs

The simulation records:

- `V(in)`
- `V(out)`

---

## Software and Tools

| Tool | Purpose |
|---|---|
| **ngspice** | Analog circuit simulation |
| **Python** | Simulation-data extraction and CSV processing |
| **LabVIEW** | Measurement visualization and signal analysis |
| **CUDA / nvcc** | Numerical analysis executable |
| **VS Code** | Development environment |

---

## Repository Structure

    analog-measurement-system/
    │
    ├── ngspice/
    │   ├── measurement_circuit.cir
    │   └── measurement_output.txt
    │
    ├── python/
    │   └── parse_ngspice.py
    │
    ├── cuda/
    │   └── signal_analysis.cu
    │
    ├── labview/
    │   └── AnalogMeasurementDashboard.vi
    │
    ├── data/
    │   ├── raw/
    │   │   └── measurement_output.txt
    │   │
    │   └── processed/
    │       └── measurement_data.csv
    │
    ├── results/
    │   └── cuda_analysis.txt
    │
    └── README.md

---

## 1. Circuit Simulation with ngspice

The circuit is defined in:

    ngspice/measurement_circuit.cir

The simulation produces transient measurements of the input and output voltages.

The raw simulation output is stored in:

    ngspice/measurement_output.txt

The raw data is also copied into:

    data/raw/measurement_output.txt

---

## 2. Data Processing with Python

The Python script:

    python/parse_ngspice.py

extracts the numerical measurement data from the ngspice output and converts it into a CSV file.

The processed data is saved to:

    data/processed/measurement_data.csv

The resulting CSV contains:

    time,vin,vout

The completed simulation contains **5008 measurement samples**.

---

## 3. Measurement Analysis with LabVIEW

The LabVIEW virtual instrument provides a measurement-analysis dashboard.

The VI imports the processed CSV data and calculates measurement quantities including:

- Mean input voltage
- Mean output voltage
- RMS input voltage
- RMS output voltage
- RMS gain
- Gain in dB
- Output peak-to-peak voltage
- Output peak voltage

The LabVIEW VI is located at:

    labview/AnalogMeasurementDashboard.vi

### LabVIEW Measurement Functions

The dashboard processes the imported measurement arrays to calculate:

    Mean Voltage
         │
         ▼
    RMS Voltage
         │
         ▼
    RMS Gain
         │
         ▼
    Gain in dB

Peak measurements are calculated using the maximum and minimum values of the output signal:

    Maximum Vout
         │
         ├──────► Vout Peak
         │
         └──────► Maximum - Minimum
                         │
                         ▼
                  Vout Peak-to-Peak

---

## 4. Numerical Analysis with CUDA

The CUDA source file is:

    cuda/signal_analysis.cu

The program reads the processed measurement data and calculates:

- Mean voltage
- RMS voltage
- RMS gain
- Gain in dB
- Peak-to-peak voltage
- Peak voltage

The resulting analysis is saved to:

    results/cuda_analysis.txt

### Important Implementation Note

The current `.cu` program is compiled using the CUDA toolchain and `nvcc`, but the current numerical calculations are performed on the CPU.

A future version can move the signal-processing calculations into CUDA kernels for actual GPU acceleration.

This project therefore uses CUDA as part of the computational analysis and verification workflow without claiming GPU acceleration that has not yet been implemented.

---

## Results

The current analysis produced:

| Measurement | Result |
|---|---:|
| Samples | 5008 |
| Mean Vin | ~0 V |
| Mean Vout | ~0 V |
| RMS Vin | 0.00706542 V |
| RMS Vout | 0.00599969 V |
| RMS Gain | 0.849163 |
| Gain | -1.42 dB |
| Vin Peak-to-Peak | 0.01999997 V |
| Vout Peak-to-Peak | 0.01708964 V |
| Vin Peak | 0.00999998 V |
| Vout Peak | 0.00862232 V |

The measured output amplitude is lower than the input amplitude, demonstrating attenuation through the RC network.

---

## Running the Project

### Step 1: Run the ngspice Simulation

From the project directory, run:

    & "C:\Users\vanes\Downloads\ngspice-47_64\Spice64\bin\ngspice.exe" -b ngspice\measurement_circuit.cir -o ngspice\measurement_output.txt

This generates:

    ngspice/measurement_output.txt

### Step 2: Copy the Raw Measurement Data

Run:

    Copy-Item ngspice\measurement_output.txt data\raw\measurement_output.txt

### Step 3: Process the Data with Python

Run:

    python python\parse_ngspice.py

This generates:

    data/processed/measurement_data.csv

### Step 4: Compile the CUDA Analysis

Open an **x64 Native Tools Command Prompt for Visual Studio** and run:

    cd /d C:\Users\vanes\analog-measurement-system

Then compile:

    nvcc cuda\signal_analysis.cu -o cuda\signal_analysis.exe

### Step 5: Run the CUDA Analysis

Run:

    cuda\signal_analysis.exe

The results are written to:

    results/cuda_analysis.txt

---

## End-to-End Data Pipeline

The complete workflow is:

    RC Circuit
         │
         ▼
    ngspice Simulation
         │
         ▼
    Raw Voltage Measurements
         │
         ▼
    Python Data Parser
         │
         ▼
    CSV Measurement Dataset
         │
         ├─────────────────────┐
         ▼                     ▼
      LabVIEW                CUDA/C
         │                     │
         ▼                     ▼
    Measurement              Numerical
      Analysis                Analysis
         │                     │
         └──────────┬──────────┘
                    ▼
           Verified Measurements

---

## Engineering Concepts Demonstrated

This project demonstrates an end-to-end engineering workflow involving:

- Analog circuit simulation
- RC low-pass filter behavior
- Transient analysis
- Signal measurement
- Data extraction
- CSV data processing
- RMS calculations
- Peak measurements
- Peak-to-peak measurements
- Voltage gain
- Gain in decibels
- Measurement visualization
- Numerical analysis
- Computational verification
- Cross-tool engineering workflows

---

## Future Improvements

Potential future improvements include:

- Implementing actual CUDA GPU kernels
- Adding automated signal plots
- Adding frequency-response analysis
- Measuring phase shift
- Adding noise analysis
- Adding additional filter configurations
- Connecting LabVIEW to physical DAQ hardware
- Comparing simulated and experimentally measured signals
- Automating the complete simulation-to-analysis pipeline
- Expanding the system toward a hardware-based analog measurement platform

---

## Author

**Vanessa Knight**

Special thankyou to Richard, ChatGPT, who has helped me greatly by writing this ReadME, as well as mentoring me throughout the project. 

PS. Don't worry, I redid the project again after to make sure I understood everything. 😉

Electrical Engineering  
University of California, Los Angeles (UCLA)
