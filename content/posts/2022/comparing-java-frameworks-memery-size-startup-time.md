+++
title = "Quick Comparison of a few popular Java Frameworks"
date = "2022-11-10"
tags = [
    "java",
    "spring",
    "micronaut",
    "quarkus",
    "rust",
    "actix-web",
    "memory",
    "comparison",
]
+++

After listening to the _progammier.bar_ podcast about the state of Java in 2022, I was impressed by the statements made by the podcast guest.
<!--more-->

The podcast is in German, though. Here is the link to the episode: https://www.programmier.bar/podcast/deep-dive-112-why-java-rocks-mit-adam-bien

Especially the claimed startup times and low memory consumption that Adam Bien mentions surprised me. That did not match my usual experiences. To look into this, I created some super-simple services with [Quarkus](https://quarkus.io/), [Micronaut](https://micronaut.io/) and [Spring Boot](https://spring.io/projects/spring-boot) (both synchronous and reactive).

The following tests and comparisons shall only be used to get a feeling on what is possible and what the differences are between frameworks. I started each service a few times on my local computer and observed the startup time and memory consumption.

The applications used for this test are dead simple. All have just one single endpoint which accepts GET requests without parameters and returns a static string.

For Spring Boot MVC, the controller code looks like this:

```java
@RestController
public class Controller {

    @GetMapping("/hello")
    String hello() {
        return "Hello Demo";
    }
}
```

### Results

All in all, I am quite impressed by the Java performance. For me, a Java Spring Boot service is usually large and takes dozens of seconds to start up. Of course, my experience is based on more complex services with dependencies such as databases, message queues, etc. These simple examples proof that Java-based services can also be light-weight and start quickly is under a second, given the services are not too complex.

|             | Spring Boot<br>(webmvc) | Spring Boot<br>(webflux) |  Quarkus | Micronaut | actix-web<br>(Rust-based) |
| :---------- | ----------------------: | -----------------------: | -------: | --------: | ------------------------: |
| Version     |                   2.7.5 |                    2.7.5 |   2.13.3 |     3.7.3 |                     4.2.1 |
| Bundle Size |                   17 MB |                    19 MB |    14 MB |     14 MB |                    4.4 MB |
| Memory      |                  235 MB |                   240 MB |   106 MB |    119 MB |                      4 MB |
| Heap        |                   15 MB |                    14 MB |    11 MB |     14 MB |                         ? |
| Startup     |                ~ 890 ms |                 ~ 880 ms | ~ 340 ms |   ~ 350 m |                         ? |

Note that the actix-web example is not a Java application. It is build with Rust. The generated bundle (or executable) is statically linked, thus, no JVM required to run the application. 4.4 MB is the total size of the application.
