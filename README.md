# Multicall sh runner

## Description

A multicall Windows batch file (the _runner_) to provide a transparent method to run a sh-script (with [busybox-w32](http://frippery.org/busybox/)), in Windows Command Prompt or from other batch file.

## Features

- **Multicall.** Rename the _runner_ to match the target sh-script, and it will run the sh-script automagically.
- **Run as admin automatically.** Append `.admin` to the _runner_'s name, and it will run the sh-script as admin.
- **Pass-through arguments.** All arguments to the _runner_ are passed through to the sh-script.
- **Portable.** Nothing to install and nothing left behind.

## Files and Usage

### Main files

- `sh-runner.cmd`
  - The _runner_. It must be in the same directory as your target sh-script.
  - Copy/hardlink and rename it to match your target sh-script. For examples:
    - To run `abc.sh` as current user, rename the _runner_ to `abc.cmd`.
    - To run `abc.sh` as admin, rename the _runner_ to `abc.admin.cmd`.
  - Symlinking does NOT work, as the _runner_ will resolve its name to the symlink target. (One of the many ugly characteristics of NTFS's symlink.)
- `sh.exe`
  - It is a renamed `busybox64.exe` (64bit) to execute the sh-script.
  - You can download the latest version or the 32bit version from [busybox-w32](http://frippery.org/busybox/).
  - This file is **mandatory**, duh.
  - It can be in the same directory as the _runner_, or in the `PATH`.
- `elevate.exe`
  - An tiny open-source utility to run commands as admin, from [here](http://code.kliu.org/misc/elevate/).
  - This file is **optional**. You don't need it if you are not planning to use the "Run as admin automatically" feature. (You can always start the _runner_ as admin manually.)
  - It can be in the same directory as the _runner_, or in the `PATH`.
- `hardlink-runner.cmd`
  - A utility script to hardlink one _runner_ to multiple _runners_ for a set of sh-scripts, so that you don't have to do it one-by-one.
  - If running it without parameters, it will create _runners_ for all the sh-script in the same directory, by hard-linking from `sh-runner.cmd`.
  - Use option `-h` to show help messages for more usage details.
  - This file is **optional**.

### Example files

- `sh-hello.sh`
  - A hello-world example sh-script.
- `sh-hello.cmd`
  - The _runner_, renamed to run the example sh-script as current user (the user starting the _runner_).
- `sh-hello.admin.cmd`
  - The _runner_, renamed and appended `.admin`, to run the example sh-script as admin automatically.

## FAQ

### Will this work with WSL, Cygwin, MSYS, etc.?

I don't know. Maybe you can try it and let me know?

### Why make this project while one-liner like `busybox.exe sh <sh-script>` can do the job?

For several reasons:

- I like to run my sh-scripts in the same way everywhere, i.e. calling their names. Be it in busybox shell or in command prompt.
- I like to start some of my sh-scripts always as admin, without manually doing it.
- I like to double-click to start some of my sh-scripts, without writing a single line of launching code.
- Generally, I am lazy, OK?

### Why use sh-script on Windows anyway? I know batch script is awful, but isn't PowerShell script good enough?

It's just a matter of preference. My main personal reasons are

- sh-script is powerful and can be found everywhere, on Linux, Android, and now Windows.
- busybox-w32 is tiny, powerful, portable, and just plain awesome.
