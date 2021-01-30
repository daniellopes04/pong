# Pong Game
***Lecture 0* on "S50's Intro to Game Development" course, available on [YouTube](https://www.youtube.com/playlist?list=PLWKjhJtqVAbluXJKKbCIb4xd7fcRkpzoz)**
    
Implementation of arcade game ["Pong"](https://pt.wikipedia.org/wiki/Pong).

**Rules:**
- Each player controls a paddle which must be used to hit the ball into the opponent's 
player direction.
- When the player isn't able to hit the ball back, letting it pass beyond its paddle, the 
opponent scores a point.
- By getting 10 points, a player wins the match.

## Objectives

1. ~Implement a version from the game Pong, where the paddles are moved by input detected from the keyboard.~
2. ~Implement an AI version of either paddle of player 1 or 2 (or both).~

## Possible updates

1. Adapt AI movement so it is more close to a human opponent. Currently the movement is too precise and machine-like, so it is basically impossible to score a point in Player vs. Com mode.

## Installation

### Build

First, you have to install [LÖVE2D](https://love2d.org/), then run the following.

```bash
    git clone https://github.com/daniellopes04/pong
    cd pong
    love .
```

### Run

Simply go to ["Resources"](https://github.com/daniellopes04/pong/tree/main/resources) folder and download the version compatible with your system.
