FROM centos:8

RUN yum -y install epel-release && yum makecache

# crontab system
RUN yum install -y cronie vim && \
    crond -V && rm -rf /etc/cron.*/*
COPY ./crontab-tasks /etc/local/etc/cron.d/crontab-tasks
RUN crontab /etc/local/etc/cron.d/crontab-tasks

# git pull script
RUN yum install -y git
RUN git config --global pull.rebase false
COPY ./gitpuller.sh /usr/local/bin/gitpuller.sh

# for git clone through ssh stuff
RUN mkdir -p /root/.ssh/
RUN echo "Host *" > /root/.ssh/config && echo "StrictHostKeyChecking no" >> /root/.ssh/config

# Cron and docker. See also:
# https://sudonull.com/post/80071-Running-cron-inside-a-docker-container-Redmadrobots-blog
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-n"]
