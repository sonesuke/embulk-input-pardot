FROM openjdk:8

RUN curl --create-dirs -o ~/.embulk/bin/embulk -L "https://dl.embulk.org/embulk-latest.jar" \
    && chmod +x ~/.embulk/bin/embulk \
    && echo 'export PATH="$HOME/.embulk/bin:$PATH"' >> ~/.bashrc

RUN apt-get update \
    && apt-get install -y ruby ruby-dev build-essential

RUN gem install bundler:1.16.0