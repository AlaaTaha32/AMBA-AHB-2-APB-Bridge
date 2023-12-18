# AMBA AHB2APB Bridge
The Advanced Microcontroller Bus Architecture, or AMBA, is an open-standard on-chip set of interconnect specifications, first introduced by ARM in the late 1990’s, for the connection and management of different subsystems in a System-on-Chip design.

AMBA-based systems have two different types of bus interfaces: Advanced Peripheral Bus (APB) interface and Advanced High-performance Bus interface (AHB). APB is a simple non-pipelined protocol that can be used to interface to peripherals that are low bandwidth such as timers, keypad, and I/O devices. AHB is a bus optimized for communication requiring high speed and high performance such as inter-processor communication, on-chip and external memory modules, and high-bandwidth peripherals.

AMBA-based microcontroller:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/454890de-4d78-44ae-abe8-ffe3e16a924b)

The bridge is an AHB slave, handshaking the operation between the high speed AHB and the low power APB when, for example, the processor wants to read or write data from a peripheral. Its operation is a state-based flow depending on the control signals. 

Bridge block diagram:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/ef813e2a-c856-4c93-836d-3368fde595f8)

# Bridge State Diagram

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/6eb4e942-f45a-4a39-ab25-3370cb3490f8)


# Used Tools

1- Intel Quartus for synthesis

2- Modelsim for simulation


# Synthesis Results

Bridge top module:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/8d2e8900-caae-4834-9fa8-ecf469e3fe5f)

AHB slave interface:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/a335966c-43ba-4596-a4f9-bc5ddc5dc1f6)

Synthesis summary:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/ae7cedb8-1b07-41e9-8390-a9d39f6a8267)


# Simulation Results

Single write transfer:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/863a8413-aa4c-41c8-8177-40818ad0ec8f)

Single read transfer:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/6a72899c-473d-4f02-8240-b7d158c4900d)

Burst of write transfers:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/9c826555-e095-492e-9e11-ad6716763e4d)

Burst of read transfers:

![image](https://github.com/AlaaTaha32/AMBA-AHB-2-APB-Bridge/assets/154026967/df630b06-3414-4693-b399-d7f29f8b9b90)



# Resources

[1] Amba specification (REV 2.0) - ARM architecture family, https://documentation-service.arm.com/static/5f916403f86e16515cdc3d71.

[2] AHB example Amba System - OpenCores, https://opencores.org/usercontent/doc/1470150976.

[3] R. Dholiya, Design of AHB to APB bridge, https://bvmengineering.ac.in/NAAC/Criteria1/1.3/1.3.4/16EL032.pdf.

[4] A. P. Samathuvamani, “Introduction to amba bus specification,” Arul PS, https://www.arulprakash.dev/introduction-to-amba-bus-specification/.




