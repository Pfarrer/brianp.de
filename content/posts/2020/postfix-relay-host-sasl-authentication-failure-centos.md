+++
title = "Postfix: Fixing SASL authentication failure: No worthy mechs found error on Centos 8"
date = "2020-10-04"
tags = [
    "linux",
    "centos",
    "postfix",
    "sasl",
    "relay",
]
+++

On a freshly installed CentOS 8.2, Postfix faced a SASL authentication issue when trying to authenticate against a SMTP mail server. The connection could be established, but Postfix did not find a matching authentication mechanism.
<!--more-->

These are the logs produced when tring to relay an eMail:
```log
Oct  4 16:13:51 centos postfix/smtp[431946]: warning: SASL authentication failure: No worthy mechs found
Oct  4 16:13:51 centos postfix/smtp[431946]: 4C4FL74S9BzX1WQ: to=<mail@example.com>, relay=smtp.sender.com[1.2.3.4]:25, delay=0.21, delays=0.07/0.02/0.12/0, dsn=4.7.0, status=deferred (SASL authentication failed; cannot authenticate to server smtp.sender.com[1.2.3.4]: no mechanism available)
```

The solution wasn't a broken Postfix configuration, but a missing package. Installing `cyrus-sasl-plain` and restarting Postfix fixed the problem for me:
```bash
$ dnf install cyrus-sasl-plain
$ systemctl restart postfix
```