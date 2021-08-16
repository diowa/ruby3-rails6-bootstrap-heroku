const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

const datatables = require('./loaders/datatables')

environment.loaders.append('datatables', datatables)

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
});

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    // jQuery
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',

    // Window
    'window.jQuery': 'jquery'
  })
)

// export the updated config
module.exports = environment
