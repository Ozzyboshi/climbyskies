# climbyskies compiler docker image 

This image lets you compile and build the Amiga adf file of the game 'climbyskies' out of the github official source repository located at https://github.com/alpine9000/climbyskies
The compile process is quite long and error prone even if the author published some instructions here : https://github.com/alpine9000/climbyskies/blob/master/docs/BuildingCrossDev.md that is why i Built this Docker image.

## Instructions

```
cd
git clone https://github.com/alpine9000/climbyskies.git
cd climbyskies/game
tar zxvf climbyskies-assets.tgz
cd
docker run --rm -it -v $HOME/climbyskies:/project/repos/climbyskies ozzyboshi/climbyskies
```

at this point you should look for ~/climbyskies/game/bin, this directory contains the full adf file of the game.

to clean just type

```
docker run --rm -it -v $HOME/climbyskies:/project/repos/climbyskies ozzyboshi/climbyskies make clean
```

Warning: the climbyskies-assets.tgz file is not included in the official repository due to copyright issues on the music files (assets/P61*.bin), you can use your own music producing your own custom P61.climbyskies_ingame_a.bin, P61.climbyskies_ingame_b.bin and P61.climbyskies_ingame_c.bin files.

Have fun with climbyskies!
