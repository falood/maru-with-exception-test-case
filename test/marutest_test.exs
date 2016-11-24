defmodule MarutestTest do
  use ExUnit.Case

  test "mounted with exception handlers" do
    defmodule TEST1 do
      use Maru.Test, for: MWEH.M2

      def test1, do: get("/").status
      def test2, do: get("/match_error").status
      def test3, do: get("/arithmetic_error").status
      def test4, do: get("/runtime_error").status
      def test5, do: get("/param_required").status
    end

    assert 200 == TEST1.test1
    assert 502 == TEST1.test2
    assert_raise ArithmeticError, fn ->
      TEST1.test3
    end
    assert_raise RuntimeError, fn ->
      TEST1.test4
    end
    assert_raise Maru.Exceptions.InvalidFormatter, fn ->
      TEST1.test5
    end

    defmodule TEST2 do
      use Maru.Test,
        for: MWEH.M2,
        with_exception_handlers: true

      def test1, do: get("/").status
      def test2, do: get("/match_error").status
      def test3, do: get("/arithmetic_error").status
      def test4, do: get("/runtime_error").status
      def test5, do: get("/param_required").status
    end

    assert 200 == TEST2.test1
    assert 502 == TEST2.test2
    assert 501 == TEST2.test3
    assert 500 == TEST2.test4
    assert 400 == TEST2.test5
  end
end
