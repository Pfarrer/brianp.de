+++
title = "PHP: Sort associative array in a specific order given by a second array"
date = "2013-09-27"
tags = [
    "php",
    "sort",
]
+++

If you have to sort a associative array in a very specific order that cannot be described easily with a lambda,
PHP's sort functions do not help a lot. In this example, a second array contains the keys in the required order.
A nice and easy way to do the same thing with just a few lines of code:

```js
$source_array = array('elem1' => 1, 'elem2' => 2, 'elem3' => 3, 'elem4' => 4);
$sort_order = array('elem1', 'elem4', 'elem2', 'elem3');
```

The first array `$source_array` is supposed to be the array that should be sorted.
The second array `$sort_order` specifies the required order by listing the elements as they should be arranged.

To sort the array, the internal functions `array_fill_keys` and `array_merge` are quite helpful:

```js
$sorted_array = array_fill_keys($sort_order, null);
$sorted_array = array_merge($sorted_array, $source_array);
```

The result is a sorted array with a ordering as specified in array `$sort_order`:

```
Array ( [elem1] => 1 [elem4] => 4 [elem2] => 2 [elem3] => 3 )
```
