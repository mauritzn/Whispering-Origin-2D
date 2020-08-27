# Whispering-Origin-2D
A 2D top-down RPG game, with a tile-based world. Built with Godot, based on earlier C++ version

**HTML5 Demo:** https://games.mauritzonline.com/game/Whispering-Origin-html5/

---

## Features

- Inventory System *(With stack support)*
- Item drops *(From: Ores, Trees)*
- Leveling *(Mining, Woodcutting)*

<br />


## Skills *(max skill cap 20)*

- Woodcutting
- Mining

<br />


## Skill mechanics

The skill’s level will tell you which tool you can use and which item “tier” you can “use”.

When cutting trees, mining ores the ”item” drops a random amount of items *(from a minimum drop and a maximum drop)*. The amount of XP you get is determined based on how many items dropped.

<br />


## Inventory system

- **Slots:** 24 item slots
- **Items stacks:** yes
- **Max stack size:** 999

Stores items you get from resources like trees, ores. Resource items stack, each stack can contain 999 items, after that a new stack is created. Items can also be non-stackable.

<br />


## Polynomial Progression

The experience system will go after this formula: 
*(current level * 2) ^ 3*


That in return will mean that the system will go after a polynomial progress which is cubed, much similar to the system made with the old game Armada which had *(current level * 8) ^ 3*.

<br />


## Controls

- **WASD:** Up, Left, Down, Right *(arrow keys also work)*
- **Space:** Use tool *(attack mob/hit tree or ore)*
