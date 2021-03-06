require 'helper'

class TestSlimPretty < TestSlim
  def setup
    Slim::Engine.set_default_options :pretty => true
  end

  def teardown
    Slim::Engine.set_default_options :pretty => false
  end

  def test_pretty
    source = %q{
doctype 5
html
  head
    title Hello World!
    /! Meta tags
       with long explanatory
       multiline comment
    meta name="description" content="template language"
    /! Stylesheets
    link href="style.css" media="screen" rel="stylesheet" type="text/css"
    link href="colors.css" media="screen" rel="stylesheet" type="text/css"
    /! Javascripts
    script src="jquery.js"
    script src="jquery.ui.js"
    /[if lt IE 9]
      script src="old-ie1.js"
      script src="old-ie2.js"
    sass:
      body
        background-color: red
  body
    #container
      p Hello
        World!
      p= "dynamic text with\nnewline"
}

    result = %q{<!DOCTYPE html>
<html>
  <head>
    <title>
      Hello World!
    </title>
    <!--Meta tags
    with long explanatory
    multiline comment-->
    <meta content="template language" name="description" />
    <!--Stylesheets-->
    <link href="style.css" media="screen" rel="stylesheet" type="text/css" />
    <link href="colors.css" media="screen" rel="stylesheet" type="text/css" />
    <!--Javascripts-->
    <script src="jquery.js"></script>
    <script src="jquery.ui.js"></script>
    <!--[if lt IE 9]>
    <script src="old-ie1.js"></script>
    <script src="old-ie2.js"></script>
    <![endif]-->
    <style type="text/css">
      body {
        background-color: red;
      }
    </style>
  </head>
  <body>
    <div id="container">
      <p>
        Hello
        World!
      </p>
      <p>
        dynamic text with
        newline
      </p>
    </div>
  </body>
</html>}

    assert_html result, source
  end

  def test_partials
    body = %q{body
  == render content}

    content = %q{div
  | content}

    source = %q{html
  == render body, :scope => self, :locals => { :content => content }}

    result = %q{<html>
  <body>
    <div>
      content
    </div>
  </body>
</html>}

    assert_html result, source, :scope => self, :locals => {:body => body, :content => content }
  end
end
