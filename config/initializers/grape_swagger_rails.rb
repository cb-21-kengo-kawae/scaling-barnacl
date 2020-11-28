GrapeSwaggerRails.options.tap do |o|
  o.url          = 'swagger_doc.json'
  o.app_name     = 'Zelda Template4th'
  o.app_url      = '/template4th/api/'
  o.api_auth     = 'bearer'
  o.api_key_name = 'Authorization'
  o.api_key_type = 'header'
end
