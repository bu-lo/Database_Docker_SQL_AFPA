# Image constuire à partir de "docker/whalesay"

FROM nathanbetts/whalesay

# Mise à jour du conteneur

RUN apt-get -y update

# Installation de l'application "fortunes"

RUN apt-get install -y fortunes

# Re-direction d'un message de fortune vers cowsay pour faire parler la baleine

CMD /usr/games/fortune | cowsay


