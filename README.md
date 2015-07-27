# docker-xwalk
Dockerfile creating a container for building Crosswalk Android applications 

Run `docker build -t lynx/xwalk-builder <path to the project folder>` to build Docker image.
It sets up everything needed for building JS app. There is no app source code inside the container built.
A folder containing the source code should be mounted into the container as `/src` while running it.

To run the container do: `docker run -it --rm -v <path to the project folder>:/src lynx/xwalk-builder`.
At the end of the Docker script it executes an external `build.sh`. This file contains commands that build a final APK with Crosswalk build tools.

As a result the Crosswalk runtime is bundled with the application. Shared mode option is going to be added to the project soon.

Read more about Crosswalk project here: https://crosswalk-project.org/documentation/android.html
