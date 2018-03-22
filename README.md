# TidyDesktop
Cleans your desktop and puts all files from previous days in daily directory 
## Installation

    $ gem install tidy_desktop

## Usage
    $ tidy_desktop --install
It will create default configuration file at ~/.tidydesktop
```yaml
---
directory: ~/Desktop
target: ~/daily
ignore: []
```
Please review this file and run 

    $ tidy_desktop --install
    
From now on at least once a day your files from yasterdays (and older) will be moved to the ~/daily/%d-%m-%Y directory.
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lectral/tidy_desktop
