FROM openjdk:11-jre-slim-buster

RUN apt-get update && apt-get install -y \
    python \
    wget

# install gcloud
ENV GCLOUD_OBJ=google-cloud-sdk-245.0.0-linux-x86_64.tar.gz
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$GCLOUD_OBJ
RUN tar -xf $GCLOUD_OBJ -C /usr/local/
ENV PATH=/usr/local/google-cloud-sdk/bin:$PATH
RUN gcloud components install beta cloud-datastore-emulator

# create staging area
ADD ./ /mnt/data
WORKDIR /mnt/data
RUN mkdir gcd

# configure gcloud
RUN gcloud config set project emulator

# start emulator
CMD ["gcloud", "beta", "emulators", "datastore", "start", "--quiet", "--data-dir", "/mnt/data/gcd", "--host-port", "0.0.0.0:8432"]