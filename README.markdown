This is a fork of the [official FlashPunk repo](https://github.com/ChevyRay/FlashPunk/).

You can learn more about FlashPunk at
[http://flashpunk.net](http://flashpunk.net).

ADDITIONS
=========

- **Components**, for reusable entity functionality.
- **Signals**, for lightweight events attached to objects.
- `Entity` class:
    -- Added `created()`, like added, but called by `world.create()`.
    -- Made `moveBy()` return `true` when it actually moves the entity.
- `FP` class:
    -- Added `FP.worldTime` (seconds since world started).
    -- Added `FP.time` (absolute time in seconds, from Flash's getTimer).
- `Image` class:
    -- Added `lock()`/`unlock()` to defer buffer updates, for a performance boost when updating many image properties.
- `Screen` class:
    -- Optional alpha, so you can layer other DisplayObjects under FP.
- `Sfx` class:
    -- Added a `minElapsed` argument to `play()` to rate limit a sound.
- `Spritemap` class:
    -- Animations can be flipped.
    -- Added an `animCount` property.
- `Tilemap` class:
    -- Added `createGrid()` to create a mask from tile indexes.
- `Tween` class:
    -- Added public `updateTween()`, so you can tick tween objects manually from `Graphic` classes.

BUGFIXES
========

Bug fixes with open pull requests have feature branches. Check the branches
list for this repo to see the modifications for that fix, or look at the pull
requests on [ChevyRay's repo](https://github.com/ChevyRay/FlashPunk/pulls).

- Fixed `Entity.render()` and `update()` being called with null world
- Clamped `FP.getColorHSV()` ([pull request](https://github.com/ChevyRay/FlashPunk/pull/77))
- Fixed problems with null parent when using a `Masklist` ([pull request](https://github.com/ChevyRay/FlashPunk/pull/68))
- Fixed `World.registerName()` incorrectly being called before name is set ([pull request](https://github.com/ChevyRay/FlashPunk/pull/73))
- Fixed `Entity.addGraphic()` not actually adding the graphic for a new `Graphiclist` ([pull request](https://github.com/ChevyRay/FlashPunk/pull/72))
- Made image classes `_createBuffer()` dispose of existing buffer objects ([pull request](https://github.com/ChevyRay/FlashPunk/pull/71))
- Fixed `Text` being getting cropped when changed ([pull request](https://github.com/ChevyRay/FlashPunk/pull/70))
- Made `Grid.saveToString()` output 0 and 1, so it works with `Grid.loadFromString()` ([pull request](https://github.com/ChevyRay/FlashPunk/pull/69))

BUILDING
========

This fork has a Rakefile for building on OS X (thought it would probably work
with the Flex SDK on Windows, too). By default, it dumps a debug SWC file
into the bin folder, and builds any projects in the examples folder.

You don't *need* to do any of that, though. You can just copy the net folder
into your project, like normal.
