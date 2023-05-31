+++
title = "Alex Gilleran: Test against what won't change"
date = "2022-09-17"
tags = [
    "unit",
    "test",
    "tdd",
    "interface",
]
+++

Alex Gilleran brings up very valid criteria on great tests in his post that I strongly recommend: https://blog.alexgilleran.com/test-against-what-wont-change.
<!--more-->

My experience with the test larger code bases is - if not counteracted - the tests tend to be dominated by Unit tests. For a developer, a unit test can be created with little effort, helps to take the next step in implementing a feature or fixing a bug (especially if TDD is used) and can be executed frequently and quickly.

Unfortunately, unit tests also tend to test against an internal interface that might be changed sooner rather than later. With a test code base with a large unit test coverage, refactoring some code will inevitably result in lots of broken tests - not necessarily due to broken functionality but simply due to a broken interface.

 > These unit interfaces tend to change often in response to refactoring, optimisations, new    requirements and so on, and they should be able to change quickly too, or we make any of these important improvements. - Alex Gilleran

Not all unit tests are bad, though. Equally, not all integration or e2e test are good. The important detail is that the test only depends on a stable, likely public interface that rarely changes.

So the gist, in one line:

 > […] you should only have to change your tests when you change what your system does, not how it does it - Alex Gilleran