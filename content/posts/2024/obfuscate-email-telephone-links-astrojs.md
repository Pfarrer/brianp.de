+++
title = "Link Obfuscation for Email and Phone Numbers in Astrojs"
date = "2024-03-23"
tags = [
    "obfuscation",
    "email",
    "javascript",
    "astrojs"
]
+++

Spiders and automated programs often scan websites for email addresses and phone numbers to harvest for spam campaigns. Obfuscation scrambles the data, making it unreadable to these bots and significantly reducing the chances of receiving unwanted emails or calls.

<!--more--->

While obfuscation protects your information to some extend, it doesn't prevent users from contacting you. The idea behind the implementation proposed in this article is to Base64-encode the sensitive data and reverse the characters. The result is assigned to a `data` attribute while the standard `href` attribute contains no sensitve data. A small Javascript script will load automatically and will decode the value of the `data` attribute once the element get into the viewport.

## Reusable Component

This is the code for the reusable component located in `src/components/ObfuscatedLink.astro`:

```js
---
type Props = {
  href: string;
  text: string;
};

const { href, text } = Astro.props;

function reverseStr(str) {
  return str.split('').reverse().join('');
}

const obfuscatedHref = reverseStr(btoa(href));
const obfuscatedText = reverseStr(btoa(await Astro.slots.render('default')));
const id = ''+process.hrtime()[1];
---

<a href="#" id={id} data-href={obfuscatedHref} data-text={obfuscatedText}>[hidden]</a>

<script define:vars={{ id, obfuscatedHref, obfuscatedText }}>
function reverseStr(str) {
  return str.split('').reverse().join('');
}

new IntersectionObserver((entries, observer) => {
  if (entries[0].isIntersecting) {
    const el = entries[0].target;
    el.href = atob(reverseStr(el.attributes['data-href'].value));
    el.innerHTML = atob(reverseStr(el.attributes['data-text'].value));
    observer.disconnect();
  }
}).observe(document.getElementById(id));
</script>
```

## Example Usage

The component can be used just like a standard link tag:

```
---
import ObfuscatedLink from '../components/ObfuscatedLink.astro';
---

<p>
  Contact me via:
  <ObfuscatedLink href="mailto:mail@example.com">mail@example.com</ObfuscatedLink>
</p>
```

Astro will generate the following HTML code:

```html
<p>
  Contact me via:
  <a href="#" id="239889741" data-href="=02bj5SZsBXbhhXZAxWah1mOvRHbpFWb" data-text="==QbvNmLlxGctFGelBEbpFWb">[hidden]</a>
  <script>[...]</script>
</p>
```

With Javascript disabled, the link will have no action and display only the text "[hidden]". The sensitive data remains encoded in the `data` attributes.

This obfusction does not aim to properly protect senstive data, but to make is harder for scrapers to automatically extract valid email addresses or telephone numbers. The impact to regular users should be minimal.
