/*
 Copyright (C) 2021 Fredrik Öhrström

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include"dvparser.h"
#include"meters.h"
#include"meters_common_implementation.h"
#include"wmbus.h"
#include"wmbus_utils.h"
#include"util.h"

#include<assert.h>

using namespace std;

struct MeterAuto : public virtual MeterCommonImplementation {
    MeterAuto(MeterInfo &mi, DriverInfo &di);

    void processContent(Telegram *t);
};

bool ok = registerDriver([](DriverInfo&di)
{
    di.setName("auto");
    di.setMeterType(MeterType::AutoMeter);
    di.setConstructor([](MeterInfo& mi, DriverInfo& di){ return shared_ptr<Meter>(new MeterAuto(mi, di)); });
});

MeterAuto::MeterAuto(MeterInfo &mi, DriverInfo &di) : MeterCommonImplementation(mi, di)
{
}

shared_ptr<Meter> createAuto(MeterInfo &mi)
{
    DriverInfo di;
    di.setName("auto");
    return shared_ptr<Meter>(new MeterAuto(mi, di));
}

void MeterAuto::processContent(Telegram *t)
{
}
