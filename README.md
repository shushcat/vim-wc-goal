# WC-Goal

This plugin displays a word count goal in a small popup that sticks in the upper right of your Vim window.  When you reach the goal, the popup disappears.

## Usage

The command `:WCGoal n` sets a word count goal of _n_.  The goal updates every time Vim notices a period of inactivity equal to its internal variable `updatetime`---4 seconds by default---and the popup disappears when the goal is reached.  While a word count popup is already active for a given buffer, entering a positive _n_ will set the goal to that number, a negative _n_ will decrease the goal by that amount, and `:WCGoal 0` calls the whole thing off.

## TODO

- [ ] Implement negative goals, for when you've got to trim things down a bit.
