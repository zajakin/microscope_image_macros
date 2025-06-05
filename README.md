# microscope_image_macros

docker run -d --hostname=fiji --name=fiji --workdir /home/fiji -p 443:443 -v `pwd`:/home/fiji/data -v cert:/cert:ro --shm-size=2g --restart always ghcr.io/zajakin/microscope_image_macros