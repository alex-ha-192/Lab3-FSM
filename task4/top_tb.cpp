#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);

    Vtop* top = new Vtop;
    
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top.vcd");

    if (vbdOpen() != 1) return (-1);
    vbdHeader("T4: Delay F1");
    vbdSetMode(1);

    bool watchLocked = false;

    top->clk = 1;
    top->rst = 1;
    top->N = 85;
    top->trigger = 0;
    top->cmd_seq_in = 0;
    top->cmd_delay_in = 1;

    const int CLOCK_COUNT = 10000;
    for (i = 0; i < CLOCK_COUNT; i++) {
        for (clk = 0; clk < 2; clk++) {
            tfp->dump(2 * i + clk);
            top->clk = !top->clk;
            top->eval();
        }
        
        vbdBar(top->data_out & 0xFF);
        // vbdCycle(i + 1);

        if (top->data_out == 0 && !watchLocked) {
            watchLocked = true;
            vbdInitWatch();
        }
        
        if (top->data_out != 0) {
            watchLocked = false;
        }

        top->rst = (i < 2);

        top->cmd_seq_in = top->cmd_seq_out;
        top->cmd_delay_in = top->cmd_delay_out;

        top->trigger = vbdFlag();
        if (top->trigger) {
            vbdCycle(vbdElapsed());
        }

        if (Verilated::gotFinish() || vbdGetkey() == 'q') {
            exit(0);
        }
    }

    vbdClose();
    tfp->close();
    exit(0);
}