# Use an existing docker image as a base
# we want to use alpine linux because it already has a package manager on it
FROM alpine

# Download and install a dependency
RUN apk add --update redis

# Tell the image what to do when it starts as a container
CMD ["redis-server"]