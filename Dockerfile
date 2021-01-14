FROM python:3.7.6-stretch

EXPOSE 5000

RUN apt-get update && \
  apt-get install --yes --no-install-recommends chromium=73.0.3683.75-1~deb9u1

ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} validata && \
  useradd -u ${uid} -g ${gid} --create-home --shell /bin/bash validata

# Cf https://bugs.chromium.org/p/chromium/issues/detail?id=638180 and https://blog.ineat-conseil.fr/2018/08/executer-karma-avec-chromeheadless-dans-un-conteneur-docker/
USER validata

WORKDIR /home/validata/

COPY --chown=validata:validata requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

CMD gunicorn --workers 4 --bind 0.0.0.0:5000 validata_ui:app
