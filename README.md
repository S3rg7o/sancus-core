# sancus-core
[![Build Status](https://travis-ci.org/sancus-pma/sancus-core.svg?branch=master)](https://travis-ci.org/sancus-pma/sancus-core)

Minimal OpenMSP430 hardware extensions for isolation and attestation.
The current Sancus version supports secure DMA implementation: any attempt of accessing protected memory is detected and prevented from internal MAL circuitry.

## Installation and C Examples
For the installation instructions, please refer to https://github.com/S3rg7o/sancus-main.

Some examples, written in C code, show the security guarantees that Sancus can offer. The source codes are provided at https://github.com/S3rg7o/sancus-example.

## Write to Memory
Device - DMA interface
![Imgur](https://i.imgur.com/N0BktJo.png)

What is written into openMSP430 memory and into device internal registers
![Imgur](https://i.imgur.com/RsL1yWP.png)


## Read from Memory
Device - DMA interface
![Imgur](https://i.imgur.com/FvPgiMc.png)

What is written into openMSP430 memory and into device internal registers
![Imgur](https://i.imgur.com/HEllTXG.png)

## Overview

Detailed README coming soon.. For now, please refer to the Sancus [website](https://distrinet.cs.kuleuven.be/software/sancus/install.php) for installation instructions.
