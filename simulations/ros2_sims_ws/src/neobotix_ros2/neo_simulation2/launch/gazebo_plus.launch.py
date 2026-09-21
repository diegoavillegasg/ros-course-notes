#! /usr/bin/env python3
# Neobotix GmbH
"""
What this launch file launches:
    1. Robot spawn
    2. Robot State Publisher
    3. Moving service
    4. Stop service
    5. Move Robot Action Server.

Gazebo is launched with gazebo_only.launch.py
"""
import os

from ament_index_python import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node


MY_NEO_ROBOT = 'mp_400'
MY_NEO_ENVIRONMENT = 'neo_track1'


def generate_launch_description():

    use_sim_time = LaunchConfiguration('use_sim_time', default='true')

    urdf = os.path.join(get_package_share_directory(
        'neo_simulation2'), 'robots/'+MY_NEO_ROBOT+'/', MY_NEO_ROBOT+'.urdf'
    )

    spawn_entity = Node(
        package='gazebo_ros',
        executable='spawn_entity.py',
        arguments=['-entity', MY_NEO_ROBOT, '-file',
                   urdf, '-spawn_service_timeout', '30.0'],
        output='screen'
    )

    start_robot_state_publisher_cmd = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        name='robot_state_publisher',
        output='screen',
        parameters=[{'use_sim_time': use_sim_time}],
        arguments=[urdf]
    )

    moving_srv = Node(
        package='services_pkg',
        executable='service',
        output='screen'
    )

    stop_srv = Node(
        package='services_pkg',
        executable='service2',
        output='screen'
    )

    move_robot_as_pkg_prefix = get_package_share_directory('move_robot_as')
    move_robot_as_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            [move_robot_as_pkg_prefix, '/launch/action_server.launch.py']),
        launch_arguments={}.items()
    )

    return LaunchDescription([
        spawn_entity,
        start_robot_state_publisher_cmd,
        moving_srv,
        stop_srv,
        move_robot_as_launch
    ])
