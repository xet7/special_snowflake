##############################################
space_left_in_page_not_enough:
  add 0+$space_left_in_page;
len_for_transfer_shorter_than_block_size:
  add 0+$len_for_transfer__less_block_size;
##############################################

check_irq_in_gb_0:
  and $gb_0_careof_int_abt;
  cmp/nop :signal_irq_gb_0;  # OH THE PAIN!!!
  or  $gb_0_irq_des_and_certain_01;
  cmp/nop :exec_gb_1; # 20
  null;
  nop;


grab_meta_gb_0:
  null;
  add 0+$gb_0_active;
  cmp/nop :continue_grab_meta_gb_0;

  i_1_gb;
  add 0+$gb_0_begin_addr_low;

# not part of main execution
  ones;
  cmp/null :exit_into_exec_gb_1;
# end not part of main execution

continue_grab_meta_gb_0:
  stc $gb_0_begin_addr_low; # store w/ clear
  add s+$gb_0_begin_addr_high;
  sto $gb_0_begin_addr_high;
  i_1_gb;
  xor 0xffff;
  add 1+$gb_0_len_left;
  sto $gb_0_len_left;

  cmp/i_2_gb :check_irq_in_gb_0;
  or  $gb_0_irq_desc_and_certain_01;
  sto $gb_0_store_irq_abort; # 15
  nop;
  nop;
  nop;
  nop;
  nop;
  nop;
signal_irq_gb_0:
  irq;
  sto $gb_0_active;

# jump into execution of gb_1

## longest to enter gb_1: 21 instructions

exec_gb_1:
  add 0+$gb_1_active;
  cmp/null :continue_gb_1__0;  # ?
  add 0+$gb_1_begin_addr_high;
  o_1_gb;

# not part of main execution
  ones;
  cmp/null :some_exit;
# end not part of main execution

continue_gb_1__0:
  null;
  add 0+$gb_1_begin_addr_low;
  o_2_gb;
  and $page_addr_submask;
  xor 0xffff; # 30
  add 1+$page_size;
  sto $space_left_in_page;

  sub $gb_1_len_left;
  and 0;
  add s+0;

  cmp/ones :space_left_in_page_not_enough;
  cmp/null :continue_gb_1__1;
  sub $block_size;
  add 0+$gb_1_len_left;
continue_gb_1__1:
  sto $len_for_transfer__less_block_size; # 40
  and $0x8000; # still magically right

  cmp/ones :len_for_transfer_shorter_than_block_size;
  cmp/null :exec_transfer_gb_1;
  add 0+$block_size;
  nop;

## 45 to reach this point

exec_transfer_gb_1:
  or $other_bits_gb_1;
  o_3_gb; # nulls

## 47 instructions

#####################

  and 0+$mb_flipflop_ctrl;
  cmp/null :prepare_mb_trans;

#####################

  add 0+(INDEX+D($mb_active -> $mb_begin_addr_low));
  cmp/nop :continue_grab_meta_mb;

  i_1_mb; # 50
  add 0+INDEX;

# escape goes here

continue_grab_meta_mb:
  stc (INDEX+D($mb_begin_addr_low -> $mb_begin_addr_high));
  add s+INDEX;
  sto (INDEX+D($mb_begin_addr_high -> $mb_len_left));
  i_1_mb;
  xor 0xffff;
  add 1+INDEX;
  sto (INDEX+D($mb_len_left -> $mb_irq_desc_and_certain_01));

  cmp/i_2_mb :check_irq_in_mb;
  or  (INDEX+D($mb_irq_desc_and_certain_01 -> $mb_store_irq_abort)); # 60
  sto (INDEX+D($mb_store_irq_abort -> $mb_careof_int_abt));

# nop trail comes here. You can also change the INDEX about.

