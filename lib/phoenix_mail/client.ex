defmodule PhoenixMail.Client do
  @moduledoc """
  Alternative to mailgun lib.
  This is a quick dev. It could be interesting to offer all the possibilities permitted by :gen_smtp
  For example, offer signed messages would be very cool.
  """

  @doc """
  __using__ macro permits to configurate the generated code when "use PhoenixMail.Client <conf>" is used
  """
  defmacro __using__(config) do
    quote do
      def conf, do: unquote(config)
      def send_email(email) do
        unquote(__MODULE__).send_email(conf(), email)
      end
    end
  end

  # Exported functions
  ####################
  @doc """
  Connect to the smtp server configured in the setup to send the email
  """
  def send_email(conf, email) do
    IO.puts "from send_email  -> #{ inspect conf}, #{inspect email}"
    do_send_email(conf[:mode], conf, email)
  end

  @doc """
  Test what is actually sent to the smtp server. :test_file_path should be defined in <conf>.exs
  """
  def log_email(conf, email) do
    json = email
    |> Enum.into(%{})
    File.write(conf[:test_file_path], json)
  end

  # Private functions
  ####################
  defp do_send_email(:test, conf, email) do
    log_email(conf, email)
    {:ok, "OK"}
  end
  defp do_send_email(_, conf, email) do
    email_tuple = encode_mail(conf, email)
    email_options = encode_options(conf, email)
    ready_to_send = :mimemail.encode(email_tuple, email_options)
    sendit(conf, email, ready_to_send)
  end


  defp encode_mail(conf, email) do
      { get_type(conf[:type]), get_subtype(conf[:subtype]), get_headers(conf, email),
                      get_content_type_params(conf, email), get_parts(conf, email)}
  end

  defp get_type(:text), do: "text"
  defp get_type(:multipart), do: "multipart"
  defp get_type(_), do: "text"

  defp get_subtype(:plain), do: "plain"
  defp get_subtype(:html), do: "html"
  defp get_subtype(:mixed), do: "mixed"
  defp get_subtype(_), do: "html"

  defp get_headers(conf, email) do
      [{"From", Dict.fetch!(email, :from) },
       {"Reply", Dict.fetch!(conf, :reply)},
       {"To", get_to_addresses Dict.fetch!(email, :to)},
       {"Subject", Dict.get(email, :subject, "")}]
  end

  defp get_to_addresses(addresses) when is_list(addresses), do: addresses |> Enum.join(";")
  defp get_to_addresses(addresses)                        , do: addresses

  defp get_content_type_params(_, _), do: []

  defp get_parts(_conf, email) do
      Dict.get(email, :text)
  end

  # Signed message can be added here
  defp encode_options(_, _), do: []

  defp sendit(conf, email, attrs) do
    :gen_smtp_client.send_blocking({Dict.get(conf, :reply, "noreply@domain.com"),Dict.fetch!(email, :to) , attrs}, conf[:mailer_smtp_config])
  end

end