integer test_no;

initial begin

// add : 00
// addi: 10
// rsub: 01
// rsubi: 11
// bs  : 21 // 11'h400: rD <= rA << rB; 200: rA >> rB arit; rA >> rB
// bsi : 31 // bs with IMM, IMM is 5 bits long
// xor : 42
// xori: 52
// and : 41
// andi: 51
// or  : 40
// ori : 50
// beq : 47 (delay: rD == 5'h10) // branch if rA equal 0, to PC + rB
// beqi: 57 (delay: rD == 5'h10) // branch if rA equal 0, to PC + IMM
// br  : 46 // branch to PC + rB, store cur PC to rD
// bri : 56 // branch to PC + IMM, store cur PC to rD
// lw  : 62 // load word from rA + rB to rD
// lwi : 72 // load word from rA + IMM to rD
// sw  : 66 // store word from rD into rA + rB
// swi : 76 // store word from rD into rA + IMM

// init R0
core.i_cache.cachedat.ram.r_data[0] <= {6'o05,5'h0,5'h0,5'h0,11'd0};
core.i_cache.cachedat.ram.r_data[1] <= {6'o05,5'h0,5'h0,5'h0,11'd0};
core.i_cache.cachedat.ram.r_data[2] <= {6'o05,5'h0,5'h0,5'h0,11'd0};


core.i_cache.cachedat.ram.r_data[3] <= {6'o54,5'h0,5'h0,16'h9707};
core.i_cache.cachedat.ram.r_data[4] <= {6'o10,5'h1,5'h0,16'h0008};
core.i_cache.cachedat.ram.r_data[5] <= {6'o10,5'h2,5'h0,16'hf7ef};

//core.i_cache.cachedat.ram.r_data[6] <= {6'o76,5'h2,5'h0,16'h0404};
  core.i_cache.cachedat.ram.r_data[6] <= {6'o11,5'hf,5'hf,16'h0010};

// standing jump
core.i_cache.cachedat.ram.r_data[7] <= {6'o56,5'h1e,5'h0,16'h0};

  core.i_cache.cachedat.ram.r_data[8] <= {6'o11,5'hf,5'hf,16'h0017};
  core.i_cache.cachedat.ram.r_data[9] <= {6'o11,5'hf,5'hf,16'h0010};
  core.i_cache.cachedat.ram.r_data[10] <= {6'o11,5'hf,5'hf,16'h0fe0};
  core.i_cache.cachedat.ram.r_data[11] <= {6'o11,5'hf,5'hf,16'h0010};
  core.i_cache.cachedat.ram.r_data[12] <= {6'o11,5'hf,5'hf,16'h0017};

core.i_cache.cachedat.ram.r_data[13] <= {6'o05,5'h1f,5'h1f,5'h1f,11'd9};
core.i_cache.cachedat.ram.r_data[14] <= {6'o05,5'h1f,5'h1f,5'h1f,11'd10};
core.i_cache.cachedat.ram.r_data[15] <= {6'o05,5'h1f,5'h1f,5'h1f,11'd11};

core.i_cache.cachedat.ram.r_data[96] <= {6'o05,5'h1f,5'h1f,5'h1f,11'd9};
core.i_cache.cachedat.ram.r_data[97] <= {6'o05,5'h1f,5'h1f,5'h1f,11'd10};
core.i_cache.cachedat.ram.r_data[98] <= {6'o05,5'h1f,5'h1f,5'h1f,11'd11};
core.i_cache.cachedat.ram.r_data[99] <= {6'o05,5'h1f,5'h1f,5'h1f,11'd11};
core.i_cache.cachedat.ram.r_data[100] <= {6'o05,5'h1f,5'h1f,5'h1f,11'd11};

`define hyper_imem core.hyper_softcore.prog_mem.ram.r_data
`define hyper_dmem core.hyper_softcore.data_mem.ram.r_data

`define S_space_left_in_page_not_enough            8'd0
`define S_len_for_transfer_shorter_than_block_size 8'd1
`define S_care_of_irq             8'd2
`define S_grab_meta_gb_0          8'd3
`define S_check_irq_in_gb_0       8'd9
`define S_continue_grab_meta_gb_0 8'd15
`define S_signal_irq_gb_0         8'd25
`define S_exec_gb_1               8'd28
`define S_continue_gb_1__0        8'd34
`define S_continue_gb_1__1        8'd47
`define S_exec_transfer_gb_1      8'd53
`define S_check_if_exec_mb        8'd55
`define S_check_irq_in_mb         8'd64
`define S_continue_grab_meta_mb   8'd70
`define S_signal_irq_mb           8'd80
`define S_exec_mb_other           8'd83
`define S_continue_mb__0          8'd91
`define S_continue_mb__1          8'd104
`define S_exec_transfer_mb        8'd110
`define S_grab_meta_gb_1          8'd112
`define S_check_irq_in_gb_1       8'd118
`define S_continue_grab_meta_gb_1 8'd124
`define S_signal_irq_gb_1         8'd134
`define S_exec_gb_0               8'd137
`define S_continue_gb_0__0        8'd143
`define S_continue_gb_0__1        8'd156
`define S_exec_transfer_gb_0      8'd162
`define S_prepare_mb_flipflop     8'd164
`define S_prepare_gb_0            8'd167
`define S_jump_over_prepare_gb_0  8'd174
`define S_write_careof_int_gb_0   8'd189
`define S_prepare_gb_1            8'd190
`define S_jump_over_prepare_gb_1  8'd197
`define S_write_careof_int_gb_1   8'd212
`define S_balancing_wait          8'd213
`define S_prepare_mb_trans        8'd215
`define S_jump_over_prepare_mb    8'd229
`define S_write_careof_int_mb     8'd244
`define S_mb_step_indices         8'd245
`define S_waitout_untill_gb       8'd250

`define const_5             8'h5f
`define const_0xc000        8'h5e
`define const_20            8'h5d
`define const_15            8'h5c
`define const_0x8000        8'h5b
`define const_0x0003        8'h5a
`define const_0x7ffc        8'h59
`define const_0x4000        8'h5a
`define const_6             8'h59
`define const_12            8'h58

`define space_left_in_page           8'h70
`define len_for_transfer__less_block_size 8'h71
`define page_addr_submask            8'h72
`define page_size                    8'h73
`define block_size                   8'h74
`define next_index                   8'h75
`define section_mask                 8'h76
`define certain_01                   8'h77
`define location_of_careofint_bit    8'h78
`define care_of_irq                  8'h79
`define cur_mb_trans_ptr             8'h7a
`define cur_mb_trans_ptr_mask        8'h7b

`define gb_0_active                  8'h80
`define gb_0_begin_addr_high         8'h81
`define gb_0_begin_addr_low          8'h82
`define gb_0_len_left                8'h83
`define gb_0_careof_int_abt          8'h84
`define gb_0_irq_desc_and_certain_01 8'h85
`define other_bits_gb_0              8'h86
`define signal_bits_gb_0             8'h87
`define len_left_gb_0                8'h88
`define section_and_certain_01_gb_0  8'h89
`define careof_interrupt_abort_gb_0  8'h8a

`define gb_1_active                  8'h90
`define gb_1_begin_addr_high         8'h91
`define gb_1_begin_addr_low          8'h92
`define gb_1_len_left                8'h93
`define gb_1_careof_int_abt          8'h94
`define gb_1_irq_desc_and_certain_01 8'h95
`define other_bits_gb_1              8'h96
`define signal_bits_gb_1             8'h97
`define len_left_gb_1                8'h98
`define section_and_certain_01_gb_1  8'h99
`define careof_interrupt_abort_gb_1  8'h9a

`define mb_flipflop_ctrl             8'ha0

`define D_mb_active_T_mb_begin_addr_low                  8'hxx
`define D_mb_careof_int_abt_T_mb_irq_desc_and_certain_01 8'hxx
`define D_mb_irq_desc_and_certain_01_T_mb_careof_int_abt 8'hxx
`define D_mb_begin_addr_low_T_mb_begin_addr_high         8'hxx
`define D_mb_begin_addr_high_T_mb_len_left               8'hxx
`define D_mb_len_left_T_mb_irq_desc_and_certain_01       8'hxx
`define D_mb_careof_int_abt_T_mb_active                  8'hxx
`define D_mb_active_T_mb_begin_addr_high                 8'hxx
`define D_mb_begin_addr_high_T_mb_begin_addr_low         8'hxx
`define D_mb_begin_addr_low_T_mb_len_left                8'hxx
`define D_mb_len_left_T_mb_other_bits                    8'hxx
`define D_mb_other_bits_T_mb_active                      8'hxx
`define D_mb_active_T_signal_bits                        8'hxx
`define D_signal_bits_T_mb_active                        8'hxx
`define D_mb_active_T_len_left                           8'hxx
`define D_len_left_T_signal_bits                         8'hxx
`define D_signal_bits_T_mb_irq_desc_and_certain_01       8'hxx
`define D_mb_irq_desc_and_certain_01_T_signal_bits       8'hxx
`define D_signal_bits_T_mb_careof_int_abt                8'hxx

///Cspace_left_in_page_not_enough:
///C  add 0+$space_left_in_page;
// S_space_left_in_page_not_enough
`hyper_imem[0] <= {8'h00,`space_left_in_page};
///Clen_for_transfer_shorter_than_block_size:
///C  add 0+$len_for_transfer__less_block_size;
// S_len_for_transfer_shorter_than_block_size
`hyper_imem[1] <= {8'h00,`len_for_transfer__less_block_size};
///Ccare_of_irq:
///C  add $0xc000;  # mask for both IRQ and ABORT
// S_care_if_irq
`hyper_imem[2] <= {8'h00,`const_0xc000};

///Cgrab_meta_gb_0:
///C  lod $gb_0_active; # 1
// S_grab_meta_gb_0
`hyper_imem[3] <= {8'h0a,`gb_0_active};
///C  cmp/nop :continue_grab_meta_gb_0;
`hyper_imem[4] <= {8'hce,`S_continue_grab_meta_gb_0};

///C  i_1_gb;
`hyper_imem[5] <= 16'h4500;
///C  add 0+$gb_0_begin_addr_low;
`hyper_imem[6] <= {8'h00,`gb_0_begin_addr_low};

///C  lod $distance_gb_0__exec_gb_1;  # 5
`hyper_imem[7] <= {8'h0a,`const_15};
///C  wait :exec_gb_1; # 6 # wait 15 cycles
`hyper_imem[8] <= {8'h48,`S_exec_gb_1};

///Ccheck_irq_in_gb_0:
///C  and $gb_0_careof_int_abt; # 15
// S_check_irq_in_gb_0
`hyper_imem[9] <= {8'h0d,`gb_0_careof_int_abt};
///C  cmp/nop :signal_irq_gb_0;  # OH THE PAIN!!!
`hyper_imem[10] <= {8'hce,`S_signal_irq_gb_0};
///C  or  $gb_0_irq_desc_and_certain_01;
`hyper_imem[11] <= {8'h0e,`gb_0_irq_desc_and_certain_01};
///C  cmp/nop :exec_gb_1;
`hyper_imem[12] <= {8'hce,`S_exec_gb_1};
///C  null;
`hyper_imem[13] <= 16'h4d00;
///C  nop; # 20
`hyper_imem[14] <= 16'h4e00;

///Ccontinue_grab_meta_gb_0:
///C  stc $gb_0_begin_addr_low; # 5 # swap w/ 0x0000
// S_continue_grab_mega_gb_0
`hyper_imem[15] <= {8'h47,`gb_0_begin_addr_low};
///C  add s+$gb_0_begin_addr_high;
`hyper_imem[16] <= {8'h02,`gb_0_begin_addr_high};
///C  sto $gb_0_begin_addr_high;
`hyper_imem[17] <= {8'h46,`gb_0_begin_addr_high};
///C  i_1_gb;
`hyper_imem[18] <= 16'h4500;
///C  xor 0xffff;
`hyper_imem[19] <= 16'h6f00;
///C  add 1+$gb_0_len_left; # 10
`hyper_imem[20] <= {8'h01,`gb_0_len_left};
///C  sto $gb_0_len_left;
`hyper_imem[21] <= {8'h46,`gb_0_len_left};