check_irq_in_mb:
  and (INDEX+D($mb_careof_int_abt -> $mb_irq_desc_and_certain_01));
  cmp/nop :signal_irq_mb; # much, much less pain now, all of a sudden :)
  or  (INDEX+D($mb_irq_desc_and_certain_01 -> $mb_active));
  cmp/nop :exec_mb_other;
  null;
  nop;

signal_irq_mb:
  irq;
  sto INDEX;

## 67 to this point

exec_mb_other:
  # at this point, the accumulator is guarrantied to be nulled.
  # swichover the index
  add 0+$next_index;
  inl;

  add 0+(INDEX+D($mb_active -> $mb_begin_addr_high)); # 70
  cmp/null :continue_mb__0;
  add 0+(INDEX+D($mb_begin_addr_high -> $mb_begin_addr_low));
  o_1_mb;

# escape sequence goes here.

continue_mb__0:
  null;
  add 0+(INDEX+D($mb_begin_addr_low -> $mb_len_left));
  o_2_mb;
  and $page_addr_submask;
  xor 0xffff;
  add 1+$page_size;
  sto $space_left_in_page; # 80

  sub INDEX;
  and 0;
  add s+0;  # ? are you sure about this?

  cmp/ones :space_left_in_page_not_enough;
  cmp/null :continue_mb__1;
  sub $block_size;
  add 0+INDEX;
continue_mb__1:
  sto $len_for_transfer__less_block_size;
  and $0x8000; # still magically right

  cmp/ones :len_for_transfer_shorter_than_block_size; # 90
  cmp/null :exec_transfer_mb;
  add 0+$block_size;
  nop;

##

exec_transfer_mb:
  nop (INDEX+D($mb_len_left -> $mb_other_bits));
  or  (INDEX+D($mb_other_bits -> $mb_active));
  o_3_mb;

## 96 instructions + 2 for the mb trans prepare branch

## 98 instructions

grab_meta_gb_1:
  null;
  add 0+$gb_1_active; # 100
  cmp/nop :continue_grab_meta_gb_1;

  i_1_gb;
  add 0+$gb_1_begin_addr_low;

# escape sequence

continue_grab_meta_gb_1:
  stc $gb_1_begin_addr_low;
  add s+$gb_1_begin_addr_high;
  sto $gb_1_begin_addr_high;
  i_1_gb;
  xor 0xffff;
  add 1+$gb_1_len_left;
  sto $gb_1_len_left; # 110

  cmp/i_2_gb :check_irq_in_gb_1;
  or  $gb_1_irq_desc_and_certain_01;
  sto $gb_1_store_irq_abort;

# nop trail

check_irq_in_gb_1:
  and $gb_1_careof_int_abt;
  cmp/nop :signal_irq_gb_1; # OH THE PAIN!!!! (not really :) )
  or  $gb_1_irq_desc_and_certain_01;
  cmp/nop :exec_gb_0;
  null;
  nop;

signal_irq_gb_1:
  irq;
  sto $gb_1_active;

exec_gb_0:
  add 0+$gb_0_active; # 120
  cmp/null :continue_gb_0__0;
  add 0+$gb_0_begin_addr_high;
  o_1_gb;

# escape sequence

continue_gb_0__0:
  null;
  add 0+$gb_0_begin_addr_low;
  o_2_gb;
  and $page_addr_submask;
  xor 0xffff; # 128
  and 1+$page_size;
  sto $space_left_in_page; # 130

  sub $gb_0_len_left;
  and 0;
  add s+0;

  cmp/ones :space_left_in_page_not_enough;
  cmp/null :continue_gb_0__1;
  sub $block_size;
  add 0+$gb_0_len_left;
continue_gb_0__1:
  sto $len_for_transfer__less_block_size;
  and $0x8000; # still magically right

  cmp/ones :len_for_transfer_shorter_than_block_size; # 140
  cmp/null :exec_transfer_gb_0;
  add 0+$block_size;
  nop;

exec_transfer_gb_0:
  or $other_bits_gb_0;
  o_3_gb; # nulls

## 145 instructions