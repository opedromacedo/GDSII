//***************************************************************************//
//                           VERILOG MAINSIM FILE                            //
// Modus(TM) DFT Software Solution, Version 23.11-s014_1, built Mar 14 2024  //
//***************************************************************************//
//                                                                           //
//  FILE CREATED..............December 15, 2025 at 15:40:01                  //
//                                                                           //
//  PROJECT NAME..............test_scripts                                   //
//                                                                           //
//  TESTMODE..................FULLSCAN                                       //
//                                                                           //
//  INEXPERIMENT..............logic                                          //
//                                                                           //
//  TDR.......................dummy.tdr                                      //
//                                                                           //
//  TEST PERIOD...............80.000   TEST TIME UNITS...........ns          //
//  TEST PULSE WIDTH..........8.000                                          //
//  TEST STROBE OFFSET........72.000   TEST STROBE TYPE..........edge        //
//  TEST BIDI OFFSET..........0.000                                          //
//  TEST PI OFFSET............0.000    X VALUE...................X           //
//                                                                           //
//  SCAN FORMAT...............serial   SCAN OVERLAP..............yes         //
//  SCAN PERIOD...............80.000   SCAN TIME UNITS...........ns          //
//  SCAN PULSE WIDTH..........8.000                                          //
//  SCAN STROBE OFFSET........0.000    SCAN STROBE TYPE..........edge        //
//  SCAN BIDI OFFSET..........0.000                                          //
//  SCAN PI OFFSET............0.000    X VALUE...................X           //
//                                                                           //
//                                                                           //
//   Individually set PIs                                                    //
//  "clock" (PI # 66)                                                        //
//  TEST OFFSET...............8.000    PULSE WIDTH...............8.000       //
//  SCAN OFFSET...............0.000                                          //
//                                                                           //
//  "nreset" (PI # 68)                                                       //
//  TEST OFFSET...............8.000    PULSE WIDTH...............8.000       //
//  SCAN OFFSET...............0.000                                          //
//                                                                           //
//  Active TESTMODEs TM = 1 ..FULLSCAN                                       //
//                                                                           //
//***************************************************************************//

