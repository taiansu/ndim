# Ndim

[![Run Tests](https://github.com/taiansu/ndim/actions/workflows/elixir.yml/badge.svg?branch=main)](https://github.com/taiansu/ndim/actions/workflows/elixir.yml)

The `Ndim` lib provides functions for working with n-dimensional lists.

This module is particularly useful when you need to:
  * Map functions over deeply nested lists at a specific level while maintaining their shape
  * Transform between the n-dimensional list and the coordinated map

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ndim` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ndim, "~> 0.1.0"}
  ]
end
```

## Terminology

### N-dimensional List
An n-dimensional list is a regularly nested list structure where n represents the depth
of nesting. Each level must maintain consistent structure:

#### 1-dimensional list (vector)
```elixir
[1, 2, 3]
```

#### 2-dimensional list (matrix)
```elixir
[[1, 2, 3],
  [4, 5, 6]]
```

#### 3-dimensional list (cube)
```elixir
[[[1, 2], [3, 4]],
  [[5, 6], [7, 8]]]
```

### Coordinate Map
A coordinate map is a map representation of an n-dimensional list where each value
is keyed by its dimensional coordinates. This is useful for sparse data or when
you need direct coordinate access:

#### From 2-dimensional list to coordinate map
```elixir
[
  [1, 2],     -->  %{{0, 0} => 1, {0, 1} => 2,
  [3, 4]             {1, 0} => 3, {1, 1} => 4}
]
```

#### From 3-dimensional list to coordinate map
```elixir
[
  [[1, 2]],   -->  %{{0, 0, 0} => 1, {0, 0, 1} => 2,
  [[3, 4]]           {1, 0, 0} => 3, {1, 0, 1} => 4}
]
```

## Core functions

  * `d2map/2` ... `d5map/2` - Map a function over a 2-dimensional list (upto 5-dimensional list)
  * `dmap/3` - The general version which maps a function over elements at any specified dimensional list
  * `to_coord_map/1` - Transform a n-dimensional list to a coordinate map

## Examples

Map a function over a 2-dimensional list

```elixir
iex> numbers = [[1, 2], [3, 4]]
iex> Ndim.d2map(numbers, fn x -> x * 2 end)
[[2, 4], [6, 8]]
```

Transform a 2-dimensional list to a coordinate map
```elixir
iex> vector = [[1, 2], [3, 4]]
iex> Ndim.to_coord_map(vector)
%{{0, 0} => 1, {0, 1} => 2, {1, 0} => 3, {1, 1} => 4}
```

Find the document at [https://hexdocs.pm/ndim](https://hexdocs.pm/ndim)
