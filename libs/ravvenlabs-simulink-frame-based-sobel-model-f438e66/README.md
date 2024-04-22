This Simulink model demonstrates how to perform a frame-based Sobel filter 
on an input image. The convolution kernel can easily be converted to HDL via HDL coder. 
The conv_core block was successfully converted to a Xilinx AXI Stream IP core and run
on the Fusion 2 FPGA stereo imager.