// Command Line: write_vectors -WORKDIR mydir -TESTMODE FULLSCAN -INEXPERIMENT logic -language verilog -outputfilename test_results -scanformat serial

  `timescale 1 ns / 1 ps

  module test_scripts_FULLSCAN_logic ;

//***************************************************************************//
//                DEFINE VARIABLES FOR ALL PRIMARY I/O PORTS                 //
//***************************************************************************//

  reg [1:71] stim_PIs;   
  reg [1:71] part_PIs;   

  reg [1:71] stim_CIs;   

  reg [1:67] meas_POs;   
  wire [1:67] part_POs;   

//***************************************************************************//
//                   DEFINE VARIABLES FOR ALL SHIFT CHAINS                   //
//***************************************************************************//


//***************************************************************************//
//                             OTHER DEFINITIONS                             //
//***************************************************************************//

  integer  CYCLE, SCANCYCLE, SERIALCYCLE, PInum, POnum, ORnum, MODENUM, EXPNUM, SCANOPNUM, SEQNUM, TASKNUM, START, NUM_SHIFTS, MultiShift, maxMultiShifts, MultiShiftsLeft, forcePointStart, forcePoint, SCANNUM, FREQNUM ; 
  integer  CMD, DATAID, SAVEID, TID, num_files, rc_read, repeat_depth, repeat_heart, repeat_num, MAX, FAILSETID, DIAG_DATAID; 
  integer  test_num, test_num_prev, failed_test_num, num_tests, num_failed_tests, total_num_tests, total_num_failed_tests, total_cycles, scan_num, overlap; 
  integer  num_repeats [1:15]; 
  reg      [1:8185] name_POs [1:67]; 
  reg      [130:0] good_compares, miscompares, miscompare_limit, total_good_compares, total_miscompares, measure_current; 
  reg      [63:0] start_of_repeat [1:15]; 
  reg      [63:0] start_of_current_line, fseek_offset; 
  reg      [130:0] line_number, save_line_number; 
  reg      count_cycles, sim_trace, sim_heart, sim_range, sim_range_measure, failset, global_term, sim_debug, sim_more_debug, diag_debug; 
  reg      [1:800] PATTERN, pattern, TESTFILE, INITFILE, SOD, EOD, eventID, DIAG_DEBUG_FILE; 
  reg      [1:8184] DATAFILE, SAVEFILE, COMMENT, FAILSET; 
  reg      [1:4096] PROCESSNAME; 

//***************************************************************************//
//        INSTANTIATE THE STRUCTURE AND CONNECT TO VERILOG VARIABLES         //
//***************************************************************************//

  opdiv
    opdiv_inst (
      .clock           ( part_PIs[66] ),      // pinName = clock;  tf = -ES  ; testOffset = 8.000000;  scanOffset = 0.000000;  
      .nreset          ( part_PIs[68] ),      // pinName = nreset;  tf = +SC  ; testOffset = 8.000000;  scanOffset = 0.000000;  
      .a               ({part_PIs[26]  ,      // pinName = a[31]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[25]  ,      // pinName = a[30]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[23]  ,      // pinName = a[29]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[22]  ,      // pinName = a[28]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[21]  ,      // pinName = a[27]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[20]  ,      // pinName = a[26]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[19]  ,      // pinName = a[25]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[18]  ,      // pinName = a[24]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[17]  ,      // pinName = a[23]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[16]  ,      // pinName = a[22]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[15]  ,      // pinName = a[21]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[14]  ,      // pinName = a[20]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[12]  ,      // pinName = a[19]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[11]  ,      // pinName = a[18]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[10]  ,      // pinName = a[17]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[09]  ,      // pinName = a[16]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[08]  ,      // pinName = a[15]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[07]  ,      // pinName = a[14]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[06]  ,      // pinName = a[13]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[05]  ,      // pinName = a[12]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[04]  ,      // pinName = a[11]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[03]  ,      // pinName = a[10]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[33]  ,      // pinName = a[9]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[32]  ,      // pinName = a[8]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[31]  ,      // pinName = a[7]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[30]  ,      // pinName = a[6]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[29]  ,      // pinName = a[5]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[28]  ,      // pinName = a[4]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[27]  ,      // pinName = a[3]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[24]  ,      // pinName = a[2]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[13]  ,      // pinName = a[1]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[02]}),      // pinName = a[0]; testOffset = 0.000000;  scanOffset = 0.000000;  
      .b               ({part_PIs[58]  ,      // pinName = b[31]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[57]  ,      // pinName = b[30]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[55]  ,      // pinName = b[29]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[54]  ,      // pinName = b[28]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[53]  ,      // pinName = b[27]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[52]  ,      // pinName = b[26]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[51]  ,      // pinName = b[25]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[50]  ,      // pinName = b[24]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[49]  ,      // pinName = b[23]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[48]  ,      // pinName = b[22]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[47]  ,      // pinName = b[21]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[46]  ,      // pinName = b[20]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[44]  ,      // pinName = b[19]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[43]  ,      // pinName = b[18]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[42]  ,      // pinName = b[17]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[41]  ,      // pinName = b[16]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[40]  ,      // pinName = b[15]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[39]  ,      // pinName = b[14]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[38]  ,      // pinName = b[13]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[37]  ,      // pinName = b[12]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[36]  ,      // pinName = b[11]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[35]  ,      // pinName = b[10]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[65]  ,      // pinName = b[9]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[64]  ,      // pinName = b[8]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[63]  ,      // pinName = b[7]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[62]  ,      // pinName = b[6]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[61]  ,      // pinName = b[5]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[60]  ,      // pinName = b[4]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[59]  ,      // pinName = b[3]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[56]  ,      // pinName = b[2]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[45]  ,      // pinName = b[1]; testOffset = 0.000000;  scanOffset = 0.000000;  
                         part_PIs[34]}),      // pinName = b[0]; testOffset = 0.000000;  scanOffset = 0.000000;  
      .c               ({part_POs[25]  ,      // pinName = c[31]; 
                         part_POs[24]  ,      // pinName = c[30]; 
                         part_POs[22]  ,      // pinName = c[29]; 
                         part_POs[21]  ,      // pinName = c[28]; 
                         part_POs[20]  ,      // pinName = c[27]; 
                         part_POs[19]  ,      // pinName = c[26]; 
                         part_POs[18]  ,      // pinName = c[25]; 
                         part_POs[17]  ,      // pinName = c[24]; 
                         part_POs[16]  ,      // pinName = c[23]; 
                         part_POs[15]  ,      // pinName = c[22]; 
                         part_POs[14]  ,      // pinName = c[21]; 
                         part_POs[13]  ,      // pinName = c[20]; 
                         part_POs[11]  ,      // pinName = c[19]; 
                         part_POs[10]  ,      // pinName = c[18]; 
                         part_POs[09]  ,      // pinName = c[17]; 
                         part_POs[08]  ,      // pinName = c[16]; 
                         part_POs[07]  ,      // pinName = c[15]; 
                         part_POs[06]  ,      // pinName = c[14]; 
                         part_POs[05]  ,      // pinName = c[13]; 
                         part_POs[04]  ,      // pinName = c[12]; 
                         part_POs[03]  ,      // pinName = c[11]; 
                         part_POs[02]  ,      // pinName = c[10]; 
                         part_POs[32]  ,      // pinName = c[9]; 
                         part_POs[31]  ,      // pinName = c[8]; 
                         part_POs[30]  ,      // pinName = c[7]; 
                         part_POs[29]  ,      // pinName = c[6]; 
                         part_POs[28]  ,      // pinName = c[5]; 
                         part_POs[27]  ,      // pinName = c[4]; 
                         part_POs[26]  ,      // pinName = c[3]; 
                         part_POs[23]  ,      // pinName = c[2]; 
                         part_POs[12]  ,      // pinName = c[1]; 
                         part_POs[01]}),      // pinName = c[0]; 
      .r               ({part_POs[59]  ,      // pinName = r[31]; 
                         part_POs[58]  ,      // pinName = r[30]; 
                         part_POs[56]  ,      // pinName = r[29]; 
                         part_POs[55]  ,      // pinName = r[28]; 
                         part_POs[54]  ,      // pinName = r[27]; 
                         part_POs[53]  ,      // pinName = r[26]; 
                         part_POs[52]  ,      // pinName = r[25]; 
                         part_POs[51]  ,      // pinName = r[24]; 
                         part_POs[50]  ,      // pinName = r[23]; 
                         part_POs[49]  ,      // pinName = r[22]; 
                         part_POs[48]  ,      // pinName = r[21]; 
                         part_POs[47]  ,      // pinName = r[20]; 
                         part_POs[45]  ,      // pinName = r[19]; 
                         part_POs[44]  ,      // pinName = r[18]; 
                         part_POs[43]  ,      // pinName = r[17]; 
                         part_POs[42]  ,      // pinName = r[16]; 
                         part_POs[41]  ,      // pinName = r[15]; 
                         part_POs[40]  ,      // pinName = r[14]; 
                         part_POs[39]  ,      // pinName = r[13]; 
                         part_POs[38]  ,      // pinName = r[12]; 
                         part_POs[37]  ,      // pinName = r[11]; 
                         part_POs[36]  ,      // pinName = r[10]; 
                         part_POs[66]  ,      // pinName = r[9]; 
                         part_POs[65]  ,      // pinName = r[8]; 
                         part_POs[64]  ,      // pinName = r[7]; 
                         part_POs[63]  ,      // pinName = r[6]; 
                         part_POs[62]  ,      // pinName = r[5]; 
                         part_POs[61]  ,      // pinName = r[4]; 
                         part_POs[60]  ,      // pinName = r[3]; 
                         part_POs[57]  ,      // pinName = r[2]; 
                         part_POs[46]  ,      // pinName = r[1]; 
                         part_POs[35]}),      // pinName = r[0]; 
      .in_valid_i      ( part_PIs[67] ),      // pinName = in_valid_i; testOffset = 0.000000;  scanOffset = 0.000000;  
      .in_ready_o      ( part_POs[33] ),      // pinName = in_ready_o; 
      .out_valid_o     ( part_POs[34] ),      // pinName = out_valid_o; 
      .signal_division ( part_PIs[71] ),      // pinName = signal_division; testOffset = 0.000000;  scanOffset = 0.000000;  
      .out_ready_i     ( part_PIs[69] ),      // pinName = out_ready_i; testOffset = 0.000000;  scanOffset = 0.000000;  
      .SE              ( part_PIs[01] ),      // pinName = SE;  tf = +SE  ; testOffset = 0.000000;  scanOffset = 0.000000;  
      .scan_in         ( part_PIs[70] ),      // pinName = scan_in;  tf =  SI  ; testOffset = 0.000000;  scanOffset = 0.000000;  
      .scan_out        ( part_POs[67] )     // pinName = scan_out;  tf =  SO  ; 
      );

//***************************************************************************//
//                        MAKE SOME OTHER CONNECTIONS                        //
//***************************************************************************//

  assign ( weak0, weak1 ) // Termination 
    part_POs [1] = global_term,     // pinName = c[0]; 
    part_POs [2] = global_term,     // pinName = c[10]; 
    part_POs [3] = global_term,     // pinName = c[11]; 
    part_POs [4] = global_term,     // pinName = c[12]; 
    part_POs [5] = global_term,     // pinName = c[13]; 
    part_POs [6] = global_term,     // pinName = c[14]; 
    part_POs [7] = global_term,     // pinName = c[15]; 
    part_POs [8] = global_term,     // pinName = c[16]; 
    part_POs [9] = global_term,     // pinName = c[17]; 
    part_POs [10] = global_term,     // pinName = c[18]; 
    part_POs [11] = global_term,     // pinName = c[19]; 
    part_POs [12] = global_term,     // pinName = c[1]; 
    part_POs [13] = global_term,     // pinName = c[20]; 
    part_POs [14] = global_term,     // pinName = c[21]; 
    part_POs [15] = global_term,     // pinName = c[22]; 
    part_POs [16] = global_term,     // pinName = c[23]; 
    part_POs [17] = global_term,     // pinName = c[24]; 
    part_POs [18] = global_term,     // pinName = c[25]; 
    part_POs [19] = global_term,     // pinName = c[26]; 
    part_POs [20] = global_term,     // pinName = c[27]; 
    part_POs [21] = global_term,     // pinName = c[28]; 
    part_POs [22] = global_term,     // pinName = c[29]; 
    part_POs [23] = global_term,     // pinName = c[2]; 
    part_POs [24] = global_term,     // pinName = c[30]; 
    part_POs [25] = global_term,     // pinName = c[31]; 
    part_POs [26] = global_term,     // pinName = c[3]; 
    part_POs [27] = global_term,     // pinName = c[4]; 
    part_POs [28] = global_term,     // pinName = c[5]; 
    part_POs [29] = global_term,     // pinName = c[6]; 
    part_POs [30] = global_term,     // pinName = c[7]; 
    part_POs [31] = global_term,     // pinName = c[8]; 
    part_POs [32] = global_term,     // pinName = c[9]; 
    part_POs [33] = global_term,     // pinName = in_ready_o; 
    part_POs [34] = global_term,     // pinName = out_valid_o; 
    part_POs [35] = global_term,     // pinName = r[0]; 
    part_POs [36] = global_term,     // pinName = r[10]; 
    part_POs [37] = global_term,     // pinName = r[11]; 
    part_POs [38] = global_term,     // pinName = r[12]; 
    part_POs [39] = global_term,     // pinName = r[13]; 
    part_POs [40] = global_term,     // pinName = r[14]; 
    part_POs [41] = global_term,     // pinName = r[15]; 
    part_POs [42] = global_term,     // pinName = r[16]; 
    part_POs [43] = global_term,     // pinName = r[17]; 
    part_POs [44] = global_term,     // pinName = r[18]; 
    part_POs [45] = global_term,     // pinName = r[19]; 
    part_POs [46] = global_term,     // pinName = r[1]; 
    part_POs [47] = global_term,     // pinName = r[20]; 
    part_POs [48] = global_term,     // pinName = r[21]; 
    part_POs [49] = global_term,     // pinName = r[22]; 
    part_POs [50] = global_term,     // pinName = r[23]; 
    part_POs [51] = global_term,     // pinName = r[24]; 
    part_POs [52] = global_term,     // pinName = r[25]; 
    part_POs [53] = global_term,     // pinName = r[26]; 
    part_POs [54] = global_term,     // pinName = r[27]; 
    part_POs [55] = global_term,     // pinName = r[28]; 
    part_POs [56] = global_term,     // pinName = r[29]; 
    part_POs [57] = global_term,     // pinName = r[2]; 
    part_POs [58] = global_term,     // pinName = r[30]; 
    part_POs [59] = global_term,     // pinName = r[31]; 
    part_POs [60] = global_term,     // pinName = r[3]; 
    part_POs [61] = global_term,     // pinName = r[4]; 
    part_POs [62] = global_term,     // pinName = r[5]; 
    part_POs [63] = global_term,     // pinName = r[6]; 
    part_POs [64] = global_term,     // pinName = r[7]; 
    part_POs [65] = global_term,     // pinName = r[8]; 
    part_POs [66] = global_term,     // pinName = r[9]; 
    part_POs [67] = global_term;      // pinName = scan_out;  tf =  SO  ; 

//***************************************************************************//
//                     OPEN THE FILE AND RUN SIMULATION                      //
//***************************************************************************//

  initial 
    begin 

      $timeformat ( -12, 2, " ps", 10 ); 

      `ifdef sdf_annotate 
        `ifdef SDF_Minimum 
          $sdf_annotate ("default.sdf",opdiv_inst,,"sdf_Min.log","MINIMUM");
        `endif 
        `ifdef SDF_Maximum 
          $sdf_annotate ("default.sdf",opdiv_inst,,"sdf_Max.log","MAXIMUM");
        `endif 
        `ifdef SDF_Typical
          $sdf_annotate ("default.sdf",opdiv_inst,,"sdf_Typ.log","TYPICAL");
        `endif 
      `endif 

      `ifndef NOT_NC 
        if ( $test$plusargs ( "simvision" ) )  begin 
          $shm_open("simvision.shm"); 
          $shm_probe("AC"); 
        end  
      `endif 

      if ( $test$plusargs ( "vcd" ) )  begin 
        $dumpfile("out.vcd"); 
        $dumpvars(0,test_scripts_FULLSCAN_logic ); 
      end  

      DATAFILE = 0; 
      sim_setup; 

      `ifdef MISCOMPAREDEBUG 
        diag_debug = 1'b0; 
        if ( $value$plusargs ( "MISCOMPAREDEBUGFILE=%s", DIAG_DEBUG_FILE )) begin 
          DIAG_DATAID = $fopen ( DIAG_DEBUG_FILE, "r" ); 
          if ( DIAG_DATAID ) begin 
            diag_debug = 1'b1; 
            $fclose ( DIAG_DATAID ); 
          end  
          else $display ( "\nERROR (TVE-951): Failed to open the file: Diagnostic 'MISCOMPAREDEBUGFILE' %0s. \n", DIAG_DEBUG_FILE ); 
        end  
      `endif  

      num_files = 0; 
      for ( TID = 1; TID <= 99; TID = TID + 1 ) begin 
        $sformat ( TESTFILE, "TESTFILE%0d=%s", TID, "%s" ); 
        if ( $value$plusargs ( TESTFILE, DATAFILE )) begin 
          DATAID = $fopen ( DATAFILE, "r" ); 
          if ( DATAID )  begin 
            sim_vector_file; 
            num_files = num_files + 1; 
          end  
          else $display ( "\nERROR (TVE-951): Failed to open the file: %0s. \n", DATAFILE ); 
        end  
      end  

      if ( FAILSETID )  $fclose ( FAILSETID ); 

      if ( DATAFILE )  begin
        $display ( "\nINFO (TVE-209): Cumulative Results: " ); 
        $display ( "                      Number of Files Simulated:        %0d ", num_files ); 
        $display ( "                      Total Number of Cycles:           %0d ", total_cycles ); 
        $display ( "                      Total Number of Tests:            %0d ", total_num_tests ); 
        $display ( "                        - Total Passed Tests:           %0d ", total_num_tests - total_num_failed_tests ); 
        $display ( "                        - Total Failed Tests:           %0d ", total_num_failed_tests ); 
        $display ( "                      Total Number of Compares:         %0.0f ", total_good_compares + total_miscompares ); 
        $display ( "                        - Total Good Compares:          %0.0f ", total_good_compares ); 
        $display ( "                        - Total Miscompares:            %0.0f \n", total_miscompares ); 
      end  
      else $display ( "\nWARNING (TVE-661): No input data files found. The data file must be specified using +TESTFILE1=<string>, +TESTFILE2=<string>, ... The +TESTFILEn=<string> keyword is an NC-Sim command. \n" ); 

      $finish; 

    end  

//***************************************************************************//
//                     DEFINE SIMULATION SETUP PROCEDURE                     //
//***************************************************************************//

  task sim_setup; 
    begin 

      total_good_compares = 0; 
      total_miscompares = 0; 
      miscompare_limit = 0; 
      total_num_tests = 0; 
      total_num_failed_tests = 0; 
      total_cycles = 0; 
      SOD = ""; 
      EOD = ""; 
      START = 0; 
      NUM_SHIFTS = 0; 
      MAX = 1; 

      sim_heart = 1'b0; 
      sim_range = 1'b1; 
      sim_range_measure = 1'b1; 
      sim_trace = 1'b0; 
      sim_debug = 1'b0; 
      sim_more_debug = 1'b0; 

      global_term = 1'bZ; 

      failset = 1'b0; 
      FAILSETID = 0; 

      CYCLE = 0; 
      SCANCYCLE = 0; 
      SERIALCYCLE = 0; 
      count_cycles = 1'b1; 
      SEQNUM = 0; 
      name_POs [1] = "c[0]";      // pinName = c[0]; 
      name_POs [2] = "c[10]";      // pinName = c[10]; 
      name_POs [3] = "c[11]";      // pinName = c[11]; 
      name_POs [4] = "c[12]";      // pinName = c[12]; 
      name_POs [5] = "c[13]";      // pinName = c[13]; 
      name_POs [6] = "c[14]";      // pinName = c[14]; 
      name_POs [7] = "c[15]";      // pinName = c[15]; 
      name_POs [8] = "c[16]";      // pinName = c[16]; 
      name_POs [9] = "c[17]";      // pinName = c[17]; 
      name_POs [10] = "c[18]";      // pinName = c[18]; 
      name_POs [11] = "c[19]";      // pinName = c[19]; 
      name_POs [12] = "c[1]";      // pinName = c[1]; 
      name_POs [13] = "c[20]";      // pinName = c[20]; 
      name_POs [14] = "c[21]";      // pinName = c[21]; 
      name_POs [15] = "c[22]";      // pinName = c[22]; 
      name_POs [16] = "c[23]";      // pinName = c[23]; 
      name_POs [17] = "c[24]";      // pinName = c[24]; 
      name_POs [18] = "c[25]";      // pinName = c[25]; 
      name_POs [19] = "c[26]";      // pinName = c[26]; 
      name_POs [20] = "c[27]";      // pinName = c[27]; 
      name_POs [21] = "c[28]";      // pinName = c[28]; 
      name_POs [22] = "c[29]";      // pinName = c[29]; 
      name_POs [23] = "c[2]";      // pinName = c[2]; 
      name_POs [24] = "c[30]";      // pinName = c[30]; 
      name_POs [25] = "c[31]";      // pinName = c[31]; 
      name_POs [26] = "c[3]";      // pinName = c[3]; 
      name_POs [27] = "c[4]";      // pinName = c[4]; 
      name_POs [28] = "c[5]";      // pinName = c[5]; 
      name_POs [29] = "c[6]";      // pinName = c[6]; 
      name_POs [30] = "c[7]";      // pinName = c[7]; 
      name_POs [31] = "c[8]";      // pinName = c[8]; 
      name_POs [32] = "c[9]";      // pinName = c[9]; 
      name_POs [33] = "in_ready_o";      // pinName = in_ready_o; 
      name_POs [34] = "out_valid_o";      // pinName = out_valid_o; 
      name_POs [35] = "r[0]";      // pinName = r[0]; 
      name_POs [36] = "r[10]";      // pinName = r[10]; 
      name_POs [37] = "r[11]";      // pinName = r[11]; 
      name_POs [38] = "r[12]";      // pinName = r[12]; 
      name_POs [39] = "r[13]";      // pinName = r[13]; 
      name_POs [40] = "r[14]";      // pinName = r[14]; 
      name_POs [41] = "r[15]";      // pinName = r[15]; 
      name_POs [42] = "r[16]";      // pinName = r[16]; 
      name_POs [43] = "r[17]";      // pinName = r[17]; 
      name_POs [44] = "r[18]";      // pinName = r[18]; 
      name_POs [45] = "r[19]";      // pinName = r[19]; 
      name_POs [46] = "r[1]";      // pinName = r[1]; 
      name_POs [47] = "r[20]";      // pinName = r[20]; 
      name_POs [48] = "r[21]";      // pinName = r[21]; 
      name_POs [49] = "r[22]";      // pinName = r[22]; 
      name_POs [50] = "r[23]";      // pinName = r[23]; 
      name_POs [51] = "r[24]";      // pinName = r[24]; 
      name_POs [52] = "r[25]";      // pinName = r[25]; 
      name_POs [53] = "r[26]";      // pinName = r[26]; 
      name_POs [54] = "r[27]";      // pinName = r[27]; 
      name_POs [55] = "r[28]";      // pinName = r[28]; 
      name_POs [56] = "r[29]";      // pinName = r[29]; 
      name_POs [57] = "r[2]";      // pinName = r[2]; 
      name_POs [58] = "r[30]";      // pinName = r[30]; 
      name_POs [59] = "r[31]";      // pinName = r[31]; 
      name_POs [60] = "r[3]";      // pinName = r[3]; 
      name_POs [61] = "r[4]";      // pinName = r[4]; 
      name_POs [62] = "r[5]";      // pinName = r[5]; 
      name_POs [63] = "r[6]";      // pinName = r[6]; 
      name_POs [64] = "r[7]";      // pinName = r[7]; 
      name_POs [65] = "r[8]";      // pinName = r[8]; 
      name_POs [66] = "r[9]";      // pinName = r[9]; 
      name_POs [67] = "scan_out";      // pinName = scan_out;  tf =  SO  ; 



      if ( $test$plusargs ( "MODUS_DEBUG" ) )  sim_trace = 1'b1; 

      if ( $test$plusargs ( "HEARTBEAT" ) )  sim_heart = 1'b1; 

      if ( $value$plusargs ( "START_RANGE=%s", SOD ) )  sim_range = 1'b0; 
      if ( $value$plusargs ( "START_RANGE=%s", SOD ) ) sim_range_measure = 1'b0;

      if ( $value$plusargs ( "END_RANGE=%s", EOD ) ); 

      if ( $value$plusargs ( "miscompare_limit=%0f", miscompare_limit ) ); 

      if ( $test$plusargs ( "FAILSET" ) )  failset = 1'b1; 

      stim_PIs = {71{1'bX}};   
      stim_CIs = 71'bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0X1XXX; 
      meas_POs = {67{1'bX}};   

    end  
  endtask  

//***************************************************************************//
//                          FAILSET SETUP PROCEDURE                          //
//***************************************************************************//

  task failset_setup; 
    begin 

      $sformat ( FAILSET, "%0s_FAILSET", DATAFILE ); 
      FAILSETID = $fopen ( FAILSET, "w" ); 
      if ( ! FAILSETID ) 
        $display ( "\nERROR (TVE-951): Failed to open the file: %0s. \n", FAILSET ); 

    end  
  endtask 

//***************************************************************************//
//                           SET UP FOR SIMULATION                           //
//***************************************************************************//

  task sim_vector_file; 
    begin 

      CYCLE = 0; 
      SCANCYCLE = 0; 
      SERIALCYCLE = 0; 
      good_compares = 0; 
      miscompares = 0; 
      measure_current = 0; 
      test_num = 0; 
      test_num_prev = 0; 
      failed_test_num = 0; 
      num_tests = 0; 
      num_failed_tests = 0; 
      scan_num = 0; 
      overlap = 0; 
      repeat_depth = 0; 
      repeat_heart = 1000; 


      $display ( "\nINFO (TVE-200): Simulating vector file: %0s ", DATAFILE ); 

      $display ( "\nINFO (TVE-189): Design:  opdiv   Test Mode:  FULLSCAN   InExperiment:  logic " ); 
      start_of_current_line = $ftell ( DATAID ); 
      line_number = 1; 
      rc_read = $fscanf ( DATAID, "%d", CMD ); 
      while ( rc_read > 0 ) begin 

        cmd_code; 

        if ( rc_read > 0 )  begin 
          if ( sim_range )  begin 
            if (( miscompare_limit > 0 ) & ( miscompares > miscompare_limit ))  begin 
              sim_range = 1'b0; 
              if ( overlap )  num_tests = num_tests - 1; 
              $display ( "\nINFO (TVE-207): The miscompare limit (+miscompare_limit) of %0.0f has been reached. ", miscompare_limit ); 
            end  
            if ( EOD == pattern )  begin 
              sim_range = 1'b0; 
            end  
          end  
          start_of_current_line = $ftell ( DATAID ); 
          rc_read = $fscanf ( DATAID, "%d", CMD ); 
          if ( rc_read <= 0 )  begin 
            rc_read = $fgets ( COMMENT, DATAID ); 
            if ( rc_read > 0 )  bad_cmd_code; 
            else  line_number = 0; 
          end  
        end  
      end  

      if ( line_number == 0 )  begin
        $display ( "\nINFO (TVE-201): Simulation complete on vector file: %0s ", DATAFILE ); 
        $display ( "\nINFO (TVE-210): Results for vector file: %0s ", DATAFILE ); 
        $display ( "                      Number of Cycles:               %0d ", CYCLE ); 
        $display ( "                      Number of Tests:                %0d ", num_tests ); 
        $display ( "                        - Passed Tests:               %0d ", num_tests - num_failed_tests ); 
        $display ( "                        - Failed Tests:               %0d ", num_failed_tests ); 
        $display ( "                      Number of Compares:             %0.0f ", good_compares + miscompares ); 
        $display ( "                        - Good Compares:              %0.0f ", good_compares ); 
        $display ( "                        - Miscompares:                %0.0f ", miscompares ); 
        $display ( "                      Time:                       %t \n", $time ); 
      end  

      $fclose ( DATAID ); 

      total_good_compares = total_good_compares + good_compares; 

      total_miscompares = total_miscompares + miscompares; 

      total_num_tests = total_num_tests + num_tests; 

      total_num_failed_tests = total_num_failed_tests + num_failed_tests; 

      total_cycles = total_cycles + CYCLE; 

    end  
  endtask  

//***************************************************************************//
//                           DEFINE TEST PROCEDURE                           //
//***************************************************************************//

  task test_cycle; 
    begin 

      CYCLE = CYCLE + 1; 
      SERIALCYCLE = SERIALCYCLE + 1; 
     #0.000000;        // 0.000000 ns;  From the start of the cycle.
      part_PIs [1] = stim_PIs [1];      // pinName = SE;  tf = +SE  ; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [2] = stim_PIs [2];      // pinName = a[0]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [3] = stim_PIs [3];      // pinName = a[10]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [4] = stim_PIs [4];      // pinName = a[11]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [5] = stim_PIs [5];      // pinName = a[12]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [6] = stim_PIs [6];      // pinName = a[13]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [7] = stim_PIs [7];      // pinName = a[14]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [8] = stim_PIs [8];      // pinName = a[15]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [9] = stim_PIs [9];      // pinName = a[16]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [10] = stim_PIs [10];      // pinName = a[17]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [11] = stim_PIs [11];      // pinName = a[18]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [12] = stim_PIs [12];      // pinName = a[19]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [13] = stim_PIs [13];      // pinName = a[1]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [14] = stim_PIs [14];      // pinName = a[20]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [15] = stim_PIs [15];      // pinName = a[21]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [16] = stim_PIs [16];      // pinName = a[22]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [17] = stim_PIs [17];      // pinName = a[23]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [18] = stim_PIs [18];      // pinName = a[24]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [19] = stim_PIs [19];      // pinName = a[25]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [20] = stim_PIs [20];      // pinName = a[26]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [21] = stim_PIs [21];      // pinName = a[27]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [22] = stim_PIs [22];      // pinName = a[28]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [23] = stim_PIs [23];      // pinName = a[29]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [24] = stim_PIs [24];      // pinName = a[2]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [25] = stim_PIs [25];      // pinName = a[30]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [26] = stim_PIs [26];      // pinName = a[31]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [27] = stim_PIs [27];      // pinName = a[3]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [28] = stim_PIs [28];      // pinName = a[4]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [29] = stim_PIs [29];      // pinName = a[5]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [30] = stim_PIs [30];      // pinName = a[6]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [31] = stim_PIs [31];      // pinName = a[7]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [32] = stim_PIs [32];      // pinName = a[8]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [33] = stim_PIs [33];      // pinName = a[9]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [34] = stim_PIs [34];      // pinName = b[0]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [35] = stim_PIs [35];      // pinName = b[10]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [36] = stim_PIs [36];      // pinName = b[11]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [37] = stim_PIs [37];      // pinName = b[12]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [38] = stim_PIs [38];      // pinName = b[13]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [39] = stim_PIs [39];      // pinName = b[14]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [40] = stim_PIs [40];      // pinName = b[15]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [41] = stim_PIs [41];      // pinName = b[16]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [42] = stim_PIs [42];      // pinName = b[17]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [43] = stim_PIs [43];      // pinName = b[18]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [44] = stim_PIs [44];      // pinName = b[19]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [45] = stim_PIs [45];      // pinName = b[1]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [46] = stim_PIs [46];      // pinName = b[20]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [47] = stim_PIs [47];      // pinName = b[21]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [48] = stim_PIs [48];      // pinName = b[22]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [49] = stim_PIs [49];      // pinName = b[23]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [50] = stim_PIs [50];      // pinName = b[24]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [51] = stim_PIs [51];      // pinName = b[25]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [52] = stim_PIs [52];      // pinName = b[26]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [53] = stim_PIs [53];      // pinName = b[27]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [54] = stim_PIs [54];      // pinName = b[28]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [55] = stim_PIs [55];      // pinName = b[29]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [56] = stim_PIs [56];      // pinName = b[2]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [57] = stim_PIs [57];      // pinName = b[30]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [58] = stim_PIs [58];      // pinName = b[31]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [59] = stim_PIs [59];      // pinName = b[3]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [60] = stim_PIs [60];      // pinName = b[4]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [61] = stim_PIs [61];      // pinName = b[5]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [62] = stim_PIs [62];      // pinName = b[6]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [63] = stim_PIs [63];      // pinName = b[7]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [64] = stim_PIs [64];      // pinName = b[8]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [65] = stim_PIs [65];      // pinName = b[9]; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [67] = stim_PIs [67];      // pinName = in_valid_i; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [69] = stim_PIs [69];      // pinName = out_ready_i; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [70] = stim_PIs [70];      // pinName = scan_in;  tf =  SI  ; testOffset = 0.000000;  scanOffset = 0.000000;  
      part_PIs [71] = stim_PIs [71];      // pinName = signal_division; testOffset = 0.000000;  scanOffset = 0.000000;  
     #8.000000;        // 8.000000 ns;  From the start of the cycle.
      part_PIs [66] = stim_PIs [66];      // pinName = clock;  tf = -ES  ; testOffset = 8.000000;  scanOffset = 0.000000;  
      part_PIs [68] = stim_PIs [68];      // pinName = nreset;  tf = +SC  ; testOffset = 8.000000;  scanOffset = 0.000000;  
     #8.000000;        // 16.000000 ns;  From the start of the cycle.
      part_PIs [66] = stim_CIs [66];      // pinName = clock;  tf = -ES  ; testOffset = 8.000000;  scanOffset = 0.000000;  
      part_PIs [68] = stim_CIs [68];      // pinName = nreset;  tf = +SC  ; testOffset = 8.000000;  scanOffset = 0.000000;  
     #56.000000;        // 72.000000 ns;  From the start of the cycle.

      for ( POnum = 1; POnum <= 67; POnum = POnum + 1 ) begin 
        if (( part_POs [ POnum ] !== meas_POs [ POnum ] ) & ( meas_POs [ POnum ] !== 1'bX )) begin 
          if ( test_num != failed_test_num )  begin 
            num_failed_tests = num_failed_tests + 1; 
            failed_test_num = test_num; 
          end  
          miscompares = miscompares + 1; 
          $display ( "\nWARNING (TVE-650): PO miscompare at Test: %0d  Odometer: %0s  Relative Cycle: %0d  Time: %0t ", test_num, PATTERN, CYCLE, $time ); 
          $display ( "           Expected: %0b   Simulated: %0b   On PO: %0s   ", meas_POs [ POnum ], part_POs [ POnum ], name_POs [ POnum ] ); 

          if (( failset ) & ( FAILSETID == 0 ))  failset_setup; 
          if ( FAILSETID ) begin 
            $fdisplay ( FAILSETID, " Chip %0s pad %0s pattern %0s position %0d value %0b ", "opdiv", name_POs [ POnum ], PATTERN, -1, part_POs [ POnum ] ); 
          end  
        end  
        else if ( meas_POs [ POnum ] !== 1'bX )  good_compares = good_compares + 1; 
      end  
     #8.000000;        // 80.000000 ns;  From the start of the cycle.
      meas_POs = {67{1'bX}}; 

    end  
  endtask  

//***************************************************************************//
//                 READ COMMANDS AND DATA AND RUN SIMULATION                 //
//***************************************************************************//

  task cmd_code; 
    begin 

      if ( sim_trace )  $display ( "\nCommand code:  %0d ", CMD ); 

      case ( CMD ) 

        000: begin 
          rc_read = 0;  // This will stop execution 
          line_number = line_number + 1; 
        end  

        100: begin 
          rc_read = $fgets ( COMMENT, DATAID ); 
          if ( rc_read > 0 )  begin 
          end  
          else  begin 
            $display ( "\nERROR (TVE-998): Unrecognizable data at line %0.0f in file: %0s \n", line_number, DATAFILE ); 
            $display ( "  Command code = %0d, Unrecognized data = %0s \n", CMD, COMMENT ); 
          end  
          line_number = line_number + 1; 
        end  

        104: begin 
          rc_read = $fgets ( PROCESSNAME, DATAID ); 
          if ( rc_read > 0 )  begin 
            if ( $value$plusargs ( "START_RANGE=%s", SOD ) ) begin
              if( sim_range == 1'b0 && PROCESSNAME == 4096'b100000010011010100111101000100010001010100100101001110010010010101010000001010) begin // PROCESSNAME == MODEINIT in ASCII
                sim_range = 1'b1 ;
              end
              if( sim_range==1'b1 && PROCESSNAME == 4096'b1000000010000000001010) begin // PROCESSNAME == '' in ASCII 
                sim_range = 1'b0 ;
              end
            end
          end  
          else  begin 
            $display ( "\nERROR (TVE-998): Unrecognizable data at line %0.0f in file: %0s \n", line_number, DATAFILE ); 
            $display ( "  Command code = %0d, Unrecognized data = %0s \n", CMD, PROCESSNAME ); 
          end  
          line_number = line_number + 1; 
        end  

        110: begin 
          rc_read = $fgets ( COMMENT, DATAID ); 
          if ( rc_read > 0 )  begin 
            $display ( "\n %0s ", COMMENT ); 
          end  
          else  begin 
            $display ( "\nERROR (TVE-998): Unrecognizable data at line %0.0f in file: %0s \n", line_number, DATAFILE ); 
            $display ( "  Command code = %0d, Unrecognized data = %0s \n", CMD, COMMENT ); 
          end  
          line_number = line_number + 1; 
        end  

        151: begin 
          test_num_prev = test_num; 
          rc_read = $fscanf ( DATAID, "%d", test_num ); 
          if ( rc_read > 0 )  begin 
            if (( test_num != test_num_prev ) && ( test_num != 0 ) && ( sim_range ))  num_tests = num_tests + 1; 
          end  
          else  bad_cmd_code; 

          rc_read = $fscanf ( DATAID, "%d", scan_num ); 
          if ( rc_read > 0 )  begin 
          end  
          else  bad_cmd_code; 

          rc_read = $fscanf ( DATAID, "%d", overlap ); 
          if ( rc_read > 0 )  begin 
          end  
          else  bad_cmd_code; 

          line_number = line_number + 1; 
        end  

        200: begin 
          if ( rc_read > 0 )  begin 
            rc_read = $fscanf ( DATAID, "%b", stim_PIs [1:71] ); 
            if ( rc_read <= 0 )  bad_cmd_code; 
            line_number = line_number + 1; 
          end  
        end  

        201: begin 
          if ( rc_read > 0 )  begin 
            rc_read = $fscanf ( DATAID, "%b", stim_CIs [1:71] ); 
            if ( rc_read <= 0 )  bad_cmd_code; 
            line_number = line_number + 1; 
          end  
        end  

        202: begin 
          if ( rc_read > 0 )  begin 
            rc_read = $fscanf ( DATAID, "%b", meas_POs [1:67] ); 
            if (sim_range_measure == 1'b0 ) meas_POs = 'bx;
            if ( rc_read <= 0 )  bad_cmd_code; 
            line_number = line_number + 1; 
          end  
        end  

        203: begin 
          rc_read = $fscanf ( DATAID, "%b", global_term ); 
          if ( rc_read > 0 )  begin 
          end  
          else  bad_cmd_code; 
          line_number = line_number + 1; 
        end  

        400: begin 
          if ( sim_range )  test_cycle; 
          line_number = line_number + 1; 
        end  

        500: begin 
          repeat_depth = repeat_depth + 1; 
          rc_read = $fscanf ( DATAID, "%d", num_repeats [repeat_depth] ); 
          if ( rc_read > 0 )  begin 
            start_of_repeat[repeat_depth] = $ftell ( DATAID ); 
          end  
          else  bad_cmd_code; 
          if ((sim_range & sim_heart) && repeat_heart) 
            $display ( "\nINFO (TVE-202): Simulating Test: %0d  Odometer: %0s  Relative Cycle: %0d  Time: %0t  Tests Passed %0d of %0d, Failed %0d.  Start of %0d cycles of a repeat loop.", test_num, pattern, CYCLE + 1, $time, num_tests - num_failed_tests, num_tests, num_failed_tests, num_repeats [repeat_depth] ); 
          line_number = line_number + 1; 
        end  

        501: begin 
          num_repeats [repeat_depth] = num_repeats [repeat_depth] - 1; 
          if ( num_repeats [repeat_depth] )  begin 
            if ((sim_range & sim_heart) && repeat_heart && (num_repeats [repeat_depth] % repeat_heart == 0 )) 
              $display ( "\nINFO (TVE-202): Simulating Test: %0d  Odometer: %0s  Relative Cycle: %0d  Time: %0t  Tests Passed %0d of %0d, Failed %0d.  Number of cycles remaining in this repeat loop is %0d.", test_num, pattern, CYCLE + 1, $time, num_tests - num_failed_tests, num_tests, num_failed_tests, num_repeats [repeat_depth] ); 
            rc_read = $fseek ( DATAID, start_of_repeat [repeat_depth], 0 ); 
            rc_read = 1; 
            fseek_offset = $ftell ( DATAID ); 
            if ( fseek_offset != start_of_repeat [repeat_depth] )  begin 
              $display ( "\nERROR (TVE-956): A Verilog simulator limitation in the fseek routine has been reached.  The size of the Verilog Data file is so big that it can not support branching using fseek in the Verilog simulator.  Any branching after 9,223,372,036,854,775,807 (0x7fffffffffffffff) bytes of data will not run correctly under the Verilog simulator.  It is recommended that you break up the Verilog Data file using the keyword maxvectorsperfile.  The Verilog Data file:  %0s  \n", DATAFILE ); 
              rc_read = 0;  // This will stop execution 
            end  
          end  
          else  repeat_depth = repeat_depth - 1; 
          line_number = line_number + 1; 
        end  

        900: begin 
          rc_read = $fscanf ( DATAID, "%s", pattern ); 
          if ( rc_read > 0 )  begin 
            if ( SOD == pattern )  begin 
              sim_range = 1'b1; 
            end  
            if (( sim_range ) & ( scan_num > 0 ))  begin 
              if ( overlap )  $display ( "\nINFO (TVE-211): Simulating Test: %0d  Odometer: %0s  Relative Cycle: %0d  Time: %0t  Relative Scan: %0d  Overlap Tests %0d and %0d.  Tests Passed %0d of %0d, Failed %0d. ", test_num - 1, pattern, CYCLE + 1, $time, scan_num, test_num - 1, test_num, num_tests - num_failed_tests - 1, num_tests - 1, num_failed_tests ); 
              else  $display ( "\nINFO (TVE-211): Simulating Test: %0d  Odometer: %0s  Relative Cycle: %0d  Time: %0t  Relative Scan: %0d  Tests Passed %0d of %0d, Failed %0d. ", test_num, pattern, CYCLE + 1, $time, scan_num, num_tests - num_failed_tests, num_tests, num_failed_tests ); 
              scan_num = 0; 
            end  
            else if ( sim_range & sim_heart )  begin 
              $display ( "\nINFO (TVE-202): Simulating Test: %0d  Odometer: %0s  Relative Cycle: %0d  Time: %0t  Tests Passed %0d of %0d, Failed %0d. ", test_num, pattern, CYCLE + 1, $time, num_tests - num_failed_tests, num_tests, num_failed_tests ); 
            end  
          end  
          else  bad_cmd_code; 
          line_number = line_number + 1; 
        end  

        901: begin 
          rc_read = $fscanf ( DATAID, "%s", PATTERN ); 
          if ( rc_read > 0 )  begin 
          end  
          else  bad_cmd_code; 
          line_number = line_number + 1; 
        end  

        903: begin 
          measure_current = measure_current + 1; 
          line_number = line_number + 1; 
        end  

        904: begin 
          rc_read = $fscanf ( DATAID, "%s", eventID ); 
          if ( rc_read > 0 )  begin 
            `ifdef MISCOMPAREDEBUG 
              if ( diag_debug ) begin 
                $processSimulationDebugFile ( DIAG_DEBUG_FILE, "opdiv_inst", eventID ); 
              end 
            `endif 
          end  
          else  bad_cmd_code; 
          line_number = line_number + 1; 
        end  

        905: begin 
          rc_read = $fscanf ( DATAID, "%s", eventID ); 
          if ( rc_read > 0 )  begin 
            `ifdef MISCOMPAREDEBUG 
              if ( diag_debug ) begin 
                $processSimulationDebugFile ( DIAG_DEBUG_FILE, "opdiv_inst", eventID ); 
              end 
            `endif 
          end  
          else  bad_cmd_code; 
          line_number = line_number + 1; 
        end  


        default: begin 
          bad_cmd_code; 
          rc_read = 0;  // This will stop execution 
          line_number = line_number + 1; 
        end  

      endcase  

    end  
  endtask  

//***************************************************************************//
//                          PRINT BAD CMD CODE DATA                          //
//***************************************************************************//

  task bad_cmd_code; 
    begin 

      $display ( "\nERROR (TVE-998): Unrecognizable data at line %0.0f in file: %0s \n", line_number, DATAFILE ); 
      start_of_current_line = $ftell ( DATAID ); 
      rc_read = $fgets ( COMMENT, DATAID ); 
      $display ( "  Command code = %0d, Unrecognized data = %0s \n", CMD, COMMENT ); 
      rc_read = 0;  // This will stop execution 

    end  
  endtask  

  endmodule 
