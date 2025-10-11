# Do not add --platform=linux/blabla since this is intended for multiplatform builds
FROM tomnotch/bipvrobotics-base-image:latest
ENV HOME_FOLDER=/root
WORKDIR $HOME_FOLDER/

# Fix apt install stuck problem
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# update all obsolete packages to latest, install sudo, and cleanup
RUN apt update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true && \
    apt full-upgrade -y && \
    apt install -y sudo ca-certificates && \
    apt autoremove -y && \
    apt autoclean -y

# # Add a new group and user
# RUN addgroup --gid 1000 $USER && \
#     adduser --uid 1000 --ingroup $USER --home $HOME_FOLDER --shell /bin/zsh --disabled-password --gecos "" $USER && \
#     echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# # Fix UID/GID when mounting from host using this: https://github.com/boxboat/fixuid
# RUN curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.6.0/fixuid-0.6.0-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
#     chown root:root /usr/local/bin/fixuid && \
#     chmod 4755 /usr/local/bin/fixuid && \
#     mkdir -p /etc/fixuid

# # Switch to the new user
# USER $USER:$USER

#! Install OpenCV 4.2.0 with QUIRC support from source
ENV OPENCV_VERSION=4.2.0
RUN pip3 uninstall -y opencv && \
    apt install -y --no-install-recommends libavcodec-dev libavformat-dev libswscale-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgtk-3-dev libpng-dev libjpeg-dev && \
    git clone --depth 1 --recursive https://github.com/opencv/opencv.git $HOME_FOLDER/opencv -b $OPENCV_VERSION && \
    #  follow the error information，replace all the “ipcp-unit-growth” with “ipa-cp-unit-growth” in 3rdparty/carotene/CMakeLists.txt and 3rdparty/carotene/hal/CMakeLists.txt
    perl -pi -e 's/ipcp-unit-growth/ipa-cp-unit-growth/g' $HOME_FOLDER/opencv/3rdparty/carotene/CMakeLists.txt $HOME_FOLDER/opencv/3rdparty/carotene/hal/CMakeLists.txt && \
    git clone --depth 1 --recursive https://github.com/opencv/opencv_contrib.git $HOME_FOLDER/opencv_contrib -b $OPENCV_VERSION && \
    mkdir -p $HOME_FOLDER/opencv/build && \
    cd $HOME_FOLDER/opencv/build && \
    cmake \
    -D CMAKE_CXX_STANDARD=20 \
    -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D BUILD_opencv_python3=ON \
    -D OPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python3.8/dist-packages \
    # -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    # -D WITH_LAPACK=ON \
    -D WITH_GTK=ON \
    -D WITH_TBB=ON \
    # -D WITH_QUIRC=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_V4L=ON \
    # -D WITH_OPENGL=ON \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
    make install -j$(($(nproc)-1)) && \
    echo "export OpenCV_DIR=/usr/local/lib/cmake/opencv4/" >> ${HOME_FOLDER}/.zshrc && \
    echo "export OpenCV_DIR=/usr/local/lib/cmake/opencv4/" >> ${HOME_FOLDER}/.bashrc && \
    rm -rf $HOME_FOLDER/opencv && \
    rm -rf $HOME_FOLDER/opencv_contrib

# end of sudo apt installs
RUN apt full-upgrade -y && \
    apt autoremove -y && \
    apt autoclean -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

# Set the default shell to zsh
SHELL [ "/bin/zsh", "-c" ]

# # move fixuid config
# RUN mv $HOME_FOLDER/fixuid-config.yml /etc/fixuid/config.yml

# Entrypoint command
# ENTRYPOINT [ "/bin/sh" , "-c", "fixuid; /bin/zsh" ]
ENTRYPOINT [ "/bin/zsh" ]
