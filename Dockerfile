FROM openjdk:11-jre-slim

RUN apt-get update && apt-get install -y \
    python \
    wget \
    tini

# install gcloud
ENV GCLOUD_OBJ=google-cloud-sdk-245.0.0-linux-x86_64.tar.gz
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$GCLOUD_OBJ
RUN tar -xf $GCLOUD_OBJ -C /usr/local/
ENV PATH=/usr/local/google-cloud-sdk/bin:$PATH
RUN gcloud components install beta cloud-datastore-emulator

# create data directory
ADD ./ /mnt/data
WORKDIR /mnt/data
RUN mkdir gcd

# configure gcloud
RUN gcloud config set project emulator

EXPOSE  8432/tcp

# start emulator
ENTRYPOINT ["tini", "--"]
CMD ["gcloud", "beta", "emulators", "datastore", "start", "--quiet", "--data-dir", "/mnt/data/gcd", "--host-port", "0.0.0.0:8432"]