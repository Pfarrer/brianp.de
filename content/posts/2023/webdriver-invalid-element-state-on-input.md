+++
title = "Webdriver: Invalid element state"
date = "2023-07-18"
tags = [
    "webdriver",
    "wdio",
    "test",
]
+++

While using the [WebdriverIO](https://webdriver.io) browser automation test framework based on the Webdriver protocol, I got stuck with this error: `invalid element state: invalid element state`.
The error occurred when interacting with an input element. Since this error message is not very descriptive, I want to point to the solution for my situation.
<!--more-->

To debug the issue, I found it very helpful to enable the WebdriverIO debug logs:
```
INFO webdriver: COMMAND findElement("css selector", "#username")
INFO webdriver: [POST] http://localhost:9515/session/e33b45ce3f1199ff0b4279ff1a354c5e/element
INFO webdriver: DATA { using: 'css selector', value: '#username' }
INFO webdriver: RESULT {
  'element-6066-11e4-a52e-4f735466cecf': '66A9C4BD75727E52A62A9CF81CA9F69B_element_5'
INFO webdriver: COMMAND isElementEnabled("66A9C4BD75727E52A62A9CF81CA9F69B_element_5")
INFO webdriver: [GET] http://localhost:9515/session/e33b45ce3f1199ff0b4279ff1a354c5e/element/66A9C4BD75727E52A62A9CF81CA9F69B_element_5/enabled
INFO webdriver: RESULT true
INFO webdriver: COMMAND elementClear("66A9C4BD75727E52A62A9CF81CA9F69B_element_5")
INFO webdriver: [POST] http://localhost:9515/session/e33b45ce3f1199ff0b4279ff1a354c5e/element/66A9C4BD75727E52A62A9CF81CA9F69B_element_5/clear
WARN webdriver: Request failed with status 400 due to invalid element state
``` 

As you can clearly read from the logs, the test runner is able to find the element (`#username`), then checks if the element is enabled, and finally tries to clear the element. This step fails with the mentioned error message.

The [Webdriver standard](https://www.w3.org/TR/webdriver2/#errors) includes this error with the following description:

  > A command could not be completed because the element is in an invalid state, e.g. attempting to clear an element that isn’t both editable and resettable.

The key is the word *editable.* When looking up the definition for editable, I could finally identify my issue:

  > Denotes input elements that are mutable (e.g. that are not read only or disabled) and whose type attribute is in one of the following states: \
  \
  Text and Search, URL, Telephone, Email, Password, Date, Month, Week, TimeLocal, Date and Time, Number, Range, Color, File Upload

**As it turns out, the selected input had `type="hidden"`. This caused the test to fail, because you cannot set the value of a hidden input like this.** Just then, I noticed that I matched for the wrong input element. As soon as I used the correct `type="text"` input, the test worked flawlessly.