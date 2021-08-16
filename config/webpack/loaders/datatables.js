module.exports = {
  test: /datatables\.net.*/,
  loader: 'imports-loader',
  options: {
    additionalCode: 'var define = false;'
  }
}
