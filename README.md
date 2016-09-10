#  NODETALKING

## A. Summary

Paranoid that a restricted **host/port** is open to the public? Then `nodetalking` is for you! `nodetalking` is designed to check connections to a list of host:port(s) from an unprivileged host. Out of the box, it was written to work with Nagios, but you can easily modify the code to implement your own notifications!

## B. Dependencies

 * nc

## C. Supported Systems

`nodetalking` can be run from any system that meets the above dependencies and runs a modern version of BASH (3.2+).

It has been tested on macOS (`netcat`) and CentOS Linux 6 & 7 (`nc`).

### Installation

Clone this repo to your preferred directory (eg: /opt/nodetalking)

  `git clone https://github.com/curtis86/nodetalking`


### Usage

First you will need to define a list of host:port(s) to check. This is defined in the `hosts.txt` file.

For example, to check host `1.2.3.4` for port `22`, add the following line:

```
1.2.3.4,22
```

You can add multiple ports to a single host by comma-separating them:
```
1.2.3.4,22,443,500
```

### Sample output

```
# ./nodetalking
# CRITICAL: Ports OPEN: 1.2.3.4:22
```

In accordance with Nagios exit codes, the following codes are generated:

* Exit code 0: No open ports found (OK)
* Exit code 1: No hosts configured (WARNING)
* Exit code 2: Open ports found (CRITICAL)

## Warnings

Due to the port-checking nature of this script, to protect themselves, some networks may block your host due to port-scanning activitiy (depending on volume, frequency etc). Please ensure that you are allowed to perform this activity before running this script.

## Notes

Currently only supports TCP.

Please ensure that the egress firewall configuration for the host running `nodetalking` is allowed to access the required hosts & ports.

## Disclaimer

I'm not a programmer, but I do like to make things! Please use this at your own risk.

## License

The MIT License (MIT)

Copyright (c) 2016 Curtis K

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
