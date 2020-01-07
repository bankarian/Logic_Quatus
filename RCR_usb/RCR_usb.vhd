-- Copyright (C) 1991-2009 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- Generated by Quartus II Version 9.0 Build 184 04/29/2009 Service Pack 1 SJ Web Edition
-- Created on Thu Nov 14 13:01:42 2019

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY RCR_usb IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC := '0';
        nrxf : IN STD_LOGIC := '0';
        din	: IN STD_LOGIC_VECTOR(7 downto 0);
        ntxe : IN STD_LOGIC := '0';
        nrd : OUT STD_LOGIC;
        wr : OUT STD_LOGIC;
        dout: OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END RCR_usb;

ARCHITECTURE BEHAVIOR OF RCR_usb IS
    TYPE type_fstate IS (wait_nrxf_low,set_wr_high,wait_ntxe_low,set_nrd_low,latch_data_from_host,send_data_host);
    SIGNAL fstate : type_fstate;
    SIGNAL reg_fstate : type_fstate;
BEGIN
    PROCESS (clock,reset,reg_fstate)
    BEGIN
        IF (reset='1') THEN
            fstate <= wait_nrxf_low;
        ELSIF (clock='1' AND clock'event) THEN
            fstate <= reg_fstate;
        END IF;
    END PROCESS;

    PROCESS (clock, fstate,nrxf,ntxe)
    BEGIN
        nrd <= '0';
        wr <= '0';
        IF clock'event and clock='1' then
        CASE fstate IS
            WHEN wait_nrxf_low =>
                IF (NOT((nrxf = '1'))) THEN
                    reg_fstate <= set_nrd_low;
                ELSIF ((nrxf = '1')) THEN
                    reg_fstate <= wait_nrxf_low;
                -- Inserting 'else' block to prevent latch inference
                ELSE
                    reg_fstate <= wait_nrxf_low;
                END IF;

                nrd <= '1';

                wr <= '0';
            WHEN set_nrd_low =>
                reg_fstate <= latch_data_from_host;

                nrd <= '0';

                wr <= '0';
            WHEN latch_data_from_host =>
                reg_fstate <= wait_ntxe_low;

                nrd <= '0';

                wr <= '0';
            WHEN wait_ntxe_low =>
                IF (NOT((ntxe = '1'))) THEN
                    reg_fstate <= set_wr_high;
                ELSE
                    reg_fstate <= wait_ntxe_low;
                END IF;

                nrd <= '1';

                wr <= '0';
            WHEN set_wr_high =>
                reg_fstate <= send_data_host;

                nrd <= '1';

                wr <= '1';
            WHEN send_data_host =>
                reg_fstate <= wait_nrxf_low;

                nrd <= '1';

                wr <= '1';
            WHEN OTHERS => 
                nrd <= '1';
                wr <= '1';
                dout <= "ZZZZZZZZ";
                report "Reach undefined state";
        END CASE;
        END IF;
    END PROCESS;
END BEHAVIOR;