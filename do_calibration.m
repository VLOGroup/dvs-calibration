% This file is part of dvs-calibration.
%
% Copyright (C) 2017 Christian Reinbacher <reinbacher at icg dot tugraz dot at>
% Institute for Computer Graphics and Vision, Graz University of Technology
% https:%www.tugraz.at/institute/icg/teams/team-pock/
%
% dvs-calibration is free software: you can redistribute it and/or modify it under the
% terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or any later version.
%
% dvs-calibration is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http:%www.gnu.org/licenses/>.

%% Create calibration target for DVS camera

close all;
clear all;

resolution=[1920,1080];
dvs_executable = 'grabber/grabber&';
addpath helpers/
addpath camera_calibration/
addpath camera_calibration/ICG_functions
template = make_target(96,5,-4:4,-8:6,0);
test_mode = true;
% crop image to resolution
to_crop = round((size(template.pattern)-resolution)/2);
pattern = flipud(template.pattern(to_crop(1)+1:end-to_crop(1),to_crop(2)+1:end-to_crop(2)));
non_pattern=ones(size(pattern));

%% Take Images
if ~test_mode
    for image_id=1:20
        fullscreen(non_pattern,2);
        % start capturing
        pause(0.5);
        system(dvs_executable);
    %     pause(1);
        for i=1:10;
            fullscreen(non_pattern,2);
            pause(0.1);
            fullscreen(pattern,2);
            pause(0.1);
        end
        pause(2);

        % aer_event_viewer(data_files{end},1,5,1);
        [image_plus,image_minus] = get_calib_image_from_event('events.aer2');
        diff_img = image_plus+image_minus;
        diff_img = diff_img-min(diff_img(:));
        diff_img = diff_img./max(diff_img(:));
    %     figure;imshow(histeq(1-(diff_img/max(diff_img(:)))),[]);
    %     image(image==2)=1;
        figure(3);imshow(im2bw(1-diff_img,0.9),[]); 
    %     img_filt = colfilt(image,[3,3],'sliding',@median);
    %     subplot(122);imshow(img_filt,[]);drawnow;
        imwrite(1-diff_img./max(diff_img(:)),fullfile('data',num2str(image_id,'image%02d.jpg')));
        disp('move camera');
        pause(3);
    end
    closescreen;
end

%% Calibrate Camera
cd camera_calibration
toolbox_path = fullfile(pwd,'TOOLBOX_calib/');

if(~exist(toolbox_path, 'dir'))
    !wget http:%www.vision.caltech.edu/bouguetj/calib_doc/download/toolbox_calib.zip
    !unzip toolbox_calib.zip
    !rm toolbox_calib.zip
end

addpath(toolbox_path);
image_dir = '../data';

% Read in images
path__ = pwd;
cd(image_dir);
calib_name = 'image';
format_image = 'jpg';
ima_read_calib;
cd(path__);clear path__

% Set parameters
parameters.approx_marker_width_pixels = 15;
parameters.grid_width_mm = 5;
parameters.image_threshold = [];
parameters.checker_aspect_ratio = 1;
parameters.corner_extraction_method = 'projective';
parameters.target_type = 'circles';
parameters.template_type = 'circles';
parameters.grid_coordinates_h = -4:4;
parameters.grid_coordinates_v = -8:6;
parameters.pixel_size_wh_mm = [6, 6]*1e-3;
parameters.feature_subsampling_rate = 1;
parameters.USE_IPP = 0;

est_aspect_ratio = 0;
check_cond = 0;
center_optim = 0;
est_fc = 0;
est_dist = [1 0 0 0 0]';
est_alpha = 0;
parameters.verbose = 1;
parameters.image_threshold = 0.8;


auto_calib;

go_calib_optim;

cd ..

