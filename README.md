# MATLAB Tool for the Impedance Analyzer 4294A

![license - BSD](https://img.shields.io/badge/license-BSD-green)
![language - MATLAB](https://img.shields.io/badge/language-MATLAB-blue)
![category - power electronics](https://img.shields.io/badge/category-power%20electronics-lightgrey)
![status - unmaintained](https://img.shields.io/badge/status-unmaintained-red)

This **MATLAB** tool offers different functions for working with the **HP/Agilent/Keysight 4294A impedance analyzer**.

The following functions are implemented:
* **Read measurement file**
* **Get the device tolerances**
* **Add the tolerances to a measurement**

This tool is developed by the **Power Electronic Systems Laboratory at ETH Zurich** and is available under the **BSD License**. The code is also available on the ETH Data Archive.

## Example

The following examples are included:
* [run_device_tol.m](run_device_tol.m) - Get and plot the device tolerances
* [run_meas_tol.m](run_meas_tol.m) - Read a measurement file, add the tolerances, and plot

<p float="middle">
    <img src="readme_img/device_tol.png" width="350">
    <img src="readme_img/meas_tol.png" width="350">
</p>

## Compatibility

The tool is tested with the following MATLAB setup:
* Tested with MATLAB R2018b or 2019a
* No toolboxes are required.
* Compatibility with GNU Octave not tested but probably easy to achieve.

## References

The following references describes the impedance analyzer 4294A:
* Agilent 4294A Precision Impedance Analyzer, Operation Manual, 2003
* Agilent 4294A Precision Impedance Analyzer, Data Sheet, 2008

## Author

* **Thomas Guillod, ETH Zurich, Power Electronic Systems Laboratory** - [GitHub Profile](https://github.com/otvam)

## License

* This project is licensed under the **BSD License**, see [LICENSE.md](LICENSE.md).
* This project is copyrighted by: (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod.
