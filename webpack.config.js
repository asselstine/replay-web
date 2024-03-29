// CircleCI is possibly running an older version of NodeJS that breaks some of
// the libs.  See this thread: https://github.com/webpack/css-loader/issues/145
require('es6-promise').polyfill();

var webpack = require('webpack');
// var ExtractTextPlugin = require("extract-text-webpack-plugin");

function baseConfig(outputFilename) {
  // var cssExtract = new ExtractTextPlugin(outputFilename + '.css', { publicPath: __dirname + "/app/assets/stylesheets" })
  return {
    // 'context' sets the directory where webpack looks for module files you list in
    // your 'require' statements
    context: __dirname + '/client',

    // 'entry' specifies the entry point, where webpack starts reading all
    // dependencies listed and bundling them into the output file.
    // The entrypoint can be anywhere and named anything - here we are calling it
    // '_application' and storing it in the 'javascripts' directory to follow
    // Rails conventions.
    entry: './bundle.js',

    // 'output' specifies the filepath for saving the bundled output generated by
    // wepback.
    // It is an object with options, and you can interpolate the name of the entry
    // file using '[name]' in the filename.
    // You will want to add the bundled filename to your '.gitignore'.
    output: {
      filename: outputFilename + '.js',
      // We want to save the bundle in the same directory as the other JS.
      path: __dirname + '/app/assets/javascripts',
    },

    resolve: {
      extensions: ['', '.js', '.jsx', '.coffee', '.cjsx']
    },

    // The 'module' and 'loaders' options tell webpack to use loaders.
    // @see http://webpack.github.io/docs/using-loaders.html
    module: {
      loaders: [
        { test: /\.jsx$/, exclude: /node_modules/, loader: 'babel-loader', query: { presets: ['es2015', 'react'] } },
        { test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader'},
        { test: /\.cjsx$/, loaders: ['coffee-loader', 'cjsx']},
        { test: /\.coffee$/, loader: 'coffee-loader' },
        { test: /\.css$/, loaders: ['style', 'css']}
      ],
      noParse: [
          /node_modules[\\/]video\.js/
      ]
    },

    // Use the plugin to specify the resulting filename (and add needed behavior to the compiler)
    plugins: []
  }
}

/**
 * @see http://webpack.github.io/docs/configuration.html
 * for webpack configuration options
 */

config = baseConfig('webpack.bundle');

/*
 * Note that the NODE_ENV environment variable should be set to 'production'
 * in order to compile for production.
 *
 * Also, make sure to have Heroku NodeJS buildpacks installed.  I.e.:
 * heroku buildpacks:add --index 1 heroku/nodejs --app vey-staging
 */
var isProduction = process.env.NODE_ENV === 'production';
if (isProduction) {
  console.log("Compiling in production mode...");
  config.devtool = 'source-map';
  config.plugins = [
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': '"production"'
      }
    }),
    new webpack.optimize.UglifyJsPlugin()
  ];
}

module.exports = [
  config
];
