#!/usr/bin/env sh
set -e

if [ "${RUBYC_SERVER}" = "true" ]; then
  cd /app
  exec ruby app.rb
fi

if [ "${RUBYC_CPUS}" = "" ]; then
  export RUBYC_CPUS="$((`nproc`+1))"
fi

if [ "${RUBYC_GEM}" != "" ]; then
  cd /tmp
  gem unpack "${RUBYC_GEM}"
  cp -R /tmp/${RUBYC_GEM}*/* /gem
  ls -la /gem
else
  :
fi

if [ "${RUBYC_ENTRYPOINT}" = "" ]; then
  echo "RUBYC_ENTRYPOINT must be set to executable"
  exit 1
fi

if [ "${RUBYC_OUTPUT}" = "" ]; then
  echo "RUBYC_OUTPUT must be set"
  exit 1
fi

if [ "${RUBYC_URL}" != "" ]; then
  curl -sL "${RUBYC_URL}" | gunzip > /usr/local/bin/rubyc
  chmod +x /usr/local/bin/rubyc
fi

mkdir -p /cache
cd /gem

exec rubyc --openssl-dir=/etc/ssl \
      -o /build/"${RUBYC_OUTPUT}" \
      -d /cache \
      --make-args="-j${RUBYC_CPUS}" \
      "${RUBYC_ENTRYPOINT}"
