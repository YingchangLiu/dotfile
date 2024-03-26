# Autocomplete for Zsh
This plugin for Zsh adds real-time type-ahead autocompletion to your command line, similar to what
you find desktop apps. While you type on the command line, available completions are listed
automatically; no need to press any keyboard shortcuts. Press <kbd>Tab</kbd> to insert the top
completion or <kbd>↓</kbd> to select a different one.

Additional features:
* Out-of-the-box configuration of Zsh's completion system
* Multi-line history search
* Completion of recent directories
* Useful [keyboard shortcuts](#keyboard-shortcuts)
* Easy to [configure](#configuration)

> Enjoy using this software? [Become a sponsor!](https://github.com/sponsors/marlonrichert) 💝

## Requirements
Recommended:
* Tested to work with [Zsh](http://zsh.sourceforge.net) 5.8 and newer.

Minimum:
* Should theoretically work with Zsh 5.4, but I'm unable to test that.

## Installation & setup
First, install Autocomplete itself. Here are some way to do so:
  * To use only releases (instead of the `main` branch), install `zsh-autocomplete` with a package
    manager. As of this writing, this package is available through Homebrew, Nix, `pacman`, Plumage,
    and (as `app-shells/zsh-autocomplete`) Portage.
  * To always use the latest commit on the `main` branch, do one of the following:
    * Use `pacman` to install `zsh-autocomplete-git`.
    * Use a Zsh plugin manager to install `marlonrichert/zsh-autocomplete`. (If you don't have a
      plugin manager yet, I recommend using [Znap](https://github.com/marlonrichert/zsh-snap).)
    * Clone the repo directly:
      ```sh
      % git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
      ```

After installing, make the following modifications to your shell config:
* In your `.zshrc` file:
  * Remove any calls to `compinit`.
  * Add near the top, _before_ any calls to `compdef`:
     ```sh
     source /path/to/zsh-autocomplete/zsh-autocomplete.plugin.zsh
     ```
* When using **Ubuntu,** add to your `.zshenv` file:
  ```sh
  skip_global_compinit=1
  ```
* When using **Nix,** add to your `home.nix` file:
  ```
  programs.zsh.enableCompletion = false;
  ```

Finally, restart your shell. Here's two ways to do so:
* Open a new tab or window in your terminal.
* Replace the current shell with a new one:
  ```sh
  % exec zsh
  ```

## Keyboard shortcuts
* Depending on your terminal, not all keybindings might be available to you.
* Instead of <kbd>Alt</kbd>, your terminal might require you to press
  <kbd>Escape</kbd>, <kbd>Option</kbd> or <kbd>Meta</kbd>.
* In most terminals, <kbd>Enter</kbd> is interchangeable with <kbd>Return</kbd>,
  but in some terminals, it is not.

### On the command line
| `main` | `emacs` | `vicmd` | `viins` | Action
| -----: | ------: | ------: | ------: | -----:
| | <kbd>Tab</kbd> | | <kbd>Tab</kbd> | Insert top completion
| <kbd>Shift</kbd><kbd>Tab</kbd> | | | | Insert substring occurring in all listed completions
| <kbd>↑</kbd> | <kbd>Ctrl</kbd><kbd>P</kbd> | <kbd>K</kbd> | |  Cursor up _-or-_ [History menu](#history-menu)
| <kbd>↓</kbd> | <kbd>Ctrl</kbd><kbd>N</kbd> | <kbd>J</kbd> | | Cursor down _-or-_ Completion menu
| <kbd>Alt</kbd><kbd>↑</kbd> | <kbd>Alt</kbd><kbd>P</kbd> | <kbd>Shift</kbd><kbd>N</kbd> | | History menu (always)
| <kbd>Alt</kbd><kbd>↓</kbd> | <kbd>Alt</kbd><kbd>N</kbd> | <kbd>N</kbd> | | Completion menu (always)
| | <kbd>Ctrl</kbd><kbd>S</kbd> | <kbd>?</kbd> | | Search through _all_ menu text
| | <kbd>Ctrl</kbd><kbd>R</kbd> | <kbd>/</kbd> | | Toggle [history search mode](#real-time-history-search) on/off

### In the menus
| Key(s) | Action |
| -----: | ------
| <kbd>↑</kbd> <kbd>↓</kbd> <kbd>←</kbd> <kbd>→</kbd> | Change selection
| <kbd>Alt</kbd><kbd>↑</kbd> | Backward one group (completion only)
| <kbd>Alt</kbd><kbd>↓</kbd> | Forward one group (completion only)
| <kbd>PgUp</kbd><br><kbd>Alt</kbd><kbd>V</kbd> | Page up
| <kbd>PgDn</kbd><br><kbd>Ctrl</kbd><kbd>V</kbd> | Page down
| <kbd>Ctrl</kbd><kbd>S</kbd> | Enter search mode _-or-_ Go to next match
| <kbd>Ctrl</kbd><kbd>R</kbd> | Enter search mode _-or-_ Go to previous match
| <kbd>Tab</kbd><br><kbd>Enter</kbd> | Exit search mode _-or-_ Exit menu
| <kbd>Ctrl</kbd><kbd>Space</kbd> | Add another completion
| <kbd>Ctrl</kbd><kbd>-</kbd><br><kbd>Ctrl</kbd><kbd>/</kbd> | Remove last completion
| <kbd>Ctrl</kbd><kbd>G</kbd> | Remove all completions
| Other keys | Depends on the keymap from which you opened the menu. See the Zsh manual on [menu selection](https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#Menu-selection).

## Configuration
The following are the most commonly requested ways to configure Autocomplete's
behavior.  Add these to your `.zshrc` file to use them.

### Pass arguments to `compinit`

If necessary, you can let Autocomplete pass arguments to `compinit` as follows:
```sh
zstyle '*:compinit' arguments -D -i -u -C -w
```

### Reassign <kbd>Tab</kbd>
You can reassign <kbd>Tab</kbd> to do something else than the default.  This
includes letting another plugin set it.  Here are two examples of what you can
do with this:

#### Make <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> cycle completions on the command line
```zsh
bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
```

#### Make <kbd>Tab</kbd> go straight to the menu and cycle there
```zsh
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
```

### First insert the common substring
You can make any completion widget first insert the longest sequence of characters
that will complete to all completions shown, if any, before inserting actual completions:
```zsh
# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes

# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
```

#### Insert prefix instead of substring
When using the above, if you want each widget to first try to insert only the longest _prefix_ that
will complete to all completions shown, if any, then add the following:
```zsh
zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
```
Note, though, that this will also slightly change what completions are listed initially. This is a
limitation of the underlying implementation in Zsh.

### Make <kbd>Enter</kbd> submit the command line straight from the menu
By default, pressing <kbd>Enter</kbd> in the menu search exits the search and
pressing it otherwise in the menu exits the menu.  If you instead want to make
<kbd>Enter</kbd> _always_ submit the command line, use the following:
```zsh
bindkey -M menuselect '\r' .accept-line
```

### Add or don't add a space after certain completions
When inserting a completion, a space is added after certain types of
completions.  The default list is as follows:
```zsh
zstyle ':autocomplete:*' add-space \
    executables aliases functions builtins reserved-words commands
```
Modifying this list will change when a space is inserted.  If you change the
list to `'*'`, a space is always inserted.  If you put no elements in the list,
then a space is never inserted.

### Use a custom backend for recent directories
Autocomplete comes with its own backend for keeping track of and listing recent
directories (which uses part of
[`cdr`](https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Recent-Directories)
under the hood).  However, you can override this and supply Autocomplete with
recent directories from any source that you like.  To do so, define a function
like this:
```zsh
+autocomplete:recent-directories() {
  typeset -ga reply=( [code that generates an array of absolute paths] )
}
```

### Add a backend for recent files
Out of the box, Autocomplete doesn't track or offer recent files. However, it
will do so if you add a backend for it:
```zsh
+autocomplete:recent-files() {
  typeset -ga reply=( [code that generates an array of absolute paths] )
}
```

### Start each new line in history search mode
This will make Autocomplete behave as if you pressed <kbd>Ctrl</kbd><kbd>R</kbd> at the start of each new command line:
```zsh
zstyle ':autocomplete:*' default-context history-incremental-search-backward
```

### Wait for a minimum amount of input
To suppress autocompletion until a minimum number of characters have been typed:
```zsh
zstyle ':autocomplete:*' min-input 3
```

### Wait with autocompletion until typing stops for a certain amount of seconds
Normally, Autocomplete fetches completions after you stop typing for about 0.05 seconds. You can change this as follows:
```zsh
zstyle ':autocomplete:*' delay 0.1  # seconds (float)
```

### Don't show completions if the current word matches a pattern
For example, this will stop completions from showing whenever the current word consists of two or more dots:
```zsh
zstyle ':autocomplete:*' ignored-input '..##'
```

## Limit the number of lines shown
By default, Autocomplete lets the history menu fill half of the screen, and limits autocompletion and history search
to a maximum of 16 lines.  You can change these limits as follows:

```zsh
# Autocompletion
zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( $(( LINES / 3 )) )'

# Override history search.
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8

# History menu.
zstyle ':autocomplete:history-search-backward:*' list-lines 256
```

Note that for autocompletion and history search, the maximum number of lines is additionally capped to the number of
lines that fit on screen.  However, there is no such limit for the history menu.  If that generates more lines than fit
on screen, you can simply scroll upwards to see more.

### Reset history key bindings to Zsh default
Add any of the following to your `.zshrc` file _after_ sourcing Autocomplete:

#### Reset <kbd>↑</kbd> and <kbd>↓</kbd>
```zsh
() {
   local -a prefix=( '\e'{\[,O} )
   local -a up=( ${^prefix}A ) down=( ${^prefix}B )
   local key=
   for key in $up[@]; do
      bindkey "$key" up-line-or-history
   done
   for key in $down[@]; do
      bindkey "$key" down-line-or-history
   done
}
```

#### Preserve Zsh-default keybindings
To prevent Autocomplete from overriding a default keybinding, add a `.` in front of the widget's name. For example:
```
bindkey '^R' .history-incremental-search-backward
bindkey '^S' .history-incremental-search-forward
```

## Troubleshooting
Try the steps in the
[bug report template](.github/ISSUE_TEMPLATE/bug-report.md).

## Author
© 2020-2023 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License.  See the [LICENSE](LICENSE) file
for details.
