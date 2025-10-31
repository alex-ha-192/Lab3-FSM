#include "Vf1_fsm.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);

    Vf1_fsm* f1_fsm = new Vf1_fsm;
    
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    f1_fsm->trace(tfp, 99);
    tfp->open("f1_fsm.vcd");

    if (vbdOpen() != 1) return (-1);
    vbdHeader("Lab 3: F1");
    vbdSetMode(1);

    f1_fsm->clk = 1;
    f1_fsm->rst = 1;
    f1_fsm->en = 1;

    const int CLOCK_COUNT = 1000000;
    for (i = 0; i < CLOCK_COUNT; i++) {
        for (clk = 0; clk < 2; clk++) {
            tfp->dump(2 * i + clk);
            f1_fsm->clk = !f1_fsm->clk;
            f1_fsm->eval();
        }
        
        vbdBar(f1_fsm->data_out & 0xFF);
        vbdCycle(i + 1);
        if (f1_fsm->data_out == 0) {
            f1_fsm->en = vbdFlag();
        } else {
            f1_fsm->en = 1;
        }

        f1_fsm->rst = 0;

        if (Verilated::gotFinish() || vbdGetkey() == 'q') {
            exit(0);
        }
    }

    vbdClose();
    tfp->close();
    exit(0);
}