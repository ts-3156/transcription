module.exports = {
  test: /\.(js|ts)$/,
  loader: 'eslint-loader',
  enforce: 'pre',
  options: {failOnError: true, failOnWarning: false}
};