///C  cmp/i_2_gb :check_irq_in_gb_0;
`hyper_imem[22] <= {8'he5,`S_check_irq_in_gb_0};
///C  or  $gb_0_irq_desc_and_certain_01;
`hyper_imem[23] <= {8'h0e,`gb_0_irq_desc_and_certain_01};
///C  nop; # 14
`hyper_imem[24] <= 16'h4e00;

///Csignal_irq_gb_0:
///C  irq; # nulls
// S_signal_irq_gb_0
`hyper_imem[25] <= 16'h4900;
///C  sto $gb_0_active;
`hyper_imem[26] <= {8'h46,`gb_0_active};

///C  wait (:+1 instruction); # 17 # wait 4 cycles
`hyper_imem[27] <= {8'h48,`S_exec_gb_1};

///Cexec_gb_1:
///C  add 0+$gb_1_active; # 21
// S_exec_gb_1
`hyper_imem[28] <= {8'h00,`gb_1_active};

///C  cmp/null :continue_gb_1__0;
`hyper_imem[29] <= {8'hcd,`S_continue_gb_1__0};
///C  add 0+$gb_1_begin_addr_high;
`hyper_imem[30] <= {8'h00,`gb_1_begin_addr_high};
///C  o_1_gb;
`hyper_imem[31] <= 16'h4b05;

///C  lod $distance_gb_01__mb; # 25
`hyper_imem[32] <= {8'h0a,`const_20};
///C  wait :check_if_exec_mb; # 26 # wait 20 cycles
`hyper_imem[33] <= {8'h48,`S_check_if_exec_mb};
///Ccontinue_gb_1__0:
///C  lod $gb_1_begin_addr_low; # 25
// S_continue_gb_1__0
`hyper_imem[34] <= {8'h0a,`gb_1_begin_addr_low};
///C  o_2_gb;
`hyper_imem[35] <= 16'h4b06;
///C  and $page_addr_submask;
`hyper_imem[36] <= {8'h0d,`page_addr_submask};
///C  xor 0xffff;
`hyper_imem[37] <= 16'h6f00;
///C  add 1+$page_size;
`hyper_imem[38] <= {8'h01,`page_size};
///C  sto $space_left_in_page; # 30
`hyper_imem[39] <= {8'h46,`space_left_in_page};

///C  sub $gb_1_len_left;
`hyper_imem[40] <= {8'h21,`gb_1_len_left};
///C  or  0xffff;
`hyper_imem[41] <= 16'h6e00;
///C  add s+0; # meant to detect a negative number, meaning more len than space
`hyper_imem[42] <= 16'h4200;

