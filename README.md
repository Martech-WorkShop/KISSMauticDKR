``` 
               _  _____ ____ ____                        _   _      ____  _  ______
              | |/ /_ _/ ___/ ___| _ __ ___   __ _ _   _| |_(_) ___|  _ \| |/ /  _ \ 
              | ' / | |\___ \___ \| '_ ` _ \ / _` | | | | __| |/ __| | | | ' /| |_) |
              | . \ | | ___) |__) | | | | | | (_| | |_| | |_| | (__| |_| | . \|  _ < 
              |_|\_\___|____/____/|_| |_| |_|\__,_|\__,_|\__|_|\___|____/|_|\_\_| \_\

```
# Pull & Play, very verbose, KISS Dockerfile for Mautic 5.1.1

This Dockerfile concentrates on simplicity and convenience for the person deploying the image,
as well as clarity and verboseness for those wanting to understand what is going in the container.

This adds a bit of complexity on the dockerfile itself, and breaks the one service per 
container rule, by design.
It installs all the components required to run Mautic in one single Docker container.
It deploys Apache2, PHP-FPM, MariaDB and Mautic, as well as many required packages
and some configuration files for those services.

The database is prepopulated with a user and a Mautic database as well as the Mautic DB schema,
so you don't have to go through Mautic's installation (wizard) process.

# How to use:
## Deploy from DockerHub
The easiest way to use this image is to deploy it directly from the Docker Hub, use this command:
docker run -d
## Clone this repo and build



How to use:
Run from docker hub (recommended)

docker run -d --name KISSmauticDKR -p 8080:80 martechws/kiss-mautic:5.1.1 Use your browser to navigate to http://localhost:8080
To login into the container:

docker exec -ti KISSmauticDKR bash
Build locally
git clone Martech-WorkShop/KISSMauticDKR docker build -f 511.Dockerfile . -t KISSmauticDKR:5.1.1 docker run -d --name KISSmauticDKR -p 8080:80 martechws/kiss-mautic:5.1.1 docker exec -ti KISSmauticDKR bash





## Intended uses: 
 - A simple way to test Mautic, pull & play.
 - A live overview of Mautic requirements.
 - A starting point for Mautic code exploration and tinkering.
 - A way to learn about Dockerization, Dockerfiles and Docker image creation.

It is NOT meant as a production ready image.

If you have any ideas how to make it clearer or simpler, please send me an email, submit a PR or an Issue.

We use ARGuments to parametrize the build-time parameters.
While Debian is the only OS supported by this Dockerfile,
you should be able to try other versions of Debian by adjusting the OS_VER ARG.

This particular Dockerfile is intended for documentation.
There is a properly optimized verion of this dockerfile without comments and with RUN commands grouped.

All the files for this dockerfile are on this GitHub repository:
https://github.com/Martech-WorkShop/toolBelt

```


                                 --                                   
                           ((((((()))))))                              
                      ((((((((         ))))))                          
                   (((((                      ,                     
                ((((                        ***    )))                  
              ((((                        ****      )))           
             ((((          ,             ****        )))                 
            (((           ****         ****           )))              
           (((           *******     *****             )))             
           (((          ********** ******  **          )))             
           (((         ****   *********   ****         )))             
           (((        ****     ******      ****        )))             
           (((       ****         *         ****       )))             
            (((     ****                     ****     )))              
             ((((                                   ))))               
               (((                                 )))                 
                (((((                           )))))                  
                   (((((                     )))))                     
                       (((((((         )))))))                        
                            (((((()))))))                              
                                 --                                   
                      _     _                _                   
                     | |   | |              | |                  
           ________  | | __| |_  ____     __| |  ___ __   __     
          |  _   _ \ | |/ /| __|/ _  |   / _  | / _ \  \ / /           
          | | | | | ||   < | |_| (_| | _| (_| ||  __/ \ V /      
          |_| |_| |_||_|\_\ \__|\___ |(_)\____| \___|  \_/       
                         _       __/ |                           
                        | |     |___/                            
   ________   ____ _   _| |_ ___  ____ _______        ___  ____ ____ 
  |  _   _ \ / _  | | | | __/ _ \/ _  |  _   _ \     / _ \|  __/ _  |
  | | | | | | (_| | |_| | ||  __/ (_| | | | | | | _  |(_) | | | (_| |
  |_| |_| |_|\__,_|\__,_|\__\___|\__,_|_| |_| |_|(_) \___/|_|  \__, |
                                                                __/ |
                                                               |___/ 
                                                                         
```


