+++
title = "Angular: Interceptors from NgModules with standalone App"
date = "2023-06-14"
tags = [
    "angular",
    "dependency-injection"
]
+++

In the long run, standalone components in Angular are expected to replace NgModules. However, it's important to note that not all libraries and modules have made the transition yet. Many still provide only classic NgModules. Fortunately, the Angular team has done an excellent job ensuring that both approaches can work seamlessly together.
<!--more-->

That said, I recently encountered a challenging scenario that lacked proper documentation. However, once I understood the issue, I discovered a straightforward solution.

The problem arose when I tried integrating the [keycloak-angular](https://github.com/mauriciovigolo/keycloak-angular) library into a modern Angular app consisting solely of standalone components. (As of writing this, the current versions are Angular v16 and keycloak-angular v14.)

Importing the library using [importProvidersFrom](https://angular.io/api/core/importProvidersFrom) is straightforward. However, there is a special case when it comes to the HTTP interceptor. While keycloak-angular defines an interceptor service, it is not automatically recognized by the HTTP client.

To enable the HTTP client to automatically detect any registered HTTP interceptor in the dependency injection context, you need to use the [withInterceptorsFromDi](https://angular.io/api/common/http/withInterceptorsFromDi) provider.

Consequently, the final import statement for the HTTP client may resemble the following:

```ts{hl_lines=[2]}
bootstrapApplication(AppComponent, {
  providers: [ provideHttpClient(withInterceptorsFromDi()) ],
}).
```