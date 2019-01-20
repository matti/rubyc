# rubyc

## Build a local gem

    docker run -it \
      -e RUBYC_ENTRYPOINT=gemname -e RUBYC_OUTPUT=gemname \
      -v "$(pwd):/gem" \
      mattipaksula/rubyc

## Build a remote gem

    docker run -it \
      -e RUBYC_GEM=gemname \
      -e RUBYC_ENTRYPOINT=gemname -e RUBYC_OUTPUT=gemname \
      mattipaksula/rubyc
