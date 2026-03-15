---
name: highlight-codesample
description: Set up a CODESAMPLE XML node so the generated HTML is highlighted with the correct language.
---

The XLST now supports generating highlighted code in the generated HTML.

In order to get the code highlighted, you need to:
- add a "language" attribute to the CODESAMPLE XML node indicating the language of the code  
  in case of doubt about the language, ask the user
- unindent all lines except the first line
- remove <BR/> nodes from the CODESAMPLE XML node
- replace all <TAB/> nodes with 4 spaces

For example:

```xml
    <CODESAMPLE language="java">public class Box&lt;T&gt; {
    
      <TAB/>private T t;
    
      <TAB/>public void add(T t) {
      <TAB/><TAB/>this.t = t;
      <TAB/>}
    
      <TAB/>public T get() {
      <TAB/><TAB/>return t;
      <TAB/>}
      }</CODESAMPLE>
```

Should be transformed into:

```xml
    <CODESAMPLE language="java">public class Box&lt;T&gt; {

    private T t;

    public void add(T t) {
        this.t = t;
    }

    public T get() {
        return t;
    }
}</CODESAMPLE>
```
