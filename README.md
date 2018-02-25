# MahjongBlockchain

This is classic [mahjong solitaire game](https://en.wikipedia.org/wiki/Mahjong_solitaire) improved by superpower of **blockchain**.

All steps are writing into blockchain and if you make a mistake, you can back a few steps back in order to correct this mistake. This mechanism use information in previous blocks on blockchain to retrieve nessesary information about your previous steps.

# How to run

Install docker & docker-compose

```
curl https://get.docker.com/ | sh
sudo pip install docker-compose
```

Run containters:

```
docker-compose up --build
```

# Or

You can try deployed version [on this site](http://kosmose.me:8585). But this site are working on very small machine, so it can leads to slow running, infinite loading, etc.
