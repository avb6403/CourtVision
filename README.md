# Real-Time Image Processing and Analysis System

## Project Overview
This project is designed to perform real-time image processing and pose analysis using a Zynq processor, integrating with MATLAB for processing and Unity for visualization.

## System Architecture

![Alt text](/CourtVision/doc/topology_orig.png "System Architecture Diagram")


### Components:
- **Image Processing Core**: A dedicated module for initial image processing. It performs real-time operations such as filtering, edge detection, or noise reduction.
- **VDMA (Video Direct Memory Access)**: Multiple VDMA blocks are used for efficient data transfer between the image processing core, Zynq processor, and the memory components without CPU intervention.
- **Zynq Processor**: The central processing unit that manages the flow of data, processes images, and communicates with external tools like MATLAB and Unity.
- **MATLAB**: Used for advanced image processing and analysis, including pose estimation algorithms.
- **Unity**: A game engine used for the visualization of processed data, showing the pose estimation in a 3D environment.

### Data Flow:
1. **Raw Images**: The initial images are captured and fed into the system.
2. **Image Processing Core**: Raw images are processed using the core.
3. **VDMA**: The processed images are then passed through VDMA to the Zynq processor.
4. **Zynq Processor**: Further image processing and analysis take place here.
5. **MATLAB**: The Zynq Processor sends images to MATLAB for pose estimation.
6. **Unity**: The estimated pose is visualized in the Unity environment.

### Interface:
- The system utilizes **64-bit interfaces** for data transfer between the various components to ensure high throughput and efficient processing.
- **Control Lines** are used between the Zynq Processor and MATLAB to manage the flow of data and synchronization of processes.

## Usage Scenarios
This system can be employed in various applications such as:
- Real-time surveillance for security purposes.
- Motion capture for animation and gaming.
- Sports analytics to analyze athletes' performance.

## Enhancements
- Implementing custom algorithms on the Image Processing Core for specialized image processing tasks.
- Optimizing VDMA settings to handle higher resolution images without compromising real-time performance.
- Expanding the interface with Unity to include more complex visualizations and interactive elements.

---

For more detailed documentation, please refer to the individual component guides and the system integration manual.
