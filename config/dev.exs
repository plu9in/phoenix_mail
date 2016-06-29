use Mix.Config

config :phoenix_mail,
  phoenix_mail_config: %{
    test_file_path: "toto.txt",
    type: "text",
    subtype: "html",
    reply: "reply@domain.com",
    mailer_smtp_config: [ relay: "yourrelay.yourISP.com",
                        username: "username@yourpostoffice.com",
                        password: "mypassword",
                        port: 465,
                        ssl: true,
                        tls: true,
                        auth: true ]
  }
