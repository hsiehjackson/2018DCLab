wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/team04/DClab/DCLab-Material/lab1/sim/Lab1_test.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/Top_test"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/top0"
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/Top_test/dut/top0/i_start} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/Top_test"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/top0"
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/Top_test/dut/top0/i_start} \
{/Top_test/dut/top0/state\[4:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/Top_test"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/top0"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/top0"
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/Top_test/dut/top0/i_start} \
{/Top_test/dut/top0/state\[4:0\]} \
{/Top_test/dut/top0/i_rst} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvGetSignalClose -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 29629271.310167 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 28474456.543878 -snap {("G2" 0)}
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/Top_test"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/top0"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/top0"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/deb0"
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/Top_test/dut/top0/i_start} \
{/Top_test/dut/top0/state\[4:0\]} \
{/Top_test/dut/top0/i_rst} \
{/Top_test/dut/deb0/i_in} \
{/Top_test/dut/deb0/i_rst} \
{/Top_test/dut/deb0/o_debounced} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 5 6 )} 
wvSetPosition -win $_nWave1 {("G1" 6)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 30362778.383921 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 28936768.408000 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 28912182.029105 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 29600600.638170 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 28272936.177830 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 28272936.177830 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 28272936.177830
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/Top_test"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/top0"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/deb0"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut/top0"
wvGetSignalSetScope -win $_nWave1 "/Top_test/dut"
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/Top_test/dut/top0/i_start} \
{/Top_test/dut/top0/state\[4:0\]} \
{/Top_test/dut/top0/i_rst} \
{/Top_test/dut/deb0/i_in} \
{/Top_test/dut/deb0/i_rst} \
{/Top_test/dut/deb0/o_debounced} \
{/Top_test/dut/KEY\[3:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 29231804.954742 -snap {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSetRadix -win $_nWave1 -format Bin {("G1" 7)}
wvSetCursor -win $_nWave1 28297522.556725
wvSetCursor -win $_nWave1 33711597.420136
wvSetCursor -win $_nWave1 33564079.146765
wvSetCursor -win $_nWave1 29581085.765745
wvSetCursor -win $_nWave1 28290300.873748
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 33662424.662346
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 33834529.314612
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 34191031.808593
wvSetCursor -win $_nWave1 28204248.547615 -snap {("G1" 0)}
wvSetCursor -win $_nWave1 28253421.305406
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 28981792.780175 -snap {("G1" 0)}
wvSetCursor -win $_nWave1 28360986.713072 -snap {("G1" 0)}
wvSetCursor -win $_nWave1 27999950.000000
wvSetCursor -win $_nWave1 28453185.633929
wvSetCursor -win $_nWave1 28502358.391719
wvSetCursor -win $_nWave1 28576117.528405
wvSetCursor -win $_nWave1 28594557.312576
wvExit
