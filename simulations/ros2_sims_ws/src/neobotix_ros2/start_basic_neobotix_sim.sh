#! /bin/bash

NEOBOTIX_SIM_PATH=/home/simulations/ros2_sims_ws/install/setup.bash
#NEOBOTIX_SIM_PATH=/home/user/ros2_ws/install/setup.bash
echo "[$(date +'%T')] 🔸️ SOURCE.start $NEOBOTIX_SIM_PATH ..."
source $NEOBOTIX_SIM_PATH
echo "[$(date +'%T')] 🔸️ SOURCE.finish $NEOBOTIX_SIM_PATH ..."
export GAZEBO_MODEL_PATH=/home/simulations/ros2_sims_ws/src/neobotix_ros2/neo_simulation2/models:/home/simulations/ros2_sims_ws/src:/home/simulations/ros2_sims_ws/src/neobotix_ros2
#export GAZEBO_MODEL_PATH=/home/user/ros2_ws/src/neobotix_ros2/neo_simulation2/models:/home/user/ros2_ws/src:/home/user/ros2_ws/src/neobotix_ros2

# ros2 launch neo_simulation2 simulation_basics.launch.py

# -------------------------
# First, launch gazebo only
# -------------------------
ros2 launch neo_simulation2 gazebo_only.launch.py &
gazebo_pid=$!
is_gz_running=false

# ----------------------------------------------------
# Check for up until 60 seconds if gzserver is running
# ----------------------------------------------------
for i in {1..60}; do
    echo "[$(date +'%T')] 🔸️ [$i/60] Checking gzserver running..."

    sudo netstat -lntp | grep ':11345' &> /dev/null
    exit_code=$?

    if [[ $exit_code == 0 ]]; then
        echo "[$(date +'%T')] ✅️ [$i/60] gzserver is running."
        is_gz_running=true
        break
    fi
    sleep 1
done

# -----------------------------------------------------------------------
# If gzserver not running after 60 seconds, let's force container restart
# -----------------------------------------------------------------------
if [[ $is_gz_running == false ]]; then
    echo "[$(date +'%T')] 🍂️ gzserver not running after 60 secs. Exiting."

    rkill -9 ${gazebo_pid} || kill -9 ${gazebo_pid}

    exit 1
fi

# ------------------------------------
# Run robot spawn and other components
# ------------------------------------
echo -e "\033[0m" # Reset color.
echo "[$(date +'%T')] 🔹️ Calling robot spawn, action servers, etc."
ros2 launch neo_simulation2 gazebo_plus.launch.py
