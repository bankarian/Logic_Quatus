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
-- Created on Mon Nov 11 16:37:38 2019

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY USBupload IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC := '0';
        nrxf : IN STD_LOGIC := '0';
        ntxe : IN STD_LOGIC := '0';
        din: IN STD_LOGIC_VECTOR(7 downto 0);
        nrd : OUT STD_LOGIC;
        wr : OUT STD_LOGIC;
        dout: OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END USBupload;

ARCHITECTURE BEHAVIOR OF USBupload IS
    TYPE type_fstate IS (wait_nRXF_low,set_nRD_low,wait_nTXE_low,latch_data_from_host,set_WR_high,send_data_host);
    SIGNAL fstate : type_fstate;
    SIGNAL reg_fstate : type_fstate;
    SIGNAL temp : STD_LOGIC_VECTOR(7 downto 0);
BEGIN
    PROCESS (clock,reset,reg_fstate)
    BEGIN
        IF (reset='1') THEN
            fstate <= wait_nRXF_low;
        ELSIF (clock='1' AND clock'event) THEN
            fstate <= reg_fstate;
        END IF;
    END PROCESS;
	
    PROCESS (fstate,nrxf,ntxe, clock)
    BEGIN
        nrd <= '0';
        wr <= '0';
        --if (clock='1' AND clock'event) THEN
        CASE fstate IS
            WHEN wait_nRXF_low =>
                IF ((nrxf = '1')) THEN
                    reg_fstate <= wait_nRXF_low;
                ELSIF (NOT((nrxf = '1'))) THEN
                    reg_fstate <= set_nRD_low;
                -- Inserting 'else' block to prevent latch inference
                ELSE
                    reg_fstate <= wait_nRXF_low;
                END IF;

                wr <= '0';
                
                nrd <= '1';

            WHEN set_nRD_low =>
                reg_fstate <= latch_data_from_host;

                wr <= '0';

                nrd <= '0';
            WHEN wait_nTXE_low =>
                IF ((ntxe = '1')) THEN
                    reg_fstate <= wait_nTXE_low;
                ELSIF (NOT((ntxe = '1'))) THEN
                    reg_fstate <= set_WR_high;
                -- Inserting 'else' block to prevent latch inference
                ELSE
                    reg_fstate <= wait_nTXE_low;
                END IF;

                wr <= '0';

                nrd <= '1';
            WHEN latch_data_from_host =>
                reg_fstate <= wait_nTXE_low;

                wr <= '0';

                nrd <= '0';
                
                temp(7 downto 0) <= din(7 downto 0);
            WHEN set_WR_high =>
                reg_fstate <= send_data_host;

                wr <= '1';

                nrd <= '1';
            WHEN send_data_host =>
                reg_fstate <= wait_nRXF_low;

                wr <= '0';

                nrd <= '1';
                
                dout(7 downto 0) <= temp(7 downto 0);	-- send info
            WHEN OTHERS => 
                nrd <= '1';
                wr <= '0';
                dout <= "ZZZZZZZZ";
                reg_fstate <= wait_nrxf_low;
                --report "Reach undefined state";
        END CASE;
        --END IF;
    END PROCESS;
END BEHAVIOR;
