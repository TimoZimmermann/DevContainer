#!/bin/bash
set -e

source /opt/ros/jazzy/setup.bash
source /opt/robot_localization_ws/install/setup.bash

if [ -f /ws/install/setup.bash ]; then
    source /ws/install/setup.bash
fi

exec "$@"
