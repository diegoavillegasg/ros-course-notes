#! /usr/bin/env python3
"""
Launch gazebo only.
See: gazebo_spawn.launch.py
"""
import os

from ament_index_python import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource


MY_NEO_ROBOT = 'mp_400'
MY_NEO_ENVIRONMENT = 'neo_track1'


def generate_launch_description():
    default_world_path = os.path.join(
        get_package_share_directory('neo_simulation2'),
        'worlds', MY_NEO_ENVIRONMENT + '.world'
    )

    gazebo = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(os.path.join(
            get_package_share_directory('gazebo_ros'),
            'launch', 'gazebo.launch.py')
        ),
        launch_arguments={
            'world': default_world_path,
            'verbose': 'true'
        }.items()
    )

    return LaunchDescription([gazebo])
