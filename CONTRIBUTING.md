# Contributing

1. Fork the repo
2. Create a branch, we will not merge from master.
3. Create a test case for your change. If you are adding functionality or
   fixing a bug, we need tests.
4. Make your test pass.
5. Ensure other tests still pass. We will only merge pull requests with
   passing tests.
6. Push your changes to GitHub and submit a pull request.

# Style Guide

This document gives coding conventions for Objective-C code. It is very similar
to Python's PEP-8. The main key point in this guideline is that code is read
much more often than it is written. These guidelines are designed to improve
the readability of code and make is consistent across all code used in this
framework.

## Indentation

Use 4 spaces per indentation level. Never use tabs.

## Imports

Imports are always put at the top of the file, before any constants. Imports
should be grouped in the following order:

1. Standard library header
2. Related third party headers
3. Local application headers

You should put a blank line between each group of headers.

## Whitespace in Expressions and Statements

Trailing whitespace should never be found in code, this includes any lines
which only contain whitespace.

Avoid extraneious whitespace in the following situations:

* Use a single space around an assignment (or any) operator. Never use multiple
  spaces for alignment.

## Dot-notation

Do not use dot notation.

Use:

   [array count]

Intstead of:

   array.count

## Implementation organisation

Methods should be grouped together, with '#pragma mark -' headers, for example
grouping alloc/dealloc, viewDidLoad, etc together.