///C  cmp/ones :space_left_in_page_not_enough;
`hyper_imem[43] <= {8'hee,`S_space_left_in_page_not_enough};
///C  cmp/null :continue_gb_1__1; # 35
`hyper_imem[44] <= {8'hcd,`S_continue_gb_1__1};
///C  sub $block_size;
`hyper_imem[45] <= {8'h21,`block_size};
///C  add 0+$gb_1_len_left;
`hyper_imem[46] <= {8'h00,`gb_1_len_left};
///Ccontinue_gb_1__1:
///C  stf $len_for_transfer__less_block_size; # swap w/ 0xffff
// S_continue_gb_1__1
`hyper_imem[47] <= {8'h67,`len_for_transfer__less_block_size};
///C  add s+0;
`hyper_imem[48] <= 16'h4200;

///C  cmp/ones :len_for_transfer_shorter_than_block_size; # 40
`hyper_imem[49] <= {8'hee,`S_len_for_transfer_shorter_than_block_size};
///C  cmp/null :exec_transfer_gb_1;
`hyper_imem[50] <= {8'hcd,`S_exec_transfer_gb_1};
///C  add 0+$block_size;
`hyper_imem[51] <= {8'h00,`block_size};
///C  nop;
`hyper_imem[52] <= 16'h4e00;

///Cexec_transfer_gb_1:
///C  or $other_bits_gb_1;
// S_exec_transfer_gb_1
`hyper_imem[53] <= {8'h0e,`other_bits_gb_1};
///C  o_3_gb; # 45 # nulls
`hyper_imem[54] <= 16'h0b04;


///Ccheck_if_exec_mb:
///C  add 0+$mb_flipflop_ctrl; # 46
// S_check_if_exec_mb
`hyper_imem[55] <= {8'h00,`mb_flipflop_ctrl};
///C  cmp/null :prepare_mb_trans; # test if we execute or prepare mb trans
`hyper_imem[56] <= {8'hcd,`S_prepare_mb_trans};
///C  nop;  # <-- this one slows by one cycle compared w/ before proving
`hyper_imem[57] <= 16'h4e00;

///C  add 0+(INDEX+D($mb_active -> $mb_begin_addr_low)); # 49
`hyper_imem[58] <= {8'h10,`D_mb_active_T_mb_begin_addr_low};
///C  cmp/nop :continue_grab_meta_mb; # 50
`hyper_imem[59] <= {8'hce,`S_continue_grab_meta_mb};
///C  i_1_mb;
`hyper_imem[60] <= 16'h4400;
///C  add 0+INDEX;
`hyper_imem[61] <= 16'h1000;
///C  lod $distance_gb_01__mb; # 53
`hyper_imem[62] <= {8'h0a,`const_15};
///C  wait :exec_mb_other; # 54 # wait 15 cycles
`hyper_imem[63] <= {8'h48,`S_exec_mb_other};
///Ccheck_irq_in_mb:
///C  and (INDEX+D($mb_careof_int_abt -> $mb_irq_desc_and_certain_01)); # 63
// S_check_irq_in_mb
`hyper_imem[64] <= {8'h1d,`D_mb_careof_int_abt_T_mb_irq_desc_and_certain_01};
///C  cmp/nop :signal_irq_mb; # much, much less pain now, all of a sudden :)
`hyper_imem[65] <= {8'hce,`S_signal_irq_mb};
///C  or  (INDEX+D($mb_irq_desc_and_certain_01 -> $mb_careof_int_abt)); # 65
`hyper_imem[66] <= {8'h1e,`D_mb_irq_desc_and_certain_01_T_mb_careof_int_abt};
///C  cmp/nop :exec_mb_other;
`hyper_imem[67] <= {8'hce,`S_exec_mb_other};
///C  null;
`hyper_imem[68] <= 16'h4d00;
///C  nop;
`hyper_imem[69] <= 16'h4e00;
///Ccontinue_grab_meta_mb:
///C  stc (INDEX+D($mb_begin_addr_low -> $mb_begin_addr_high)); # 53
// S_continue_grab_meta_mb
`hyper_imem[70] <= {8'h57,`D_mb_begin_addr_low_T_mb_begin_addr_high};
///C  add s+INDEX;
`hyper_imem[71] <= 16'h1200;
///C  sto (INDEX+D($mb_begin_addr_high -> $mb_len_left)); # 55
`hyper_imem[72] <= {8'h56,`D_mb_begin_addr_high_T_mb_len_left};
///C  i_1_mb;
`hyper_imem[73] <= 16'h4400;
///C  xor 0xffff;
`hyper_imem[74] <= 16'h6f00;
///C  add 1+INDEX;
`hyper_imem[75] <= 16'h1100;
///C  sto (INDEX+D($mb_len_left -> $mb_irq_desc_and_certain_01));
`hyper_imem[76] <= {8'h56,`D_mb_len_left_T_mb_irq_desc_and_certain_01};
///C  cmp/i_2_mb :check_irq_in_mb; # 60
`hyper_imem[77] <= {8'he4,`S_check_irq_in_mb};
///C  or  (INDEX+D($mb_irq_desc_and_certain_01 -> $mb_careof_int_abt));
`hyper_imem[78] <= {8'h1e,`D_mb_irq_desc_and_certain_01_T_mb_careof_int_abt};
///C  nop;
`hyper_imem[79] <= 16'h4e00;
///Csignal_irq_mb:
///C  irq (INDEX+D($mb_careof_int_abt -> $mb_active));
// S_signal_irq_mb
`hyper_imem[80] <= {8'h59,`D_mb_careof_int_abt_T_mb_active};
///C  sto INDEX;
`hyper_imem[81] <= 16'h5600;
///C  wait (:+1 instruction); # 65 # wait 4 cycles
`hyper_imem[82] <= {8'h48,`S_exec_mb_other};

///Cexec_mb_other:
///C  add 0+$next_index; # 69
// S_exec_mb_other
`hyper_imem[83] <= {8'h00,`next_index};
///C  inl; # 70
`hyper_imem[84] <= 16'h4c00;
///C  add 0+(INDEX+D($mb_active -> $mb_begin_addr_high)); # 71
`hyper_imem[85] <= {8'h10,`D_mb_active_T_mb_begin_addr_high};
///C  cmp/null :continue_mb__0;
`hyper_imem[86] <= {8'hcd,`S_continue_mb__0};
///C  add 0+(INDEX+D($mb_begin_addr_high -> $mb_begin_addr_low));
`hyper_imem[87] <= {8'h10,`D_mb_begin_addr_high_T_mb_begin_addr_low};
///C  o_1_mb; # 74
`hyper_imem[88] <= 16'h4b01;
///C  lod $distance_gb_01__mb; # 75
`hyper_imem[89] <= {8'h0a,`const_20};
///C  wait :grab_meta_gb_1; # 76 # wait 20 cycles
`hyper_imem[90] <= {8'h48,`S_grab_meta_gb_1};
///Ccontinue_mb__0:
///C  lod (INDEX+D($mb_begin_addr_low -> $mb_len_left)); # 75
// S_continue_mb__0
`hyper_imem[91] <= {8'h1a,`D_mb_begin_addr_low_T_mb_len_left};
///C  o_2_mb;
`hyper_imem[92] <= 16'h4b02;
///C  and $page_addr_submask;
`hyper_imem[93] <= {8'h0d,`page_addr_submask};
///C  xor 0xffff;
`hyper_imem[94] <= 16'h6f00;
///C  add 1+$page_size;
`hyper_imem[95] <= {8'h01,`page_size};
///C  sto $space_left_in_page; # 80
`hyper_imem[96] <= {8'h46,`space_left_in_page};
///C  sub INDEX;
`hyper_imem[97] <= 16'h3100;
///C  or  0xffff;
`hyper_imem[98] <= 16'h6e00;
///C  add s+0; # meant to detect a negative number, meaning more len than space
`hyper_imem[99] <= 16'h4200;
///C  cmp/ones :space_left_in_page_not_enough;
`hyper_imem[100] <= {8'hee,`S_space_left_in_page_not_enough};
///C  cmp/null :continue_mb__1; # 85
`hyper_imem[101] <= {8'hcd,`S_continue_mb__1};
///C  sub $block_size;
`hyper_imem[102] <= {8'h21,`block_size};
///C  add 0+INDEX;
`hyper_imem[103] <= 16'h1000;
///Ccontinue_mb__1:
///C  stf $len_for_transfer__less_block_size;
// S_continue_mb__1
`hyper_imem[104] <= {8'h67,`len_for_transfer__less_block_size};
///C  add s+0 INDEX+D($mb_len_left -> $mb_other_bits);
`hyper_imem[105] <= {8'h52,`D_mb_len_left_T_mb_other_bits};
///C  cmp/ones :len_for_transfer_shorter_than_block_size; # 90
`hyper_imem[106] <= {8'hee,`S_len_for_transfer_shorter_than_block_size};
///C  cmp/null :exec_transfer_mb;
`hyper_imem[107] <= {8'hcd,`S_exec_transfer_mb};
///C  add 0+$block_size;
`hyper_imem[108] <= {8'h00,`block_size};
///C  nop (INDEX+D($mb_len_left -> $mb_other_bits));
`hyper_imem[109] <= 16'h4e00;
///Cexec_transfer_mb:
///C  or  (INDEX+D($mb_other_bits -> $mb_active)); # which mb_active? # your own
// S_exec_transfer_mb
`hyper_imem[110] <= {8'h1e,`D_mb_other_bits_T_mb_active};
///C  o_3_mb; # 95 # nulls
`hyper_imem[111] <= 16'h0b00;

///Cgrab_meta_gb_1:
///C  lod $gb_1_active; # 96
// S_grab_meta_gb_1
`hyper_imem[112] <= {8'h0a,`gb_1_active};
///C  cmp/nop :continue_grab_meta_gb_1;
`hyper_imem[113] <= {8'hee,`S_continue_grab_meta_gb_1};
///C  i_1_gb;
`hyper_imem[114] <= 16'h4500;
///C  add 0+$gb_1_begin_addr_low;
`hyper_imem[115] <= {8'h00,`gb_1_begin_addr_low};
///C  lod $distance_gb_01__mb; # 100
`hyper_imem[116] <= {8'h0a,`const_15};
///C  wait :exec_gb_0; # 101 # wait 15 cycles
`hyper_imem[117] <= {8'h48,`S_exec_gb_0};
///Ccheck_irq_in_gb_1:
///C  and $gb_1_careof_int_abt; # 110
// S_check_irq_in_gb_1
`hyper_imem[118] <= {8'h0d,`gb_1_careof_int_abt};
///C  cmp/nop :signal_irq_gb_1; # OH THE PAIN!!!! (not really :) )
`hyper_imem[119] <= {8'hee,`S_signal_irq_gb_1};
///C  or  $gb_1_irq_desc_and_certain_01;
`hyper_imem[120] <= {8'h0e,`gb_1_irq_desc_and_certain_01};
///C  cmp/nop :exec_gb_0;
`hyper_imem[121] <= {8'hee,`S_exec_gb_0};
///C  null;
`hyper_imem[122] <= 16'h4d00;
///C  nop; # 115
`hyper_imem[123] <= 16'h4e00;
///Ccontinue_grab_meta_gb_1:
///C  stc $gb_1_begin_addr_low; # 100
// S_continue_grab_meta_gb_1
`hyper_imem[124] <= {8'h47,`gb_1_begin_addr_low};
///C  add s+$gb_1_begin_addr_high;
`hyper_imem[125] <= {8'h02,`gb_1_begin_addr_high};
///C  sto $gb_1_begin_addr_high;
`hyper_imem[126] <= {8'h46,`gb_1_begin_addr_high};
///C  i_1_gb;
`hyper_imem[127] <= 16'h4500;
///C  xor 0xffff;
`hyper_imem[128] <= 16'h6f00;
///C  add 1+$gb_1_len_left; # 105
`hyper_imem[129] <= {8'h01,`gb_1_len_left};
///C  sto $gb_1_len_left;
`hyper_imem[130] <= {8'h46,`gb_1_len_left};
///C  cmp/i_2_gb :check_irq_in_gb_1;
`hyper_imem[131] <= {8'he5,`S_check_irq_in_gb_1};
///C  or  $gb_1_irq_desc_and_certain_01;
`hyper_imem[132] <= {8'h0e,`gb_1_irq_desc_and_certain_01};
///C  nop; # 109
`hyper_imem[133] <= 16'h4e00;
///Csignal_irq_gb_1:
///C  irq;
// S_signal_irq_gb_1
`hyper_imem[134] <= 16'h4900;
///C  sto $gb_1_active;
`hyper_imem[135] <= {8'h46,`gb_1_active};
///C  wait (:+1 instruction); # 112 # wait 4 cycles
`hyper_imem[136] <= {8'h48,`S_exec_gb_0};
///Cexec_gb_0:
///C  add 0+$gb_0_active; # 116
// S_exec_gb_0
`hyper_imem[137] <= {8'h00,`gb_0_active};
///C  cmp/null :continue_gb_0__0;
`hyper_imem[138] <= {8'hcd,`S_continue_gb_0__0};
///C  add 0+$gb_0_begin_addr_high;
`hyper_imem[139] <= {8'h00,`gb_0_begin_addr_high};
///C  o_1_gb; # 119
`hyper_imem[140] <= 16'h4b05;
///C  lod $distance_gb_01__mb; # 120
`hyper_imem[141] <= {8'h0a,`const_20};
///C  wait :prepare_mb_flipflop; # 121 # wait 20 cycles
`hyper_imem[142] <= {8'h48,`S_prepare_mb_flipflop};
///Ccontinue_gb_0__0:
///C  lod $gb_0_begin_addr_low; # 120
// S_continue_gb_0__0
`hyper_imem[143] <= {8'h0a,`gb_0_begin_addr_low};
///C  o_2_gb;
`hyper_imem[144] <= 16'h4b06;
///C  and $page_addr_submask;
`hyper_imem[145] <= {8'h0d,`page_addr_submask};
///C  xor 0xffff;
`hyper_imem[146] <= 16'h6f00;
///C  add 1+$page_size;
`hyper_imem[147] <= {8'h01,`page_size};
///C  sto $space_left_in_page; # 125
`hyper_imem[148] <= {8'h46,`space_left_in_page};
///C  sub $gb_0_len_left;
`hyper_imem[149] <= {8'h21,`gb_0_len_left};
///C  or  0xffff;
`hyper_imem[150] <= 16'h6e00;
///C  add s+0; # 128
`hyper_imem[151] <= 16'h4200;
///C  cmp/ones :space_left_in_page_not_enough;
`hyper_imem[152] <= {8'hee,`S_space_left_in_page_not_enough};
///C  cmp/null :continue_gb_0__1; # 130
`hyper_imem[153] <= {8'hcd,`S_continue_gb_0__1};
///C  sub $block_size;
`hyper_imem[154] <= {8'h21,`block_size};
///C  add 0+$gb_0_len_left;
`hyper_imem[155] <= {8'h00,`gb_0_len_left};
///Ccontinue_gb_0__1:
///C  sto $len_for_transfer__less_block_size;
// S_continue_gb_0__1
`hyper_imem[156] <= {8'h46,`len_for_transfer__less_block_size};
///C  add s+0;
`hyper_imem[157] <= 16'h4200;
///C  cmp/ones :len_for_transfer_shorter_than_block_size; # 135
`hyper_imem[158] <= {8'hee,`S_len_for_transfer_shorter_than_block_size};
///C  cmp/null :exec_transfer_gb_0;
`hyper_imem[159] <= {8'hcd,`S_exec_transfer_gb_0};
///C  add 0+$block_size;
`hyper_imem[160] <= {8'h00,`block_size};
///C  nop;
`hyper_imem[161] <= 16'h4e00;
///Cexec_transfer_gb_0:
///C  or $other_bits_gb_0;
// S_exec_transfer_gb_0
`hyper_imem[162] <= {8'h0e,`other_bits_gb_0};
///C  o_3_gb; # 140 # nulls
`hyper_imem[163] <= 16'h0b04;
///Cprepare_mb_flipflop:
///C  add 0+$0x8000; # 141
// S_prepare_mb_flipflop
`hyper_imem[164] <= {8'h00,`const_0x8000};
///C  add 0+$mb_flipflop_ctrl;
`hyper_imem[165] <= {8'h00,`mb_flipflop_ctrl};
///C  stc $mb_flipflop_ctrl;
`hyper_imem[166] <= {8'h47,`mb_flipflop_ctrl};
///Cprepare_gb_0:
///C  add 0+$gb_0_active;
// S_prepare_gb_0
`hyper_imem[167] <= {8'h00,`gb_0_active};
///C  xor $0x8000; # 145
`hyper_imem[168] <= {8'h0f,`const_0x8000};
///C  cmp/null :jump_over_prepare_gb_0;
`hyper_imem[169] <= {8'hcd,`S_jump_over_prepare_gb_0};
///C  add 0+$signal_bits_gb_0;
`hyper_imem[170] <= {8'h00,`signal_bits_gb_0};
///C  and $0x8000; # 148
`hyper_imem[171] <= {8'h0d,`const_0x8000};
///C  lod $distance_gb_01__mb; # 149
`hyper_imem[172] <= {8'h0a,`const_15};
///C  wait :prepare_gb_1; # 150 # wait 15 cycles
`hyper_imem[173] <= {8'h48,`S_prepare_gb_1};
///Cjump_over_prepare_gb_0:
///C  stc $gb_0_active; # 149
// S_jump_over_prepare_gb_0
`hyper_imem[174] <= {8'h47,`gb_0_active};
///C  add 0+$len_left_gb_0; # 150
`hyper_imem[175] <= {8'h00,`len_left_gb_0};
///C  add 0+$0x0003;
`hyper_imem[176] <= {8'h00,`const_0x0003};
///C  and $0x7ffc;
`hyper_imem[177] <= {8'h0d,`const_0x7ffc};
///C  stc $len_left_gb_0;
`hyper_imem[178] <= {8'h47,`len_left_gb_0};
///C  add 0+$signal_bits_gb_0;
`hyper_imem[179] <= {8'h00,`signal_bits_gb_0};
///C  and $section_mask; # 155
`hyper_imem[180] <= {8'h0d,`section_mask};
///C  or  $certain_01;
`hyper_imem[181] <= {8'h0e,`certain_01};
///C  stc $section_and_certain_01_gb_0; # AKA $gb_0_irq_desc_and_cerain_01
`hyper_imem[182] <= {8'h47,`section_and_certain_01_gb_0};
///C  add 0+$signal_bits_gb_0;
`hyper_imem[183] <= {8'h00,`signal_bits_gb_0};
///C  and $location_of_careofint_bit;
`hyper_imem[184] <= {8'h0d,`location_of_careofint_bit};
///C  cmp/ones :care_of_irq; # 160
`hyper_imem[185] <= {8'hee,`care_of_irq};
///C  cmp/nop :write_careof_int_gb_0;
`hyper_imem[186] <= {8'hce,`S_write_careof_int_gb_0};
///C  null;
`hyper_imem[187] <= 16'h4d00;
///C  add $0x4000;  # mask for only ABORT
`hyper_imem[188] <= {8'h00,`const_0x4000};
///Cwrite_careof_int_gb_0:
///C  stc $careof_interrupt_abort_gb_0; # AKA $gb_0_careof_int_abt
// S_write_careof_int_gb_0
`hyper_imem[189] <= {8'h47,`careof_interrupt_abort_gb_0};
///Cprepare_gb_1:
///C  add 0+$gb_1_active; # 165
// S_prepare_gb_1
`hyper_imem[190] <= {8'h00,`gb_1_active};
///C  xor $0x8000;
`hyper_imem[191] <= {8'h0f,`const_0x8000};
///C  cmp/null :jump_over_prepare_gb_1;
`hyper_imem[192] <= {8'hcd,`S_jump_over_prepare_gb_1};
///C  add 0+$signal_bits_gb_1;
`hyper_imem[193] <= {8'h00,`signal_bits_gb_1};
///C  and $0x8000; # 169
`hyper_imem[194] <= {8'h0d,`const_0x8000};
///C  lod $distance_gb_01__mb; # 170
`hyper_imem[195] <= {8'h0a,`const_15};
///C  wait :balancing_wait; # 171 # wait 15 cycles
`hyper_imem[196] <= {8'h48,`S_balancing_wait};
///Cjump_over_prepare_gb_1:
///C  stc $gb_1_active; # 170
// S_jump_over_prepare_gb_1
`hyper_imem[197] <= {8'h47,`gb_1_active};
///C  add 0+$len_left_gb_1;
`hyper_imem[198] <= {8'h00,`len_left_gb_1};
///C  add 0+$0x0003;
`hyper_imem[199] <= {8'h00,`const_0x0003};
///C  and $0x7ffc;
`hyper_imem[200] <= {8'h0d,`const_0x7ffc};
///C  stc $len_left_gb_1;
`hyper_imem[201] <= {8'h47,`len_left_gb_1};
///C  add 0+$signal_bits_gb_1; # 175
`hyper_imem[202] <= {8'h00,`signal_bits_gb_1};
///C  and $section_mask;
`hyper_imem[203] <= {8'h0d,`section_mask};
///C  or  $certain_01;
`hyper_imem[204] <= {8'h0e,`certain_01};
///C  stc $section_and_certain_01_gb_1; # AKA $gb_1_irq_desc_and_cerain_01
`hyper_imem[205] <= {8'h47,`section_and_certain_01_gb_1};
///C  add 0+$signal_bits_gb_1;
`hyper_imem[206] <= {8'h00,`signal_bits_gb_1};
///C  and $location_of_careofint_bit; # 180
`hyper_imem[207] <= {8'h0d,`location_of_careofint_bit};
///C  cmp/ones :care_of_irq;
`hyper_imem[208] <= {8'hee,`S_care_of_irq};
///C  cmp/nop :write_careof_int_gb_1;
`hyper_imem[209] <= {8'hce,`S_write_careof_int_gb_1};
///C  null;
`hyper_imem[210] <= 16'h4d00;
///C  add $0x4000;  # mask for only ABORT
`hyper_imem[211] <= {8'h00,`const_0x4000};
///Cwrite_careof_int_gb_1:
///C  stc $careof_interrupt_abort_gb_1; # 185 # AKA $gb_1_careof_int_abt
// S_write_careof_int_gb_1
`hyper_imem[212] <= {8'h47,`careof_interrupt_abort_gb_1};
///Cbalancing_wait:
///C  lod $balancing_wait_cycles; # 186
// S_balancing_wait
`hyper_imem[213] <= {8'h0a,`const_6};
///C  wait :grab_meta_gb_0; # 187 # wait 6 cycles
`hyper_imem[214] <= {8'h48,`S_grab_meta_gb_0};
///Cprepare_mb:
///C  null; # 50 in the main thread # origin of counting # /1
// S_prepare_mb_trans
`hyper_imem[215] <= 16'h4d00;
///C  add 1+$cur_mb_trans_ptr;
`hyper_imem[216] <= {8'h01,`cur_mb_trans_ptr};
///C  and $cur_mb_trans_ptr_mask;
`hyper_imem[217] <= {8'h0d,`cur_mb_trans_ptr_mask};
///C  sto $cur_mb_trans_ptr;
`hyper_imem[218] <= {8'h46,`cur_mb_trans_ptr};
///C  inl;
`hyper_imem[219] <= 16'h4c00;
///C  add 0+INDEX; # 55
`hyper_imem[220] <= 16'h1000;
///C  inl;  # loaded with $mb_active
`hyper_imem[221] <= 16'h4c00;
///C  add 0+(INDEX+D($mb_active -> $signal_bits));
`hyper_imem[222] <= {8'h10,`D_mb_active_T_signal_bits};
///C  xor $0x8000;
`hyper_imem[223] <= {8'h0f,`const_0x8000};
///C  cmp/null :jump_over_prepare_mb;
`hyper_imem[224] <= {8'hcd,`S_jump_over_prepare_mb};
///C  add 0+(INDEX+D($signal_bits -> $mb_active)); # 60/10
`hyper_imem[225] <= {8'h10,`D_signal_bits_T_mb_active};
///C  and $0x8000; # 61
`hyper_imem[226] <= {8'h0d,`const_0x8000};
///C  lod $distance_gb_01__mb; # 62
`hyper_imem[227] <= {8'h0a,`const_15};
///C  wait :mb_step_indices; # 63 # wait 15 cycles
`hyper_imem[228] <= {8'h48,`S_mb_step_indices};
///Cjump_over_prepare_mb:
///C  stc (INDEX+D($mb_active -> $len_left)); # 62
// S_jump_over_prepare_mb
`hyper_imem[229] <= {8'h57,`D_mb_active_T_len_left};
///C  add 0+INDEX;
`hyper_imem[230] <= 16'h1000;
///C  add 0+$0x0003;
`hyper_imem[231] <= {8'h00,`const_0x0003};
///C  and $0x7ffc; # 65
`hyper_imem[232] <= {8'h0d,`const_0x7ffc};
///C  stc (INDEX+D($len_left -> $signal_bits));
`hyper_imem[233] <= {8'h57,`D_len_left_T_signal_bits};
///C  add 0+(INDEX+D($signal_bits -> $mb_irq_desc_and_certain_01));
`hyper_imem[234] <= {8'h10,`D_signal_bits_T_mb_irq_desc_and_certain_01};
///C  and $section_mask;
`hyper_imem[235] <= {8'h0d,`section_mask};
///C  or  $certain_01;
`hyper_imem[236] <= {8'h0e,`certain_01};
///C  stc (INDEX+D($mb_irq_desc_and_certain_01 -> $signal_bits)); # 70/20
`hyper_imem[237] <= {8'h57,`D_mb_irq_desc_and_certain_01_T_signal_bits};
///C  add 0+(INDEX+D($signal_bits -> $mb_careof_int_abt));
`hyper_imem[238] <= {8'h10,`D_signal_bits_T_mb_careof_int_abt};
///C  and $location_of_careofint_bit;
`hyper_imem[239] <= {8'h0d,`location_of_careofint_bit};
///C  cmp/ones :care_of_irq;
`hyper_imem[240] <= {8'hee,`S_care_of_irq};
///C  cmp/nop :write_careof_int_mb;
`hyper_imem[241] <= {8'hce,`S_write_careof_int_mb};
///C  null; # 75
`hyper_imem[242] <= 16'h4d00;
///C  add $0x4000;
`hyper_imem[243] <= {8'h00,`const_0x4000};
///Cwrite_careof_int_mb:
///C  stc INDEX;
// S_write_careof_int_mb
`hyper_imem[244] <= 16'h5700;
///Cmb_step_indices:
///C  add 0+$cur_mb_trans_ptr; # 78
// S_mb_step_indices
`hyper_imem[245] <= {8'h00,`cur_mb_trans_ptr};
///C  inl;
`hyper_imem[246] <= 16'h4c00;
///C  add 0+INDEX; # 80/30
`hyper_imem[247] <= 16'h1000;
///C  swp $next_index; # a proper swap
`hyper_imem[248] <= {8'h07,`next_index};
///C  inl; # 82
`hyper_imem[249] <= 16'h4c00;
///Cwaitout_untill_gb:
///C  lod $delay_for_prepare_mb; # 83
// S_waitout_untill_gb
`hyper_imem[250] <= {8'h0a,`const_12};
///C  wait :grab_meta_gb_0; # 84 # wait 12 cycles
`hyper_imem[251] <= {8'h48,`S_grab_meta_gb_0};


`hyper_imem[254] <= 16'h6a00;
`hyper_imem[255] <= 16'h46ff;


  for (i=1; i<31; i=i+1)
    begin
      core.cpu.regf.RAM_A.ram.r_data[i] <= 32'hxxxx_xxxx;
      core.cpu.regf.RAM_B.ram.r_data[i] <= 32'hxxxx_xxxx;
      core.cpu.regf.RAM_D.ram.r_data[i] <= 32'hxxxx_xxxx;
    end
//  core.cpu.regf.RAM_A.ram.r_data[22] <= 32'hffff_ffff;

// test config below

//`define term_place 28 // for tests 0-4 inclusive
`define term_place 55 // for tests 5-8 inclusive
`hyper_imem[((`term_place+0) & 8'hff)] <= 16'h6a00;
`hyper_imem[((`term_place+1) & 8'hff)] <= 16'h46ff;
`hyper_imem[((`term_place+2) & 8'hff)] <= 16'h46ff;
`hyper_imem[((`term_place+3) & 8'hff)] <= 16'h46ff;
core.hyper_softcore.ip <= `S_grab_meta_gb_0 -1;
`hyper_dmem[`const_15] <= 11;
`hyper_dmem[`const_20] <= 16;

`hyper_dmem[`page_addr_submask] <= 16'h007f;
`hyper_dmem[`page_size] <= 16'h0080;
`hyper_dmem[`block_size] <= 16'h0008;

  test_no = 8;
  case (test_no)
    0: begin
      `hyper_dmem[`gb_0_active] <= 0;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
    end
    1: begin
      `hyper_dmem[`gb_0_active] <= 16'h8000;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
      `hyper_dmem[`gb_0_len_left] <= 16'h0020;
      `hyper_dmem[`gb_0_irq_desc_and_certain_01] <= 16'h0240;
      core.hyper_softcore.input_reg_1[0] <= 16'h0020;
      core.hyper_softcore.input_reg_1[1] <= 16'h0000;
    end
    2: begin
      `hyper_dmem[`gb_0_active] <= 16'h8000;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
      `hyper_dmem[`gb_0_len_left] <= 16'h0021;
      `hyper_dmem[`gb_0_careof_int_abt] <= 16'hc000;
      `hyper_dmem[`gb_0_irq_desc_and_certain_01] <= 16'h0240;
      core.hyper_softcore.input_reg_1[0] <= 16'h0020;
      core.hyper_softcore.input_reg_1[1] <= 16'h8000; // irq
    end
    3: begin
      `hyper_dmem[`gb_0_active] <= 16'h8000;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
      `hyper_dmem[`gb_0_len_left] <= 16'h0021;
      `hyper_dmem[`gb_0_careof_int_abt] <= 16'hc000;
      `hyper_dmem[`gb_0_irq_desc_and_certain_01] <= 16'h0240;
      core.hyper_softcore.input_reg_1[0] <= 16'h0020;
      core.hyper_softcore.input_reg_1[1] <= 16'h4000; // abort
    end

    4: begin
      `hyper_dmem[`gb_0_active] <= 16'h8000;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
      `hyper_dmem[`gb_0_len_left] <= 16'h0021;
      `hyper_dmem[`gb_0_careof_int_abt] <= 16'hc000;
      `hyper_dmem[`gb_0_irq_desc_and_certain_01] <= 16'h0240;
      core.hyper_softcore.input_reg_1[0] <= 16'h0020;
      core.hyper_softcore.input_reg_1[1] <= 16'h0000;
    end

    5: begin
      `hyper_dmem[`gb_0_active] <= 0;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
      `hyper_dmem[`gb_1_active] <= 0;
      `hyper_dmem[`gb_1_begin_addr_low] <= 16'hff0f;
      `hyper_dmem[`gb_1_begin_addr_high] <= 16'h00ef;
    end
    6: begin
      `hyper_dmem[`gb_0_active] <= 0;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
      `hyper_dmem[`gb_1_active] <= 16'h8000;
      `hyper_dmem[`gb_1_begin_addr_low] <= 16'hff0f;
      `hyper_dmem[`gb_1_begin_addr_high] <= 16'h00ef;
      `hyper_dmem[`gb_1_len_left] <= 16'h0021;
      `hyper_dmem[`other_bits_gb_1] <= 0;

      `hyper_dmem[`page_addr_submask] <= 16'h007f;
      `hyper_dmem[`page_size] <= 16'h0080;
      `hyper_dmem[`block_size] <= 16'h0008;
      // block_size (0x0008)
    end
    7: begin
      `hyper_dmem[`gb_0_active] <= 0;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
      `hyper_dmem[`gb_1_active] <= 16'h8000;
      `hyper_dmem[`gb_1_begin_addr_low] <= 16'hff7c;
      `hyper_dmem[`gb_1_begin_addr_high] <= 16'h00ef;
      `hyper_dmem[`gb_1_len_left] <= 16'h0021;
      `hyper_dmem[`other_bits_gb_1] <= 0;

      `hyper_dmem[`page_addr_submask] <= 16'h007f;
      `hyper_dmem[`page_size] <= 16'h0080;
      `hyper_dmem[`block_size] <= 16'h0008;
      // space_left_in_page (0x0004)
    end
    8: begin
      `hyper_dmem[`gb_0_active] <= 0;
      `hyper_dmem[`gb_0_begin_addr_low] <= 16'hffff;
      `hyper_dmem[`gb_0_begin_addr_high] <= 16'h0eef;
      `hyper_dmem[`gb_1_active] <= 16'h8000;
      `hyper_dmem[`gb_1_begin_addr_low] <= 16'hff0f;
      `hyper_dmem[`gb_1_begin_addr_high] <= 16'h00ef;
      `hyper_dmem[`gb_1_len_left] <= 16'h0002;
      `hyper_dmem[`other_bits_gb_1] <= 0;

      `hyper_dmem[`page_addr_submask] <= 16'h007f;
      `hyper_dmem[`page_size] <= 16'h0080;
      `hyper_dmem[`block_size] <= 16'h0008;
      // len_left (0x0002)
    end
    default: $finish;
  endcase // case (test_no)


