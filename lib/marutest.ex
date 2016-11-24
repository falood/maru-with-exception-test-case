defmodule Marutest do
end

defmodule MWEH do
  use Maru.Router
  mount Maru.TestTest.MWEH.M1

  rescue_from :all do
    conn |> put_status(500) |> text("500")
  end

  rescue_from Maru.Exceptions.InvalidFormatter do
    conn |> put_status(400) |> text("400")
  end
end

defmodule MWEH.M1 do
  use Maru.Router
  mount Maru.TestTest.MWEH.M2

  rescue_from ArithmeticError do
    conn |> put_status(501) |> text("501")
  end
end

defmodule MWEH.M2 do
  use Maru.Router

  rescue_from MatchError do
    conn |> put_status(502) |> text("502")
  end

  get do
    text(conn, "200")
  end

  get "match_error" do
    1 = 2
    text(conn, "200")
  end

  get "arithmetic_error" do
    2 / 0
    text(conn, "200")
  end

  get "runtime_error" do
    raise "runtime_error"
    text(conn, "200")
  end

  namespace "param_required" do
    params do
      requires :query, type: String
    end

    get do
      text(conn, 200)
    end
  end
end
