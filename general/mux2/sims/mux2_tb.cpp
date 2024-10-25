#include "obj_dir/Vmux2.h"      // Verilator generated module class
#include "verilated.h"   // Verilator support

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);   // Initialize Verilator
    Vmux2* top = new Vmux2;               // Create instance of mux2 module

    // Apply inputs
    top->a = 0;
    top->b = 1;
    top->sel = 0;
    top->eval();                          // Evaluate the module
    printf("Output y = %d\n", top->y);    // Print the output

    top->sel = 1;                         // Change selector
    top->eval();                          // Evaluate again
    printf("Output y = %d\n", top->y);    // Print the output

    delete top;
    return 0;
}
