@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.2 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Thu May 04 10:29:48 +0200 2023
REM SW Build 3064766 on Wed Nov 18 09:12:45 MST 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
REM elaborate design
echo "xelab -wto 55964c17013d44d59b25beb9af26f3af --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot testbench_full_adder_behav xil_defaultlib.testbench_full_adder -log elaborate.log"
call xelab  -wto 55964c17013d44d59b25beb9af26f3af --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot testbench_full_adder_behav xil_defaultlib.testbench_full_adder -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
