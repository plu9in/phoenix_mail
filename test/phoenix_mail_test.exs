defmodule PhoenixMailTest do
  use ExUnit.Case
  doctest PhoenixMail

  @moduledoc """
  Responsible for sending mails.
  """

  use PhoenixMail.Client, Application.get_env(:phoenix_mail, :phoenix_mail_config)


  test "send mail" do
    email = %{from: "yourmail@gmail.com", reply: "noreply@gmail.com", to: ["onefriend@gmail.com", "secondfriend@domain.com"], subject: "Guess what ?",  text: "<strong> It is a message !</strong>"}
    {:ok, _} = send_email(email)
  end
end
