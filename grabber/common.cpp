// This file is part of dvs-calibration.
//
// Copyright (C) 2017 Christian Reinbacher <reinbacher at icg dot tugraz dot at>
// Institute for Computer Graphics and Vision, Graz University of Technology
// https://www.tugraz.at/institute/icg/teams/team-pock/
//
// dvs-calibration is free software: you can redistribute it and/or modify it under the
// terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or any later version.
//
// dvs-calibration is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
#include "common.h"
#include <fstream>
void saveEvents(std::string filename, std::vector<Event> &events)
{
    // create text file and go through all events
    std::ofstream file;

    file.open(filename.c_str());
    for (int i=0;i<events.size();i++) {
        file << events[i].t << " " << events[i].x << " " << events[i].y << " " << events[i].polarity << std::endl;
    }
    file.close();
}

