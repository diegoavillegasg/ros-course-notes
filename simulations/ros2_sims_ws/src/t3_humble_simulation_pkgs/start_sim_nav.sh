#! /usr/bin/env bash

# We remove a folder that otherwise gives issues in ROS2 launches
sudo rm -r /home/user/.ros

# We set up the environment for ROS2
. /usr/share/gazebo/setup.sh
. /home/simulations/ros2_sims_ws/install/setup.bash
export GAZEBO_RESOURCE_PATH=/home/simulations/ros2_sims_ws/src/t3_humble_simulation_pkgs/turtlebot3/turtlebot3_simulations/turtlebot3_gazebo:${GAZEBO_RESOURCE_PATH}
export GAZEBO_MODEL_PATH=/home/simulations/ros2_sims_ws/src/t3_humble_simulation_pkgs/turtlebot3/turtlebot3_simulations/turtlebot3_gazebo/models:${GAZEBO_MODEL_PATH}
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_tc_world.launch.py
