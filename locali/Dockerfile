FROM ros:jazzy

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

ARG ROBOT_LOCALIZATION_REPO=https://github.com/cra-ros-pkg/robot_localization.git
ARG ROBOT_LOCALIZATION_SHA

ARG FLORIBOT_BASE_REPO=https://github.com/Team-FloriBot/FloriBot4.0_ROS2_Jazzy_Base.git
ARG FLORIBOT_BASE_REF=main

RUN [[ "${ROBOT_LOCALIZATION_SHA}" =~ ^[0-9a-f]{40}$ ]] || \
    (echo "ROBOT_LOCALIZATION_SHA must be a 40-character git commit hash" && exit 1)

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    cmake \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    python3-numpy \
    libeigen3-dev \
    libboost-dev \
    geographiclib-tools \
    libgeographiclib-dev \
    ros-jazzy-rmw-cyclonedds-cpp \
    ros-jazzy-rclcpp \
    ros-jazzy-rclpy \
    ros-jazzy-std-msgs \
    ros-jazzy-std-srvs \
    ros-jazzy-geometry-msgs \
    ros-jazzy-nav-msgs \
    ros-jazzy-sensor-msgs \
    ros-jazzy-geographic-msgs \
    ros-jazzy-diagnostic-msgs \
    ros-jazzy-diagnostic-updater \
    ros-jazzy-angles \
    ros-jazzy-tf2 \
    ros-jazzy-tf2-ros \
    ros-jazzy-tf2-eigen \
    ros-jazzy-tf2-geometry-msgs \
    ros-jazzy-tf2-sensor-msgs \
    ros-jazzy-message-filters \
    ros-jazzy-yaml-cpp-vendor \
    ros-jazzy-rosidl-default-generators \
    ros-jazzy-rosidl-default-runtime \
    ros-jazzy-launch \
    ros-jazzy-launch-ros \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/robot_localization_ws

RUN mkdir -p /opt/robot_localization_ws/src

RUN git clone ${ROBOT_LOCALIZATION_REPO} /opt/robot_localization_ws/src/robot_localization && \
    cd /opt/robot_localization_ws/src/robot_localization && \
    git checkout ${ROBOT_LOCALIZATION_SHA}

RUN rosdep init 2>/dev/null || true
RUN rosdep update || true

RUN apt-get update && \
    source /opt/ros/jazzy/setup.bash && \
    rosdep install --from-paths /opt/robot_localization_ws/src --ignore-src -r -y && \
    rm -rf /var/lib/apt/lists/*

RUN source /opt/ros/jazzy/setup.bash && \
    cd /opt/robot_localization_ws && \
    colcon build --symlink-install

WORKDIR /ws

RUN git clone --branch ${FLORIBOT_BASE_REF} --depth 1 ${FLORIBOT_BASE_REPO} /tmp/floribot_base && \
    mkdir -p /ws/config /ws/bags && \
    cp -r /tmp/floribot_base/config/* /ws/config/ && \
    test -f /ws/config/localization/local_ekf.yaml && \
    rm -rf /tmp/floribot_base

RUN echo "source /opt/ros/jazzy/setup.bash" >> /etc/bash.bashrc && \
    echo "source /opt/robot_localization_ws/install/setup.bash" >> /etc/bash.bashrc

COPY locali/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["ros2", "run", "robot_localization", "ekf_node", "--ros-args", "--params-file", "/ws/config/localization/local_ekf.yaml"]
