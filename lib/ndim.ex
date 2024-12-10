defmodule Ndim do
  @moduledoc """
  The `Ndim` lib provides functions for working with n-dimensional lists.

  This module is particularly useful when you need to:
  * Map functions over deeply nested lists at a specific level while maintaining their shape
  * Transform between the n-dimensional list and the coordinated map

  ## Terminology

  ### N-dimensional List
  An n-dimensional list is a regularly nested list structure where n represents the depth
  of nesting. Each level must maintain consistent structure:

  # 1-dimensional list (vector)

  ```elixir
  [1, 2, 3]
  ```

  # 2-dimensional list (matrix)

  ```elixir
  [
    [1, 2, 3],
    [4, 5, 6]
  ]
  ```

  # 3-dimensional list (cube)

  ```elixir
  [
    [
      [1, 2], [3, 4]
    ],
    [
      [5, 6], [7, 8]
    ]
  ]
  ```

  ### Coordinate map
  A coordinate map is a map representation of an n-dimensional list where each value
  is keyed by its dimensional coordinates. This is useful for sparse data or when
  you need direct coordinate access:

  #### From 2-dimensional list to 2d coordinate map

  ```elixir
  [
    [1, 2],     -->  %{{0, 0} => 1, {0, 1} => 2,
    [3, 4]             {1, 0} => 3, {1, 1} => 4}
  ]
  ```

  #### From 3-dimensional list to 3d coordinate map

  ```elixir
  [
    [[1, 2]],   -->  %{{0, 0, 0} => 1, {0, 0, 1} => 2,
    [[3, 4]]           {1, 0, 0} => 3, {1, 0, 1} => 4}
  ]
  ```

  ## Core functions

  * `d2map/2` ... `d5map/2` - Map a function over a 2-dimensonal list (upto 5)
  * `dmap/3` - The general version which maps a function over elements at any specified dimensional list
  * `to_coordinate_map/1` - Transform a n-dimensional list to a coordinate map

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
    iex> Ndim.to_coordinate_map(vector)
    %{{0, 0} => 1, {0, 1} => 2, {1, 0} => 3, {1, 1} => 4}
    ```
  """

  @doc """
  Maps a function over a specified dimensional list.
  Takes a n-dimensional list as the first argument, followed by the nesting level, then a mapping function.

  ## Parameters
    * `list` - A n-dimensional nested list to transform
    * `dim` - The dimension at which to apply the function (1-based indexing)
    * `fun` - The function to apply at the specified dimension

  ## Examples

      ```elixir
      iex> numbers = [[1, 2], [3, 4], [5, 6]]
      iex> Ndim.dmap(numbers, 2, fn i -> i * 10 end)
      [[10, 20], [30, 40], [50, 60]]

      iex> nested = [[["a", "b"], ["c", "d"]], [["e", "f"], ["g", "h"]], [["i", "j"], ["k", "l"]]]
      iex> Ndim.dmap(nested, 3, &String.upcase/1)
      [[["A", "B"], ["C", "D"]], [["E", "F"], ["G", "H"]], [["I", "J"], ["K", "L"]]]
      ```
  """
  def dmap(list, dim, func) do
    dim_accessors = List.duplicate(Access.all(), dim)
    update_in(list, dim_accessors, func)
  end

  @doc """
  Maps a function over a 2-dimensional list.
  Takes a 2-dimensional list as the first argument, followed by a mapping function.
  This is equivalent to calling `dmap(list, 2, fun)`.

  ## Examples

    ```elixir
     iex> numbers = [[1, 2], [3, 4], [5, 6]]
     iex> Ndim.d2map(numbers, fn x -> x * 2 end)
     [[2, 4], [6, 8], [10, 12]]

     iex> strings = [["a", "b"], ["c", "d"]]
     iex> Ndim.d2map(strings, &String.upcase/1)
     [["A", "B"], ["C", "D"]]
     ```
  """
  def d2map(list, fun), do: dmap(list, 2, fun)

  @doc """
  Maps a function over a 3-dimensional list.
  Takes a 3-dimensional list as the first argument, followed by a mapping function.
  This is equivalent to calling `dmap(list, 3, fun)`.

  ## Examples

    ```elixir
     iex> numbers = [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
     iex> Ndim.d3map(numbers, fn x -> x + 1 end)
     [[[2, 3], [4, 5]], [[6, 7], [8, 9]]]

     iex> strings = [[["hello", "world"], ["foo"]], [["bar"], ["baz", "qux"]]]
     iex> Ndim.d3map(strings, &String.capitalize/1)
     [[["Hello", "World"], ["Foo"]], [["Bar"], ["Baz", "Qux"]]]
     ```
  """
  def d3map(list, fun), do: dmap(list, 3, fun)

  @doc """
  Maps a function over a 4-dimensional list.
  Takes a 4-dimensional list as the first argument, followed by a mapping function.
  This is equivalent to calling `dmap(list, 4, fun)`.

  ## Examples

    ```elixir
     iex> numbers = [[[[1, 2], [3]], [[4, 5]]], [[[6]], [[7, 8], [9]]]]
     iex> Ndim.d4map(numbers, fn x -> x * 2 end)
     [[[[2, 4], [6]], [[8, 10]]], [[[12]], [[14, 16], [18]]]]

     iex> strings = [[[[{"a", 1}]]], [[[{"b", 2}]]]]
     iex> Ndim.d4map(strings, fn {str, num} -> {String.upcase(str), num} end)
     [[[[{"A", 1}]]], [[[{"B", 2}]]]]
     ```
  """
  def d4map(list, fun), do: dmap(list, 4, fun)

  @doc """
  Maps a function over a 5-dimensional list.
  Takes a 5-dimensional list as the first argument, followed by a mapping function.
  This is equivalent to calling `dmap(list, 5, fun)`.

  ## Examples

    ```elixir
     iex> numbers = [[[[[1]], [[2]]], [[[3]]]], [[[[4]]], [[[5]], [[6]]]]]
     iex> Ndim.d5map(numbers, fn x -> x + 10 end)
     [[[[[11]], [[12]]], [[[13]]]], [[[[14]]], [[[15]], [[16]]]]]

     iex> data = [[[[[%{x: 1}]], [[%{x: 2}]]]], [[[[%{x: 3}]]]]]
     iex> Ndim.d5map(data, fn map -> Map.update!(map, :x, & &1 * 2) end)
     [[[[[%{x: 2}]], [[%{x: 4}]]]], [[[[%{x: 6}]]]]]
     ```
  """
  def d5map(list, fun), do: dmap(list, 5, fun)

  @doc """
  Converts an n-dimensional nested list into a coordinate map where each value
  is keyed by its dimensional coordinates. The dimension can be specified to
  handle specific cases, or automatically detected from the list structure.

  ## Parameters
   * `list` - An n-dimensional nested list to convert
   * `dimension` - (Optional) The expected dimension of the nested list

  ## Examples

    ```elixir
     # Automatic dimension detection
     iex> matrix = [[1, 2], [3, 4]]
     iex> Ndim.to_coordinate_map(matrix)
     %{{0, 0} => 1, {0, 1} => 2, {1, 0} => 3, {1, 1} => 4}

     iex> cube = [[[1, 2]], [[3, 4]]]
     iex> Ndim.to_coordinate_map(cube)
     %{{0, 0, 0} => 1, {0, 0, 1} => 2, {1, 0, 0} => 3, {1, 0, 1} => 4}

     # Explicitly specifying 2D
     iex> matrix = [[1, 2], [3, 4]]
     iex> Ndim.to_coordinate_map(matrix, 2)
     %{{0, 0} => 1, {0, 1} => 2, {1, 0} => 3, {1, 1} => 4}

     # Explicitly specifying 3D
     iex> cube = [[[1, 2]], [[3, 4]]]
     iex> Ndim.to_coordinate_map(cube, 3)
     %{{0, 0, 0} => 1, {0, 0, 1} => 2, {1, 0, 0} => 3, {1, 0, 1} => 4}
     ```

  ## Return Value
  Returns a map where keys are tuples of coordinates and values are the corresponding
  elements from the input list.

  Note: Coordinates use zero-based indexing, following programming conventions.
  """
  def to_coordinate_map(list, 2) do
    for {row, i} <- Enum.with_index(list),
        {value, j} <- Enum.with_index(row),
        into: %{},
        do: {{i, j}, value}
  end

  def to_coordinate_map(list, 3) do
    for {row, x} <- Enum.with_index(list),
        {column, y} <- Enum.with_index(row),
        {value, z} <- Enum.with_index(column),
        into: %{},
        do: {{x, y, z}, value}
  end

  def to_coordinate_map(_list, n),
    do: raise(ArgumentError, "to_coordinate_map/2 not implement for #{n} dimensional list (yet)")

  def to_coordinate_map(list) do
    depth = get_depth(list)
    to_coordinate_map(list, depth)
  end

  def regular?(list) do
    try do
      check_regular(list)
    catch
      :irregular -> false
    end
  end

  defp check_regular(elem) when not is_list(elem), do: false
  defp check_regular([]), do: true

  defp check_regular([head | tail]) do
    if is_list(head) do
      # Check if all elements at current level are lists
      not Enum.any?(tail, fn x -> not is_list(x) end) or throw(:irregular)

      # Check if all lists at current level have the same length
      head_length = length(head)
      not Enum.any?(tail, fn x -> length(x) != head_length end) or throw(:irregular)

      # Check if all sublists have the same type for their first element
      first_child_type = list_first_type(head)

      for list <- tail do
        if list_first_type(list) != first_child_type, do: throw(:irregular)
      end

      # Recursively check sublist structure
      check_regular(head) or throw(:irregular)
    else
      # Check if all other elements are not lists
      not Enum.any?(tail, &is_list/1) or throw(:irregular)
    end
  end

  defp list_first_type([]), do: :empty
  defp list_first_type([head | _]), do: is_list(head)

  @doc """
  Gets the depth (dimension) of a regular nested list. Returns 0 for an empty list,
  1 for a flat list, and n for an n-dimensional nested list. Only works with regular
  nested structures where elements at the same depth share the same dimensionality.

  ## Examples

    ```elixir
     iex> Ndim.get_depth([])
     0

     iex> Ndim.get_depth([1, 2, 3])
     1

     iex> Ndim.get_depth([[1, 2], [3, 4]])
     2

     iex> Ndim.get_depth([[[1, 2]], [[3, 4]]])
     3
     ```

  ## Error cases

    ```elixir
    iex> Ndim.get_depth([1, [2, 3]])
    ** (ArgumentError) list is not a regular nested structure

    iex> Ndim.get_depth([[1, 2], [3]])
    ** (ArgumentError) list is not a regular nested structure
    ```

  ## Return Value
  Returns an integer representing the depth (dimension) of the nested list.
  For irregular structures, raises an ArgumentError.

  Note: The depth counting starts from 0 for an empty list, 1 for a flat list,
  and increments by one for each level of regular nesting.
  """
  def get_depth(list) do
    if regular?(list) do
      get_depth(list, :validate)
    else
      raise ArgumentError, "list is not a regular nested structure"
    end
  end

  def get_depth([], :validate), do: 0
  def get_depth([head | _], :validate) when not is_list(head), do: 1
  def get_depth([head | _], :validate), do: 1 + get_depth(head, :validate)
end
