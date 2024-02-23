+++
title = "Reusable Test Data with Object Mother and Builder Pattern in Java"
date = "2024-02-22"
tags = [
    "test data",
    "pattern",
    "builder",
    "java",
    "test",
    "random",
]
+++

From my observation, code bases with a high test coverage and a certain level of complexity tend to have cluttered and messy tests.
Such tests are often dominated by the *preparation* step in order to prepare test data or bring the system into a state required for the test.
The actual test code, such as invocation of the component-under-test and verification of the results, can easily be buried under the preparation step.

To ease such problems and to improve readability and maintainability of test code in general, I like to combine the Builder pattern with the Object Mother pattern and randomized test data.

<!--more-->

Test cases can often be separated into three logical steps:
* **given** step: Prepares the data, models and state required for the test to run,
* **when** step: actual execution of the component-under-test,
* **then** step: verification of the results.

The advise given in this article refer mostly to the *given* step.

## Builder Pattern

From my experience, the Builder pattern is widely known. It also supported by [Lombok](https://projectlombok.org/) via the `@Builder` annotation. In this article, I will not get into the details of this pattern.

## Object Mother Pattern

On the other hand, the Object Mother pattern is not widely known. It builds on the concept of a builder, but provides more complex builder methods. Such methods usually change more than one field of the underlying model.
What fields are changed depends strongly on the domain and use cases of the model.

For more details, please see the [Martin Fowlers article on Object Mother](https://martinfowler.com/bliki/ObjectMother.html).

## Randomized Test Data

Before executing the component-under-test, the test data preparation is critical because the actual values used for the test affect the results. This is the obvious and deliberate part. But usually, there are also many values and preparations that just need to be done beforehand but have no influence on the test result as such. Examples are mandatory fields in models which are not used in the tested scenario, or dependencies that have to be mocked to not run into errors during the execution.

Since the actual values for such secondary test data has no effect on the test result, I propose to generate such data randomly. This has a few benefits that, in my opinion, outweigh any downsides:

* Clear separation of primary (which has a direct influence on the test result) and secondary (which has no influence on the test result) test data.
* Since the secondary test data is randomized, different values and combinations (think of empty lists, optional values, etc.) are tested over time.
* Previous assumptions are constantly challenged with each test execution. This also holds on an evolving code base in which tests can easily become obsolete or useless by later changes.

An alternative to random test data can be mocked domain objects. This can also work well, but can be hard when working with nested data and complex models.

## Example

Lets use this example domain models to demonstrate the advantages. Keep in mind that these models are neither realistic nor complete.

```java
@Builder(toBuilder = true)
record Order(
    List<OrderItem> orderItems,
    BigDecimal discount,
    OrderStatus status,
    Address shippingAddress,
    Address invoiceAddress
) {}

@Builder(toBuilder = true)
record OrderItem(
    float weightKg,
    int[] dimensionsCm,
    BigDecimal price
) {}

enum OrderStatus {
    NEW,
    SHIPPING,
    PAYMENT_PENDING,
    COMPLETE
}

@Builder(toBuilder = true)
record Address(
    String street,
    String city,
    String country
) {}
```

### Object Mother with Randomized Test Data

The Object Mother pattern help to have clean and precise code. Utility methods, which are more complex than default builder methods, can be located here. Such methods
have a domain background, thus, often they manipulate multiple fields and values at once or in dependence of each other.

This pattern also plays very well with the Builder pattern. The builder methods are fully reused and limit the overhead code to a minimum.

In the following example, I will use the [Instancio](https://www.instancio.org/) library to automatically generate randomized test data.

```java
@RequiredArgsConstructor
class OrderObjectMother {

    private final Order.OrderBuilder builder;

    public static OrderObjectMother randomized() {
        return new OrderObjectMother(Instancio.of(Order.class).create().toBuilder());
    }

    public OrderObjectMother discount(String val) {
        return new OrderObjectMother(builder.discount(new BigDecimal(val)));
    }

    public OrderObjectMother sameAddresses() {
        return new OrderObjectMother(builder.invoiceAddress(builder.build().shippingAddress()));
    }

    public Order.OrderBuilder and() {
        return builder;
    }

    public Order build() {
        return builder.build();
    }
}

@RequiredArgsConstructor
class OrderItemObjectMother {

    private final OrderItem.OrderItemBuilder builder;

    public static OrderItemObjectMother randomized() {
        return new OrderItemObjectMother(Instancio.of(OrderItem.class).create().toBuilder());
    }

    public OrderItemObjectMother price(String val) {
        return new OrderItemObjectMother(builder.price(new BigDecimal(val)));
    }

    public OrderItem.OrderItemBuilder and() {
        return builder;
    }

    public OrderItem build() {
        return builder.build();
    }
}

@RequiredArgsConstructor
class AddressObjectMother {

  private final Address.AddressBuilder builder;

  public static AddressObjectMother randomized() {
    return new AddressObjectMother(Instancio.of(Address.class).create().toBuilder());
  }

  public Address.AddressBuilder and() {
    return builder;
  }

  public Address build() {
    return builder.build();
  }
}
```

### Example Tests

For this example, a fictional function in a Component under test (cut) is to be tested. This function calculates the total price of an order.
The function accepts an `Order` and returns the total price as a `BigDecimal`.

In the given step of this test, a `Order` must be created with predefined `orderItems` and `discount`. The remaining fields of the `Order` are not
relevant for the test.

Without random test data generation, you either have to set arbitrary values to each field, which will clutter the test, thus, make it harder
to understand what data is actually relevant for the test to pass and which is not.

```java
@Test
void shouldCalculateCorrectTotalPrice() {
    OrderItem item1 = OrderItemObjectMother.randomized().and()
        .price("17.99")
        .build();
    OrderItem item2 = OrderItemObjectMother.randomized().and()
        .price("3.95")
        .build();

    Order given = OrderObjectMother.randomized()
        .discount("0.1")
        .and()
        .orderItems(List.of(item1, item2))
        .build();

    BigDecimal actual = cut.calculateTotalOrderPrice(given);

    BigDecimal expected = new BigDecimal("19.75");
    assertEquals(expected, actual);
}
```

In the second example, it becomes fairly obvious that the shipping cost depends on the weight, dimensions and country. All other values are random, thus, not relevant.

```java
@Test
void shouldCalculateShippingCost() {
    OrderItem item = OrderItemObjectMother.randomized().and()
        .weightKg(1.5f)
        .dimensionsCm(new int[] {60, 20, 30})
        .build();

    Address shippingAddress = AddressObjectMother.randomized().and()
        .country("Germany")
        .build();

    Order given = OrderObjectMother.randomized().and()
        .orderItems(List.of(item))
        .shippingAddress(shippingAddress)
        .build();

    BigDecimal actual = cut.calculateShippingCost(given);

    BigDecimal expected = new BigDecimal("5.99");
    assertEquals(expected, actual);
}
```
