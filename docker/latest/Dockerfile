# Do not add --platform=linux/blabla since this is intended for multiplatform builds
FROM nvidia/cuda:13.0.0-cudnn-devel-ubuntu24.04
ENV HOME=${HOME_FOLDER}
WORKDIR ${HOME_FOLDER}/

# Fix apt install stuck problem
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Copy home folder config
COPY --from=home-folder-config . ${HOME_FOLDER}/

# Remove cuda source list
# E: Failed to fetch https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/Packages.gz File has unexpected size (853674 != 833365). Mirror sync in progress? [IP: 23.58.157.10 443]
RUN rm /etc/apt/sources.list.d/cuda.list

# update all obsolete packages to latest, install sudo, and cleanup
RUN apt update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true && \
    apt full-upgrade -y && \
    apt install -y sudo ca-certificates && \
    apt autoremove -y && \
    apt autoclean -y

# fix local time problem
RUN apt-get install -y --no-install-recommends tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    echo "America/New_York" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

# update all obsolete packages to latest, install sudo, and cleanup
RUN apt update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true && \
    apt full-upgrade -y && \
    apt install -y sudo ca-certificates && \
    apt autoremove -y && \
    apt autoclean -y

    # Install some goodies
RUN apt-get install -y --no-install-recommends \
    build-essential \
    clang-format \
    curl \
    dirmngr \
    git \
    gnupg \
    htop \
    less \
    locate \
    lsb-release \
    nano \
    ncdu \
    net-tools \
    perl \
    screen \
    software-properties-common \
    tmux \
    tmuxp \
    tree \
    unzip \
    valgrind \
    vim \
    wget \
    zsh

# upgrade cmake to kitware official apt-get repo release version
RUN wget https://apt-get.kitware.com/kitware-archive.sh -O- | sh -s && \
    apt-get upgrade -y cmake && \
    apt-get autoremove -y

# # Add a new group and user
# RUN addgroup --gid 1000 $USER && \
#     adduser --uid 1000 --ingroup $USER --home ${HOME_FOLDER} --shell /bin/zsh --disabled-password --gecos "" $USER && \
#     echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# # Fix UID/GID when mounting from host using this: https://github.com/boxboat/fixuid
# RUN curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.6.0/fixuid-0.6.0-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
#     chown root:root /usr/local/bin/fixuid && \
#     chmod 4755 /usr/local/bin/fixuid && \
#     mkdir -p /etc/fixuid

# install zsh, Oh-My-Zsh, and plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/latest/download/zsh-in-docker.sh)" -- \
    -t https://github.com/romkatv/powerlevel10k \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -a "[[ ! -f ${HOME_FOLDER}/.p10k.zsh ]] || source ${HOME_FOLDER}/.p10k.zsh" \
    -a "POWERLEVEL9K_DISABLE_GITSTATUS=true" \
    -a "bindkey -M emacs '^[[3;5~' kill-word" \
    -a "bindkey '^H' backward-kill-word" \
    -a "autoload -U compinit && compinit" \
    -a "export PATH=~/.local/bin:${PATH}"

# change default shell for the $USER in the image building process for extra environment safety
RUN chsh -s $(which zsh)

# Use bash -lc for conda commands in build layers
SHELL ["/bin/bash", "-lc"]

# Install miniconda at /opt/conda
RUN wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh" -O ~/miniconda.sh && \
    sh ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

# Add conda to PATH
ENV PATH=${PATH}:/opt/conda/bin

# Init conda for zsh
RUN conda init zsh

#! Examples of actual dependency install:
# #! Install OpenCV 4.2.0 with QUIRC support from source
# ENV OPENCV_VERSION=4.2.0
# RUN pip3 uninstall -y opencv && \
#     apt install -y --no-install-recommends libavcodec-dev libavformat-dev libswscale-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgtk-3-dev libpng-dev libjpeg-dev && \
#     git clone --depth 1 --recursive https://github.com/opencv/opencv.git ${HOME_FOLDER}/opencv -b $OPENCV_VERSION && \
#     #  follow the error information，replace all the “ipcp-unit-growth” with “ipa-cp-unit-growth” in 3rdparty/carotene/CMakeLists.txt and 3rdparty/carotene/hal/CMakeLists.txt
#     perl -pi -e 's/ipcp-unit-growth/ipa-cp-unit-growth/g' ${HOME_FOLDER}/opencv/3rdparty/carotene/CMakeLists.txt ${HOME_FOLDER}/opencv/3rdparty/carotene/hal/CMakeLists.txt && \
#     git clone --depth 1 --recursive https://github.com/opencv/opencv_contrib.git ${HOME_FOLDER}/opencv_contrib -b $OPENCV_VERSION && \
#     mkdir -p ${HOME_FOLDER}/opencv/build && \
#     cd ${HOME_FOLDER}/opencv/build && \
#     cmake \
#     -D CMAKE_CXX_STANDARD=20 \
#     -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
#     -D OPENCV_GENERATE_PKGCONFIG=ON \
#     -D BUILD_opencv_python3=ON \
#     -D OPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python3.8/dist-packages \
#     # -D OPENCV_ENABLE_NONFREE=ON \
#     -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
#     # -D WITH_LAPACK=ON \
#     -D WITH_GTK=ON \
#     -D WITH_TBB=ON \
#     # -D WITH_QUIRC=ON \
#     -D WITH_GSTREAMER=ON \
#     -D WITH_V4L=ON \
#     # -D WITH_OPENGL=ON \
#     -D BUILD_TESTS=OFF \
#     -D BUILD_PERF_TESTS=OFF \
#     -D BUILD_EXAMPLES=OFF \
#     -D CMAKE_BUILD_TYPE=RELEASE \
#     -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
#     make install -j$(($(nproc)-1)) && \
#     echo "export OpenCV_DIR=/usr/local/lib/cmake/opencv4/" >> ${HOME_FOLDER}/.zshrc && \
#     echo "export OpenCV_DIR=/usr/local/lib/cmake/opencv4/" >> ${HOME_FOLDER}/.bashrc && \
#     rm -rf ${HOME_FOLDER}/opencv && \
#     rm -rf ${HOME_FOLDER}/opencv_contrib

# Add git safe directory
RUN git config --global --add safe.directory "*"

# end of sudo apt installs
RUN apt full-upgrade -y && \
    apt autoremove -y && \
    apt autoclean -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

# change owner of home folder
RUN chown -R ${IMAGE_USER}:${IMAGE_USER} ${HOME_FOLDER}

# change user
USER ${IMAGE_USER}

# Set the default shell to zsh
SHELL [ "/bin/zsh", "-c" ]

# # move fixuid config
# RUN mv ${HOME_FOLDER}/fixuid-config.yml /etc/fixuid/config.yml

# Entrypoint command
# ENTRYPOINT [ "/bin/sh" , "-c", "fixuid; /bin/zsh" ]
ENTRYPOINT [ "/bin/zsh" ]
