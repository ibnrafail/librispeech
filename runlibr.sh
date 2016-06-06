#!/bin/bash

. ./cmd.sh
. ./path.sh

#rm -rf exp/tri5b/
#utils/fix_data_dir.sh data/test_native || exit 1;
#utils/fix_data_dir.sh data/test_foreign || exit 1;
#utils/fix_data_dir.sh data/test_native_noise || exit 1;
#utils/fix_data_dir.sh data/test_foreign_noise || exit 1;

echo ============================================================================
echo "         MFCC Feature Extration & CMVN for Test set                       "
echo ============================================================================
#mfccdir=mfcc
#for part in test_native test_foreign test_native_noise test_foreign_noise; do
#  steps/make_mfcc.sh --cmd "$train_cmd" --nj 1 data/$part exp/make_mfcc/$part $mfccdir
#  steps/compute_cmvn_stats.sh data/$part exp/make_mfcc/$part $mfccdir
#done

echo ============================================================================
echo "                     MonoPhone Decoding                                   "
echo ============================================================================
# decode using the monophone model
#utils/mkgraph.sh --mono data/lang_nosp_test_tgsmall exp/mono exp/mono/graph_nosp_tgsmall
#for test in test_native test_foreign test_native_noise test_foreign_noise; do
	#steps/decode.sh --nj 1 --cmd "$decode_cmd" exp/mono/graph_tgsmall data/$test exp/mono/decode_$test
#done

#for x in exp/*/decode_test*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done


echo ============================================================================
echo "              tri5b : LDA + MLLT + SAT Decoding 460                       "
echo ============================================================================
# decode using the tri5b model
##utils/mkgraph.sh data/lang_test_tgsmall exp/tri5b exp/tri5b/graph_tgsmall
#for test in test_native test_foreign test_native_noise test_foreign_noise; do
#	steps/decode_fmllr.sh --nj 1 --cmd "$decode_cmd" exp/tri5b/graph_tgsmall data/$test exp/tri5b/decode_tgsmall_$test
#   steps/lmrescore.sh --cmd "$decode_cmd" data/lang_test_{tgsmall,tgmed} data/$test exp/tri5b/decode_{tgsmall,tgmed}_$test
#    steps/lmrescore_const_arpa.sh --cmd "$decode_cmd" data/lang_test_{tgsmall,tglarge} data/$test exp/tri5b/decode_{tgsmall,tglarge}_$test
#done

#for x in exp/tri5b/decode_*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done

echo ============================================================================
echo "               DNN Hybrid Decoding 460                                    "
echo ============================================================================
#local/nnet2/run_6a_clean_460.sh
#for x in exp/nnet6a_clean_460_gpu/decode_*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done


echo ============================================================================
echo "              tri6b : LDA + MLLT + SAT Decoding 960                       "
echo ============================================================================
# decode using the tri6b model
#utils/mkgraph.sh data/lang_test_tgsmall exp/tri6b exp/tri6b/graph_tgsmall
for test in test_native test_foreign test_native_noise test_foreign_noise; do
	steps/decode_fmllr.sh --nj 1 --cmd "$decode_cmd" exp/tri6b/graph_tgsmall data/$test exp/tri6b/decode_tgsmall_$test
    steps/lmrescore.sh --cmd "$decode_cmd" data/lang_test_{tgsmall,tgmed} data/$test exp/tri6b/decode_{tgsmall,tgmed}_$test
    steps/lmrescore_const_arpa.sh --cmd "$decode_cmd" data/lang_test_{tgsmall,tglarge} data/$test exp/tri6b/decode_{tgsmall,tglarge}_$test
done
#for x in exp/nnet6a_clean_460_gpu/decode_*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done

echo ============================================================================
echo "               DNN Hybrid Decoding 960                                    "
echo ============================================================================
local/nnet2/run_7a_960.sh
for x in exp/nnet6a_clean_460_gpu/decode_*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done
