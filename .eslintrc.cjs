module.exports = {
  root: true,
  extends: [
    'standard'
  ],
  settings: {
    'import/resolver': {
      node: {
        paths: ['app/javascript']
      }
    }
  }
}
