# Graceful Degradation on FPGAs: A High-Radix Online Approach

This project tests the performance of high-radix online addition and multiplication on FPGA. It corresponds to my [Master's Thesis](Reports/LaneyThesis.pdf) for the completion of the [MSc Analogue and Digital Integrated Circuit Design](http://www.imperial.ac.uk/study/pg/electrical-engineering/analogue-digital-circuit/) program at Imperial College London

## Disclaimer

This project is academic in nature, and was developed as a means to answer an experimental question. As such it has only been tested using a single software toolchain and hardware stack. It is likely some or all of this code will not function as intended given a different compute environment or settings. The purpose of the repository is to document my implementation, and serve as inspiration for future related projects.

## Tools Used
Development was done in Linux

[Quartus Prime Lite Edition (20.1.1)](https://imperialcollegelondon.app.box.com/s/2tj5vwxnfrpprtgjg2ns1expl8ipfv9q)

[Python 2.7.12](https://www.python.org/downloads/release/python-2712/)

[C++20](https://en.cppreference.com/w/cpp/20)

[MATLAB R2021a](https://uk.mathworks.com/products/new_products/latest_features.html)

That targeted FPGA was the [Intel Cyclone V SoC Development Kit](https://www.intel.com/content/www/us/en/programmable/products/boards_and_kits/dev-kits/altera/kit-cyclone-v-soc.html) running the Linux image found [here](https://imperialcollegelondon.app.box.com/s/2tj5vwxnfrpprtgjg2ns1expl8ipfv9q) (Login: `root`, Password: `root`).


## File Structure

* [rR_add](rRp_add) and [rRp_mult](rRp_mult) contain the tested online arithmetic IP, as well as simulation test benches for verification.
* [Adder_Test_Param](Adder_Test_Param) and [mult_test_param](mult_test_param) are the Quartus projects used to generate the FPGA test benches for data collection
* [FPGAFiles/josh](FPGAFiles/josh) contains the python test scripts run on the FPGA, and the collected test data. This mirros the files stored on the Cyclone V SoC.
  * [run_tests.sh](FPGAFiles/run_tests.sh) will collect degreadation data on all generated adders and multipliers. It takes about 24 hours to complete
* [PLL_Test](PLL_Test) is a simple Quartus Project to test dynamic reconfiguration of the CycloneV PLL
* [mult_csims](mult_csims) contains C++ simulations of the online multiplication algorithm
* [Reports](Reports) contains various submitted materials related to this project  



## Support

Please contact [Joshua Laney](mailto:josh.laney20@imperial.ac.uk) for questions or suggestions

## License
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), see [license](LICENSE.txt) file for terms.