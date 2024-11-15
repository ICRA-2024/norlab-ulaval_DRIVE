# Use official ROS 2 Humble base image
FROM ros:humble

# Set shell to bash and enable source command
SHELL ["/bin/bash", "-c"]

# Install git and other dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    python3-dev \
    python3-numpy \
    python3-pandas \
    python3-scipy \
    python3-matplotlib \
    && rm -rf /var/lib/apt/lists/*

# Create and set up the ROS 2 workspace
WORKDIR /ros2_ws
RUN mkdir -p /ros2_ws/src

# Clone the repositories
WORKDIR /ros2_ws/src
RUN git clone https://github.com/ICRA-2024/norlab-ulaval_DRIVE.git && \
    git clone https://github.com/norlab-ulaval/norlab_controllers_ros.git

# Install ROS dependencies using rosdep
WORKDIR /ros2_ws
RUN source /opt/ros/humble/setup.bash && \
    rosdep update && \
    rosdep install --from-paths src -y --ignore-src

# Build the workspace
RUN source /opt/ros/humble/setup.bash && \
    colcon build

# Source the workspace in .bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

# Set the working directory
WORKDIR /ros2_ws

# Default command to open a bash shell
CMD ["bash"]