end // initial begin

always @(posedge CLK_n)
  begin
    if (core.hyper_softcore.d_w_en_cpu && 0)
      $display("w_sys %x w_cpu %x",
	       core.hyper_softcore.d_w_en_sys,
	       core.hyper_softcore.d_w_en_cpu);
    if (core.hyper_softcore.RST)
      begin
	$display("cc %d io %x if %x acc %x",
		 gremlin_cycle,
		 core.hyper_softcore.instr_o,
		 core.hyper_softcore.instr_f,
		 core.hyper_softcore.accumulator);
      end
  end

always @(posedge CPU_CLK)
  begin
//    if (record)
    if (core.cpu.grst && 0)
      begin
	$display("rPC %x xRD %x dRD %x xREGD %x xDST %x r8d %x",
		 core.cpu.bpcu.rPC, core.cpu.regf.xRD,
		 core.cpu.regf.dRD, core.cpu.regf.xREGD,
		 core.cpu.regf.xDST, core.cpu.regf.RAM_D.ram.r_data[8]);
        $display("i_pc_addr %x rPC %x dOPC %x xOPC %x xBRA %x di/ci/ii %x SKIP %x",
		 core.i_cache_pc_addr, core.cpu.bpcu.rPC,
		 core.cpu.ibuf.dOPC, core.cpu.ibuf.xOPC,
		 core.cpu.bpcu.xBRA,
		 {core.cpu.ibuf.do_interrupt,core.cpu.ibuf.cpu_interrupt,
		  core.cpu.ibuf.issued_interrupt},
		 {core.cpu.bpcu.fSKIP,core.cpu.bpcu.dSKIP,
		  core.cpu.bpcu.xSKIP});

	$display("-------------------------------------------------");
      end
  end

/*
`define CHANGER 64'h0b
always @(negedge CPU_CLK)
  begin
    if (cpu_ctr == (`CHANGER -1))
      record <= 1;
    if (cpu_ctr == (`CHANGER))
      begin
        $display("core.i_cache_pc_addr %x", core.i_cache_pc_addr);
	$display("fire interrupt!");
        force core.cpu.sys_int_i = 1'b1;
      end
    if (cpu_ctr == (`CHANGER +1))
      begin
        release core.cpu.sys_int_i;
      end
  end
 */