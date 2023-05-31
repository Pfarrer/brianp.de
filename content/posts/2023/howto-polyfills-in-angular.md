+++
title = "Howto: Setup Polyfills in Angular"
date = "2023-01-23"
tags = [
    "angular",
    "ng-cli",
    "polyfill"
]
+++

Angular CLI based projects support polyfills. Here are the steps required to set them up on a newly created project which does not contain them so far:
<!--more-->


1) Create `polyfills.ts` file (file name can be choosen freely)
2) Include the file in the `tsconfig.app.ts` and `tsconfig.spec.ts` configs, e.g.

    ```json {hl_lines=[5]}
    {
        "compilerOptions": {
        },
        "files": [
            "src/polyfills.ts",
            "src/main.ts"
        ],
    }
    ```
3) Make Angular include the file as a ployfill by adding it to the `polyfills` section in the `angular.json` file, e.g.

     ```json {hl_lines=[7,15]}
    {
        "projects": {
            "architect": {
                "build": {
                    "options": {
                        "polyfills": [
                            "src/polyfills.ts",
                            "zone.js"
                        ],
                    }
                },
                "test": {
                    "options": {
                        "polyfills": [
                            "src/polyfills.ts",
                            "zone.js",
                            "zone.js/testing"
                        ],
                    }
                }
            }
        }
    }
    ```

Those changes did the trick for me. Any code located in the `polyfills.ts` file was included in the transpiled code and executed prior to any other application code.