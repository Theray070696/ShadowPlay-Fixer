# ShadowPlay-Fixer
I use ShadowPlay (now Nvidia Share) to capture moments with my friends/family that are either funny, memorable, or that I want to shove in their face later. ShadowPlay makes that easier, but it silently failing in the background at seemingly random times would be a dealbreaker if there was an alternative.

Since there isn't an alternative that meets all my requirements (that I'm aware of), I've made this script that aims to detect all failures of ShadowPlay that I've run into and either automatically fix them or notify the user if it can't be fixed automatically.

If you run into your own failures of ShadowPlay, try this script and see if it detects your specific failure. If it doesn't, add it to the script and see if the current methods fix it. If it does, make a pull request! Someone might find use in it!

# Using the script
This script is intended to be run as a scheduled task on user logon.  
1. In task scheduler, create a task
2. Under triggers, create a new trigger that runs at log on
3. Under actions, create a new action that starts a program
4. Program is mshta
5. Arguments are vbscript:Execute("CreateObject(""Wscript.Shell"").Run ""powershell -NoLogo -Command """"& '<PATH TO SCRIPT>\Fix-Shadowplay.ps1'"""""", 0 : window.close")
6. Save task
7. Log off
8. Log back on, the script should be running in the background!
