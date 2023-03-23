FROM ubuntu:20.04


ARG PYTHON_VERSION=3.8.16 \
    CODE_SERVER_VERSION=4.11.0

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget curl vim openssl git zip jq gettext-base && \
    # code-server
    curl -fsSL https://code-server.dev/install.sh | sh -s -- --version ${CODE_SERVER_VERSION} && \
    # Python
    apt-get install -y build-essential libbz2-dev libdb-dev libreadline-dev libffi-dev libgdbm-dev liblzma-dev libncursesw5-dev libsqlite3-dev libssl-dev zlib1g-dev uuid-dev && \
    cd && git clone https://github.com/pyenv/pyenv.git -b master --depth 1 && \
    pyenv/plugins/python-build/bin/python-build ${PYTHON_VERSION} /usr/local && \
    pip install -U pip  && pip install wheel && \
    rm -rf pyenv && \
    # supervisord
    pip install supervisor && \
    echo_supervisord_conf > /etc/supervisord.conf && \
    mkdir /etc/supervisord.d && \
    sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf && \
    sed -i "s/;\[include\]/\[include\]/" /etc/supervisord.conf && \
    sed -i "s/;files = relative\/directory\/\*\.ini/files = supervisord.d\/*.ini/" /etc/supervisord.conf && \
    # 日本語対応
    apt-get install -y language-pack-ja-base language-pack-ja locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    # クリーニング
    rm -rf /root/.cache && \
    apt-get autoremove && apt-get autoclean && apt-get clean && rm -fr /var/lib/apt/lists/*

COPY ./src/python/requirements.txt /tmp/requirements.txt

# Pythonモジュール
RUN pip install -r /tmp/requirements.txt  && \
    rm -rf /root/.cache && rm -rf /tmp/*


# 必須ファイルコピー
COPY ./src/code-server/User /root/.local/share/code-server/User
#COPY ./src/code/languagepacks.json /root/.local/share/code-server/languagepacks.json
COPY ./src/supervisor /etc/supervisord.d
COPY ./src/start-scripts /dockerstartscript

# 権限設定
RUN chmod -R 755 /dockerstartscript


# コンテナ起動時の実行コマンド設定
ENTRYPOINT [ "/dockerstartscript/supervisor.sh" ]