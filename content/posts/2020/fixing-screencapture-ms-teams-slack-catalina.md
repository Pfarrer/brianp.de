+++
title = "Fixing missing Application in Catalina's Privacy Protection settings"
date = "2020-11-09"
tags = [
    "catalina",
    "privacy",
    "tccutil",
    "ms-teams",
    "slack",
]
+++

Slack and Microsoft Teams did not show up in Catalina's Privacy Protection settings, thus, I could not grant permission to capture the screen. I could solve the problem for both applications by completely removing the application and resetting Catalina's internal settings.
<!--more-->

Here are the detailed steps for Microsoft Teams on Catalina 10.15.7:

- Uninstall Microsoft Teams
- Delete any Microsoft Teams leftovers:
    ```bash {linenos=table}
    rm -rf ~/Library/Caches/com.microsoft.teams
    rm -rf ~/Library/Caches/com.microsoft.teams.shipit
    rm -rf ~/Library/Application Support/Microsoft/Teams
    ```

- Reset Catalina's internal Privacy Protection "Screen Capture" settings. **This will reset any screen capture permission that was granted to any application.** In my case, other applications just asked again for permission without a problem. 
    ```bash {linenos=table}
    tccutil reset ScreenCapture
    ```

- Install Microsoft Teams again as normal
- After attempting to share the screen in a call, the Screen Capture permission requested should show up automatically

Sidenote:
Other categories `tccutil` can reset:
``` {linenos=table}
Accessibility
AddressBook
AppleEvents
Calendar
Camera
Microphone
Photos
Reminders
ScreenCapture
SystemPolicyAllFiles
SystemPolicyDesktopFolder
SystemPolicyDeveloperFiles
SystemPolicyDocumentsFolder
SystemPolicyDownloadsFolder
SystemPolicyNetworkVolumes
SystemPolicyRemovableVolumes
SystemPolicySysAdminFiles
```