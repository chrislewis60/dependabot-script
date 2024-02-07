FROM ghcr.io/dependabot/dependabot-core:0.215.0

ARG ROOT_DIR=/home/dependabot
ARG CODE_DIR=/home/dependabot/dependabot-script
ARG DEPENDABOT_BUNDLE_DIR=/home/dependabot/dependabot-script/.bundle/gems/dependabot-npm_and_yarn-0.209.0/lib/dependabot/npm_and_yarn/update_checker/
RUN mkdir -p ${CODE_DIR}
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ${CODE_DIR}/
WORKDIR ${CODE_DIR}

RUN bundle config set --local path "vendor" \
  && bundle install --jobs 4 --retry 3

COPY --chown=dependabot:dependabot . ${CODE_DIR}
COPY --chown=dependabot:dependabot npmrc-docker.sh ${ROOT_DIR}
# CMD bash ../npmrc-docker.sh && npm config list && bundle exec ruby ./generic-update-script.rb
CMD bash ../npmrc-docker.sh && cd ${DEPENDABOT_BUNDLE_DIR} && npm config list && cd ${CODE_DIR} && bundle exec ruby ./generic-update-script.rb

