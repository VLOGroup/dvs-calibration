# DVS Camera Calibration
This repository provides software for an automatic camera calibration of a DVS128. It uses the calibration framework of Jean-Yves Bouguet (http://www.vision.caltech.edu/bouguetj/calib_doc/index.html) together with a recently proposed feature detections method for low-resolution cameras (https://github.com/RobVisLab/camera_calibration). For showing a fullscreen picture in MATLAB, the repository contains the code from https://de.mathworks.com/matlabcentral/fileexchange/11112-fullscreen .

The main idea of this framework is to use a LCD monitor as calibration target. By recording a flickering target, it is easy to reconstruct images by simple addition of all observed events.

The software consists of two parts, a camera grabber written in C++ and the main calibration routine in MATLAB.

## Compiling
For your convenience, the required libraries that are on Github are added as
submodules. So clone this repository with `--recursive` or do a
~~~
git submodule update --init --recursive
~~~
after cloning.

This software requires:
 - libcaer >=2.0 (https://github.com/inilabs/libcaer)
 - camera_calibration (https://github.com/RobVisLab/camera_calibration)
 - DVS128 camera

To compile, first build and install `libcaer`, then the grabber:
 ~~~
cd libcaer
cmake .
make
(sudo) make install
cd ../grabber
mkdir build
cd build
cmake ..
make
 ~~~

Per default, the application will compile to support the iniLabs DVS128.

## Usage
Run the `do_calibration.m` file in MATLAB. It will capture 20 images using a flickering target and then start the calibration routine. Adapt `resolution=[1920,1080];` to the resolution of your second screen (`fullscreen.m` only works reliably on the non-primary monitor).

In case you get an error about a broken .mexa64 file on Linux systems, you will have to override the `libstdc++.so.6` that comes with MATLAB by executing `export LD_PRELOAD=$LD_PRELOAD:/usr/lib/x86_64-linux-gnu/libstdc++.so.6:/usr/lib/x86_64-linux-gnu/libprotobuf.so.9` before starting MATLAB.

During the calibration, the target will flicker for approximately 2 seconds, after that you have 3 seconds to reposition the camera before the next picture is taken. Make sure to take pictures from different angles and distances to the target. Use a tripod in order to minimize camera movement!

A few images are already included in the `data/` folder to test the method without a camera.

The result of the calibration is stored in the following variables:
~~~
Calibration results after optimization (with uncertainties):

Focal Length:          fc = [ 158.85961   158.52668 ] +/- [ 2.81702   2.86259 ]
Principal point:       cc = [ 63.50000   63.50000 ] +/- [ 0.00000   0.00000 ]
Skew:             alpha_c = [ 0.00000 ] +/- [ 0.00000  ]   => angle of pixel axes = 90.00000 +/- 0.00000 degrees
Distortion:            kc = [ -0.19702   0.00000   0.00000   0.00000  0.00000 ] +/- [ 0.01750   0.00000   0.00000   0.00000  0.00000 ]
Pixel error:          err = [ 0.05699   0.05704 ]
~~~
