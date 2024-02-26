defmodule OpenApiSpex.Plug.SwaggerUI do
  @moduledoc """
  Module plug that serves SwaggerUI.

  The full path to the API spec must be given as a plug option.
  The API spec should be served at the given path, see `OpenApiSpex.Plug.RenderSpec`

  ## Configuring SwaggerUI

  SwaggerUI can be configured through plug `opts`.
  All options will be converted from `snake_case` to `camelCase` and forwarded to the `SwaggerUIBundle` constructor.
  See the [swagger-ui configuration docs](https://swagger.io/docs/open-source-tools/swagger-ui/usage/configuration/) for details.
  Should dynamic configuration be required, the `config_url` option can be set to an API endpoint that will provide additional config.

  ## Example

      scope "/" do
        pipe_through :browser # Use the default browser stack

        get "/", MyAppWeb.PageController, :index
        get "/swaggerui", OpenApiSpex.Plug.SwaggerUI,
          path: "/api/openapi",
          default_model_expand_depth: 3,
          display_operation_id: true
      end

      # Other scopes may use custom stacks.
      scope "/api" do
        pipe_through :api
        resources "/users", MyAppWeb.UserController, only: [:index, :create, :show]
        get "/openapi", OpenApiSpex.Plug.RenderSpec, :show
      end
  """
  @behaviour Plug

  @html """
  <!-- HTML for static distribution bundle build -->
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Swagger UI</title>
      <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/4.14.0/swagger-ui.css" >
      <link rel="icon" type="image/png" href="./favicon-32x32.png" sizes="32x32" />
      <link rel="icon" type="image/png" href="./favicon-16x16.png" sizes="16x16" />
      <style>
        html
        {
          box-sizing: border-box;
          overflow: -moz-scrollbars-vertical;
          overflow-y: scroll;
        }
        *,
        *:before,
        *:after
        {
          box-sizing: inherit;
        }
        body {
          margin:0;
          background: #fafafa;
        }
        @media only screen and (prefers-color-scheme: dark) {

          .swagger-ui a {
            color: #4990e2;
            text-decoration: none;
          }
          
          body,
          .swagger-ui,
          .swagger-ui input,
          .swagger-ui textarea,
          .swagger-ui input[type="text"],
          .swagger-ui select,
          .swagger-ui .btn,
          .swagger-ui .info .title,
          .swagger-ui .opblock-tag,
          .swagger-ui section.models h4,
          .swagger-ui .dialog-ux .modal-ux-header h3,
          .swagger-ui .dialog-ux .modal-ux-content h4,
          .swagger-ui .dialog-ux .modal-ux-content p {
            color: #ffffff;
          }
          .swagger-ui a.nostyle,
          .swagger-ui .parameter__name,
          .swagger-ui .parameter__type,
          .swagger-ui .parameter__deprecated,
          .swagger-ui .parameter__in,
          .swagger-ui table thead tr th,
          .swagger-ui .response-col_status,
          .swagger-ui table thead tr td,
          .swagger-ui .opblock .opblock-section-header h4,
          .swagger-ui label,
          .swagger-ui .tab li,
          .swagger-ui .opblock .opblock-section-header label,
          .swagger-ui .opblock .opblock-summary-operation-id,
          .swagger-ui .opblock .opblock-summary-path,
          .swagger-ui .opblock .opblock-summary-path__deprecated,
          .swagger-ui .scheme-container,
          .swagger-ui .scheme-container .schemes > label,
          .swagger-ui .opblock-description-wrapper p,
          .swagger-ui .opblock-external-docs-wrapper p,
          .swagger-ui .opblock-title_normal p,
          .swagger-ui .info li,
          .swagger-ui .info p,
          .swagger-ui .info table,
          .swagger-ui .model,
          .swagger-ui .model-title,
          .swagger-ui .model .property.primitive,
          .swagger-ui .responses-inner h4,
          .swagger-ui .responses-inner h5,
          .swagger-ui .renderedMarkdown,
          .swagger-ui .opblock-tag small {
            color: #cccccc;
          }
          
          .swagger-ui .opblock.opblock-post .opblock-summary-method,
          .swagger-ui .opblock-post .btn.execute {
            background: #007841;
          }
          .swagger-ui .opblock.opblock-post .opblock-summary,
          .swagger-ui .opblock-post .btn.execute {
            border-color: #007841;
          }
          .swagger-ui .opblock-post .opblock-summary-description {
            color: #007841;
          }
          
          .swagger-ui .opblock.opblock-patch .opblock-summary-method,
          .swagger-ui .opblock-patch .btn.execute {
            background: #266e5e;
          }
          .swagger-ui .opblock.opblock-patch .opblock-summary,
          .swagger-ui .opblock-patch .btn.execute {
            border-color: #266e5e;
          }
          .swagger-ui .opblock-patch .opblock-summary-description {
            color: #266e5e;
          }
          
          .swagger-ui .opblock.opblock-get .opblock-summary-method,
          .swagger-ui .opblock-get .btn.execute {
            background: #0064c9;
          }
          .swagger-ui .opblock.opblock-get .opblock-summary,
          .swagger-ui .opblock-get .btn.execute {
            border-color: #0064c9;
          }
          .swagger-ui .opblock-get .opblock-summary-description {
            color: #0064c9;
          }
          
          .swagger-ui .opblock.opblock-put .opblock-summary-method,
          .swagger-ui .opblock-put .btn.execute {
            background: #a55b00;
          }
          .swagger-ui .opblock.opblock-put .opblock-summary,
          .swagger-ui .opblock-put .btn.execute {
            border-color: #a55b00;
          }
          .swagger-ui .opblock-put .opblock-summary-description {
            color: #a55b00;
          }
          
          .swagger-ui .opblock.opblock-delete .opblock-summary-method,
          .swagger-ui .opblock-delete .btn.execute {
            background: #990000;
          }
          .swagger-ui .opblock.opblock-delete .opblock-summary,
          .swagger-ui .opblock-delete .btn.execute {
            border-color: #990000;
          }
          .swagger-ui .opblock-delete .opblock-summary-description {
            color: #990000;
          }
          
          body,
          .swagger-ui .info .title,
          .swagger-ui .scheme-container,
          .swagger-ui select,
          .swagger-ui textarea,
          .swagger-ui input[type="text"],
          .swagger-ui input[type="email"],
          .swagger-ui input[type="file"],
          .swagger-ui input[type="password"],
          .swagger-ui input[type="search"],
          .swagger-ui textarea,
          .swagger-ui .topbar,
          .swagger-ui .dialog-ux .modal-ux {
            background-color: rgb(15, 23, 36);
          }
          
          .swagger-ui .opblock .opblock-section-header,
          .swagger-ui input[type="email"].invalid,
          .swagger-ui input[type="file"].invalid,
          .swagger-ui input[type="password"].invalid,
          .swagger-ui input[type="search"].invalid,
          .swagger-ui input[type="text"].invalid,
          .swagger-ui textarea.invalid {
            background-color: transparent;
          }
          
          .swagger-ui input[disabled],
          .swagger-ui select[disabled],
          .swagger-ui textarea[disabled] {
            border: none;
            color: rgb(146, 171, 207);
          }
          
          input[type="file"]::-webkit-file-upload-button {
            color: rgb(146, 171, 207);
            background-color: rgb(146, 171, 207);
            color: rgb(15, 23, 36);
            border: none;
            border-radius: 25px;
          }
          
          input[type="text"]::placeholder {
            color: rgb(146, 171, 207);
            opacity: 1;
          }
          
          .swagger-ui .btn,
          .swagger-ui select {
            border-color: #ccc;
          }
          
          .swagger-ui select {
            background: url('data:image/svg+xml;charset=utf-8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path fill="white" d="M13.418 7.859a.695.695 0 01.978 0 .68.68 0 010 .969l-3.908 3.83a.697.697 0 01-.979 0l-3.908-3.83a.68.68 0 010-.969.695.695 0 01.978 0L10 11l3.418-3.141z"/></svg>')
              right 10px center no-repeat;
          }
          
          .swagger-ui .model-toggle:after {
            background: url('data:image/svg+xml;charset=utf-8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path fill="white" d="M13.418 7.859a.695.695 0 01.978 0 .68.68 0 010 .969l-3.908 3.83a.697.697 0 01-.979 0l-3.908-3.83a.68.68 0 010-.969.695.695 0 01.978 0L10 11l3.418-3.141z"/></svg>')
              50% no-repeat;
          }
          
          .swagger-ui svg {
            fill: #ccc;
          }
          
          .swagger-ui .topbar,
          .swagger-ui .opblock .opblock-section-header,
          .swagger-ui table thead tr td,
          .swagger-ui table thead tr th {
            border-bottom: 1px solid rgb(59, 65, 81);
          }
          .swagger-ui .opblock-tag,
          .swagger-ui .dialog-ux .modal-ux,
          .swagger-ui section.models .model-container {
            border: 1px solid rgb(59, 65, 81);
          }
          
          .swagger-ui section.models.is-open h4,
          .swagger-ui section.models,
          .swagger-ui .dialog-ux .modal-ux-header,
          .swagger-ui .auth-container {
            border-color: rgb(59, 65, 81);
          }
          
          .swagger-ui span.model-title__text {
            color: #10bf9c;
          }
          
          .swagger-ui .property-row td:first-child {
            color: #e57044;
            font-weight: normal;
          }
          
          .swagger-ui .prop-type {
            color: #d95dbd;
          }
          
          .swagger-ui .model .property.primitive {
            color: rgb(59, 65, 81);
          }
          
          .swagger-ui .auth-btn-wrapper .modal-btn {
            margin-right: 1rem;
          }
          
          .swagger-ui .opblock:hover {
            border-width: 2px;
          }
          
          pre {
            background-color: rgb(15, 23, 36) !important;
          }
      }
      </style>
    </head>

    <body>
    <div id="swagger-ui"></div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/4.14.0/swagger-ui-bundle.js" charset="UTF-8"> </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/4.14.0/swagger-ui-standalone-preset.js" charset="UTF-8"> </script>
    <script>
    window.onload = function() {
      // Begin Swagger UI call region
      const api_spec_url = new URL(window.location);
      api_spec_url.pathname = "<%= config.path %>";
      api_spec_url.hash = "";
      const ui = SwaggerUIBundle({
        url: api_spec_url.href,
        dom_id: '#swagger-ui',
        deepLinking: true,
        presets: [
          SwaggerUIBundle.presets.apis,
          SwaggerUIStandalonePreset
        ],
        plugins: [
          SwaggerUIBundle.plugins.DownloadUrl
        ],
        layout: "StandaloneLayout",
        requestInterceptor: function(request){
          server_base = window.location.protocol + "//" + window.location.host;
          if(request.url.startsWith(server_base)) {
            request.headers["x-csrf-token"] = "<%= csrf_token %>";
          } else {
            delete request.headers["x-csrf-token"];
          }
          return request;
        }
        <%= for {k, v} <- Map.drop(config, [:path, :oauth]) do %>
        , <%= camelize(k) %>: <%= encode_config(camelize(k), v) %>
        <% end %>
      })
      // End Swagger UI call region
      <%= if config[:oauth] do %>
        ui.initOAuth(
          <%= config.oauth
              |> Map.new(fn {k, v} -> {camelize(k), v} end)
              |> OpenApiSpex.OpenApi.json_encoder().encode!()
          %>
        )
      <% end %>
      window.ui = ui
    }
    </script>
    </body>
    </html>
  """

  @ui_config_methods [
    "operationsSorter",
    "tagsSorter",
    "onComplete",
    "requestInterceptor",
    "responseInterceptor",
    "modelPropertyMacro",
    "parameterMacro",
    "initOAuth",
    "preauthorizeBasic",
    "preauthorizeApiKey"
  ]

  @doc """
  Initializes the plug.

  ## Options

   * `:path` - Required. The URL path to the API definition.
   * `:oauth` - Optional. Config to pass to the `SwaggerUIBundle.initOAuth()` function.
   * all other opts - forwarded to the `SwaggerUIBundle` constructor

  ## Example

      get "/swaggerui", OpenApiSpex.Plug.SwaggerUI,
        path: "/api/openapi",
        default_model_expand_depth: 3,
        display_operation_id: true
  """
  @impl Plug
  def init(opts) when is_list(opts) do
    Map.new(opts)
  end

  @impl Plug
  def call(conn, config) do
    csrf_token = Plug.CSRFProtection.get_csrf_token()
    config = supplement_config(config, conn)
    html = render(config, csrf_token)

    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, html)
  end

  require EEx

  EEx.function_from_string(:defp, :render, @html, [
    :config,
    :csrf_token
  ])

  defp camelize(identifier) do
    identifier
    |> to_string
    |> String.split("_", parts: 2)
    |> case do
      [first] -> first
      [first, rest] -> first <> Macro.camelize(rest)
    end
  end

  defp encode_config("tagsSorter", "alpha" = value) do
    OpenApiSpex.OpenApi.json_encoder().encode!(value)
  end

  defp encode_config("operationsSorter", value) when value == "alpha" or value == "method" do
    OpenApiSpex.OpenApi.json_encoder().encode!(value)
  end

  defp encode_config(key, value) do
    case Enum.member?(@ui_config_methods, key) do
      true -> value
      false -> OpenApiSpex.OpenApi.json_encoder().encode!(value)
    end
  end

  if Code.ensure_loaded?(Phoenix.Controller) do
    defp supplement_config(%{oauth2_redirect_url: {:endpoint_url, path}} = config, conn) do
      endpoint_module = Phoenix.Controller.endpoint_module(conn)
      url = Path.join(endpoint_module.url(), path)
      Map.put(config, :oauth2_redirect_url, url)
    end
  end

  defp supplement_config(config, _conn) do
    config
  end
end
