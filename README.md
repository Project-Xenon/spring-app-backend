# spring-app-backend
The final Spring App Repo for the backend application. I promise.


## Running the application:
1. I'm going to assume you have JDK 10 installed. If not, please install JDK 10 before proceeding.
2. Have a dockerized Postgresql db server running:
    1. Download [Docker Toolbox](https://docs.docker.com/toolbox/) and [VirtualBox](https://www.virtualbox.org/)
    2. Run `Kitematic` application and go into the settings in the lower left corner to make sure 
       "Use VirtualBox instead of Native on next restart" is selected (and restart if necessary)
    3. Search for `postgresql` and click on "Create" in the lower right corner of the tile. 
       Make sure the text above postgres says `official` so we have the official Docker image of Postgresql DB server.
    4. Once you hit "Create", it should start downloading the image and running it automatically for you. 
       You've basically run a virtual machine that contains nothing except the Postgresql db server at this point. And it's accessible by a URL shown on the right side of the terminal that pops up while the image is running.
    5. Now go into the settings for the image (top right tab) and add the following properties to the environment variables list:
        1. POSTGRES_USER (value create your own or take from application.properties file)
        2. POSTGRES_PASSWORD (same thing as above)
        3. POSTGRES_DB (guess what I'll say)
    6. Click "Save" and go to "Hostname/Ports" tab and change published ip:port's first record's port to 5432. The docker port and published port should both be same. Click "Save" again.
    7. Restart the image (top left button) to be sure all these changes reflect in the image.
3. Install `gradle` (through `homebrew` for macs or `chocolatey` for windows) on your machine.
4. Put `application.properties` in `src/main/java/resources`
4. Through the terminal go to this application's root directory: `gradle run bootRun` to run this Spring App.

__Note: You will require an application.properties file that will need to be placed under `src/main/resources` folder! 
Please ask one of the club officers to provide you with that file on [our Slack channel](ccsu-project-xenon.slack.com).__

#### __Note 2.0: Make sure the values in application.properties for db username, password and db name match the environment variables for the Docker images, otherwise it won't connect to the DB.__ 


## Installation on Linux
1. Install Docker

   This is not trivial and varies depending on your distro. For Ubuntu 18.04, a good resource is https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04.
   
   
    
2. Get the official postgres docker image
    
    `docker pull postgres`
    
    
3. Build the container

    `docker run -d -p 5432:5432 --name xenon -e POSTGRES_PASSWORD=password1 postgres`
    
    
4. Create the database

    `docker exec -it xenon psql -U postgres -c "CREATE DATABASE ccsucsclubdb"`


5. Install gradle

   For swing to properly boot, you will need gradle version 4.0 or higher, which is not available in the standard ubuntu repositories. To get around this, add the following ppa:
    ```
    sudo add-apt-repository ppa:cwchien/gradle
    sudo apt update
    sudo apt install gradle
    ```
    
    
6. Change application.properties file

   In the **application.properties** file (src/main/resources/application.properties), set the configurations as follows:
    ```
    spring.datasource.url=jdbc:postgresql://localhost:5432/ccsucsclubdb
    spring.datasource.username=postgres
    spring.datasource.password=password1
    ```
    
    
7. Boot the application

    `gradle bootRun`
